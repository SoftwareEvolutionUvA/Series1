module Metrics::Duplication

import IO;
import Map;
import String;
import List;
import String;
import Metrics::Volume;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;


// Note: Duplicates result should be between 1000-4000

/**
* Function to obtain all the initial 6-line frames of all files of a project.
* Using tuple with:
* - File location (for same line-nrs in different files)
* - Frame hash (using MD5 128bit hashing; for next n lines)
* - Info (range, i.e., line-nrs of the checked frame)
* with n as minimum nr of lines for a clone. 
*/
list[tuple[loc, int, str, value]] createCloneIndex(loc projectLoc) {
    map[loc, list[str]] project = getProjectLOC(projectLoc);
    list[tuple[loc, list[str]]] projectLines = toList(project);
    list[tuple[loc, int, str, value]] cloneIndex = [];

    for (file <- projectLines) {
        int index = 0;
        lines = file[1];

        for (i <- [index..size(lines)-6]) {
            sequence = lines[i..i+5];
            hash = md5Hash(sequence);
            info = -1;
            cloneIndex += append <file, index, hash, info>;
        }
    }
    return cloneIndex;
}