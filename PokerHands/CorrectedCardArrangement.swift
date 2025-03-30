import Foundation

// Corrected card arrangement that satisfies all conditions
let correctedCards = [
    // Row 0: All Spades
    [Card(suit: .spades, rank: .ace),
     Card(suit: .spades, rank: .king),
     Card(suit: .spades, rank: .queen),
     Card(suit: .spades, rank: .jack),
     Card(suit: .spades, rank: .ten)],
    
    // Row 1: Three 8s
    [Card(suit: .spades, rank: .eight),
     Card(suit: .hearts, rank: .eight),
     Card(suit: .diamonds, rank: .eight),
     Card(suit: .hearts, rank: .two),
     Card(suit: .hearts, rank: .three)],
    
    // Row 2: Royal Court
    [Card(suit: .clubs, rank: .eight),
     Card(suit: .hearts, rank: .king),
     Card(suit: .hearts, rank: .queen),
     Card(suit: .hearts, rank: .jack),
     Card(suit: .hearts, rank: .four)],
    
    // Row 3: Pair of 9s
    [Card(suit: .diamonds, rank: .king),
     Card(suit: .hearts, rank: .nine),
     Card(suit: .diamonds, rank: .nine),
     Card(suit: .hearts, rank: .six),
     Card(suit: .hearts, rank: .seven)],
    
    // Row 4: Pair of 10s
    [Card(suit: .hearts, rank: .ten),
     Card(suit: .diamonds, rank: .ten),
     Card(suit: .clubs, rank: .nine),
     Card(suit: .clubs, rank: .six),
     Card(suit: .clubs, rank: .seven)]
]
