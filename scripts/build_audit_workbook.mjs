import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";


const HERE = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(HERE, "..");
const OUTPUT_DIR = path.join(ROOT, "outputs", "esmt_radar");
const PREVIEW_DIR = path.join(OUTPUT_DIR, "previews");
const OUTPUT_FILE = path.join(OUTPUT_DIR, "ESMT_Ranking_Intelligence_Radar_Audit.xlsx");

const COLORS = {
  ink: "#101723",
  blue: "#165DFF",
  paleBlue: "#EAF0FF",
  amber: "#C47B13",
  paleAmber: "#FFF4DF",
  red: "#BA3A3A",
  paleRed: "#FDECEC",
  green: "#18794E",
  paleGreen: "#EAF7F0",
  grey: "#667085",
  paleGrey: "#F3F5F8",
  line: "#D9E0E8",
  white: "#FFFFFF",
};

const [signals, sources, trendsText, peersText] = await Promise.all([
  fs.readFile(path.join(ROOT, "data", "processed", "signals_enriched.json"), "utf8").then(JSON.parse),
  fs.readFile(path.join(ROOT, "data", "raw", "sources.json"), "utf8").then(JSON.parse),
  fs.readFile(path.join(ROOT, "data", "raw", "qs_esmt_trends.csv"), "utf8"),
  fs.readFile(path.join(ROOT, "data", "raw", "qs_german_peer_ranks.csv"), "utf8"),
]);

function parseCsv(text) {
  const lines = text.trim().split(/\r?\n/);
  const headers = lines[0].split(",");
  return lines.slice(1).map((line) => {
    const values = line.split(",");
    return Object.fromEntries(headers.map((header, index) => [header, values[index] ?? ""]));
  });
}

const trends = parseCsv(trendsText);
const peers = parseCsv(peersText);
console.log("Workbook build: inputs loaded");
const workbook = Workbook.create();
const dashboard = workbook.worksheets.add("Dashboard");
const signalSheet = workbook.worksheets.add("Signals");
const sourceSheet = workbook.worksheets.add("Sources");
const scoringSheet = workbook.worksheets.add("Scoring Rules");
const qsSheet = workbook.worksheets.add("QS Trends");
const qaSheet = workbook.worksheets.add("Communication QA");
console.log("Workbook build: sheets created");

for (const sheet of [dashboard, signalSheet, sourceSheet, scoringSheet, qsSheet, qaSheet]) {
  sheet.showGridLines = false;
}

function styleTitle(sheet, rangeAddress, title) {
  const range = sheet.getRange(rangeAddress);
  range.merge();
  range.values = [[title]];
  range.format = {
    fill: COLORS.ink,
    font: { bold: true, color: COLORS.white, size: 20 },
    verticalAlignment: "center",
  };
  range.format.rowHeight = 34;
}

function styleSection(range) {
  range.format = {
    fill: COLORS.paleBlue,
    font: { bold: true, color: COLORS.ink },
    borders: { bottom: { style: "medium", color: COLORS.blue } },
    verticalAlignment: "center",
  };
}

function styleHeader(range) {
  range.format = {
    fill: COLORS.ink,
    font: { bold: true, color: COLORS.white },
    verticalAlignment: "center",
    wrapText: true,
  };
  range.format.rowHeight = 30;
}

function dateValue(value) {
  return value ? new Date(`${value}T00:00:00Z`) : null;
}

// Dashboard
styleTitle(dashboard, "A1:K2", "ESMT Ranking Intelligence Radar — Audit Workbook");
dashboard.getRange("A3:K3").merge();
dashboard.getRange("A3").values = [["Verified external signals, explicit judgement, and a transparent action queue. Prototype as-of 18 August 2026."]];
dashboard.getRange("A3:K3").format = { font: { color: COLORS.grey, italic: true }, wrapText: true };
dashboard.getRange("A4").values = [["As-of date"]];
dashboard.getRange("B4").values = [[new Date("2026-08-18T00:00:00Z")]];
dashboard.getRange("B4").format.numberFormat = "yyyy-mm-dd";
dashboard.getRange("D4:K4").merge();
dashboard.getRange("D4").values = [["Management rule only — priority is not a rank forecast or an objective truth."]];
dashboard.getRange("D4:K4").format = { fill: COLORS.paleAmber, font: { color: COLORS.amber, bold: true }, wrapText: true };

