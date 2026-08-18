# Сценарий демонстрации проекта (7–8 минут)

## 0:00–0:45 — сформулировать проблему

«Я не делала агрегатор новостей. Для Ranking Manager ценность возникает не из количества статей, а из связи между официальным изменением, затронутой программой, доказательством, сроком и владельцем действия. Поэтому объект системы — проверенный signal, а не публикация».

## 0:45–1:45 — показать границы системы

Открыть `Source Health`.

Показать 23 источника и три отключённых private/manual gaps: FT participant communications, QS MoveIN, внутренний evidence/calendar.

Ключевая фраза: «Публичный prototype не претендует на управление submissions. Exact operative deadlines и definitions должны подтверждаться в авторизованных каналах».

## 1:45–3:00 — Priority Inbox

Открыть Dashboard/Inbox и выбрать два разных случая:

1. AACSB 2026 standards — высокий institutional impact.
2. Ближайшее FT/QS publication window — высокий urgency, но это не submission deadline.

Объяснить score: пять видимых компонентов, веса версионируются, override требует причины. Не называть score «AI prediction».

## 3:00–4:15 — Fact / Interpretation / Action

Открыть один Signal Detail и буквально показать три разных блока:

- Verified fact;
- ESMT interpretation;
- Proposed action.

Объяснить, что reviewer может оспорить интерпретацию или action, не меняя исходный факт.

## 4:15–5:30 — QS diagnostics

Показать workbook или notebook.

- Global MBA: rank 78 → 84, score 60.4 → 59.4; основные отрицательные component deltas — E&A Outcomes и Employability.
- Management: rank 75 → 100, score 52.0 → 51.1; Value for Money −4.6.

Вывод: «Место без score и cohort context недостаточно для management reporting. Но эти outputs ещё не доказывают причинность — следующий шаг начинается с reconciliation inputs/evidence».

## 5:30–6:30 — Communication QA

Показать два текущих year-label mismatch на страницах ESMT.

Предложение — не только исправить текст, а создать единый ranking-claims register, из которого проверяются все public claims.

## 6:30–7:30 — production architecture

Открыть Lovable spec и Supabase schema.

Показать:

- RLS/Auth;
- score override с обязательной причиной;
- evidence при закрытии QA;
- audit events;
- private sources не вызываются из browser client;
- snapshot hash создаёт review candidate, а не автоматически подтверждённый methodology change.

## Финальная формулировка

«Prototype решает intelligence и governance slice: обнаружить, проверить, приоритизировать и передать в действие. Production value появится только после подключения авторизованных источников, согласования owners и определения политики evidence/retention».

## Что не утверждать на интервью

- что система уже знает все ranking deadlines;
- что position можно предсказать по одной опубликованной component score;
- что 25 мест равны 25 единицам ухудшения качества;
- что web hash доказывает methodology change;
- что предложенные owners и internal due dates отражают реальную структуру ESMT;
- что publisher workbooks можно свободно распространять.

