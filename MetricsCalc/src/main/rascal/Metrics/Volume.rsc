module Metrics::Volume

import lang::java::m3::Core;
import IO;
import Map;
import String;
import List;
import Set;

/**
* Calculate the score for volume.
* The score is calculated for Java projects.
* @param linesOfCode
* @return 0-based rank for volume (0 = --, 4 = ++)
*/
int score(real linesOfCode) {
    linesOfCode /= 1000.0;
    if (0 <= linesOfCode && linesOfCode < 66) return 4;
    if (66 <= linesOfCode && linesOfCode < 246) return 3;
    if (246 <= linesOfCode && linesOfCode < 665) return 2;
    if (655 <= linesOfCode && linesOfCode < 1310) return 1;
    return 0;
}

map[loc, int] calculateProjectLoc(loc fileLoc) {
    map[loc, int] classLocs = ();
    M3 proj = createM3FromMavenProject(fileLoc);
    set[loc] cls = classes(proj);
    
    // calculate the LOCs for each class
    for (c <- cls) {
        classLocs[c] = calculateLoc(c);    
    }

    return classLocs;
}

/**
* Calculates the LOC from the file location given by caller.
* Whitespaces and comments are ignored
* @param fileLoc location to file
* @return LOC for fileLoc
*/
int calculateLoc(loc fileLoc) {
    // remove comments
    str fileContent = readFile(fileLoc);
    commentsRemoved = visit(fileContent) {
        case /(?s)\/\*.*?\*\// => "" // this needs to come first. Only god knows why
        case /\/\/.*/ => ""  
    }

    list[str] whitespaceRemoved = [s |s <- split("\n", commentsRemoved), !(/^\s*$/ := s)];
    return size(whitespaceRemoved);
}