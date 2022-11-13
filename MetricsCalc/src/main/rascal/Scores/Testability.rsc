module Scores::Testability

import Map;
import util::Math;

private bool keys_there(map[str, value] m) {
    //if ("volume" notin m) return false;
    if ("unitComplexity" notin m) return false;
    if ("unitSize" notin m) return false;
    //if ("duplication" notin m) return false;
    return true;
}

int calculate_testability(map[str, int] metrics) {
    map[str, real] weights = ();
    weights["unitComplexity"] = 1.0/2.0;
    weights["unitSize"] = 1.0/2.0;
    return calculate_testability(metrics, weights);
}

int calculate_testability(map[str, int] metrics, map[str, real] weights) {
    if (keys_there(metrics) ||keys_there(weights)) return -1;
    
    real final_score = 0.0;
    final_score += weights["unitComplexity"] * metrics["unitComplexity"];
    final_score += weights["unitSize"] * metrics["unitSize"];

    return floor(final_score/2.0);
}