module Metrics::UnitComplexity

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


/* 
Cyclomatic Complexity (CC), as described by McGabe et al. (1976), can be calculated by displaying a
given program in a control flow graph. Following, CC is calculated by counting the edges (E) and nodes (N).
This gives: CC = E - N + 2

Another method to calculating the CC is to traverse the AST of the given program and count all the statements
that increase complexity, which are conditionals such if, while, or, etc. 

The latter method is implemented below.
*/


// Function that returns the list of ASTs of each method in a given project
list[Declaration] getMethodASTsProject(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);

    list[Declaration] methodASTs = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];

    // return methodASTs;
    return [ m | /Declaration m := methodASTs, m is method || m is constructor]; // Also returns methodCalls(), but I think that is ok.
}

// Function returning the risk category based on the CC of a method
str riskCat(int cc) {
    if (cc < 1) return "CC cannot be smaller than 1 (was <cc>)";
    if (cc <= 10) return "low risk";
    if (cc <= 20) return "moderate risk";
    if (cc <= 50) return "high risk";
    return "very high risk";
}

int countConditionals(Declaration methodAST) {
    int metric = 1;
    visit (methodAST) {
        case \do(_,_) : metric += 1;
        case \foreach(_,_,_) : metric += 1;
        case \for(_,_,_,_) : metric += 1;
        case \for(_,_,_) : metric += 1;
        case \if(_,_) : metric += 1;
        case \if(_,_,_) : metric += 1;
        case \case(_) : metric += 1;
        case \catch(_,_): metric += 1;
        case \conditional(_,_,_): metric += 1;
        case \infix(_,"&&",_) : metric += 1;
        case \infix(_,"||",_) : metric += 1;
        case \while(_,_) : metric += 1;
        case \methodCall(_,_, "forEach",_) : metric += 1;
        case \methodCall(_,"forEach",_) : metric += 1;
    }
    return metric;
}

// Function that visits the ASTs of all methods of a Java project (potentially multiple programs) 
// and counts complexity-contributing statements per method with its risk category
list[tuple[loc, str]] riskCalc(list[Declaration] projectAST) {
    return for (mtd <- projectAST) {
        int numConditionals = countConditionals(mtd);
        str category = riskCat(numConditionals);
        append <mtd.src, category>;
    }
}

list[tuple[str, real]] riskPercentages(list[tuple[loc, str]] methods, loc projectLocation) {
    list[int] countModerate = [size(getLines(l)) | <l, "moderate risk"> <- methods];
    list[int] countHigh = [size(getLines(l)) | <l, "high risk"> <- methods];
    list[int] countVeryHigh = [size(getLines(l)) | <l, "very high risk"> <- methods];
    
    int modLOC = isEmpty(countModerate) ? 0 : sum(countModerate);
    int highLOC = isEmpty(countHigh) ? 0 : sum(countHigh);
    int vhighLOC = isEmpty(countVeryHigh) ? 0 : sum(countVeryHigh);

    int projectLoc = calculateProjectLOC(projectLocation);

    return [
        <"moderate", (toReal(modLOC) / projectLoc * 100)>,
        <"high", (toReal(highLOC) / projectLoc * 100)>,
        <"very high", (toReal(vhighLOC) / projectLoc * 100)>
        ];
}

int rankCC(list[tuple[str, real]] riskP) {
    real veryHighScore = riskP[2][1];
    real highScore = riskP[1][1];
    real moderateScore = riskP[0][1];

    if (moderateScore > 50.0 || highScore > 15.0 || veryHighScore > 5.0) return 1;
    if (moderateScore > 40.0 || highScore > 10.0 || veryHighScore > 0.0) return 2;
    if (moderateScore > 30.0 || highScore > 5.0 || veryHighScore > 0.0) return 3;
    if (moderateScore > 25.0 || highScore > 0.0 || veryHighScore > 0.0) return 4;
    return 5;
}

// Function to calculate the ranking of Cyclomatic complexity of a Java project. 
// Returns rank from 1-5 (--/-/o/+/++, respectively)
int complexityRank(loc projectLocation) {
    list[Declaration] projectAST = getMethodASTsProject(projectLocation);
    list[tuple[loc, str]] risks = riskCalc(projectAST);
    list[tuple[str, real]] riskPerc = riskPercentages(risks, projectLocation);

    return rankCC(riskPerc); 
}