const cards = [
  ["A6:B6", "A7:B8", "Act now", `=COUNTIF(Signals!$C$3:$C$${signals.length + 2},"Act now")`],
  ["D6:E6", "D7:E8", "Starts in 60 days", `=COUNTIFS(Signals!$I$3:$I$${signals.length + 2},">="&$B$4,Signals!$I$3:$I$${signals.length + 2},"<="&$B$4+60)`],
  ["G6:H6", "G7:H8", "Communication QA", `=COUNTIF(Signals!$E$3:$E$${signals.length + 2},"communication_mismatch")`],
  ["J6:K6", "J7:K8", "Private gaps", `=COUNTIF(Sources!$F$3:$F$${sources.length + 2},"manual_private")`],
];
for (const [labelRange, valueRange, label, formula] of cards) {
  dashboard.getRange(labelRange).merge();
  dashboard.getRange(labelRange.split(":")[0]).values = [[label]];
  dashboard.getRange(labelRange).format = { fill: COLORS.paleGrey, font: { bold: true, color: COLORS.grey }, horizontalAlignment: "center" };
  dashboard.getRange(valueRange).merge();
  dashboard.getRange(valueRange.split(":")[0]).formulas = [[formula]];
  dashboard.getRange(valueRange).format = {
    fill: COLORS.white,
    font: { bold: true, color: COLORS.ink, size: 22 },
    borders: { preset: "outside", style: "thin", color: COLORS.line },
    horizontalAlignment: "center",
    verticalAlignment: "center",
  };
}

dashboard.getRange("A11:B11").merge();
dashboard.getRange("A11").values = [["Priority distribution"]];
styleSection(dashboard.getRange("A11:B11"));
dashboard.getRange("A13:B17").values = [
  ["Priority band", "Signals"],
  ["Act now", null],
  ["Plan", null],
  ["Monitor", null],
  ["Archive", null],
];
styleHeader(dashboard.getRange("A13:B13"));
for (let row = 14; row <= 17; row += 1) {
  dashboard.getRange(`B${row}`).formulas = [[`=COUNTIF(Signals!$C$3:$C$${signals.length + 2},A${row})`]];
}
dashboard.getRange("A13:B17").format.borders = { preset: "outside", style: "thin", color: COLORS.line };
const priorityChart = dashboard.charts.add("bar", dashboard.getRange("A13:B17"));
priorityChart.title = "Signals by priority band";
priorityChart.titleTextStyle.fontSize = 12;
priorityChart.hasLegend = false;
priorityChart.xAxis = { numberFormatCode: "0" };
priorityChart.setPosition("D11", "K27");

dashboard.getRange("A29:K29").merge();
dashboard.getRange("A29").values = [["Highest-priority records"]];
styleSection(dashboard.getRange("A29:K29"));
dashboard.getRange("A31:F31").values = [["Score", "Signal", "Type", "Official timing", "Owner (proposed)", "Status"]];
styleHeader(dashboard.getRange("A31:F31"));
for (let index = 0; index < Math.min(8, signals.length); index += 1) {
  const row = 32 + index;
  const signalRow = 3 + index;
  dashboard.getRange(`A${row}:F${row}`).formulas = [[
    `=Signals!B${signalRow}`,
    `=Signals!F${signalRow}`,
    `=Signals!E${signalRow}`,
    `=Signals!L${signalRow}`,
    `=Signals!Q${signalRow}`,
    `=Signals!D${signalRow}`,
  ]];
}
dashboard.getRange("A31:F39").format.borders = { preset: "outside", style: "thin", color: COLORS.line };
dashboard.getRange("A32:F39").format.rowHeight = 48;
dashboard.getRange("A32:F39").format.verticalAlignment = "top";
dashboard.getRange("B32:B39").format.wrapText = true;
dashboard.getRange("D32:F39").format.wrapText = true;
dashboard.getRange("A42:K44").merge();
dashboard.getRange("A42").values = [["Coverage limitation: FT participant communications, QS MoveIN, and ESMT internal data/evidence systems are represented but deliberately not connected. Public monitoring cannot replace authorised portal checks or submission governance."]];
dashboard.getRange("A42:K44").format = { fill: COLORS.paleRed, font: { color: COLORS.red, bold: true }, wrapText: true, verticalAlignment: "center" };
dashboard.freezePanes.freezeRows(4);
dashboard.getRange("A:K").format.columnWidth = 15;
dashboard.getRange("B:B").format.columnWidth = 34;
dashboard.getRange("D:D").format.columnWidth = 22;
dashboard.getRange("E:E").format.columnWidth = 22;
dashboard.getRange("F:F").format.columnWidth = 16;
console.log("Workbook build: Dashboard complete");

