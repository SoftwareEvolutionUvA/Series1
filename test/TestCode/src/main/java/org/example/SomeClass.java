package org.example;

import java.util.ArrayList;
import java.util.Collections;

/**
 * Class gets a list of words that gets stuff replaced by some constants
 *
 * LOC: count methods + 2 [class block] + 1 [array] + 3 [imports, package] = (3+3+8+13+15) + 2 + 1 + 3 = 48
 *      validated using https://plugins.jetbrains.com/plugin/4509-statistic (4.2.6)
 * LOC per method: see methods
 * Cyclomatic complexity (CC): see methods
 *  used https://app.code2flow.com/ to generate the CFGs
 * Duplication: 22/48 = 45.83%
 */
public class SomeClass {
    private ArrayList<String> arr;

    /**
     * LOC: 3
     * CC: 1 (E = 1, N = 2)
     * Duplication: 0%
     * RiskEvaluation: 3 
     * @param arr
     */
    public SomeClass(ArrayList<String> arr) {
            this.arr = arr;
    }

    /**
     * Add word to list of words.
     * <br>
     * LOC: 3
     * CC: 1 (E = 1, N = 2)
     * Duplication: 0%
     * RiskEvaluation: 3
     * @param s word to add
     */
    public void addWord(String s) {
        arr.add(s);
    }

    /**
     * Simple function that sorts words, makes them lower case, removes trailing/leading whitespace
     * and counts the total length of all words together.
     * <br>
     * Used to have a simple function.
     * <br>
     * LOC: 8
     * CC: 4 (E = 12, N = 10) - that's a tricky one due to syntax
     * Duplication: 0%
     * RiskEvaluation: 3
     * @return total length of the words in the list
     */
    public int sanitizer() {
        Collections.sort(arr);

        arr.forEach(String::toLowerCase);
        arr.forEach(String::strip);

        var len = new Object(){ int count = 0; };
        arr.forEach(s -> len.count += s.length());

        return len.count;
    }

    /**
     * Allows to replace a word at {pos} with {word}.
     * Word is also transformed: If it is longer than 5, it is capitalized, else it is reversed.
     * If it is reversed, it is made lower-case to conform with the sanitizer.
     * <br>
     * We use the function to have some more complexity for the cyclomatic complexity.
     * <br>
     * LOC: 13
     * CC: 4 (E = 8, N = 6)
     * Duplication: 11/11 = 100%
     * RiskEvaluation: 2
     * @param pos 0-based position to replace word from.
     * @param word raw word to replace word at position {pos} with. Will be transformed.
     */
    public void replace(int pos, String word) {
        for (int i = 0; i < arr.size(); i++) {
            if (i == pos) {
                String curr = arr.get(i);
                if (curr.length() > 5) {
                    arr.add(i, word.toUpperCase());
                }
                else {
                    arr.add(i, new StringBuilder(word.toLowerCase()).reverse().toString());
                }
            }
        }
    }

    /**
     * Same as replace(), but always adds the same two words ("bananas" and "strawberries") to the end of the list.
     * <br>
     * We use this to measure duplication.
     * <br>
     * LOC: 15
     * CC: 4 (E = 8, N = 6)
     * Duplication: 11/13 = 84.61%
     * RiskEvaluation: 2
     * @param pos 0-based position to replace word from.
     * @param word raw word to replace word at position {pos} with. Will be transformed.
     */
    public void replaceAndAppend(int pos, String word) {
        // start: shameless copy of replace
        for (int i = 0; i < arr.size(); i++) {
            if (i == pos) {
                String curr = arr.get(i);
                if (curr.length() > 5) {
                    arr.add(i, word.toUpperCase());
                }
                else {
                    arr.add(i, new StringBuilder(word.toLowerCase()).reverse().toString());
                }
            }
        }
        // end: shameless copy of replace
        arr.add("bananas");
        arr.add("strawberries");
    }
}
