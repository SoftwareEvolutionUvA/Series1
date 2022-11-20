module Metrics::Test::UnitSize

import Metrics::Volume;
import Metrics::UnitSize;
import lang::java::m3::Core;
import IO;

test bool testRiskEvaluation0() {
    return riskEvaluation(30) == 0;
}

test bool testRiskEvaluation1() {
    return riskEvaluation(20) == 1;
}

test bool testRiskEvaluation2() {
    return riskEvaluation(10) == 2;
}

test bool testRiskEvaluation3() {
    return riskEvaluation(0) == 3;
}

test bool testCalculateLOCMethods() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    M3 model = createM3FromMavenProject(locationTestCode);
    return calculateLOCMethods(model) == [0, 0, 28, 14];
}

test bool testRelativeRisks() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    M3 model = createM3FromMavenProject(locationTestCode);
    list[int] locsRisksAbs = calculateLOCMethods(model);
    int locProject = calculateProjectLOC(locationTestCode);

    list[real] res = relativeRisks(locsRisksAbs, locProject);
    return res == [0.,0.,(28.0/48)*100,(14.0/48)*100];
}

test bool testScore() {
     loc locationTestCode = |project://Series1/test/TestCode|;
    M3 model = createM3FromMavenProject(locationTestCode);
    list[int] locsRisksAbs = calculateLOCMethods(model);
    int locProject = calculateProjectLOC(locationTestCode);

    return score(locsRisksAbs, locProject) == 1;
}