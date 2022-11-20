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
    //loc locationTestCode = |project://Series1/test/TestCode|;
    loc locationTestCode = |project://smallsql0.21_src|;
    //loc locationTestCode = |project://hsqldb-2.3.1|;
    M3 model = createM3FromMavenProject(locationTestCode);
    
    // calculate Volume
    datetime begin = now();
    // int scoreVolume = scoreLOC(calculateProjectLOC(locationTestCode));
    datetime end = now();
    // println("Volume done in <createDuration(begin, end)>");
    // println("Volume Score is <scoreVolume>");

    // calculate Complexity per Unit
    // str scoreComplexity = complexityRank(locationTestCode)[1];
    // println("Complexity Per Unit Score is <scoreComplexity>");

    // calculate Unit Size
    // begin = now();
    // list[int] locByRiskLevel = calculateLOCMethods(model);
    // // TODO: having 2nd parameter here doesn't make sense. LOC of project can be obtained from first volume call
    // int scoreUnitSize = score(locByRiskLevel, locationTestCode);
    // end = now();
    // println("Unit Size done in <createDuration(begin, end)>");
    // println("Unit Size Score is <scoreUnitSize>");

    // calculate Duplication
    begin = now();
    int dupLines = absoluteDuplicateLinesProject(locationTestCode);
    end = now();
    println("Duplication done in <createDuration(begin, end)>");
    println("Duplication Score is <dupLines>");
}