// Signals
styleTitle(signalSheet, "A1:AB1", "Signal Register");
const signalHeaders = [
  "Signal ID", "Priority Score", "Priority Band", "Status", "Signal Type", "Title", "Programme(s)", "Ranking / Standard",
  "Event Start", "Event End", "Date Precision", "Official Timing", "Verification", "Verified Fact", "ESMT Interpretation",
  "Recommended Action", "Proposed Owner", "Internal Proposed Due", "Source Count", "Strategic Impact", "Urgency", "Actionability",
  "ESMT Relevance", "Evidence Confidence", "Formula Score Check", "Score QA", "Source URLs", "Independent Confirmations",
];
signalSheet.getRange(`A2:AB2`).values = [signalHeaders];
styleHeader(signalSheet.getRange("A2:AB2"));
const signalRows = signals.map((signal) => [
  signal.signal_id,
  signal.priority_score,
  signal.priority_band,
  signal.status,
  signal.signal_type,
  signal.title,
  signal.programmes.join("; "),
  signal.ranking_or_standard,
  dateValue(signal.event_date_start),
  dateValue(signal.event_date_end),
  signal.date_precision,
  signal.official_date_text,
  signal.verification_status,
  signal.factual_summary,
  signal.esmt_interpretation,
  signal.recommended_action,
  signal.proposed_owner,
  dateValue(signal.proposed_due_date),
  signal.source_ids.length,
  signal.score_inputs.strategic_impact,
  signal.score_inputs.urgency,
  signal.score_inputs.actionability,
  signal.score_inputs.esmt_relevance,
  signal.score_inputs.evidence_confidence,
  null,
  null,
  signal.sources.filter((source) => source.url).map((source) => source.url).join(" | "),
  signal.independent_confirmation_count,
]);
signalSheet.getRange(`A3:AB${signals.length + 2}`).values = signalRows;
const firstSignalRow = 3;
const lastSignalRow = signals.length + 2;
signalSheet.getRange(`Y${firstSignalRow}`).formulas = [["=ROUND((T3*'Scoring Rules'!$B$7+U3*'Scoring Rules'!$B$8+V3*'Scoring Rules'!$B$9+W3*'Scoring Rules'!$B$10+X3*'Scoring Rules'!$B$11)/5,1)"]];
signalSheet.getRange(`Y${firstSignalRow}:Y${lastSignalRow}`).fillDown();
signalSheet.getRange(`Z${firstSignalRow}`).formulas = [["=IF(ABS(B3-Y3)<0.01,\"OK\",\"CHECK\")"]];
signalSheet.getRange(`Z${firstSignalRow}:Z${lastSignalRow}`).fillDown();
signalSheet.getRange(`I3:J${lastSignalRow}`).format.numberFormat = "yyyy-mm-dd";
signalSheet.getRange(`R3:R${lastSignalRow}`).format.numberFormat = "yyyy-mm-dd";
signalSheet.getRange(`B3:B${lastSignalRow}`).format.numberFormat = "0.0";
signalSheet.getRange(`T3:X${lastSignalRow}`).format.numberFormat = "0";
signalSheet.tables.add(`A2:AB${lastSignalRow}`, true, "SignalRegisterTable");
signalSheet.freezePanes.freezeRows(2);
signalSheet.freezePanes.freezeColumns(6);
signalSheet.dataValidations.add({ range: `D3:D${lastSignalRow}`, rule: { type: "list", values: ["New", "In review", "Actioned", "Monitoring", "Closed", "Superseded"] } });
signalSheet.getRange(`B3:B${lastSignalRow}`).conditionalFormats.add("colorScale", {
  criteria: [
    { type: "lowestValue", color: COLORS.paleGrey },
    { type: "percentile", value: 50, color: COLORS.paleAmber },
    { type: "highestValue", color: COLORS.paleRed },
  ],
});
signalSheet.getRange(`Z3:Z${lastSignalRow}`).conditionalFormats.add("containsText", { text: "CHECK", format: { fill: COLORS.paleRed, font: { color: COLORS.red, bold: true } } });
signalSheet.getRange(`A2:AB${lastSignalRow}`).format.verticalAlignment = "top";
signalSheet.getRange(`F3:R${lastSignalRow}`).format.wrapText = true;
signalSheet.getRange(`AA3:AA${lastSignalRow}`).format.wrapText = true;
signalSheet.getRange(`A3:AB${lastSignalRow}`).format.rowHeight = 66;
signalSheet.getRange("A:A").format.columnWidth = 28;
signalSheet.getRange("B:E").format.columnWidth = 14;
signalSheet.getRange("F:F").format.columnWidth = 42;
signalSheet.getRange("G:H").format.columnWidth = 24;
signalSheet.getRange("I:J").format.columnWidth = 12;
signalSheet.getRange("K:M").format.columnWidth = 23;
signalSheet.getRange("N:P").format.columnWidth = 52;
signalSheet.getRange("Q:Q").format.columnWidth = 30;
signalSheet.getRange("R:Z").format.columnWidth = 14;
signalSheet.getRange("AA:AA").format.columnWidth = 48;
signalSheet.getRange("AB:AB").format.columnWidth = 14;
console.log("Workbook build: Signals complete");

