module Metrics::Volume

import lang::java::m3::Core;
import IO;

void newApproach(loc fileLoc) {
    M3 proj = createM3FromMavenProject(fileLoc);
    set[loc] cls = classes(proj);
    // calculate the LOCs for each class
    for (c <- cls) {
        // remove whitespace and comments
        str fContent = readFile(c);
        a = visit(fContent) {
            // https://stackoverflow.com/questions/13014947/regex-to-match-a-c-style-multiline-comment
            //case /^\s*$/ => "SPACE"
            case /(?s)\/\*.*?\*\// => "" // this needs to come first. Only god knows why
            case /\/\/.*/ => ""
            
            
        }
        a = visit(a) {
           case /^\s*$/ => "SPACE" 
        }
        println(a);

        //for (f <- fields()) {
        //    println("");
        //}
    }
    // don't forget fields
    //return fields(proj);
}

int countLOC(loc fileLoc) {
    list[str] f = readFileLines(fileLoc);
    
    int count = 0;
    bool begin = false;
    for (line <- f) {
        // is end of comment
        if (begin) {
            // has end
            if (/(\*\/\s*)$/ := line) {
                begin = false;
            }
            continue;
        }
        // skip empty lines
        if ((/^\s*$/ := line));
        // skip single comment 
        else if (/^\s*\/\// := line);
        // skip multiline (single line)
        else if (/^(\s*\/\*).*(\*\/\s*)$/ := line);
        // skip leading multiline
        // skip multiline
        else if (/^\s*\/\*/ := line) {
            begin = true;
        }
        else {
            println(line);
            count += 1;
        }
    }

    return count;
}

// https://docs.oracle.com/javase/specs/jls/se7/html/jls-3.html#jls-3.7