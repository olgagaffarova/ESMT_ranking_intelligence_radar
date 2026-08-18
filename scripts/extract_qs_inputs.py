"""Extract the small, auditable QS analysis tables from authorised exports.

The script is deliberately strict about workbook structure. If QS changes a
sheet or column name, extraction stops for human review instead of guessing.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path

import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
SELECTED_PEERS = {
    "QS Global MBA": {
        "Frankfurt School of Finance & Management": ["Frankfurt School of Finance & Management"],
        "Mannheim Business School": ["Mannheim Business School"],
        "WHU (Otto Beisheim)": ["WHU (Otto Beisheim)"],
        "ESMT Berlin": ["ESMT Berlin"],
    },
    "QS Management": {
        "WHU (Otto Beisheim)": ["WHU (Otto Beisheim)"],
        "Mannheim Business School": ["Mannheim Business School", "University of Mannheim, Business School"],
        "TUM School of Management": ["TUM School of Management"],
        "Frankfurt School of Finance & Management": ["Frankfurt School of Finance & Management"],
        "EBS Business School": ["EBS Business School", "EBS University for Business and Law"],
        "ESMT Berlin": ["ESMT Berlin"],
    },
}


def rank_number(value: object) -> int:
    match = re.search(r"\d+", str(value))
    if not match:
        raise ValueError(f"Cannot parse rank from {value!r}")
    return int(match.group())


def read_sheet(path: Path, sheet: str, header_row_zero_based: int) -> pd.DataFrame:
    frame = pd.read_excel(path, sheet_name=sheet, header=header_row_zero_based, engine="openpyxl")
    required = {"Institution", "Country / Territory"}
    missing = required - set(frame.columns)
    if missing:
        raise ValueError(f"{path.name}/{sheet} is missing expected columns {sorted(missing)}")
    return frame


def esmt_row(frame: pd.DataFrame, path: Path, sheet: str) -> pd.Series:
    matches = frame.loc[frame["Institution"].astype(str).str.strip() == "ESMT Berlin"]
    if len(matches) != 1:
        raise ValueError(f"Expected exactly one ESMT row in {path.name}/{sheet}; found {len(matches)}")
    return matches.iloc[0]


def mba_record(frame: pd.DataFrame, edition: int, path: Path, sheet: str) -> dict:
    row = esmt_row(frame, path, sheet)
    return {
        "ranking": "QS Global MBA",
        "edition": edition,
        "rank": rank_number(row[f"{edition} Rank"]),
        "overall_score": float(row["Overall Score"]),
        "employability": float(row["Employability Score"]),
        "entrepreneurship_alumni_outcomes": float(row["Entrepreneurship & Alumni Outcomes Score"]),
        "roi": float(row["Return on Investment Score"]),
        "thought_leadership": float(row["Thought Leadership Score"]),
        "diversity": float(row["Diversity Score"]),
        "alumni_outcomes": None,
        "value_for_money": None,
        "source_file": path.name,
    }


def management_record(frame: pd.DataFrame, edition: int, path: Path, sheet: str) -> dict:
    row = esmt_row(frame, path, sheet)
    return {
        "ranking": "QS Management",
        "edition": edition,
        "rank": rank_number(row[f"{edition} Rank"]),
        "overall_score": float(row["Overall Score"]),
        "employability": float(row["Employability Score"]),
        "entrepreneurship_alumni_outcomes": None,
        "roi": None,
        "thought_leadership": float(row["Thought Leadership Score"]),
        "diversity": float(row["Diversity Score"]),
        "alumni_outcomes": float(row["Alumni Outcomes Score"]),
        "value_for_money": float(row["Value for Money Score"]),
        "source_file": path.name,
    }


def peer_records(frame: pd.DataFrame, edition: int, ranking: str, path: Path) -> list[dict]:
    germany = frame.loc[frame["Country / Territory"].astype(str).str.strip() == "Germany"].copy()
    output = []
    normalised_names = germany["Institution"].astype(str).str.strip()
    for school, aliases in SELECTED_PEERS[ranking].items():
        matches = germany.loc[normalised_names.isin(aliases)]
        if len(matches) != 1:
            raise ValueError(f"Expected one {school} row in {path.name}; found {len(matches)}")
        output.append(
            {
                "ranking": ranking,
                "school": school,
                "edition": edition,
                "rank": rank_number(matches.iloc[0][f"{edition} Rank"]),
                "source_file": path.name,
            }
        )
    return output


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mba-2024", type=Path, default=ROOT / "inputs/2024_QS_Global_MBA.xlsx")
    parser.add_argument("--results-2025", type=Path, default=ROOT / "inputs/2025_QS_GME_Results.xlsx")
    parser.add_argument("--results-2026", type=Path, default=ROOT / "inputs/2026_QS_GME_Results.xlsx")
    parser.add_argument("--output-dir", type=Path, default=ROOT / "data/raw")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    for path in [args.mba_2024, args.results_2025, args.results_2026]:
        if not path.exists():
            raise FileNotFoundError(f"Missing authorised input: {path}")

    mba_2024 = read_sheet(args.mba_2024, "Global MBA", 4)
    mba_2025 = read_sheet(args.results_2025, "MBA Global", 3)
    mim_2025 = read_sheet(args.results_2025, "MS_Management", 3)
    mba_2026 = read_sheet(args.results_2026, "MBA Global", 3)
    mim_2026 = read_sheet(args.results_2026, "MS_Management", 3)

    trends = [
        mba_record(mba_2024, 2024, args.mba_2024, "Global MBA"),
        mba_record(mba_2025, 2025, args.results_2025, "MBA Global"),
        mba_record(mba_2026, 2026, args.results_2026, "MBA Global"),
        management_record(mim_2025, 2025, args.results_2025, "MS_Management"),
        management_record(mim_2026, 2026, args.results_2026, "MS_Management"),
    ]
    peers = [
        *peer_records(mba_2025, 2025, "QS Global MBA", args.results_2025),
        *peer_records(mba_2026, 2026, "QS Global MBA", args.results_2026),
        *peer_records(mim_2025, 2025, "QS Management", args.results_2025),
        *peer_records(mim_2026, 2026, "QS Management", args.results_2026),
    ]

    args.output_dir.mkdir(parents=True, exist_ok=True)
    pd.DataFrame(trends).to_csv(args.output_dir / "qs_esmt_trends.csv", index=False)
    pd.DataFrame(peers).sort_values(["ranking", "school", "edition"]).to_csv(
        args.output_dir / "qs_german_peer_ranks.csv", index=False
    )
    print(f"Extracted {len(trends)} ESMT edition rows and {len(peers)} peer rows to {args.output_dir}.")


if __name__ == "__main__":
    main()
