"""Public-page snapshot collector and conservative change detector.

The module intentionally does not scrape private portals. It respects source
access modes from the registry and treats a hash change only as a review
candidate. Production use also needs robots/terms review, retry policies,
encrypted snapshot storage, and rate limits approved by ESMT IT.
"""

from __future__ import annotations

import hashlib
import re
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from html.parser import HTMLParser
from typing import Any
from urllib.request import Request, urlopen


USER_AGENT = "ESMT-Ranking-Intelligence-Radar/0.1 (+manual prototype review)"
DROP_TAGS = {"script", "style", "nav", "footer", "noscript", "svg", "header"}


@dataclass(frozen=True)
class PageSnapshot:
    source_id: str
    url: str
    retrieved_at: str
    http_status: int
    content_hash: str
    normalized_text: str

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


class _StableTextParser(HTMLParser):
    """Small dependency-free parser for change-detection text."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self._drop_depth = 0
        self.parts: list[str] = []

    def handle_starttag(self, tag: str, _attrs: list[tuple[str, str | None]]) -> None:
        if tag.casefold() in DROP_TAGS:
            self._drop_depth += 1

    def handle_endtag(self, tag: str) -> None:
        if tag.casefold() in DROP_TAGS and self._drop_depth:
            self._drop_depth -= 1

    def handle_data(self, data: str) -> None:
        if not self._drop_depth and data.strip():
            self.parts.append(data.strip())


def normalize_html(html: str) -> str:
    """Extract stable text while removing common high-noise elements."""
    parser = _StableTextParser()
    parser.feed(html)
    return re.sub(r"\s+", " ", " ".join(parser.parts)).strip()


def fetch_public_source(source: dict[str, Any], timeout_seconds: int = 20) -> PageSnapshot:
    """Fetch one explicitly public source from the registry."""
    if source.get("access_mode") != "public_http":
        raise ValueError(f"Source {source.get('source_id')} is not approved for public HTTP collection")
    if not source.get("enabled", False):
        raise ValueError(f"Source {source.get('source_id')} is disabled")
    url = source.get("canonical_url")
    if not url:
        raise ValueError("Public source requires a canonical_url")

    request = Request(url, headers={"User-Agent": USER_AGENT})
    with urlopen(request, timeout=timeout_seconds) as response:  # noqa: S310 - registry gates URLs
        status = int(getattr(response, "status", 200))
        charset = response.headers.get_content_charset() or "utf-8"
        html = response.read().decode(charset, errors="replace")
    normalized = normalize_html(html)
    digest = hashlib.sha256(normalized.encode("utf-8")).hexdigest()
    return PageSnapshot(
        source_id=source["source_id"],
        url=url,
        retrieved_at=datetime.now(timezone.utc).isoformat(),
        http_status=status,
        content_hash=digest,
        normalized_text=normalized,
    )


def has_material_candidate(previous: PageSnapshot, current: PageSnapshot) -> bool:
    """Flag changed normalized content; human verification is still mandatory."""
    if previous.source_id != current.source_id:
        raise ValueError("Snapshots must belong to the same source")
    return previous.content_hash != current.content_hash
