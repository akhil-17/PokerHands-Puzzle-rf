# Poker Hands Puzzle Creation Guidelines

## Core Rules
1. The puzzle is played on a 5x5 grid
2. Each cell must contain either a playing card or be empty
3. Cards can be moved by dragging or tapping
4. The goal is to arrange cards to satisfy both row and column conditions
5. All conditions must be satisfied simultaneously for the puzzle to be solved
6. **CRITICAL: Cards cannot be reused across conditions**
   - Example: If you use three 8s for a Three of a Kind in a row, you cannot use those same 8s for another Three of a Kind in a column
   - Each card can only be used once in the entire grid
   - You cannot create duplicate cards or reuse cards from a standard 52-card deck

## Condition Types
1. Row Conditions:
   - All Same Suit (e.g., all Spades)
   - Three of a Kind (e.g., three 8s)
   - Ascending Sequence (e.g., 2-3-4-5-6)
   - Flush (all same suit)
   - All Face Cards (K, Q, J only)
   - All Same Rank (e.g., all Kings)
   - High to Low (descending sequence)
   - Sum Equals (e.g., sum of number cards = 15)
     - **CRITICAL: Only number cards (2-10) count towards the sum**
     - Face cards (K, Q, J) and Aces are excluded from sum calculations
     - Example: 2♠, 3♥, 4♦, 5♣, K♠ is valid for Sum=14 (2+3+4+5=14)
   - Any combination of cards that can be uniquely identified

2. Column Conditions:
   - Pair (e.g., pair of Kings)
   - Three of a Kind (e.g., three Jacks)
   - All Same Suit
   - Flush
   - All Face Cards (K, Q, J only)
   - All Same Rank
   - High to Low
   - Sum Equals (e.g., sum of number cards = 15)
     - **CRITICAL: Only number cards (2-10) count towards the sum**
     - Face cards (K, Q, J) and Aces are excluded from sum calculations
     - Example: 2♠, 3♥, 4♦, 5♣, K♠ is valid for Sum=14 (2+3+4+5=14)
   - Any combination of cards that can be uniquely identified

## Condition Satisfaction
1. **CRITICAL: Cards need not be adjacent or in sequence**
   - Cards satisfying a condition can be anywhere in the row/column
   - Example: For "6-7-8", the cards can be in any order and position
   - Example: For "Royal Court" (K, Q, J), the cards can be in any order and position
   - Example: For "Three of a Kind", the cards can be in any order and position
   - Example: For "Pair", the cards can be in any order and position

2. **CRITICAL: Position independence examples**
   - Valid "6-7-8" arrangements:
     ```
     Row: 6♠  A♥  7♦  K♣  8♥  ✓ (cards in positions 0, 2, 4)
     Row: 8♠  K♥  6♦  Q♣  7♥  ✓ (cards in positions 0, 2, 4)
     Row: A♠  7♥  8♦  6♣  K♥  ✓ (cards in positions 2, 3, 4)
     ```
   - Valid "Royal Court" arrangements:
     ```
     Row: K♠  A♥  Q♦  J♣  10♥  ✓ (cards in positions 0, 2, 3)
     Row: J♠  K♥  Q♦  A♣  8♥   ✓ (cards in positions 0, 1, 2)
     ```
   - Valid "Three of a Kind" arrangements:
     ```
     Row: 8♠  A♥  8♦  K♣  8♥  ✓ (cards in positions 0, 2, 4)
     Row: K♠  8♥  Q♦  8♣  8♥  ✓ (cards in positions 1, 3, 4)
     ```

3. **CRITICAL: Only count matching cards, ignore position**
   - For Three of a Kind: Count any 3 cards of the same rank
   - For Pairs: Count any 2 cards of the same rank
   - For "6-7-8": Count any cards of rank 6, 7, and 8
   - For "Royal Court": Count any K, Q, and J
   - Position and adjacency do not matter

4. **CRITICAL: This flexibility increases solution space**
   - More possible valid arrangements
   - Easier to find solutions
   - More interesting puzzle possibilities
   - Better for puzzle creation

## Condition Flexibility
1. **CRITICAL: Conditions can be modified to achieve solvability**
   - If a set of conditions leads to an unsolvable puzzle, modify them
   - Can make conditions more or less constrained
   - Can use different types of conditions
   - Goal is to create an engaging, solvable puzzle

