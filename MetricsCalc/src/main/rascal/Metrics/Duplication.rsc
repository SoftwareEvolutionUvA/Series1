module Metrics::Duplication

import IO;
import Map;
import String;
import List;
import Metrics::Volume;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Set;
import util::Math;

// Note: Duplicates result should be between 1000-4000

/**
* Calculates the total number of duplicate LOC for a single class.
* The index is determines the granularity of a clone.
* @param filename location to the class to check for clones
* @param index index file with all blocks of code in project. @see createCloneIndex.
* @return number of duplicate LOC for the given class
*/
int duplicateLinesSingleClass(loc filename, list[tuple[loc, int, str, set[int]]] index) {
    // construct f
    list[tuple[loc, int, str, set[int]]] f = [<fName, statementIdx, hash, info> | <fName, statementIdx, hash, info> <- index, fName == filename];

    set[int] duplicates = {};

    // define set with indices
    list[set[tuple[loc, int, str, set[int]]]] c = [];
    for (elem <- f){
        sameHash = { <fName, statementIdx, hash, info> | <fName, statementIdx, hash, info> <- index, hash == elem[2] };
        // there is a duplicate somewhere
        if (size(sameHash) > 1) {
            duplicates += elem[3]; // we assume info to be a set of all indices the block has
        }
    }

    return size(duplicates);
}

/**
* Function to obtain all the initial 6-line frames of all files of a project.
* Using tuple with:
* - File location (for same line-nrs in different files)
* - Frame hash (using MD5 128bit hashing; for next n lines)
* - Info (range, i.e., line-nrs of the checked frame)
* with n as minimum nr of lines for a clone. 
*/
tuple[list[tuple[loc, int, str, set[int]]], set[loc]] createCloneIndex(loc projectLoc) {
    map[loc, list[str]] project = getProjectLOC(projectLoc);
    list[tuple[loc, int, str, set[int]]] cloneIndex = [];

    int blockSize = 6;
    set[loc] files = domain(project);
    for (file <- files) {
        list[str] lines = project[file];

        for (i <- [0..(size(lines)-blockSize)]) {
            sequence = lines[i..(i+blockSize)];
            hash = md5Hash(sequence);
            info = {idx | idx <- [i.. (i+blockSize)]};
            cloneIndex += <file, i, hash, info>;
        }
    }

    return <cloneIndex, files>;
}

/**
* Calculates the absolute number of duplicate LOC.
* @param project location to a Maven project.
* @return absolute number of duplicate LOC in project.
*/
int absoluteDuplicateLinesProject(loc project) {
    tuple[list[tuple[loc, int, str, set[int]]], set[loc]] ret = createCloneIndex(project);
    list[tuple[loc, int, str, set[int]]] index = ret[0];
    set[loc] classes = ret[1];

    int totalDuplicatedLines = 0;
    for (c <- classes) {
        totalDuplicatedLines += duplicateLinesSingleClass(c, index);
    }
    return totalDuplicatedLines;
}

/**
* Calculates the number of duplicate LOC relative to the LOC of the project.
* @param project location to a Maven project.
* @param projectLoc absolute number of LOC for the entire project.
* @return relative number of LOC in project. Return is in [0,1].
*/
real realtiveDuplicateLinesProject(loc project, int projectLoc) {
    return absoluteDuplicateLinesProject(project) / toReal(projectLoc);
}