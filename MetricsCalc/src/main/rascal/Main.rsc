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

import Metrics::Volume;
import Metrics::UnitComplexity;
import Metrics::UnitSize;
import Metrics::Duplication;

import Scores::Analysability;
import Scores::Changeability;
import Scores::Testability;
import Scores::Maintainability;


void main() {
    // loc testProjectLocation = |project://Series1/test/TestCode|;
    loc testProjectLocation = |project://smallsql0.21_src|;
    //loc testProjectLocation = |project://hsqldb-2.3.1|;
    map[str, int] metrics = ();
    map[str, int] scores = ();

    // Metric 1: Volume rank
    datetime begin1 = now();
    metrics += ("volume" : volumeRank(testProjectLocation));
    datetime end1 = now();
    println("Volume rank: <metrics["volume"]>");
    println("Volume rank calculation done in <createDuration(begin1, end1)>");

    // Metric 2: Unit Size rank
    datetime begin2 = now();
    metrics += ("unitSize" : unitSizeRank(testProjectLocation));
    datetime end2 = now();
    println("Unit size rank: <metrics["unitSize"]>");
    println("Unit Size rank calculation done in <createDuration(begin2, end2)>");

    // Metric 3: Unit Complexity rank
    datetime begin3 = now();
    metrics += ("unitComplexity" : complexityRank(testProjectLocation));
    datetime end3 = now();
    println("Unit complexity rank: <metrics["unitComplexity"]>");
    println("Unit Compexity rank calculation done in <createDuration(begin3, end3)>");


    // Metric 4: Duplication rank
    datetime begin4 = now();
    metrics += ("duplication" : duplicationRank(testProjectLocation));
    datetime end4 = now();
    println("Duplication rank: <metrics["duplication"]>");
    println("Duplication rank calculation done in <createDuration(begin4, end4)>");

    metrics = ( "volume" : 1, "unitSize" : 3, "unitComplexity" : 1, "duplication" : 5);
    /**
    * Score 1: Analysability
    * Analysability depends on the total volume of a project, the unit size of the methods of the project,
    * and the degree of duplication.
    **/
    scores += ("analysability" : calculate_analysability(metrics));

    /**
    * Score 2: Changeability
    * Changeability depends on the cyclomatic unit complexity of a program, and the degree of duplication in
    * the source code.
    **/
    scores += ("changeability" : calculate_changeability(metrics));

    /**
    * Score 3: Testability
    * Testability depends on the cyclomatic unit complexity of the methods of a program, and the unit size of the 
    * methods of the project.
    **/
    scores["testability"] = calculate_testability(metrics);

    // Final score: Maintainability
    scores += ("maintainability" : calculate_maintainability(scores));

    println("Numerical scores: <scores>");
    
    map[str, str] finalScores = ranking(scores); // Obtain the scores with the (--/++) ranking (see "Maintainability" for function)

    println("Analysability score: <finalScores["analysability"]>");
    println("Changeability score: <finalScores["changeability"]>");
    println("Testability score: <finalScores["testability"]>");
    println("Final SIG Maintainability score: <finalScores["maintainability"]>");

    /** 
    * Finally, create a report for the found results.
    **/
    createReport(metrics + scores);
}
