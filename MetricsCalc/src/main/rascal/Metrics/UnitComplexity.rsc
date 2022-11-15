module Metrics::UnitComplexity

import IO;
import List;
import Set;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

// import Metrics::Volume;


/* 
Cyclomatic Complexity (CC), as described by McGabe et al. (1976), can be calculated by displaying a
given program in a control flow graph. Following, CC is calculated by counting the edges (E) and nodes (N).
This gives: CC = E - N + 2

Another method to calculating the CC is to traverse the AST of the given program and count all the statements
that increase complexity, which are conditionals such if, while, or, etc. 

The latter method is implemented below.
*/


// Function that returns the list of ASTs of each method in a given project
list[Declaration] getProjectASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] methodASTs = [createAstFromFile(f, true)
        | f <- files(model.containment), isMethod(f)];
    return methodASTs;
}

// Function returning the risk category based on the CC of a method
str riskCat(int cc) {
    if (cc < 11) return ("low risk");
    if (cc > 10 && cc < 21) return ("moderate risk");
    if (cc > 20 && cc < 51) return ("high risk");
    if (cc > 50) return ("very high risk");
    else return ("error");
}

int countConditionals(Declaration methodAST) {
    int metric = 1;
    visit (methodAST) {
        case \case(_) : metric += 1;
        case \catch(_,_): metric += 1;
        case \conditional(_,_,_): metric += 1;
        case \do(_,_) : metric += 1;
        case \for(_,_,_) : metric += 1;
        case \for(_,_,_,_) : metric += 1;
        case \foreach(_,_,_) : metric += 1;
        case \if(_,_) : metric += 1;
        case \if(_,_,_) : metric += 1;
        case \infix(_,"&&",_) : metric += 1;
        case \infix(_,"||",_) : metric += 1;
        case \while(_,_) : metric += 1;
    }
    return metric;
}

// Function that visits the ASTs of all methods of a Java project (potentially multiple programs) 
// and counts complexity-contributing statements per method with its risk category
list[tuple[loc, str]] riskCalc(list[Declaration] projectAST) {
    return for (i <- [0..size(projectAST) - 1]) {
        mtd = projectAST[i];
        append <mtd.src, riskCat(countConditionals(mtd))>;
    }
}

// Temporary function for to-be-implemented LOC counter
int countLOC(loc location) {
    return 10;
}

list[tuple[str, int]] riskPercentages(list[tuple[loc, str]] methods, loc projectLocation) {
    int modLOC = sum([countLOC(l) | <l, "moderate risk"> <- methods]);
    int highLOC = sum([countLOC(l) | <l, "high risk"> <- methods]);
    int vhighLOC = sum([countLOC(l) | <l, "very high risk"> <- methods]);

    return [<"moderate", (modLOC / countLOC(projectLocation) * 100)>, <"high", (highLOC / countLOC(projectLocation) * 100)>, <"very high", (vhighLOC / countLOC(projectLoc) * 100)>];
}

tuple[str, int] rankCC(list[tuple[str, int]] riskP) {
    if (riskP[0][1] <= 25 && riskP[1][1] <= 0 && riskP[2][1] <= 0) rank = 5;
    if (riskP[0][1] <= 30 && riskP[1][1] <= 5 && riskP[2][1] <= 0) rank = 4;
    if (riskP[0][1] <= 40 && riskP[1][1] <= 10 && riskP[2][1] <= 0) rank = 3;
    if (riskP[0][1] <= 50 && riskP[1][1] < 16 && riskP[2][1] <= 5) rank = 2;
    else rank = 1;

    return <"unitComplexity", rank>;
}

// Function to calculate the ranking of Cyclomatic complexity of a Java project. 
// Returns rank from 1-5 (--/-/o/+/++, respectively)
tuple[str, int] complexityCalc(loc projectLocation) {
    return rankCC(riskPercentages(riskCalc(getProjectASTs(projectLocation)), projectLocation));
}
