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
int duplicateLinesSingleClass(list[tuple[loc, int, str, set[int]]] blocksFile, map[str, list[tuple[loc, int, str, set[int]]]] lookupHash) {
    set[int] duplicates = {};

    // define set with indices
    list[set[tuple[loc, int, str, set[int]]]] c = [];
    for (elem <- blocksFile){
        // there is a duplicate somewhere
        if (size(lookupHash[elem[2]]) > 1) {
            duplicates += elem[3]; // we assume info to be a set of all indices the block has
        }
    }

    return size(duplicates);
}

// TODO: create data structure that allows hash and fName to be retrieved quickly
    // idea: have two lookups:
    // 1. map [hash, list(tuples)]
    // 2. map [fname, list(tuples)]

/**
* Function to obtain all the initial 6-line frames of all files of a project.
* Using tuple with:
* - File location (for same line-nrs in different files)
* - Frame hash (using MD5 128bit hashing; for next n lines)
* - Info (range, i.e., line-nrs of the checked frame)
* with n as minimum nr of lines for a clone. 
*/
tuple[map[str, list[tuple[loc, int, str, set[int]]]], map[loc, list[tuple[loc, int, str, set[int]]]], set[loc]] createCloneIndex(loc projectLoc) {
    map[loc, list[str]] project = locsCompilationUnits(projectLoc);
    int blockSize = 6;
    set[loc] files = domain(project);

    // lookup hash -> ret list
    map[str, list[tuple[loc, int, str, set[int]]]] lookupHash = ();

    // lookup fname -> ret list
    map[loc, list[tuple[loc, int, str, set[int]]]] lookupFileName = ();

    for (file <- files) {
        lookupFileName[file] = [];
        list[str] lines = project[file];

        // files with less than "blocksize" LOC will result in negative upper bound in for loop below
        // this is why we skip them (they also don't fit our definition of duplicate)
        if (size(lines) < blockSize) {
            continue;
        }

        for (i <- [0..(size(lines)-blockSize+1)]) {
            sequence = lines[i..(i+blockSize)];
            hash = md5Hash(sequence);
            info = {idx | idx <- [i .. (i+blockSize)]};
            tuple[loc, int, str, set[int]] indexTuple = <file, i, hash, info>;
            lookupFileName[file] += indexTuple;
            if (hash in lookupHash) {
                lookupHash[hash] += indexTuple;
            }
            else {
                lookupHash[hash] = [indexTuple];
            }
        }
    }

    return <lookupHash, lookupFileName, files>;
}

/**
* Calculates the absolute number of duplicate LOC.
* @param project location to a Maven project.
* @return absolute number of duplicate LOC in project.
*/
int absoluteDuplicateLinesProject(loc project) {
    tuple[map[str, list[tuple[loc, int, str, set[int]]]], map[loc, list[tuple[loc, int, str, set[int]]]], set[loc]] ret = createCloneIndex(project);
    map[str, list[tuple[loc, int, str, set[int]]]] lookupHash = ret[0];
    map[loc, list[tuple[loc, int, str, set[int]]]] lookupFileName = ret[1];
    set[loc] classes = ret[2];

    int totalDuplicatedLines = 0;
    for (c <- classes) {
        totalDuplicatedLines += duplicateLinesSingleClass(lookupFileName[c], lookupHash);
    }
    return totalDuplicatedLines;
}

/**
* Calculates the number of duplicate LOC relative to the LOC of the project.
* @param project location to a Maven project.
* @param projectLoc absolute number of LOC for the entire project.
* @return relative number of LOC in project. Return is in [0,100].
*/
real realtiveDuplicateLinesProject(loc project, int projectLoc) {
    return absoluteDuplicateLinesProject(project) / toReal(projectLoc) * 100;
}

/**
* Calculate the score for duplication.
* @param total linesOfCode
* @return 1-based rank for Volume (1 = --, 5 = ++)
*/
int scoreDuplicates(real relativeDuplication) {
    if (0 <= relativeDuplication && relativeDuplication < 3) return 5;
    if (3 <= relativeDuplication && relativeDuplication < 5) return 4;
    if (5 <= relativeDuplication && relativeDuplication < 10) return 3;
    if (10 <= relativeDuplication && relativeDuplication < 20) return 2;
    return 1;
}