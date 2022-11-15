module Metrics::UnitSize

import Metrics::Volume;
import lang::java::m3::Core;

int riskEvaluation(int locMethod) {
    if (linesOfCode < 10) return 3;
    if (10 <= linesOfCode && linesOfCode < 20) return 2;
    if (20 <= linesOfCode && linesOfCode < 30) return 1;
    return 0;
}

int score(list[int] linesOfCode, loc project) {
    int totalLoc = sum(range(calculateProjectLoc(project)));
    list[real] relativeLoc = [(toReal(absLoc) / totalLoc) * 100 | absLoc <- linesOfCode];
    
    real veryHighScore = relativeLoc[3];
    real highScore = relativeLoc[2];
    real moderateScore = relativeLoc[1];
    
    // for now, we reuse the risk matrix from the paper for CC
    if (moderateScore > 50.0 || highScore > 15.0 || veryHighScore > 5.0) return 1;
    if (moderateScore > 40.0 || highScore > 10.0 || veryHighScore > 0.0) return 2;
    if (moderateScore > 30.0 || highScore > 5.0 || veryHighScore > 0.0) return 3;
    if (moderateScore > 25.0 || highScore > 0.0 || veryHighScore > 0.0) return 4;
    return 5;
}

list[int] calculateLOCMethods(loc fileLoc) {
    list[int] linesOfCode = [0, 0, 0, 0]; // risk: without much risk to very high

    M3 proj = createM3FromMavenProject(fileLoc);
    set[loc] methods = methods(proj);

    for (m <- methods) {
        int locMethod = calculateLoc(m);
        int idx = riskEvaluation(locMethod);
        linesOfCode[idx] += locMethod;
    }
    return linesOfCode;
}