2. When modifying conditions:
   - Keep the puzzle interesting and challenging
   - Ensure conditions are clear and unambiguous
   - Verify that the new conditions are solvable
   - Maintain a good balance of difficulty
   - **CRITICAL: Loosen restrictions if needed to achieve solvability**
     - Example: Change "Three of a Kind" to "Pair" if more cards are needed
     - Example: Change "All Face Cards" to "All Same Suit" if face cards are needed elsewhere
     - Example: Use "High to Low" instead of "Ascending Sequence" for more flexibility
     - Example: Use "All Same Suit" instead of specific suit requirements

3. Examples of condition modifications:
   - Change "Three of a Kind" to "Pair" if more cards are needed elsewhere
   - Change "All Face Cards" to "All Same Suit" if face cards are needed elsewhere
   - Add "Sum Equals" condition instead of "All Same Rank" if more flexibility is needed
   - Use "High to Low" instead of "Ascending Sequence" for variety
   - Use "All Same Suit" instead of specific suit requirements
   - Use "Any Sequence" instead of specific sequence requirements

4. **CRITICAL: Always verify solvability after modifying conditions**
   - Count required unique cards
   - Check for conflicts
   - Verify card availability
   - Test the complete solution

## Condition Restrictions
1. **CRITICAL: Restrictions can be loosened to achieve solvability**
   - If a puzzle is unsolvable with strict restrictions, consider loosening them
   - Example: Instead of "All Spades", use "All Same Suit"
   - Example: Instead of "Three of a Kind (8s)", use "Three of a Kind (any rank)"
   - Example: Instead of "Ascending Sequence 2-6", use "Any Sequence"
   - Example: Instead of "All Face Cards", use "All Same Suit"

2. When loosening restrictions:
   - Keep the puzzle interesting and challenging
   - Ensure the loosened conditions are still clear and unambiguous
   - Verify that the new conditions are solvable
   - Maintain a good balance of difficulty
   - Document any loosened restrictions for clarity

3. Examples of loosened restrictions:
   - "All Spades" → "All Same Suit"
   - "Three of a Kind (8s)" → "Three of a Kind (any rank)"
   - "Ascending Sequence 2-6" → "Any Sequence"
   - "All Face Cards" → "All Same Suit"
   - "Pair of Kings" → "Pair (any rank)"
   - "Sum Equals 15" → "Sum Equals (any number)"

4. **CRITICAL: Always verify solvability after loosening restrictions**
   - Count required unique cards
   - Check for conflicts
   - Verify card availability
   - Test the complete solution

## Condition Complexity
1. **CRITICAL: Number of required cards determines condition difficulty**
   - Conditions requiring 5 cards are the most restrictive
   - Conditions requiring 4 cards are the second-most restrictive
   - Conditions requiring 3 cards are moderately restrictive
   - Conditions requiring 2 cards are the least restrictive
   - **CRITICAL: Use 4-5 card conditions very sparingly**
     - Maximum 1-2 conditions requiring 4-5 cards per puzzle
     - Prefer conditions requiring 2-3 cards
     - Example: Use "All Same Suit" (5 cards) only once per puzzle
     - Example: Use "All Face Cards" (5 cards) only once per puzzle
     - Example: Use "Four of a Kind" (4 cards) only once per puzzle

2. **CRITICAL: Condition complexity hierarchy (from least to most restrictive)**
   - Two-card conditions (e.g., Pair)
     - Requires only 2 unique cards
     - Most flexible and easiest to satisfy
     - Can be used multiple times in a puzzle
   - Three-card conditions (e.g., Three of a Kind, 6-7-8, Royal Court)
     - Requires 3 unique cards
     - Moderately flexible
     - Can be used 2-3 times in a puzzle
   - Four-card conditions (e.g., Four of a Kind)
     - Requires 4 unique cards
     - Very restrictive
     - Use maximum once per puzzle
   - Five-card conditions (e.g., All Same Suit, All Face Cards)
     - Requires 5 unique cards
     - Most restrictive
     - Use maximum once per puzzle
   - Sequence conditions (e.g., 2-3-4-5-6)
     - Requires 5 unique cards
     - Very restrictive
     - Use maximum once per puzzle

3. **CRITICAL: Best practices for condition complexity**
   - Start with two-card and three-card conditions
   - Add one five-card condition if needed
   - Add one four-card condition if needed
   - Fill remaining conditions with two-card and three-card conditions
   - Example of good condition mix:
     ```
     Row Conditions:
     - Pair (2 cards)
     - Three of a Kind (3 cards)
     - All Same Suit (5 cards) - only one five-card condition
     - Pair (2 cards)
     - Three of a Kind (3 cards)

     Column Conditions:
     - Pair (2 cards)
     - Three of a Kind (3 cards)
     - Pair (2 cards)
     - Three of a Kind (3 cards)
     - Pair (2 cards)
     ```

