module Metrics::Volume

import lang::java::m3::Core;
import IO;
import Map;
import String;
import List;
import Set;
import util::Math;

/**
* Calculates the LOC from the project location given by caller.
* Reducer is used to transform map to tuple to sum amount of lines. 
* @param projectLoc location to project location containing files
* @return LOC for the project location
*/
public real calculateProjectLOC(loc projectLoc) {
    map[loc, list[str]] lines = getProjectLOC(projectLoc);
    return (0 | it + toReal(size(t[1])) | t <- toList(lines));
}

/**
* Get the lines from the files from project location given by caller.
* @param projectLoc location to project location containing files
* @return map of file-location with its lines for the project
*/
map[loc, list[str]] getProjectLOC(loc projectLoc) {
    map[loc, list[str]] classLines = ();
    M3 project = createM3FromMavenProject(projectLoc);
    set[loc] cls = classes(project);
    
    // Obtain the lines for each class
    for (c <- cls) {
        classLines[c] = calculateLOC(c);    
    }

    return classLines;
}

/**
* Obtains the lines from the file location given by caller.
* Whitespaces and comments are ignored
* @param fileLoc location to file
* @return lines for fileLoc
*/
list[str] calculateLOC(loc fileLoc) {
    // remove comments
    str fileContent = readFile(fileLoc);
    commentsRemoved = visit(fileContent) {
        case /(?s)\/\*.*?\*\// => "" // this needs to come first. Only god knows why
        case /\/\/.*/ => ""  
    }

    list[str] whitespaceRemoved = [s |s <- split("\n", commentsRemoved), !(/^\s*$/ := s)];
    return whitespaceRemoved;
}

/**
* Calculate the score for volume.
* The score is calculated for Java projects.
* @param total linesOfCode
* @return 1-based rank for Volume (1 = --, 5 = ++)
*/
int scoreLOC(real linesOfCode) {
    linesOfCode /= 1000.0;
    if (0 <= linesOfCode && linesOfCode < 66) return 5;
    if (66 <= linesOfCode && linesOfCode < 246) return 4;
    if (246 <= linesOfCode && linesOfCode < 665) return 3;
    if (655 <= linesOfCode && linesOfCode < 1310) return 2;
    return 1;
}

/**
* Give all lines of a project.
* All obtained lines from all files of a project are given in
* a list.
* @param projectLoc location to project location containing files
* @return list of all lines of project
*/
list[str] getLines(loc projectLoc) {
    lines = getProjectLOC(projectLoc);
    return ([] | it + t[1] | t <- toList(lines));
}

/**
* Calculate the Volume ranking of a Java project, based 
* on the calculated LOC. 
* @param projectLoc location to project location containing files
* @return 1-based rank for Volume
*/
int volumeRank(loc projectLoc) {
    return scoreLOC(calculateProjectLOC(projectLoc));
}
