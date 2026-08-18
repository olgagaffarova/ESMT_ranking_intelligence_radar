"""Streamlit prototype for the ESMT Ranking Intelligence Radar."""

from __future__ import annotations

import json
from datetime import date
from pathlib import Path

import pandas as pd
import streamlit as st


ROOT = Path(__file__).resolve().parent
SIGNALS_PATH = ROOT / "data/processed/signals_enriched.json"
SOURCES_PATH = ROOT / "data/raw/sources.json"


@st.cache_data
def load_data() -> tuple[list[dict], list[dict]]:
    if not SIGNALS_PATH.exists():
        raise FileNotFoundError("Run `python scripts/build_outputs.py` before starting the app.")
    with SIGNALS_PATH.open(encoding="utf-8") as handle:
        signals = json.load(handle)
    with SOURCES_PATH.open(encoding="utf-8") as handle:
        sources = json.load(handle)
    return signals, sources


def programme_labels(signal: dict) -> str:
    return ", ".join(signal["programmes"])


def days_label(signal: dict, today: date) -> str:
    start = date.fromisoformat(signal["event_date_start"])
    end = date.fromisoformat(signal["event_date_end"])
    if today < start:
        return f"Starts in {(start - today).days} days"
    if start <= today <= end:
        return "Window open / event today"
    return f"Occurred {(today - end).days} days ago"


st.set_page_config(page_title="ESMT Ranking Intelligence Radar", page_icon="◉", layout="wide")
st.markdown(
    """
    <style>
    :root { --ink: #0c1524; --blue: #165dff; --mist: #eef3f8; --red: #c23b3b; }
    .block-container { padding-top: 2rem; padding-bottom: 4rem; }
    [data-testid="stMetric"] { background: #f6f8fb; border: 1px solid #e0e6ee; border-radius: 12px; padding: 14px; }
    .eyebrow { color: #165dff; font-size: .76rem; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
    .fact-box { background: #f6f8fb; border-left: 4px solid #165dff; border-radius: 4px 12px 12px 4px; padding: 1rem 1.15rem; }
    .judgement-box { background: #fff7e8; border-left: 4px solid #d58a14; border-radius: 4px 12px 12px 4px; padding: 1rem 1.15rem; }
    .warning-box { background: #fff0f0; border-left: 4px solid #c23b3b; border-radius: 4px 12px 12px 4px; padding: 1rem 1.15rem; }
    .small-note { color: #5d6878; font-size: .86rem; }
    </style>
    """,
    unsafe_allow_html=True,
)

try:
    signals, sources = load_data()
except FileNotFoundError as exc:
    st.error(str(exc))
    st.stop()

st.markdown('<div class="eyebrow">Decision support prototype · public/demo data</div>', unsafe_allow_html=True)
st.title("ESMT Ranking Intelligence Radar")
st.caption("Official-source signals, transparent priority, and an auditable separation between fact and judgement.")

all_programmes = sorted({programme for signal in signals for programme in signal["programmes"]})
all_types = sorted({signal["signal_type"] for signal in signals})
all_bands = ["Act now", "Plan", "Monitor", "Archive"]

with st.sidebar:
    st.header("Filter")
    selected_programmes = st.multiselect("Programme", all_programmes)
    selected_types = st.multiselect("Signal type", all_types)
    selected_bands = st.multiselect("Priority", all_bands, default=["Act now", "Plan"])
    include_closed = st.checkbox("Include closed/superseded", value=False)
    st.divider()
    st.caption("Scores are management rules, not predictions. Every classification and action requires an accountable reviewer.")

filtered = []
for signal in signals:
    if selected_programmes and not set(selected_programmes).intersection(signal["programmes"]):
        continue
    if selected_types and signal["signal_type"] not in selected_types:
        continue
    if selected_bands and signal["priority_band"] not in selected_bands:
        continue
    if not include_closed and signal["status"] in {"Closed", "Superseded"}:
        continue
    filtered.append(signal)

today = date.today()
act_now_count = sum(signal["priority_band"] == "Act now" for signal in signals)
upcoming_60 = sum(
    0 <= (date.fromisoformat(signal["event_date_start"]) - today).days <= 60 for signal in signals
)
qa_count = sum(signal["signal_type"] == "communication_mismatch" and signal["status"] != "Closed" for signal in signals)
private_gap = sum(source["access_mode"] == "manual_private" and not source["enabled"] for source in sources)

m1, m2, m3, m4 = st.columns(4)
m1.metric("Act now", act_now_count)
m2.metric("Starts in 60 days", upcoming_60)
m3.metric("Open communication QA", qa_count)
m4.metric("Unconnected private sources", private_gap)

tabs = st.tabs(["Priority inbox", "Signal detail", "Source health", "Communication QA"])