4. **CRITICAL: Avoid multiple restrictive conditions**
   - Don't use multiple five-card conditions
   - Don't use multiple four-card conditions
   - Don't mix five-card and four-card conditions
   - Example of bad condition mix:
     ```
     Row Conditions:
     - All Same Suit (5 cards)
     - All Face Cards (5 cards) - too many five-card conditions
     - Three of a Kind (3 cards)
     - All Same Rank (5 cards) - too many five-card conditions
     - Pair (2 cards)
     ```

## Condition Conflicts
1. **CRITICAL: Avoid conditions that require reusing cards**
   - Each card can only be used to satisfy one condition
   - Example: If a row needs Three of a Kind (8s), no column can also need Three of a Kind (8s)
   - Example: If a row needs All Spades, no column can also need All Spades

2. Common conflict patterns to avoid:
   - Same rank requirements in both row and column (e.g., Three of a Kind in both)
   - Same suit requirements in both row and column (e.g., All Spades in both)
   - Face card requirements that overlap between row and column
   - Sequence requirements that conflict with other conditions

3. **CRITICAL: Check intersections carefully**
   - Each intersection must satisfy both row and column conditions
   - Cannot reuse cards to satisfy multiple conditions
   - Must have enough unique cards to satisfy all conditions

4. When creating conditions:
   - Start with row conditions
   - Choose column conditions that don't conflict with row conditions
   - Verify that each card is only used once
   - Ensure there are enough unique cards available

## Card Requirements
1. Each card must be unique (no duplicates)
2. Use standard playing cards (Ace through King, all suits)
3. **CRITICAL: Face Cards Definition**
   - Face cards are ONLY King, Queen, and Jack
   - 10s are NOT face cards
   - Aces are NOT face cards
   - Example: A row with K♠, Q♠, J♠, 10♠, 9♠ is NOT "All Face Cards" because it contains 10 and 9
4. Number cards are 2 through 10
5. **CRITICAL: Limited Card Availability**
   - Only 4 cards of each rank (one per suit)
   - Only 13 cards of each suit (Ace through King)
   - Cannot create duplicate cards
   - Cannot reuse cards across conditions

## Puzzle Creation Steps
1. First, define the row conditions
2. Then, define the column conditions
3. Select cards that can satisfy all conditions
4. Create the initial arrangement
5. **VERIFY SOLVABILITY** before implementing

## Verifying Solvability
1. Count required cards for each condition:
   - For Three of a Kind: Need 3 unique cards of same rank
   - For Pairs: Need 2 unique cards of same rank
   - For All Same Suit: Need 5 unique cards of same suit
   - For All Face Cards: Need 5 unique face cards

2. Check for conflicts:
   - If multiple conditions require the same cards, ensure there are enough unique cards
   - Example: If Column 2 needs Three of a Kind (Jacks) and Column 3 needs Pair of Jacks, we need at least 5 unique Jacks total
   - **CRITICAL: Remember that cards used in one condition cannot be reused in another**
   - Example: If you use three 8s for a Three of a Kind in a row, you cannot use those same 8s for another Three of a Kind in a column

3. Verify card availability:
   - Count how many unique cards of each rank and suit are available
   - Ensure there are enough unique cards to satisfy all conditions
   - Example: If we need 5 Jacks but only have 4 unique Jacks available, the puzzle is impossible
   - **CRITICAL: Remember that cards used in one condition cannot be reused in another**

4. Grid Validation:
   - The solution must form a valid 5x5 grid
   - Each cell must contain exactly one card
   - No card can be used more than once
   - Cards at row-column intersections must match
   - Example: If Row 0, Column 0 shows A♠, then Column 0, Row 0 must also show A♠

5. Intersection Checking:
   - For each cell (row, col), verify that:
     - The card satisfies both the row and column conditions
     - The card is not used elsewhere in the grid
     - The card appears in both the row and column lists at that position
   - Example:
     ```
     Row 0:    A♠  K♠  Q♠  J♠  10♠
     Column 0: A♠  8♥  2♥  K♦  K♣
     ```
     The intersection at (0,0) must be A♠ in both lists

6. Condition Validation
1. Count required cards for each condition:
   - For Three of a Kind: Need 3 unique cards of same rank (any position)
   - For Pairs: Need 2 unique cards of same rank (any position)
   - For All Same Suit: Need 5 unique cards of same suit (any position)
   - For All Face Cards: Need 5 face cards (any position)
   - For "6-7-8": Need cards of rank 6, 7, and 8 (any position)
   - For "Royal Court": Need K, Q, and J (any position)

