module Scores::Maintainability

import Map;
import util::Math;

private bool keys_there(map[str, value] m) {
    if ("analysability" notin m) return false;
    if ("changeability" notin m) return false;
    if ("testability" notin m) return false;
    return true;
}

int calculate_analysability(map[str, int] metrics) {
    map[str, real] weights = ();
    weights["analysability"] = 1.0/3.0;
    weights["changeability"] = 1.0/3.0;
    weights["testability"] = 1.0/3.0;
    return calculate_analysability(metrics, weights);
}

int calculate_analysability(map[str, int] metrics, map[str, real] weights) {
    if (keys_there(metrics) ||keys_there(weights)) return -1;
    
    real final_score = 0.0;
    final_score += weights["analysability"] * metrics["analysability"];
    final_score += weights["changeability"] * metrics["changeability"];
    final_score += weights["testability"] * metrics["testability"];

    return floor(final_score/3.0);
}