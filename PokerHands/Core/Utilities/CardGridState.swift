import Foundation

struct CardGridState {
    static func resetToInitialState(cards: inout [[Card?]], emptyCardVariants: inout [[EmptyCardView.Variant]]) {
        // Reset the grid to its initial state
        cards = Array(repeating: Array(repeating: nil, count: 5), count: 5)
        emptyCardVariants = Array(repeating: Array(repeating: .empty, count: 5), count: 5)
    }
    
    static func shuffleInitialState(cards: inout [[Card?]], emptyCardVariants: inout [[EmptyCardView.Variant]]) {
        // Create a deck of cards
        var deck: [Card] = []
        for suit in Card.Suit.allCases {
            for rank in Card.Rank.allCases {
                deck.append(Card(suit: suit, rank: rank))
            }
        }
        
        // Shuffle the deck
        deck.shuffle()
        
        // Place cards randomly on the grid
        placeCardsRandomly(cards: &cards, emptyCardVariants: &emptyCardVariants, deck: deck)
    }
    
    static func placeCardsRandomly(cards: inout [[Card?]], emptyCardVariants: inout [[EmptyCardView.Variant]], deck: [Card]) {
        var currentDeck = deck
        
        // Place cards randomly on the grid
        for row in 0..<5 {
            for col in 0..<5 {
                if !currentDeck.isEmpty {
                    cards[row][col] = currentDeck.removeFirst()
                    emptyCardVariants[row][col] = .empty
                } else {
                    cards[row][col] = nil
                    emptyCardVariants[row][col] = .empty
                }
            }
        }
    }
    
    static func hasDuplicateCards(_ cards: [[Card?]]) -> Bool {
        var seenCards = Set<Card>()
        
        for row in cards {
            for card in row {
                if let card = card {
                    if seenCards.contains(card) {
                        return true
                    }
                    seenCards.insert(card)
                }
            }
        }
        
        return false
    }
    
    static func getColumn(_ cards: [[Card?]], column: Int) -> [Card?] {
        return cards.map { $0[column] }
    }
} 