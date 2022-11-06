The code consists of a single class that takes a list of words that can then be manipulated by the user:
1. The list can be "sanitized", that is all words are converted to lowercase, stripped of whitespace and the total length of all words combined in the array is calculated.
2. At a specified index a word in the list can be replaced by a user-specified word. This word is, based on the length, either uppercased or lowercased and reversed.

We calculate the following metrics:
1. Lines of Code (LOC): All lines that contain more than whitespace or comments.
2. Cyclomatic Complexity (CC): We calculate the CC based on the formular E - N + 2, where E = number of edges, N = number of nodes in a control flow graph (CFG).
3. Duplication: (number of duplicated lines) / (LOC). The threshhold is 6 LOC. If 2 blocks are duplicated, only one counts in the metric. That means, a program that repeats two times a block of 6 lines has a duplication of 50%.


For the whole class that is:
| Metric  | Value | Comment |
| ------------- | ------------- | --- |
| Lines of Code (LOC)  | 48  | |
| Duplication  | 22.91%  | |

For each method that is:
| Metric | SomeClass | addWord | sanitizer | replace | replaceAndAppend |
| --     |  --       | --      |    --     | --      |    --            |
| Lines of Code (LOC) | 3       | 3      |    8     | 13      |    15            |
| Cyclomatic Complexity (CC) | 1       | 1      |    4     | 3      |    4            |
| Duplication | 0%       | 0%      |    0%     | 100%      |    84.61%            |