with tabs[0]:
    st.subheader("Priority inbox")
    st.caption(f"Showing {len(filtered)} of {len(signals)} signals. Date calculations use {today.isoformat()}.")
    inbox_rows = []
    for signal in filtered:
        inbox_rows.append(
            {
                "Score": signal["priority_score"],
                "Priority": signal["priority_band"],
                "Signal": signal["title"],
                "Type": signal["signal_type"].replace("_", " ").title(),
                "Programme": programme_labels(signal),
                "Timing": days_label(signal, today),
                "Status": signal["status"],
                "Owner (proposed)": signal["proposed_owner"],
            }
        )
    st.dataframe(pd.DataFrame(inbox_rows), use_container_width=True, hide_index=True)

    if filtered:
        band_counts = pd.DataFrame(filtered).groupby("priority_band").size().reindex(all_bands, fill_value=0)
        st.bar_chart(band_counts, horizontal=True, color="#165dff")

with tabs[1]:
    st.subheader("Signal detail")
    selected_id = st.selectbox(
        "Choose a signal",
        options=[signal["signal_id"] for signal in signals],
        format_func=lambda signal_id: next(signal["title"] for signal in signals if signal["signal_id"] == signal_id),
    )
    selected = next(signal for signal in signals if signal["signal_id"] == selected_id)
    left, right = st.columns([2, 1])
    with left:
        st.markdown(f"### {selected['title']}")
        st.markdown(
            f'<div class="fact-box"><strong>Verified fact</strong><br>{selected["factual_summary"]}</div>',
            unsafe_allow_html=True,
        )
        st.write("")
        st.markdown(
            f'<div class="judgement-box"><strong>ESMT interpretation</strong><br>{selected["esmt_interpretation"]}</div>',
            unsafe_allow_html=True,
        )
        st.write("")
        st.markdown(
            f'<div class="judgement-box"><strong>Proposed action</strong><br>{selected["recommended_action"]}</div>',
            unsafe_allow_html=True,
        )
    with right:
        st.metric("Priority", f"{selected['priority_score']:.0f}/100", selected["priority_band"])
        st.write(f"**Status:** {selected['status']}")
        st.write(f"**Programme:** {programme_labels(selected)}")
        st.write(f"**Official timing:** {selected['official_date_text']}")
        st.write(f"**Date precision:** {selected['date_precision']}")
        st.write(f"**Verification:** {selected['verification_status']}")
        st.write(f"**Owner (proposed):** {selected['proposed_owner']}")
        st.write(f"**Internal due date (proposed):** {selected['proposed_due_date']}")
        if selected.get("date_assumption"):
            st.warning(selected["date_assumption"])

    st.markdown("#### Evidence")
    for source in selected["sources"]:
        if source.get("url"):
            st.markdown(f"- [{source['name']}]({source['url']}) · {source['evidence_type']}")
        else:
            st.markdown(f"- {source['name']} · {source['access_mode']} (not connected in public prototype)")

    contribution_frame = pd.DataFrame(
        {
            "Dimension": [key.replace("_", " ").title() for key in selected["score_contributions"]],
            "Points": list(selected["score_contributions"].values()),
        }
    ).set_index("Dimension")
    st.markdown("#### Why this score")
    st.bar_chart(contribution_frame, horizontal=True, color="#165dff")

with tabs[2]:
    st.subheader("Source health and coverage gaps")
    rows = []
    for source in sources:
        rows.append(
            {
                "Source": source["name"],
                "Family": source["source_family"],
                "Evidence": source["evidence_type"],
                "Access": source["access_mode"],
                "Cadence": source["monitor_cadence"],
                "Enabled": source["enabled"],
                "Last checked": source.get("checked_at"),
                "Caveat": source.get("caveat"),
            }
        )
    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)
    st.markdown(
        '<div class="warning-box"><strong>Coverage gap</strong><br>The public prototype cannot monitor participant portals, direct publisher communications, or internal data/evidence systems. Those three sources are deliberately disabled.</div>',
        unsafe_allow_html=True,
    )

with tabs[3]:
    st.subheader("Communication QA")
    qa_signals = [signal for signal in signals if signal["signal_type"] == "communication_mismatch"]
    for signal in qa_signals:
        st.markdown(f"### {signal['title']}")
        st.markdown(
            f'<div class="fact-box"><strong>Observed mismatch</strong><br>{signal["factual_summary"]}</div>',
            unsafe_allow_html=True,
        )
        st.write(f"**Recommended correction:** {signal['recommended_action']}")
        st.write(f"**Proposed owner / due:** {signal['proposed_owner']} · {signal['proposed_due_date']}")
        st.divider()

st.caption("Prototype as-of seed: 18 August 2026. Not an official ESMT system or an authorised submission record.")

