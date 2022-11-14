module CyclomaticComplexity

import IO;
import List;
import Set;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;
import module LinesOfCode;


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
list[tuple[loc, int, str]] complexityCalc(list[Declaration] projectAST) {
    return for (i <- [0..size(projectAST) - 1]) {
        mtd = projectAST[i];
        append <mtd.src, countConditionals(mtd), riskCat(countConditionals(mtd))>;
    }
}


list[tuple[str, int]] riskPercentages(list[tuple[loc, int, str]] methods) {
    int modLOC = 0;
    int highLOC = 0;
    int vhighLOC = 0;
    visit(methods) {
        case \methods(loc, int, "moderate risk"): modLOC += 

    }
}



// tuple[int, list[str]] mostOccurringVariable(list[Declaration] asts){
//     map[str varName, int counts] counter = ();
//     visit(asts){
//         case \variable(str name, _): counter[name] ? 0 += 1;
//         case \variable(str name, _, _): counter[name] ? 0 += 1;
//         case \fieldAccess(_, _, str name): counter[name] ? 0 += 1;
//         case \fieldAccess(_, str name): counter[name] ? 0 += 1;
//         case \parameter(_, str name, _): counter[name] ? 0 += 1;
//         case \vararg(_, str name): counter[name] ? 0 += 1;
//     }
//     int maximum = max(counter.counts);
//     return <maximum, toList(invert(counter)[maximum])>;
// }





// list[loc] findNullReturned(list[Declaration] asts){
//     list[loc] locs = [];
//     visit(asts){
//         case \return(Expression expr): if(expr is \null) locs += expr.src;
//     }
//     return locs;
// }

// int totalLOC(loc project) {
//     return 20;
// }

// int unitLOC(loc unit) {
//     return 5;
// }




