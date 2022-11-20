module Scores::Analysability

import Map;
import util::Math;

private bool keys_there(map[str, value] m) {
    if ("volume" notin m) return false;
    //if ("unitComplexity" notin metrics) return -1;
    if ("unitSize" notin m) return false;
    if ("duplication" notin m) return false;
    return true;
}

int calculate_analysability(map[str, int] metrics, map[str, real] weights) {
    if (!keys_there(metrics) || !keys_there(weights)) return -1;
    
    real final_score = 0.0;
    final_score += weights["volume"] * metrics["volume"];
    final_score += weights["unitSize"] * metrics["unitSize"];
    final_score += weights["duplication"] * metrics["duplication"];

    return floor(final_score/3.0);
}

int calculate_analysability(map[str, int] metrics) {
    map[str, real] weights = ();
    weights["volume"] = 1.0/3.0;
    weights["unitSize"] = 1.0/3.0;
    weights["duplication"] = 1.0/3.0;
    return calculate_analysability(metrics, weights);
}