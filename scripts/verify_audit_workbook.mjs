import path from "node:path";
import { fileURLToPath } from "node:url";
import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";


const HERE = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(HERE, "..");
const file = path.join(ROOT, "outputs", "esmt_radar", "ESMT_Ranking_Intelligence_Radar_Audit.xlsx");
const workbook = await SpreadsheetFile.importXlsx(await FileBlob.load(file));

const expectedSheets = ["Dashboard", "Signals", "Sources", "Scoring Rules", "QS Trends", "Communication QA"];
const actualSheets = workbook.worksheets.items.map((sheet) => sheet.name);
if (JSON.stringify(actualSheets) !== JSON.stringify(expectedSheets)) {
  throw new Error(`Unexpected sheets: ${actualSheets.join(", ")}`);
}

const dashboard = workbook.worksheets.getItem("Dashboard");
const kpis = dashboard.getRange("A7:K8").values.flat().filter((value) => typeof value === "number");
for (const expected of [13, 8, 2, 3]) {
  if (!kpis.includes(expected)) throw new Error(`Dashboard KPI ${expected} is missing: ${kpis}`);
}

const signals = workbook.worksheets.getItem("Signals");
const qaValues = signals.getRange("Z3:Z20").values.flat();
if (qaValues.some((value) => value !== "OK")) {
  throw new Error(`Score QA failed: ${qaValues.join(", ")}`);
}

const weightCheck = workbook.worksheets.getItem("Scoring Rules").getRange("B12").values[0][0];
if (weightCheck !== 100) throw new Error(`Scoring weights total ${weightCheck}, expected 100`);

const formulaErrors = [];
for (const sheet of workbook.worksheets.items) {
  const values = sheet.getUsedRange(true).values;
  values.forEach((row, rowIndex) => row.forEach((value, colIndex) => {
    if (typeof value === "string" && /^#(REF!|DIV\/0!|VALUE!|NAME\?|N\/A)/.test(value)) {
      formulaErrors.push(`${sheet.name}!R${rowIndex + 1}C${colIndex + 1}: ${value}`);
    }
  }));
}
if (formulaErrors.length) throw new Error(formulaErrors.join("; "));

const chartCount = dashboard.charts.items.length + workbook.worksheets.getItem("QS Trends").charts.items.length;
if (chartCount !== 3) throw new Error(`Expected three charts, found ${chartCount}`);

console.log(`Workbook verified: ${actualSheets.length} sheets, 18 score checks, ${chartCount} charts, no formula errors.`);
