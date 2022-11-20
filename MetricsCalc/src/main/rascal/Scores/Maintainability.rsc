module Scores::Maintainability

import Map;
import IO;
import util::Math;

private bool keys_there(map[str, value] m) {
    if ("analysability" notin m) return false;
    if ("changeability" notin m) return false;
    if ("testability" notin m) return false;
    return true;
}

int calculate_maintainability(map[str, int] scores, map[str, real] weights) {
    if (!keys_there(scores) || !keys_there(weights)) return -1;
    
    real final_score = 0.0;
    final_score += weights["analysability"] * scores["analysability"];
    final_score += weights["changeability"] * scores["changeability"];
    final_score += weights["testability"] * scores["testability"];

    return floor(final_score);
}

int calculate_maintainability(map[str, int] scores) {
    map[str, real] weights = ();
    weights["analysability"] = 1.0/3.0;
    weights["changeability"] = 1.0/3.0;
    weights["testability"] = 1.0/3.0;
    return calculate_maintainability(scores, weights);
}

/**
* Convert the numerical scores in integer values (1-5) to ranking in (--/-/o/+/++), respectively.
* Returns rank (x) if the numerical score is not within the range.
**/
map[str, str] ranking(map[str, int] scores) {
    map[str, str] fscores = ();
    for (<m, r> <- toList(scores)) {
        if (r == 1) { fscores[m] = "--"; continue; } 
        if (r == 2) { fscores[m] = "-"; continue; }
        if (r == 3) { fscores[m] = "o"; continue; }
        if (r == 4) { fscores[m] = "+"; continue; }
        if (r == 5) { fscores[m] = "++"; continue; }
        else fscores[m] = "x"; continue;
    }

    return fscores;
}