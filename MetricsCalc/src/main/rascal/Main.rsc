// This program provides four metrics of the SIG Maintainability Model. The AST of a given Java program is obtained, 
// and volume, unit size, unit complexity, and duplicate metrics are calculated. 
module Main

import IO;
import List;
import Set;
import String;
import Map;
import lang::java::m3::Core;
import lang::java::m3::AST;
import DateTime;
import Report;
import util::Math;

import Metrics::Volume;
import Metrics::UnitComplexity;
import Metrics::UnitSize;
import Metrics::Duplication;

import Scores::Analysability;
import Scores::Changeability;
import Scores::Testability;
import Scores::Maintainability;


void main() {
    loc testProjectLocation = |project://Series1/test/TestCode|;
    str applicationName = "TestCode";
    //loc testProjectLocation = |project://smallsql0.21_src|;
    //loc testProjectLocation = |project://hsqldb-2.3.1|;
    map[str, int] metrics = ();
    map[str, int] scores = ();

    // Metric 1: Volume rank
    datetime begin1 = now();
    int absoluteLOC = calculateProjectLOC(testProjectLocation);
    metrics["volume"] = scoreLOC(absoluteLOC);
    datetime end1 = now();
    println("Volume rank: <metrics["volume"]>");
    durVolume = createDuration(begin1, end1);
    println("Volume rank calculation done in <durVolume>");

    // Metric 2: Unit Size rank
    datetime begin2 = now();
    list[int] locRiskCategory = calculateLOCofMethods(testProjectLocation);
    metrics["unitSize"] = score(locRiskCategory, absoluteLOC);
    datetime end2 = now();
    println("Unit size rank: <metrics["unitSize"]>");
    durUnitSize = createDuration(begin2, end2);
    println("Unit Size rank calculation done in <durUnitSize>");

    // Metric 3: Unit Complexity rank
    datetime begin3 = now();
    list[tuple[str, real]] grps = calculateLOCByRiskGroup(testProjectLocation, absoluteLOC);
    metrics["unitComplexity"] = rankCC(grps);
    datetime end3 = now();
    println("Unit complexity rank: <metrics["unitComplexity"]>");
    durUnitComplexity = createDuration(begin3, end3);
    println("Unit Compexity rank calculation done in <durUnitComplexity>");


    // Metric 4: Duplication rank
    datetime begin4 = now();
    int absDuplicateLines = absoluteDuplicateLines(testProjectLocation);
    real relDuplicateLines = absDuplicateLines / toReal(absoluteLOC) * 100;
    metrics["duplication"] = scoreDuplicates(relDuplicateLines);
    datetime end4 = now();
    println("Duplication rank: <metrics["duplication"]>");
    durDuplication = createDuration(begin4, end4);
    println("Duplication rank calculation done in <durDuplication>");

    /**
    * Score 1: Analysability
    * Analysability depends on the total volume of a project, the unit size of the methods of the project,
    * and the degree of duplication.
    **/
    scores["analysability"] = calculate_analysability(metrics);

    /**
    * Score 2: Changeability
    * Changeability depends on the cyclomatic unit complexity of a program, and the degree of duplication in
    * the source code.
    **/
    scores["changeability"] = calculate_changeability(metrics);

    /**
    * Score 3: Testability
    * Testability depends on the cyclomatic unit complexity of the methods of a program, and the unit size of the 
    * methods of the project.
    **/
    scores["testability"] = calculate_testability(metrics);

    // Final score: Maintainability
    scores ["maintainability"] = calculate_maintainability(scores);

    println("Metrics: <metrics>");
    println("Numerical scores: <scores>");
    
    map[str, str] finalScores = ranking(scores); // Obtain the scores with the (--/++) ranking (see "Maintainability" for function)

    println("Analysability score: <finalScores["analysability"]>");
    println("Changeability score: <finalScores["changeability"]>");
    println("Testability score: <finalScores["testability"]>");
    println("Final SIG Maintainability score: <finalScores["maintainability"]>");

    /** 
    * Finally, create a report for the found results.
    **/
    map[str, str] metricsSymbols = ranking(metrics);
    todayDate = splitDateTime(begin1);
    totalTime = createDuration(begin1, end4);
    values = (
        "_APPLICATION_" : applicationName,
        "_STARTTIME_" : "<todayDate[1]>",
        "_DATE_" : "<todayDate[0]>",
        "_EXECUTIONTIME_" : "<totalTime>",
        "_OVERALLSCORE_" : "<finalScores["maintainability"]>",
        //
        "_VOLUME-NUMERIC_" : "<absoluteLOC>",
        "_VOLUME-SCORE_" : "<metricsSymbols["volume"]>",
        "_VOLUME-EXECTIME_" : "<durVolume>",
        //
        "_UNITSIZE-NUMERIC_" : "<locRiskCategory>",
        "_UNITSIZE-SCORE_" : "<metricsSymbols["unitSize"]>",
        "_UNITSIZE-EXECTIME_" : "<durUnitSize>",
        //
        "_COMPLEXITY-NUMERIC_" : "<grps>",
        "_COMPLEXITY-SCORE_" : "<metricsSymbols["unitComplexity"]>",
        "_COMPLEXITY-EXECTIME_" : "<durUnitComplexity>",
        //
        "_DUPLICATION-NUMERIC_" : "<absDuplicateLines>",
        "_DUPLICATION-SCORE_" : "<metricsSymbols["duplication"]>",
        "_DUPLICATION-EXECTIME_" : "<durDuplication>",
        //
        "_ANALYSABILITY-SCORE_" : "<finalScores["analysability"]>",
        "_CHANGEABILITY-SCORE_" : "<finalScores["changeability"]>",
        "_TESTABILITY-SCORE_" : "<finalScores["testability"]>"
    );
    createReport(values);
}
