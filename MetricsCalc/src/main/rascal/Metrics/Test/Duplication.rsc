module Metrics::Test::Duplication

import Metrics::Duplication;
import Metrics::Volume;
import Map;
import Set;

test bool createCloneIndex() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    ret = createCloneIndex(locationTestCode);
    return size(ret[0]) == 37 && size(ret[1]) == 1 && size(ret[2]) == 1;
}

test bool testAbsoluteDuplicateLinesProject() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    int locProject = calculateProjectLOC(locationTestCode);
    return absoluteDuplicateLinesProject(locationTestCode) == 22;
}


test bool testRealtiveDuplicateLinesProject() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    int locProject = calculateProjectLOC(locationTestCode);
    return realtiveDuplicateLinesProject(locationTestCode, locProject) == (22/48.0) * 100;
}

test bool testScoreDuplicatesTestData() {
    loc locationTestCode = |project://Series1/test/TestCode|;
    int locProject = calculateProjectLOC(locationTestCode);

    return scoreDuplicates(realtiveDuplicateLinesProject(locationTestCode, locProject)) == 1;
}

test bool testScoreDuplicates1() {
    return scoreDuplicates(20.0) == 1;
}

test bool testScoreDuplicates2() {
    return scoreDuplicates(10.0) == 2;
}

test bool testScoreDuplicates3() {
    return scoreDuplicates(5.0) == 3;
}

test bool testScoreDuplicates4() {
    return scoreDuplicates(3.0) == 4;
}

test bool testScoreDuplicates5() {
    return scoreDuplicates(0.0) == 5;
}
