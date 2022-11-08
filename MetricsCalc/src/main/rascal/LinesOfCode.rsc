module LinesOfCode

import IO;


int countLOC() {
    list[str] f = readFileLines(|project://Series1/test/TestCode/src/main/java/org/example/SomeClass.java|);
    
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
        // skip multiline
        else if (/^\s*\/\*/ := line) {
            begin = true;
        }
        else {
            println(line);
            count += 1;
        }
        // 
    }

    return count;
}

test 