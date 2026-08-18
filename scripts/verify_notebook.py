"""Execute notebook code cells without requiring Jupyter in the test runtime."""

from __future__ import annotations

import json
import os
from pathlib import Path

os.environ.setdefault("MPLCONFIGDIR", "/tmp/esmt-radar-matplotlib")
import matplotlib


matplotlib.use("Agg")
ROOT = Path(__file__).resolve().parents[1]
NOTEBOOK = ROOT / "notebooks/ESMT_Ranking_Intelligence_Radar.ipynb"


def main() -> None:
    os.chdir(ROOT)
    notebook = json.loads(NOTEBOOK.read_text(encoding="utf-8"))
    namespace = {"display": lambda *_objects: None}
    code_cells = [cell for cell in notebook["cells"] if cell["cell_type"] == "code"]
    for index, cell in enumerate(code_cells, start=1):
        code = "".join(cell["source"])
        exec(compile(code, f"{NOTEBOOK.name}:cell-{index}", "exec"), namespace)  # noqa: S102 - local curated notebook
    print(f"Notebook verified: executed {len(code_cells)} code cells.")


if __name__ == "__main__":
    main()