// Sources
styleTitle(sourceSheet, "A1:L1", "Source Registry and Coverage Gaps");
const sourceHeaders = ["Source ID", "Source", "Publisher", "Family", "Evidence Type", "Access Mode", "Cadence", "Authority (0-5)", "Enabled", "Last Checked", "Canonical URL", "Caveat"];
sourceSheet.getRange("A2:L2").values = [sourceHeaders];
styleHeader(sourceSheet.getRange("A2:L2"));
const sourceRows = sources.map((source) => [
  source.source_id,
  source.name,
  source.publisher,
  source.source_family,
  source.evidence_type,
  source.access_mode,
  source.monitor_cadence,
  source.authority_score,
  source.enabled,
  dateValue(source.checked_at),
  source.canonical_url,
  source.caveat,
]);
sourceSheet.getRange(`A3:L${sources.length + 2}`).values = sourceRows;
sourceSheet.getRange(`J3:J${sources.length + 2}`).format.numberFormat = "yyyy-mm-dd";
sourceSheet.tables.add(`A2:L${sources.length + 2}`, true, "SourceRegistryTable");
sourceSheet.freezePanes.freezeRows(2);
sourceSheet.getRange(`F3:F${sources.length + 2}`).conditionalFormats.add("containsText", { text: "manual_private", format: { fill: COLORS.paleRed, font: { color: COLORS.red, bold: true } } });
sourceSheet.getRange(`I3:I${sources.length + 2}`).conditionalFormats.add("cellIs", { operator: "equal", formula: 0, format: { fill: COLORS.paleAmber, font: { color: COLORS.amber } } });
sourceSheet.getRange(`A3:L${sources.length + 2}`).format.wrapText = true;
sourceSheet.getRange(`A3:L${sources.length + 2}`).format.rowHeight = 38;
sourceSheet.getRange("A:A").format.columnWidth = 26;
sourceSheet.getRange("B:B").format.columnWidth = 38;
sourceSheet.getRange("C:F").format.columnWidth = 22;
sourceSheet.getRange("G:G").format.columnWidth = 26;
sourceSheet.getRange("H:J").format.columnWidth = 14;
sourceSheet.getRange("K:K").format.columnWidth = 48;
sourceSheet.getRange("L:L").format.columnWidth = 50;
console.log("Workbook build: Sources complete");

