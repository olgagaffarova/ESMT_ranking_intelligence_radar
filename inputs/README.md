# Licensed input files are not bundled

The prototype includes small derived ESMT/peer tables, but it does not duplicate the supplied publisher workbooks. Confirm ESMT's licence and redistribution rights before sharing raw exports.

To reproduce the QS extraction, place authorised copies here with these names:

| Expected filename | Supplied source |
|---|---|
| `2024_QS_Global_MBA.xlsx` | 2024 QS Global MBA Rankings - Results (for qs.com).xlsx |
| `2025_QS_GME_Results.xlsx` | 2025 Global MBA & Business Masters - Results v2.4 (for qs.com).xlsx |
| `2026_QS_GME_Results.xlsx` | 2026 Global MBA & Business Masters - Results v1.0 (for qs.com) (2)_3.xlsx |
| `2025_FT_European_Business_Schools.xlsx` | export-ranking-european-business-school-rankings-2025-….xlsx |

Then run:

```bash
python scripts/extract_qs_inputs.py
python scripts/build_outputs.py
```

The extractor checks expected sheet and column names and fails rather than silently guessing after a publisher format change.

