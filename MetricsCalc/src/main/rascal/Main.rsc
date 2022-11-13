// This program provides four metrics of the SIG Maintainability Model. The AST of a given Java program is obtained, 
// and volume, unit size, unit complexity, and duplicate metrics are calculated. 
module Main

import IO;
import List;
import Set;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;


void main() {
    println("Hello world");
}

list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

loc locationTestCode = |project://Series1/test/TestCode|;
// TODO: Call measure volume


// TODO: Call measure Unit size

// TODO: Call measure Unit complexity


// TODO: Call measure duplicates