// Scoring rules
styleTitle(scoringSheet, "A1:G1", "Scoring Governance — Prototype v1");
scoringSheet.getRange("A3:G4").merge();
scoringSheet.getRange("A3").values = [["This is a configurable management rule, not a predictive model. Production requires approval, versioning, override reasons, and periodic back-testing against real actions."]];
scoringSheet.getRange("A3:G4").format = { fill: COLORS.paleAmber, font: { color: COLORS.amber, bold: true }, wrapText: true, verticalAlignment: "center" };
scoringSheet.getRange("A6:C6").values = [["Dimension", "Weight", "Review question"]];
styleHeader(scoringSheet.getRange("A6:C6"));
scoringSheet.getRange("A7:C11").values = [
  ["Strategic impact", 30, "Could this materially affect eligibility, position, accreditation, or trust?"],
  ["Urgency", 25, "How soon does the response window start or close?"],
  ["Actionability", 20, "Can ESMT take a concrete action?"],
  ["ESMT relevance", 15, "Is the exposed programme or process material to ESMT?"],
  ["Evidence confidence", 10, "How authoritative, precise, and reproducible is the evidence?"],
];
scoringSheet.getRange("A12").values = [["Weight check"]];
scoringSheet.getRange("B12").formulas = [["=SUM(B7:B11)"]];
scoringSheet.getRange("B7:B12").format.numberFormat = "0\"%\"";
scoringSheet.getRange("E6:F6").values = [["Priority band", "Minimum score"]];
styleHeader(scoringSheet.getRange("E6:F6"));
scoringSheet.getRange("E7:F10").values = [["Act now", 75], ["Plan", 55], ["Monitor", 35], ["Archive", 0]];
scoringSheet.getRange("A15:G17").merge();
scoringSheet.getRange("A15").values = [["Formula: score = (impact×30 + urgency×25 + actionability×20 + relevance×15 + confidence×10) / 5. Each dimension is scored from 0 to 5. The Signals sheet recomputes every score and flags mismatches."]];
scoringSheet.getRange("A15:G17").format = { fill: COLORS.paleBlue, font: { color: COLORS.ink }, wrapText: true, verticalAlignment: "center" };
scoringSheet.getRange("A6:C12").format.borders = { preset: "outside", style: "thin", color: COLORS.line };
scoringSheet.getRange("E6:F10").format.borders = { preset: "outside", style: "thin", color: COLORS.line };
scoringSheet.getRange("A:A").format.columnWidth = 24;
scoringSheet.getRange("B:B").format.columnWidth = 14;
scoringSheet.getRange("C:C").format.columnWidth = 58;
scoringSheet.getRange("D:D").format.columnWidth = 4;
scoringSheet.getRange("E:F").format.columnWidth = 20;
console.log("Workbook build: Scoring Rules complete");

// QS trends
styleTitle(qsSheet, "A1:N1", "QS ESMT Trend and Selected German-Peer Diagnostics");
qsSheet.getRange("A3:N3").merge();
qsSheet.getRange("A3").values = [["Source: supplied official QS 2024–2026 result exports. Descriptive outputs do not establish causality. Rankings should be read together with score movement and cohort context."]];
qsSheet.getRange("A3:N3").format = { fill: COLORS.paleAmber, font: { color: COLORS.amber, bold: true }, wrapText: true };
const trendHeaders = ["Ranking", "Edition", "Rank", "Overall", "Employability", "E&A Outcomes", "ROI", "Thought Leadership", "Diversity", "Alumni Outcomes", "Value for Money", "Source File"];
qsSheet.getRange("A5:L5").values = [trendHeaders];
styleHeader(qsSheet.getRange("A5:L5"));
const trendRows = trends.map((row) => [
  row.ranking,
  Number(row.edition),
  Number(row.rank),
  Number(row.overall_score),
  row.employability ? Number(row.employability) : null,
  row.entrepreneurship_alumni_outcomes ? Number(row.entrepreneurship_alumni_outcomes) : null,
  row.roi ? Number(row.roi) : null,
  row.thought_leadership ? Number(row.thought_leadership) : null,
  row.diversity ? Number(row.diversity) : null,
  row.alumni_outcomes ? Number(row.alumni_outcomes) : null,
  row.value_for_money ? Number(row.value_for_money) : null,
  row.source_file,
]);
qsSheet.getRange(`A6:L${trendRows.length + 5}`).values = trendRows;
qsSheet.tables.add(`A5:L${trendRows.length + 5}`, true, "QSEsmtTrendTable");
qsSheet.getRange(`C6:K${trendRows.length + 5}`).format.numberFormat = "0.0";

