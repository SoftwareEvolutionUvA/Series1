module Metrics::UnitSize

import Metrics::Volume;
import lang::java::m3::Core;
import List;
import util::Math;

int riskEvaluation(int linesOfCode) {
    if (linesOfCode < 10) return 3;
    if (10 <= linesOfCode && linesOfCode < 20) return 2;
    if (20 <= linesOfCode && linesOfCode < 30) return 1;
    return 0;
}

list[real] relativeRisks(list[int] linesOfCode, int projectLoc) {
    return [(toReal(absLoc) / projectLoc) * 100 | absLoc <- linesOfCode];  
}

int score(list[int] linesOfCode, int projectLoc) {
    list[real] relativeLoc = relativeRisks(linesOfCode, projectLoc);
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

list[int] calculateLOCMethods(M3 model) {
    list[int] linesOfCode = [0, 0, 0, 0]; // risk: without much risk to very high

    set[loc] methods = methods(model);

    for (m <- methods) {
        int locMethod = size(getLines(m));
        int idx = riskEvaluation(locMethod);
        linesOfCode[idx] += locMethod;
    }
    return linesOfCode;
}
