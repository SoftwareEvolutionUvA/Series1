// This program provides four metrics of the SIG Maintainability Model. The AST of a given Java program is obtained, 
// and volume, unit size, unit complexity, and duplicate metrics are calculated. 
module Main

import IO;
import List;
import Set;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;
import DateTime;

import Metrics::Volume;
import Metrics::UnitComplexity;
import Metrics::UnitSize;
import Metrics::Duplication;

void main() {
    // load project and generate M3
    // loc testProjectLocation = |project://Series1/test/TestCode|;
    loc testProjectLocation = |project://smallsql0.21_src|;
    //loc testProjectLocation = |project://hsqldb-2.3.1|;

    // Metric 1: Volume rank
    datetime begin1 = now();
    int volumeRanking = volumeRank(testProjectLocation);
    datetime end1 = now();
    println("Volume ranking is <volumeRanking>");
    println("Volume rank calculation done in <createDuration(begin1, end1)>");

    // Metric 2: Unit Size rank
    datetime begin2 = now();
    int USizeRanking = unitSizeRank(testProjectLocation);
    datetime end2 = now();
    println("Unit Size ranking is <volumeRanking>");
    println("Unit Size rank calculation done in <createDuration(begin2, end2)>");

    // Metric 3: Unit Complexity rank
    datetime begin3 = now();
    int CCRanking = complexityRank(testProjectLocation);
    datetime end3 = now();
    println("Unit Complexity ranking is <CCRanking>");
    println("Unit Compexity rank calculation done in <createDuration(begin3, end3)>");    

    // Metric 4: Duplication rank
    datetime begin4 = now();
    int dupRank = duplicationRank(testProjectLocation);
    datetime end4 = now();
    println("Duplication ranking is <dupRank>");
    println("Duplication rank calculation done in <createDuration(begin4, end4)>");

    //TODO: Maintainability score calculations called below.

}
