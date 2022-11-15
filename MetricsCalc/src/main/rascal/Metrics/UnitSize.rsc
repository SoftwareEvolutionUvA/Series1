module Metrics::UnitSize

import Metrics::Volume;
import lang::java::m3::Core;

list[int] linesOfCode = [0, 0, 0, 0, 0]; // 0 = --, 4 = ++

int riskEvaluation(int locMethod) {
    // TODO: are these limits somewhere?
    if (-1 <= linesOfCode && linesOfCode < -1) return 4;
    if (-1 <= linesOfCode && linesOfCode < -1) return 3;
    if (-1 <= linesOfCode && linesOfCode < -1) return 2;
    if (-1 <= linesOfCode && linesOfCode < -1) return 1;
    return 0;
}

int score(list[int] linesOfCode, loc project) {
    int totalLoc = sum(range(calculateProjectLoc(project)));
    list[real] relativeLoc = [(absLoc / totalLoc) * 100 | absLoc <- linesOfCode];
    
}

void calcStuff(loc fileLoc) {
    M3 proj = createM3FromMavenProject(fileLoc);
    set[loc] methods = methods(proj);

    for (m <- methods) {
        int locMethod = calculateLoc(m);
        int idx = riskEvaluation(locMethod);
        linesOfCode[idx] += locMethod;
    }
}
