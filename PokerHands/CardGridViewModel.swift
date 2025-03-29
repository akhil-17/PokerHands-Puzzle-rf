import Foundation

enum CardCondition {
    case allSameSuit(Suit)
    case ascending
    case descending
    case sumEquals(Int)
    case allFaceCards
    case pokerHand(PokerHand)
    case allSameRank(Rank)
}

enum PokerHand {
    case pair
    case threeOfAKind
    case straight
    case flush
    case fullHouse
    case fourOfAKind
}

class CardGridViewModel: ObservableObject {
    @Published var cards: [[Card?]] = Array(repeating: Array(repeating: nil, count: 5), count: 5)
    @Published var emptyCardVariants: [[EmptyCardView.Variant]] = Array(repeating: Array(repeating: .empty, count: 5), count: 5)
    @Published var rowConditions: [CardCondition] = []
    @Published var columnConditions: [CardCondition] = []
    
    init() {
        setupPrototypePuzzle()
    }
    
    private func hasDuplicateCards() -> Bool {
        var seenCards = Set<String>()
        for row in 0..<5 {
            for col in 0..<5 {
                if let card = cards[row][col] {
                    let cardString = "\(card.suit) \(card.rank)"
                    if seenCards.contains(cardString) {
                        print("Warning: Duplicate card found: \(cardString)")
                        return true
                    }
                    seenCards.insert(cardString)
                }
            }
        }
        return false
    }
    
    private func setupPrototypePuzzle() {
        // Define all the cards needed for the puzzle
        var allCards: [Card] = [
            // Row 0: All hearts (5 hearts)
            Card(suit: .hearts, rank: .ace),
            Card(suit: .hearts, rank: .king),
            Card(suit: .hearts, rank: .queen),
            Card(suit: .hearts, rank: .jack),
            Card(suit: .hearts, rank: .ten),
            
            // Row 1: Three of a kind (Kings) + two unique cards
            Card(suit: .spades, rank: .king),
            Card(suit: .diamonds, rank: .king),
            Card(suit: .clubs, rank: .king),
            Card(suit: .spades, rank: .queen),
            Card(suit: .diamonds, rank: .jack),
            
            // Row 2: Ascending sequence
            Card(suit: .diamonds, rank: .two),
            Card(suit: .clubs, rank: .three),
            Card(suit: .spades, rank: .four),
            Card(suit: .diamonds, rank: .five),
            Card(suit: .clubs, rank: .six),
            
            // Row 3: Four of a kind (Sevens) + one unique card
            Card(suit: .spades, rank: .seven),
            Card(suit: .diamonds, rank: .seven),
            Card(suit: .clubs, rank: .seven),
            Card(suit: .hearts, rank: .seven),
            Card(suit: .hearts, rank: .eight),
            
            // Row 4: All face cards (using different face cards)
            Card(suit: .clubs, rank: .jack),
            Card(suit: .diamonds, rank: .queen),
            Card(suit: .spades, rank: .ace),
            Card(suit: .spades, rank: .jack),
            Card(suit: .clubs, rank: .queen)
        ]
        
        // Verify no duplicates in initial setup
        var seenCards = Set<String>()
        for card in allCards {
            let cardString = "\(card.suit) \(card.rank)"
            if seenCards.contains(cardString) {
                print("ERROR: Duplicate card found in initial setup: \(cardString)")
                fatalError("Puzzle setup contains duplicate cards")
            }
            seenCards.insert(cardString)
        }
        
        // Set up conditions
        rowConditions = [
            .allSameSuit(.hearts),
            .pokerHand(.threeOfAKind),
            .ascending,
            .pokerHand(.fourOfAKind),
            .allFaceCards
        ]
        
        columnConditions = [
            .pokerHand(.threeOfAKind),
            .pokerHand(.flush),
            .pokerHand(.straight),
            .pokerHand(.pair),
            .pokerHand(.pair)
        ]
        
        // Try to create a valid puzzle without duplicates
        var attempts = 0
        let maxAttempts = 1000 // Prevent infinite loop
        
        repeat {
            // Shuffle the cards
            allCards.shuffle()
            
            // Place the shuffled cards in the grid
            for row in 0..<5 {
                for col in 0..<5 {
                    cards[row][col] = allCards[row * 5 + col]
                    emptyCardVariants[row][col] = .empty
                }
            }
            
            attempts += 1
        } while hasDuplicateCards() && attempts < maxAttempts
        
        if attempts >= maxAttempts {
            print("Warning: Could not find a valid puzzle configuration after \(maxAttempts) attempts")
        } else {
            print("Successfully created puzzle after \(attempts) attempts")
        }
        
        // Debug print the initial state
        print("\nInitial card state (shuffled):")
        for row in 0..<5 {
            print("Row \(row):")
            for col in 0..<5 {
                if let card = cards[row][col] {
                    print("  \(card.suit) \(card.rank)")
                } else {
                    print("  empty")
                }
            }
        }
    }
    