const mba2025 = trends.find((row) => row.ranking === "QS Global MBA" && row.edition === "2025");
const mba2026 = trends.find((row) => row.ranking === "QS Global MBA" && row.edition === "2026");
const mim2025 = trends.find((row) => row.ranking === "QS Management" && row.edition === "2025");
const mim2026 = trends.find((row) => row.ranking === "QS Management" && row.edition === "2026");
qsSheet.getRange("A13:B13").values = [["MBA component", "2026 minus 2025"]];
styleHeader(qsSheet.getRange("A13:B13"));
qsSheet.getRange("A14:B18").values = [
  ["Employability", Number(mba2026.employability) - Number(mba2025.employability)],
  ["E&A Outcomes", Number(mba2026.entrepreneurship_alumni_outcomes) - Number(mba2025.entrepreneurship_alumni_outcomes)],
  ["ROI", Number(mba2026.roi) - Number(mba2025.roi)],
  ["Thought Leadership", Number(mba2026.thought_leadership) - Number(mba2025.thought_leadership)],
  ["Diversity", Number(mba2026.diversity) - Number(mba2025.diversity)],
];
qsSheet.getRange("B14:B18").format.numberFormat = "+0.0;-0.0;0.0";
const mbaChart = qsSheet.charts.add("bar", qsSheet.getRange("A13:B18"));
mbaChart.title = "MBA: largest decline is E&A Outcomes";
mbaChart.titleTextStyle.fontSize = 12;
mbaChart.hasLegend = false;
mbaChart.xAxis = { numberFormatCode: "+0.0;-0.0;0.0" };
mbaChart.setPosition("D13", "J28");

qsSheet.getRange("A22:B22").values = [["Management component", "2026 minus 2025"]];
styleHeader(qsSheet.getRange("A22:B22"));
qsSheet.getRange("A23:B27").values = [
  ["Employability", Number(mim2026.employability) - Number(mim2025.employability)],
  ["Alumni Outcomes", Number(mim2026.alumni_outcomes) - Number(mim2025.alumni_outcomes)],
  ["Value for Money", Number(mim2026.value_for_money) - Number(mim2025.value_for_money)],
  ["Thought Leadership", Number(mim2026.thought_leadership) - Number(mim2025.thought_leadership)],
  ["Diversity", Number(mim2026.diversity) - Number(mim2025.diversity)],
];
qsSheet.getRange("B23:B27").format.numberFormat = "+0.0;-0.0;0.0";
const mimChart = qsSheet.charts.add("bar", qsSheet.getRange("A22:B27"));
mimChart.title = "Management: Value for Money fell 4.6 points";
mimChart.titleTextStyle.fontSize = 12;
mimChart.hasLegend = false;
mimChart.xAxis = { numberFormatCode: "+0.0;-0.0;0.0" };
mimChart.setPosition("D30", "J45");

const pivotPeers = new Map();
for (const row of peers) {
  const key = `${row.ranking}|${row.school}`;
  if (!pivotPeers.has(key)) pivotPeers.set(key, { ranking: row.ranking, school: row.school });
  pivotPeers.get(key)[row.edition] = Number(row.rank);
}
const peerRows = [...pivotPeers.values()].map((row) => [row.ranking, row.school, row["2025"], row["2026"], row["2026"] - row["2025"]]);
qsSheet.getRange("A49:E49").values = [["Ranking", "Selected German peer", "2025 rank", "2026 rank", "Rank change (+ worse)"]];
styleHeader(qsSheet.getRange("A49:E49"));
qsSheet.getRange(`A50:E${peerRows.length + 49}`).values = peerRows;
qsSheet.tables.add(`A49:E${peerRows.length + 49}`, true, "QSGermanPeersTable");
qsSheet.getRange(`C50:E${peerRows.length + 49}`).format.numberFormat = "0";
qsSheet.getRange(`E50:E${peerRows.length + 49}`).conditionalFormats.add("colorScale", {
  criteria: [
    { type: "lowestValue", color: COLORS.paleGreen },
    { type: "percentile", value: 50, color: COLORS.paleGrey },
    { type: "highestValue", color: COLORS.paleRed },
  ],
});
qsSheet.getRange("A:A").format.columnWidth = 25;
qsSheet.getRange("B:B").format.columnWidth = 34;
qsSheet.getRange("C:K").format.columnWidth = 15;
qsSheet.getRange("L:L").format.columnWidth = 48;
qsSheet.freezePanes.freezeRows(5);
console.log("Workbook build: QS Trends complete");

