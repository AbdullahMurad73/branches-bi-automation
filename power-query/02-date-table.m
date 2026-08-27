// ============================================================
// جدول التقويم — أساس أي تحليل زمني في Power BI
// ------------------------------------------------------------
// بدون جدول تقويم مستقل، دوال الذكاء الزمني (مقارنة بالشهر
// السابق، النمو السنوي) لا تعمل بشكل صحيح.
// ============================================================

let
    تاريخ_البداية = #date(2024, 1, 1),
    تاريخ_النهاية = #date(2026, 12, 31),
    عدد_الأيام = Duration.Days(تاريخ_النهاية - تاريخ_البداية) + 1,

    قائمة = List.Dates(تاريخ_البداية, عدد_الأيام, #duration(1, 0, 0, 0)),
    كجدول = Table.FromList(قائمة, Splitter.SplitByNothing(), {"التاريخ"}),
    بنوع = Table.TransformColumnTypes(كجدول, {{"التاريخ", type date}}),

    مع_أعمدة = Table.AddColumn(بنوع, "السنة", each Date.Year([التاريخ]), Int64.Type),
    مع_شهر = Table.AddColumn(مع_أعمدة, "رقم الشهر", each Date.Month([التاريخ]), Int64.Type),
    مع_اسم_شهر = Table.AddColumn(مع_شهر, "الشهر", each Date.MonthName([التاريخ]), type text),
    مع_ربع = Table.AddColumn(مع_اسم_شهر, "الربع", each "الربع " & Text.From(Date.QuarterOfYear([التاريخ])), type text),
    مع_يوم = Table.AddColumn(مع_ربع, "اليوم", each Date.DayOfWeekName([التاريخ]), type text),
    مع_سنة_شهر = Table.AddColumn(مع_يوم, "سنة-شهر", each Date.ToText([التاريخ], "yyyy-MM"), type text)
in
    مع_سنة_شهر
