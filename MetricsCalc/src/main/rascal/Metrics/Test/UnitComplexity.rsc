module Metrics::Test::UnitComplexity

import Metrics::UnitComplexity;
import Metrics::Volume;

import IO;
import List;
import Map;
import Set;
import String;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Exception;

test bool testGetMethodASTsProject() {
    loc testProjectLocation = |project://Series1/test/TestCode|;
    list[Declaration] decls = getMethodASTsProject(testProjectLocation);
    return size(decls) == 5;
}

test bool testRiskCatError() {
    int cc = 0;
    return riskCat(cc) == "CC cannot be smaller than 1 (was <cc>)";
}

test bool testRiskCatLowRisk() {
    int cc = 1;
    return riskCat(cc) == "low risk";
}

test bool testRiskCatModerateRisk() {
    int cc = 11;
    return riskCat(cc) == "moderate risk";
}

test bool testRiskCatHighRisk() {
    int cc = 21;
    return riskCat(cc) == "high risk";
}

test bool testRiskCatVeryHighRisk() {
    int cc = 51;
    return riskCat(cc) == "very high risk";
}

test bool testCountConditionals() {
    loc testProjectLocation = |project://Series1/test/TestCode|;
    list[Declaration] decls = getMethodASTsProject(testProjectLocation);
    list[int] ret = [countConditionals(elem) | elem <- decls];
    return ret == [1,1,4,4,4];
}

test bool testRiskCalc() {
    loc testProjectLocation = |project://Series1/test/TestCode|;
    list[Declaration] decls = getMethodASTsProject(testProjectLocation);
    list[tuple[loc, str]] ret = riskCalc(decls);

    lrel[loc, str] gt = zip2([d.src | d <- decls], ["low risk" | _ <- [0..5]]);

    return ret == gt;
}

test bool testRiskPercentages() {
    loc testProjectLocation = |project://Series1/test/TestCode|;
    list[Declaration] decls = getMethodASTsProject(testProjectLocation);
    int locProj = calculateProjectLOC(testProjectLocation);

    return riskPercentages(riskCalc(decls), locProj) == [<"moderate", 0.>, <"high", 0.>, <"very high", 0.>];
}

test bool testRankCC1() {
    list[tuple[str, real]] testData = [<"moderate", 50.0>, <"high", 16.0>, <"very high", 4.9>];
    return rankCC(testData) == 1;
}

test bool testRankCC2() {
    list[tuple[str, real]] testData = [<"moderate", 50.0>, <"high", 15.0>, <"very high", 5.0>];
    return rankCC(testData) == 2;
}

test bool testRankCC3() {
    list[tuple[str, real]] testData = [<"moderate", 40.0>, <"high", 10.0>, <"very high", 0.0>];
    return rankCC(testData) == 3;
}

test bool testRankCC4() {
    list[tuple[str, real]] testData = [<"moderate", 30.0>, <"high", 5.0>, <"very high", 0.0>];
    return rankCC(testData) == 4;
}

test bool testRankCC5() {
    list[tuple[str, real]] testData = [<"moderate", 25.0>, <"high", 0.0>, <"very high", 0.0>];
    return rankCC(testData) == 5;
}

test bool testComplexityRank() {
    loc testProjectLocation = |project://Series1/test/TestCode|;
    int locProj = calculateProjectLOC(testProjectLocation);
    return complexityRank(testProjectLocation, locProj) == 5;
}
