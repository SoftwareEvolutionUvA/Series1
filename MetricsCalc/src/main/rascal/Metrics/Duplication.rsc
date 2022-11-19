module Metrics::Duplication

import List;
import Metrics::Volume;
import List;
import Set;
import IO;
import util::Math;

// Note: Duplicates result should be between 1000-4000

/**
* Calculates the total number of duplicate LOC for a single class.
* The index is determines the granularity of a clone.
* @param filename location to the class to check for clones
* @param index index file with all blocks of code in project. @see createCloneIndex.
* @return number of duplicate LOC for the given class
*/
int duplicateLinesSingleClass(loc filename, list[tuple[loc, int, str, value]] index) {
    // construct f
    list[tuple[loc, int, str, value]] f = [<fName, statementIdx, hash, info> | <fName, statementIdx, hash, info> <- index, fName == filename];
    f = sort(f, bool (tuple[loc, int, str, value] a, tuple[loc, int, str, value] b){return a[1] < b[1];});

    set[int] duplicates = {};

    // define set with indices
    list[set[tuple[loc, int, str, value]]] c = [];
    c += {};
    for (elem <- f){
        sameHash = { <fName, statementIdx, hash, info> | <fName, statementIdx, hash, info> <- index, hash == elem[2] };
        // there is a duplicate somewhere
        if (size(sameHash) > 1) {
            duplicates += elem[3]; // we assume info to be a set of all indices the block has
        }
    }

    return size(duplicates); // TODO: check that here I don't include the emtpy set
}

/**
* Calculates the absolute number of duplicate LOC.
* @param project location to a Maven project.
* @return absolute number of duplicate LOC in project.
*/
int absoluteDuplicateLinesProject(loc project) {
    // TODO: change return such that there is a list of locations as well
    list[tuple[loc, int, str, value]] index = createCloneIndex(project);
    list[loc] classes = []; // TODO: change this to return of createCloneIndex

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