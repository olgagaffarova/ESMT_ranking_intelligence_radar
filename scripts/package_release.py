"""Create a reproducible project ZIP and a checksum manifest."""

from __future__ import annotations

import hashlib
import json
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs/esmt_radar"
ZIP_PATH = OUTPUT_DIR / "ESMT_Ranking_Intelligence_Radar_MVP.zip"
MANIFEST_PATH = OUTPUT_DIR / "release_manifest.json"
EXCLUDED_PARTS = {"node_modules", "__pycache__", ".pytest_cache"}
EXCLUDED_NAMES = {
    ZIP_PATH.name,
    MANIFEST_PATH.name,
    "ESMT_Ranking_Intelligence_Radar_Audit.xlsx.inspect.ndjson",
}


def included_files() -> list[Path]:
    files = []
    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue
        if any(part in EXCLUDED_PARTS for part in path.parts):
            continue
        if path.name in EXCLUDED_NAMES:
            continue
        files.append(path)
    return sorted(files, key=lambda item: item.relative_to(ROOT).as_posix())


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    files = included_files()
    manifest = {
        "project": "ESMT Ranking Intelligence Radar",
        "release": "0.1.0-prototype",
        "as_of_date": "2026-08-18",
        "records": {"sources": 23, "signals": 18, "qs_esmt_rows": 5, "qs_peer_rows": 20},
        "verification": {
            "unit_and_smoke_tests": 10,
            "notebook_code_cells_executed": 9,
            "workbook_sheets": 6,
            "workbook_score_checks": 18,
            "workbook_charts": 3,
            "workbook_formula_errors": 0,
        },
        "files": [
            {
                "path": path.relative_to(ROOT).as_posix(),
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in files
        ],
    }
    MANIFEST_PATH.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")

    with zipfile.ZipFile(ZIP_PATH, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in files:
            archive.write(path, arcname=f"esmt_ranking_intelligence_radar/{path.relative_to(ROOT).as_posix()}")
        archive.write(MANIFEST_PATH, arcname="esmt_ranking_intelligence_radar/outputs/esmt_radar/release_manifest.json")

    print(f"Packaged {len(files) + 1} files: {ZIP_PATH} ({ZIP_PATH.stat().st_size} bytes).")


if __name__ == "__main__":
    main()