    func isConditionSatisfied(cards: [Card?], condition: CardCondition) -> Bool {
        let validCards = cards.compactMap { $0 }
        print("\nChecking condition: \(formatCondition(condition))")
        print("Valid cards: \(validCards.map { "\($0.suit) \($0.rank)" })")
        
        let result: Bool
        switch condition {
        case .allSameSuit(let suit):
            result = validCards.allSatisfy { $0.suit == suit }
            print("All same suit (\(suit)): \(result)")
            
        case .ascending:
            let values = validCards.map { $0.rank.numericValue }
            result = values == values.sorted()
            print("Ascending check: \(values) == \(values.sorted()): \(result)")
            
        case .descending:
            let values = validCards.map { $0.rank.numericValue }
            result = values == values.sorted().reversed()
            print("Descending check: \(values) == \(values.sorted().reversed()): \(result)")
            
        case .sumEquals(let target):
            let sum = validCards.reduce(into: 0) { $0 += $1.rank.numericValue }
            result = sum == target
            print("Sum check: \(sum) == \(target): \(result)")
            
        case .allFaceCards:
            result = validCards.allSatisfy { $0.rank.isFaceCard() }
            print("All face cards: \(result)")
            
        case .pokerHand(let hand):
            result = checkPokerHand(cards: validCards, hand: hand)
            print("Poker hand check (\(formatCondition(condition))): \(result)")
            
        case .allSameRank(let rank):
            result = validCards.allSatisfy { $0.rank == rank }
            print("All same rank (\(rank)): \(result)")
        }
        
        print("Final result: \(result)")
        return result
    }
    
    private func checkPokerHand(cards: [Card], hand: PokerHand) -> Bool {
        print("\nChecking poker hand: \(hand)")
        print("Cards: \(cards.map { "\($0.suit) \($0.rank)" })")
        
        let result: Bool
        switch hand {
        case .pair:
            let values = cards.map { $0.rank.numericValue }
            let valueCounts = Dictionary(grouping: values, by: { $0 }).mapValues { $0.count }
            result = valueCounts.contains { $0.value >= 2 }
            print("Pair check - Value counts: \(valueCounts), Result: \(result)")
            
        case .threeOfAKind:
            let values = cards.map { $0.rank.numericValue }
            let valueCounts = Dictionary(grouping: values, by: { $0 }).mapValues { $0.count }
            result = valueCounts.contains { $0.value >= 3 }
            print("Three of a Kind check - Value counts: \(valueCounts), Result: \(result)")
            
        case .straight:
            let values = cards.map { $0.rank.numericValue }.sorted()
            if values.count < 5 {
                print("Straight check - Not enough cards: \(values.count)")
                return false
            }
            let first = values[0]
            let last = values[values.count - 1]
            result = last - first == values.count - 1
            print("Straight check - Values: \(values), First: \(first), Last: \(last), Result: \(result)")
            
        case .flush:
            result = cards.allSatisfy { $0.suit == cards[0].suit }
            print("Flush check - All suits: \(cards.map { $0.suit }), Result: \(result)")
            
        case .fullHouse:
            let values = cards.map { $0.rank.numericValue }
            let valueCounts = Dictionary(grouping: values, by: { $0 }).mapValues { $0.count }
            result = valueCounts.contains { $0.value >= 3 } && valueCounts.contains { $0.value >= 2 }
            print("Full House check - Value counts: \(valueCounts), Result: \(result)")
            
        case .fourOfAKind:
            let values = cards.map { $0.rank.numericValue }
            let valueCounts = Dictionary(grouping: values, by: { $0 }).mapValues { $0.count }
            result = valueCounts.contains { $0.value >= 4 }
            print("Four of a Kind check - Value counts: \(valueCounts), Result: \(result)")
        }
        
        print("Final poker hand result: \(result)")
        return result
    }
    