// Communication QA
styleTitle(qaSheet, "A1:H1", "Communication QA — Verified Public-Claim Mismatches");
qaSheet.getRange("A3:H4").merge();
qaSheet.getRange("A3").values = [["These records compare official ESMT pages with publisher results. Closing a record should require a corrected page, validation date, reviewer, and evidence link — not only a status change."]];
qaSheet.getRange("A3:H4").format = { fill: COLORS.paleRed, font: { color: COLORS.red, bold: true }, wrapText: true, verticalAlignment: "center" };
const qaSignals = signals.filter((signal) => signal.signal_type === "communication_mismatch");
qaSheet.getRange("A6:H6").values = [["Score", "Issue", "Verified mismatch", "Proposed correction", "Owner", "Due", "Status", "Evidence URLs"]];
styleHeader(qaSheet.getRange("A6:H6"));
qaSheet.getRange(`A7:H${qaSignals.length + 6}`).values = qaSignals.map((signal) => [
  signal.priority_score,
  signal.title,
  signal.factual_summary,
  signal.recommended_action,
  signal.proposed_owner,
  dateValue(signal.proposed_due_date),
  signal.status,
  signal.sources.filter((source) => source.url).map((source) => source.url).join(" | "),
]);
qaSheet.getRange(`F7:F${qaSignals.length + 6}`).format.numberFormat = "yyyy-mm-dd";
qaSheet.tables.add(`A6:H${qaSignals.length + 6}`, true, "CommunicationQATable");
qaSheet.getRange(`B7:H${qaSignals.length + 6}`).format.wrapText = true;
qaSheet.getRange(`A7:H${qaSignals.length + 6}`).format.rowHeight = 66;
qaSheet.getRange("A:A").format.columnWidth = 12;
qaSheet.getRange("B:B").format.columnWidth = 38;
qaSheet.getRange("C:D").format.columnWidth = 62;
qaSheet.getRange("E:E").format.columnWidth = 28;
qaSheet.getRange("F:G").format.columnWidth = 15;
qaSheet.getRange("H:H").format.columnWidth = 55;
qaSheet.freezePanes.freezeRows(6);
console.log("Workbook build: Communication QA complete");

await fs.mkdir(PREVIEW_DIR, { recursive: true });
for (const sheet of [dashboard, signalSheet, sourceSheet, scoringSheet, qsSheet, qaSheet]) {
  console.log(`Workbook render: ${sheet.name}`);
  const preview = await workbook.render({ sheetName: sheet.name, autoCrop: "all", scale: 0.85, format: "png" });
  const safeName = sheet.name.toLowerCase().replaceAll(" ", "_");
  await fs.writeFile(path.join(PREVIEW_DIR, `${safeName}.png`), new Uint8Array(await preview.arrayBuffer()));
}

const formulaAudit = await workbook.inspect({ kind: "formula", maxChars: 6000, options: { maxResults: 120 } });
console.log(formulaAudit.ndjson);

const formulaErrors = [];
for (const sheet of [dashboard, signalSheet, sourceSheet, scoringSheet, qsSheet, qaSheet]) {
  const values = sheet.getUsedRange(true).values;
  values.forEach((row, rowIndex) => row.forEach((value, colIndex) => {
    if (typeof value === "string" && /^#(REF!|DIV\/0!|VALUE!|NAME\?|N\/A)/.test(value)) {
      formulaErrors.push(`${sheet.name}!R${rowIndex + 1}C${colIndex + 1}: ${value}`);
    }
  }));
}
if (formulaErrors.length) {
  throw new Error(`Formula errors detected: ${formulaErrors.join("; ")}`);
}

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(OUTPUT_FILE);
console.log(`Saved ${OUTPUT_FILE}`);
