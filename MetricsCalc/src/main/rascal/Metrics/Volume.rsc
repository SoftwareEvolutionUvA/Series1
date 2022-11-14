module Metrics::Volume

import lang::java::m3::Core;
import IO;
import Map;
import String;
import List;

map[loc, int] calculateProjectLoc(loc fileLoc) {
    map[loc, int] classLocs = ();
    M3 proj = createM3FromMavenProject(fileLoc);
    set[loc] cls = classes(proj);
    // calculate the LOCs for each class
    for (c <- cls) {
        // remove comments
        str fileContent = readFile(c);
        commentsRemoved = visit(fileContent) {
            case /(?s)\/\*.*?\*\// => "" // this needs to come first. Only god knows why
            case /\/\/.*/ => ""  
        }

        list[str] whitespaceRemoved = [s |s <- split("\n", commentsRemoved), !(/^\s*$/ := s)];
        classLocs[c] = size(whitespaceRemoved);
    }
    return classLocs;
}