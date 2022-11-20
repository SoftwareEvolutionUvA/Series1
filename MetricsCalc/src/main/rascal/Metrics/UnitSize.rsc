module Metrics::UnitSize

import Metrics::Volume;

import List;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;


/**
* Evaluates for size of a method what the risk level (0-4) in terms of unit size is. 
* @param linesOfCode for the number of lines of a method
* @return risk level in unit size
*/
int riskEvaluation(int linesOfCode) {
    if (linesOfCode < 10) return 3;
    if (10 <= linesOfCode && linesOfCode < 20) return 2;
    if (20 <= linesOfCode && linesOfCode < 30) return 1;
    return 0;
}

// TODO: The getProjectASTs in UnitComplexity now returns an AST with only the methods. 
// This can be used below instead of making a new M3 model and looping over the method-locations!
/**
* Calculates the total LOC per risk-category of methods from the project location given by caller.
* @param projectLoc for the location to project location containing files
* @return list of risk categories (0-4) with total LOC per category
*/
list[int] calculateLOCofMethods(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[int] linesOfCode = [0, 0, 0, 0]; // risk: without much risk to very high

    set[loc] methods = methods(model);

    for (m <- methods) {
        int locMethod = size(getLines(m));
        int idx = riskEvaluation(locMethod);
        linesOfCode[idx] += locMethod;
    }
    return linesOfCode;
}

/**
* Calculates the relative risk given the total LOC of a project.
* @param linesOfCode for LOC per risk-category
* @param projectLoc for the location to project location containing files
* @return LOC for the project location
*/
list[real] relativeRisks(list[int] linesOfCode, int projectLOC) {
    return [(toReal(absLoc) / projectLOC) * 100 | absLoc <- linesOfCode];  
}

/**
* Calculates the LOC from the project location given by caller.
* Reducer is used to transform map to tuple to sum amount of lines. 
* @param projectLoc location to project location containing files
* @return LOC for the project location
*/
int score(list[int] linesOfCode, int projectLOC) {
    list[real] relativeLOC = relativeRisks(linesOfCode, projectLOC);

    real veryHighScore = relativeLOC[3];
    real highScore = relativeLOC[2];
    real moderateScore = relativeLOC[1];
    
    // For now, we reuse the risk matrix from the paper for CC
    // Rank of 1 is a high risk, and 5 is the lowest risk
    if (moderateScore > 50.0 || highScore > 15.0 || veryHighScore > 5.0) return 1;
    if (moderateScore > 40.0 || highScore > 10.0 || veryHighScore > 0.0) return 2;
    if (moderateScore > 30.0 || highScore > 5.0 || veryHighScore > 0.0) return 3;
    if (moderateScore > 25.0 || highScore > 0.0 || veryHighScore > 0.0) return 4;
    return 5;
}

/**
* Returns the Unit Size ranking of a project.
* @param projectLoc location to project location containing files
* @return Unit Size rank of the project
*/
int unitSizeRank(loc projectLocation) {
    return score(calculateLOCofMethods(projectLocation), calculateProjectLOC(projectLocation));
}

