module Report

import IO;
import String;

void createReport(map[str, value] vars) {
    str reportTemplate = readFile(|project://Series1/MetricsCalc/report_template.html/|);
    for (var <- vars) {
        reportTemplate = replaceAll(reportTemplate, var, vars[var]);
    }

    writeFile(|project://Series1/MetricsCalc/report_template_someExecution.html|, reportTemplate);
}