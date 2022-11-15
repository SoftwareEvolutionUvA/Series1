module Duplication

import Map;
import String;
import List;
import String;
import Metrics::Volume;


// Note: Duplicates result should be between 1000-4000


// TODO: Get compilation-unit locations! 
// Adapt get function that gets lines per compilation unit, and calls getFrames with those lines.
// Assume in this function that all locs are from the compilation-unit the frame is in. 

/**
* Function to obtain all the initial 6-line frames of all files of a project.
* Using tuple with location of file (for same line-nrs in different files), and range (so line-nrs of the checked frame)
*/
map[list[str], tuple[loc, list[int]]] getFrames(loc projectLoc) {
    map[loc, list[str]] projectLines = getProjectLOC(projectLoc);

    map[list[str], tuple[loc, list[int]]] frames = ();
    list[str] frame = [];
    // loc unitLoc = ();
    int index = 0;

    // Note: p = one loc with a list of its [lines]
    for (p <- projectLines) {
        index += 1;
        unitLoc = p[0]; // TODO: how to save a location of a frame if you cannot subscript...
        unitLines = p(unitLoc);
        frame = slice(unitLines, index, 6); // IDK why it can't find lice. It is in import List (https://www.rascal-mpl.org/docs/Library/List/#List-slice)
        frames[frame] = <unitLoc, [index..6]>;
    }
    return frames;
}


tuple[list[str], list[tuple[loc, list[int]]]] findClones(map[list[str] curFrames, tuple[loc unit, list[int] range]] frames) {
        tuple[ list[str], list[ tuple[loc, list[int]] ] ] clones = [];
        
        // In "frames" hash-map, find the "curFrames"-keys that contain multiple entries (tuples). 
        // Add the key-frames to clones. Add the list of all its <location, range (which are the line nrs)> tuples
        // to clones as well.    
        // E.g.:    addClone(frames, [unitLoc, frame]);

        // Note: following is just to remove "missing return"-error.
        loc are_we = ();
        loc done_yet = ();
        list[tuple[loc, list[int]]] my_head_hurts = [<are_we, [18,04]>, <done_yet, [19,98]>];

        clones = <["this language is something else"],my_head_hurts>;
        return clones; 
}


// TODO: After this, we can start extending each 6-line frame, i.e. a "clone class", with a line (using 
// the location to find the line-nr frame) of each location in the clone class. 
// Then, compare the extended clone class with the previous clone class. If extended clone class contains only 1 tuple, 
// stop. 
// If extended iss completely similar, keep extended only. Otherwise, keep both in "clones". 
// Do the same again.
//
// If all frames are checked --> count ALL tuples in each class (so each list[str]). These are the duplicates.
