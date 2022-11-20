module Metrics::Test::Volume

import Metrics::Volume;
import Map;
import List;
import IO;

test bool testCalculateProjectLOC() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    int linesOfCode = calculateProjectLOC(locationTestCode);
    return linesOfCode == 48;
}

test bool testGetLines() {
    loc testFile = |project://Series1/MetricsCalc/src/main/rascal/Metrics/Test/testRegex.txt|;
    list[str] lines = getLines(testFile);
    //println(lines);
    return size(lines) == 6;
}


test bool testScoreLOC1() {
    return scoreLOC(1310000) == 1;
}

test bool testScoreLOC2() {
    return scoreLOC(665000) == 2;
}

test bool testScoreLOC3() {
    return scoreLOC(246000) == 3;
}

test bool testScoreLOC4() {
    return scoreLOC(66000) == 4;
}

test bool testScoreLOC5() {
    return scoreLOC(1000) == 5;
}

test bool testVolumeRank() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    int rank = volumeRank(locationTestCode);
    return rank == 5;
}

test bool testLocsCompilationUnits() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    map[loc, list[str]] linesOfCode = locsCompilationUnits(locationTestCode);
    int count = 0;
    for (k <- linesOfCode) {
        count += size(linesOfCode[k]);
    }
    return count == 48;
}