    func getSatisfyingCards(for condition: CardCondition, in cards: [Card?]) -> Set<Int> {
        let validCards = cards.compactMap { $0 }
        var satisfyingIndices = Set<Int>()
        
        switch condition {
        case .allSameSuit(let suit):
            // Find all cards of the specified suit
            for (index, card) in cards.enumerated() {
                if let card = card, card.suit == suit {
                    satisfyingIndices.insert(index)
                }
            }
            
        case .ascending:
            // Find the sequence of cards in ascending order
            let sortedCards = validCards.sorted { $0.rank.numericValue < $1.rank.numericValue }
            if sortedCards.count >= 5 {
                let values = sortedCards.map { $0.rank.numericValue }
                if values[4] - values[0] == 4 {
                    // Find the indices of these cards in the original array
                    for (index, card) in cards.enumerated() {
                        if let card = card, values.contains(card.rank.numericValue) {
                            satisfyingIndices.insert(index)
                        }
                    }
                }
            }
            
        case .descending:
            // Find the sequence of cards in descending order
            let sortedCards = validCards.sorted { $0.rank.numericValue > $1.rank.numericValue }
            if sortedCards.count >= 5 {
                let values = sortedCards.map { $0.rank.numericValue }
                if values[0] - values[4] == 4 {
                    // Find the indices of these cards in the original array
                    for (index, card) in cards.enumerated() {
                        if let card = card, values.contains(card.rank.numericValue) {
                            satisfyingIndices.insert(index)
                        }
                    }
                }
            }
            
        case .sumEquals(let target):
            // Find the combination of cards that sum to the target
            let values = validCards.map { $0.rank.numericValue }
            for i in 0..<values.count {
                for j in (i+1)..<values.count {
                    for k in (j+1)..<values.count {
                        for l in (k+1)..<values.count {
                            for m in (l+1)..<values.count {
                                if values[i] + values[j] + values[k] + values[l] + values[m] == target {
                                    // Find the indices of these cards in the original array
                                    let targetValues = [values[i], values[j], values[k], values[l], values[m]]
                                    for (index, card) in cards.enumerated() {
                                        if let card = card, targetValues.contains(card.rank.numericValue) {
                                            satisfyingIndices.insert(index)
                                        }
                                    }
                                    return satisfyingIndices
                                }
                            }
                        }
                    }
                }
            }
            
        case .allFaceCards:
            // Find all face cards
            for (index, card) in cards.enumerated() {
                if let card = card, card.rank.isFaceCard() {
                    satisfyingIndices.insert(index)
                }
            }
            
        case .pokerHand(let hand):
            switch hand {
            case .pair:
                // Find the pair
                let valueCounts = Dictionary(grouping: validCards.map { $0.rank.numericValue }, by: { $0 }).mapValues { $0.count }
                if let pairValue = valueCounts.first(where: { $0.value >= 2 })?.key {
                    for (index, card) in cards.enumerated() {
                        if let card = card, card.rank.numericValue == pairValue {
                            satisfyingIndices.insert(index)
                        }
                    }
                }
                
            case .threeOfAKind:
                // Find the three of a kind
                let valueCounts = Dictionary(grouping: validCards.map { $0.rank.numericValue }, by: { $0 }).mapValues { $0.count }
                if let threeValue = valueCounts.first(where: { $0.value >= 3 })?.key {
                    for (index, card) in cards.enumerated() {
                        if let card = card, card.rank.numericValue == threeValue {
                            satisfyingIndices.insert(index)
                        }
                    }
                }
                
            case .straight:
                // Find the straight
                let sortedCards = validCards.sorted { $0.rank.numericValue < $1.rank.numericValue }
                if sortedCards.count >= 5 {
                    let values = sortedCards.map { $0.rank.numericValue }
                    if values[4] - values[0] == 4 {
                        // Find the indices of these cards in the original array
                        for (index, card) in cards.enumerated() {
                            if let card = card, values.contains(card.rank.numericValue) {
                                satisfyingIndices.insert(index)
                            }
                        }
                    }
                }
                
            case .flush:
                // Find the flush
                let suitCounts = Dictionary(grouping: validCards.map { $0.suit }, by: { $0 }).mapValues { $0.count }
                if let flushSuit = suitCounts.first(where: { $0.value >= 5 })?.key {
                    for (index, card) in cards.enumerated() {
                        if let card = card, card.suit == flushSuit {
                            satisfyingIndices.insert(index)
                        }
                    }
                }
                
            case .fullHouse:
                // Find the full house
                let valueCounts = Dictionary(grouping: validCards.map { $0.rank.numericValue }, by: { $0 }).mapValues { $0.count }
                if let threeValue = valueCounts.first(where: { $0.value >= 3 })?.key,
                   let pairValue = valueCounts.first(where: { $0.key != threeValue && $0.value >= 2 })?.key {
                    for (index, card) in cards.enumerated() {
                        if let card = card, card.rank.numericValue == threeValue || card.rank.numericValue == pairValue {
                            satisfyingIndices.insert(index)
                        }
                    }
                }
                
            case .fourOfAKind:
                // Find the four of a kind
                let valueCounts = Dictionary(grouping: validCards.map { $0.rank.numericValue }, by: { $0 }).mapValues { $0.count }
                if let fourValue = valueCounts.first(where: { $0.value >= 4 })?.key {
                    for (index, card) in cards.enumerated() {
                        if let card = card, card.rank.numericValue == fourValue {
                            satisfyingIndices.insert(index)
                        }
                    }
                }
            }
            
        case .allSameRank(let rank):
            // Find all cards of the specified rank
            for (index, card) in cards.enumerated() {
                if let card = card, card.rank == rank {
                    satisfyingIndices.insert(index)
                }
            }
        }
        
        return satisfyingIndices
    }
    
    func formatCondition(_ condition: CardCondition) -> String {
        switch condition {
        case .allSameSuit(let suit):
            switch suit {
            case .hearts: return "All ♥"
            case .diamonds: return "All Diamonds"
            case .clubs: return "All Clubs"
            case .spades: return "All Spades"
            }
        case .ascending:
            return "Low to high"
        case .descending:
            return "High to Low"
        case .sumEquals(let value):
            return "Sum=\(value)"
        case .allFaceCards:
            return "All face cards"
        case .pokerHand(let hand):
            switch hand {
            case .pair: return "Pair"
            case .threeOfAKind: return "3 of a kind"
            case .straight: return "Straight"
            case .flush: return "Flush"
            case .fullHouse: return "Full House"
            case .fourOfAKind: return "4 of a kind"
            }
        case .allSameRank(let rank):
            return "All \(rank.rawValue)s"
        }
    }
} 