2. Check for conflicts:
   - If multiple conditions require the same cards, ensure there are enough unique cards
   - Example: If Column 2 needs Three of a Kind (Jacks) and Column 3 needs Pair of Jacks, we need at least 5 unique Jacks total
   - **CRITICAL: Remember that cards used in one condition cannot be reused in another**
   - Example: If you use three 8s for a Three of a Kind in a row, you cannot use those same 8s for another Three of a Kind in a column

3. Verify card availability:
   - Count how many unique cards of each rank and suit are available
   - Ensure there are enough unique cards to satisfy all conditions
   - Example: If we need 5 Jacks but only have 4 unique Jacks available, the puzzle is impossible
   - **CRITICAL: Remember that cards used in one condition cannot be reused in another**

4. Grid Validation:
   - The solution must form a valid 5x5 grid
   - Each cell must contain exactly one card
   - No card can be used more than once
   - Cards at row-column intersections must match
   - Example: If Row 0, Column 0 shows A♠, then Column 0, Row 0 must also show A♠

5. Intersection Checking:
   - For each cell (row, col), verify that:
     - The card satisfies both the row and column conditions
     - The card is not used elsewhere in the grid
     - The card appears in both the row and column lists at that position
   - Example:
     ```
     Row 0:    A♠  K♠  Q♠  J♠  10♠
     Column 0: A♠  8♥  2♥  K♦  K♣
     ```
     The intersection at (0,0) must be A♠ in both lists

6. Condition Validation:
   - **CRITICAL: Count cards in each row and column to verify conditions**
   - For Three of a Kind: Must have exactly 3 cards of the same rank (any position)
   - For Pairs: Must have exactly 2 cards of the same rank (any position)
   - For All Same Suit: Must have exactly 5 cards of the same suit (any position)
   - For All Face Cards: Must have exactly 5 face cards (any position)
   - For "6-7-8": Must have cards of rank 6, 7, and 8 (any position)
   - For "Royal Court": Must have K, Q, and J (any position)
   - Example:
     ```
     Column 2: J♠  Q♦  J♣  K♠  J♥
     ```
     This IS a valid Three of a Kind (Jacks) because it has exactly 3 Jacks, regardless of position
   - Example:
     ```
     Row 4: K♣  Q♣  J♣  10♣  9♣
     ```
     This is NOT a valid "All Face Cards" because it contains 10 and 9, which are not face cards

6.1 **CRITICAL: Column Validation Steps**
   - For each column:
     1. List all cards in the column
     2. Count how many cards of each rank appear in the column
     3. For Pair conditions: Must have EXACTLY 2 cards of the specified rank (not more, not less)
     4. For Three of a Kind conditions: Must have EXACTLY 3 cards of the specified rank (not more, not less)
   - Example of invalid column validation:
     ```
     Column 3: J♠  K♥  5♠  10♦ 9♦
     Condition: Pair of 9s
     ```
     This is NOT valid because there is only one 9 (9♦)
   - Example of invalid column validation (too many cards):
     ```
     Column 0: A♠  K♥  2♥  K♦  K♣
     Condition: Pair of Kings
     ```
     This is NOT valid because there are three Kings (K♥, K♦, K♣), not exactly two
   - Example of valid column validation:
     ```
     Column 3: 9♠  K♥  5♠  9♦  Q♣
     Condition: Pair of 9s
     ```
     This IS valid because there are exactly two 9s (9♠ and 9♦)
   - **CRITICAL: For Pair conditions, having more than 2 cards of the same rank is invalid**
   - **CRITICAL: For Three of a Kind conditions, having more than 3 cards of the same rank is invalid**

7. Test the solution:
   - Create a complete solution that satisfies all conditions
   - Verify that no card is used more than once
   - Ensure all conditions can be satisfied simultaneously
   - Check that the grid is valid (5x5)
   - Verify all intersections match
   - **CRITICAL: Verify that no cards are reused across conditions**
   - **CRITICAL: Count cards in each row and column to verify conditions**
   - **CRITICAL: For each column, explicitly verify that the condition is satisfied by counting matching cards**

## Common Pitfalls to Avoid
1. Creating conditions that require more cards than are available
2. Using the same card to satisfy multiple conditions when it's not possible
3. Creating conditions that conflict with each other
4. Not verifying that all conditions can be satisfied simultaneously
5. Assuming a puzzle is solvable without actually creating a complete solution
6. Not checking row-column intersections for matching cards
7. Creating an invalid grid (not 5x5)
8. Using cards that aren't in the available set
9. **CRITICAL: Reusing cards across conditions**
   - Example: Using the same three 8s for multiple Three of a Kind conditions
   - Remember: Each card can only be used once in the entire grid
