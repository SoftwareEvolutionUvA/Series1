// This program provides four metrics of the SIG Maintainability Model. The AST of a given Java program is obtained, 
// and volume, unit size, unit complexity, and duplicate metrics are calculated. 
module Main

import IO;
import List;
import Set;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

import Metrics::Volume;
import Metrics::UnitComplexity;
import Metrics::UnitSize;

void main() {
    // load project and generate M3
    loc locationTestCode = |project://Series1/test/TestCode|;
    M3 model = createM3FromMavenProject(locationTestCode);
    
    // calculate Volume
    int scoreVolume = scoreLOC(calculateProjectLOC(locationTestCode));
    println("Volume Score is <scoreVolume>");

    // calculate Complexity per Unit
    // str scoreComplexity = complexityRank(locationTestCode)[1];
    // println("Complexity Per Unit Score is <scoreComplexity>");

    // calculate Unit Size
    list[int] locByRiskLevel = calculateLOCMethods(model);
    // TODO: having 2nd parameter here doesn't make sense. LOC of project can be obtained from first volume call
    int scoreUnitSize = score(locByRiskLevel, locationTestCode);
    println("Unit Size Score is <scoreUnitSize>");

    // calculate Duplication
    // TODO
}