10. **CRITICAL: Not counting cards in each row and column**
    - Example: Assuming a Three of a Kind condition is satisfied without counting the actual number of matching cards
    - Always count the cards in each row and column to verify conditions
11. **CRITICAL: Misidentifying face cards**
    - Example: Including 10s or Aces in "All Face Cards" conditions
    - Remember: Only Kings, Queens, and Jacks are face cards
    - Always verify that "All Face Cards" conditions contain only K, Q, J
12. **CRITICAL: Including face cards or aces in sum calculations**
    - Example: Including K, Q, J, or A in Sum Equals conditions
    - Remember: Only number cards (2-10) count towards the sum
    - Always verify that Sum Equals conditions only use number cards for calculations

## Example of Verifying Solvability
Let's say we want to create a puzzle with these conditions:
- Column 2: Three of a Kind (Jacks)
- Column 3: Pair of Jacks
- Column 4: Pair of Tens

Required unique cards:
- 3 unique Jacks for Column 2
- 2 unique Jacks for Column 3
- 2 unique Tens for Column 4

Total needed:
- 5 unique Jacks (3 + 2)
- 2 unique Tens

Available unique cards:
- 4 unique Jacks (J♠, J♥, J♦, J♣)
- 2 unique Tens (10♠, 10♦)

This puzzle is impossible because we need 5 unique Jacks but only have 4 available.

## Best Practices
1. Always count required unique cards before creating the puzzle
2. Create a complete solution before implementing
3. Test the solution to ensure all conditions can be satisfied
4. Document the required unique cards and available cards
5. Verify the grid is valid (5x5)
6. Check all row-column intersections match
7. **CRITICAL: Never reuse cards across conditions**
8. If a puzzle is impossible, either:
   - Add more cards to make it possible
   - Change conditions to make it solvable with available cards
   - Start over with a new set of conditions 

## 6. Solving Strategy

### 6.1 CRITICAL: Step-by-Step Solving Process
1. Start with the most restrictive conditions (5 cards, then 4, then 3, then 2)
2. For each step:
   - Place cards to satisfy the current row condition
   - IMMEDIATELY check if the column conditions are satisfied
   - If a column condition is not satisfied, adjust the placement to satisfy both row and column conditions
   - Only proceed to the next step when both row and column conditions are satisfied
3. After each placement:
   - Verify that no cards are reused
   - Verify that all conditions are still satisfied
   - If any condition is violated, backtrack and try a different placement

### 6.2 CRITICAL: Intersection Points
- When placing cards, pay special attention to intersection points (where row and column conditions meet)
- Use intersection points strategically to satisfy multiple conditions at once
- Example: If a row needs a pair and a column needs a pair, try to place one card that satisfies both conditions

### 6.3 CRITICAL: Verification Steps
After each card placement:
1. Check the row condition:
   - Count cards in the row
   - Verify they match the required condition
2. Check all affected column conditions:
   - Count cards in each column
   - Verify they match the required conditions
3. Verify no card reuse:
   - Check that each card appears only once
   - Check that no card conflicts with existing conditions

### 6.4 Example Solving Process
1. Place first row (most restrictive condition):
   ```
   | A♠  | K♠  | Q♠  | J♠  | 10♠ |  Row 0: All Same Suit
   |-----|-----|-----|-----|-----|
   |     |     |     |     |     |
   |-----|-----|-----|-----|-----|
   |     |     |     |     |     |
   |-----|-----|-----|-----|-----|
   |     |     |     |     |     |
   |-----|-----|-----|-----|-----|
   |     |     |     |     |     |
   ```

2. Place second row while checking column conditions:
   ```
   | A♠  | K♠  | Q♠  | J♠  | 10♠ |  Row 0: All Same Suit
   |-----|-----|-----|-----|-----|
   | 8♠  | 8♥  | 8♦  | 2♥  | 3♥  |  Row 1: Three of a Kind
   |-----|-----|-----|-----|-----|
   |     |     |     |     |     |
   |-----|-----|-----|-----|-----|
   |     |     |     |     |     |
   |-----|-----|-----|-----|-----|
   |     |     |     |     |     |
   ```
   - Check Column 0: Need pair
   - Check Column 1: Need pair
   - Check Column 2: Need pair
   - Check Column 3: Need pair
   - Check Column 4: Need pair

3. Continue this process for each row, ensuring all conditions are satisfied before moving to the next step.

### 6.5 Common Mistakes to Avoid
1. Not checking column conditions after each row placement
2. Assuming a condition is satisfied without counting cards
3. Missing intersection points that could satisfy multiple conditions
4. Not verifying all conditions after each placement
5. Moving to the next step before all current conditions are satisfied