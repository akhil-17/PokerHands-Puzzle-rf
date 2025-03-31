import Foundation

public struct CardConditionLogic {
    public static func isConditionSatisfied(cards: [Card?], condition: CardCondition) -> Bool {
        let validCards = cards.compactMap { $0 }
        
        switch condition {
        case .allHearts:
            return validCards.allSatisfy { $0.suit == .hearts }
        case .threeQueens:
            let queens = validCards.filter { $0.rank == .queen }
            return queens.count >= 3
        case .ascendingSequence:
            let sortedCards = validCards.sorted { $0.rank.numericValue < $1.rank.numericValue }
            return isAscendingSequence(sortedCards)
        case .fourSevens:
            let sevens = validCards.filter { $0.rank == .seven }
            return sevens.count >= 4
        case .allFaceCards:
            return validCards.allSatisfy { [.jack, .queen, .king].contains($0.rank) }
        case .threeOfAKind:
            return hasThreeOfAKind(validCards)
        case .flush:
            return isFlush(validCards)
        case .straight:
            return isStraight(validCards)
        case .pair:
            return hasPair(validCards)
        case .allSameSuit:
            return isAllSameSuit(validCards)
        case .descending:
            return isDescending(validCards)
        case .sumEquals:
            return sumEquals(validCards)
        case .pokerHand:
            return checkPokerHand(validCards)
        case .allSameRank:
            return isAllSameRank(validCards)
        case .royalCourt:
            return isRoyalCourt(validCards)
        }
    }
    
    public static func getSatisfyingCards(for condition: CardCondition, in cards: [Card?]) -> Set<Int> {
        let validCards = cards.compactMap { $0 }
        var satisfyingIndices = Set<Int>()
        
        switch condition {
        case .allHearts:
            for (index, card) in cards.enumerated() {
                if let card = card, card.suit == .hearts {
                    satisfyingIndices.insert(index)
                }
            }
        case .threeQueens:
            let queenIndices = cards.enumerated().compactMap { index, card in
                card?.rank == .queen ? index : nil
            }
            if queenIndices.count >= 3 {
                satisfyingIndices.formUnion(queenIndices)
            }
        case .ascendingSequence:
            let sortedCards = validCards.sorted { $0.rank.numericValue < $1.rank.numericValue }
            if isAscendingSequence(sortedCards) {
                for (index, card) in cards.enumerated() {
                    if card != nil {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .fourSevens:
            let sevenIndices = cards.enumerated().compactMap { index, card in
                card?.rank == .seven ? index : nil
            }
            if sevenIndices.count >= 4 {
                satisfyingIndices.formUnion(sevenIndices)
            }
        case .allFaceCards:
            for (index, card) in cards.enumerated() {
                if let card = card, [.jack, .queen, .king].contains(card.rank) {
                    satisfyingIndices.insert(index)
                }
            }
        case .threeOfAKind:
            if let rank = findThreeOfAKindRank(validCards) {
                for (index, card) in cards.enumerated() {
                    if let card = card, card.rank == rank {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .flush:
            if let suit = findFlushSuit(validCards) {
                for (index, card) in cards.enumerated() {
                    if let card = card, card.suit == suit {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .straight:
            if let straightCards = findStraightCards(validCards) {
                for (index, card) in cards.enumerated() {
                    if let card = card, straightCards.contains(card) {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .pair:
            if let rank = findPairRank(validCards) {
                for (index, card) in cards.enumerated() {
                    if let card = card, card.rank == rank {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .allSameSuit:
            if let suit = findFlushSuit(validCards) {
                for (index, card) in cards.enumerated() {
                    if let card = card, card.suit == suit {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .descending:
            if isDescending(validCards) {
                for (index, card) in cards.enumerated() {
                    if card != nil {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .sumEquals:
            if sumEquals(validCards) {
                for (index, card) in cards.enumerated() {
                    if card != nil {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .pokerHand:
            if let pokerCards = findPokerHandCards(validCards) {
                for (index, card) in cards.enumerated() {
                    if let card = card, pokerCards.contains(card) {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .allSameRank:
            if let rank = findAllSameRank(validCards) {
                for (index, card) in cards.enumerated() {
                    if let card = card, card.rank == rank {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        case .royalCourt:
            if isRoyalCourt(validCards) {
                for (index, card) in cards.enumerated() {
                    if card != nil {
                        satisfyingIndices.insert(index)
                    }
                }
            }
        }
        
        return satisfyingIndices
    }
    
    public static func formatCondition(_ condition: CardCondition) -> String {
        switch condition {
        case .allHearts:
            return "All Hearts"
        case .threeQueens:
            return "3 Queens"
        case .ascendingSequence:
            return "2-3-4-5-6"
        case .fourSevens:
            return "4 Sevens"
        case .allFaceCards:
            return "All Face Cards"
        case .threeOfAKind:
            return "3 of a kind"
        case .flush:
            return "Flush"
        case .straight:
            return "Straight"
        case .pair:
            return "Pair"
        case .allSameSuit:
            return "All Same Suit"
        case .descending:
            return "High to Low"
        case .sumEquals:
            return "Sum=15"
        case .pokerHand:
            return "3 of a kind"
        case .allSameRank:
            return "All Same Rank"
        case .royalCourt:
            return "Royal Court"
        }
    }
    
    // Helper methods
    private static func isAscendingSequence(_ cards: [Card]) -> Bool {
        guard cards.count >= 5 else { return false }
        for i in 0..<(cards.count - 4) {
            let sequence = Array(cards[i..<(i + 5)])
            if sequence[0].rank == .two &&
                sequence[1].rank == .three &&
                sequence[2].rank == .four &&
                sequence[3].rank == .five &&
                sequence[4].rank == .six {
                return true
            }
        }
        return false
    }
    
    private static func hasThreeOfAKind(_ cards: [Card]) -> Bool {
        let ranks = cards.map { $0.rank }
        for rank in Card.Rank.allCases {
            if ranks.filter({ $0 == rank }).count >= 3 {
                return true
            }
        }
        return false
    }
    
    private static func isFlush(_ cards: [Card]) -> Bool {
        guard let firstSuit = cards.first?.suit else { return false }
        return cards.allSatisfy { $0.suit == firstSuit }
    }
    
    private static func isStraight(_ cards: [Card]) -> Bool {
        let sortedCards = cards.sorted { $0.rank.numericValue < $1.rank.numericValue }
        for i in 0..<(sortedCards.count - 4) {
            let sequence = Array(sortedCards[i..<(i + 5)])
            if sequence[4].rank.numericValue - sequence[0].rank.numericValue == 4 {
                return true
            }
        }
        return false
    }
    
    private static func hasPair(_ cards: [Card]) -> Bool {
        let ranks = cards.map { $0.rank }
        for rank in Card.Rank.allCases {
            if ranks.filter({ $0 == rank }).count >= 2 {
                return true
            }
        }
        return false
    }
    
    private static func isAllSameSuit(_ cards: [Card]) -> Bool {
        guard let firstSuit = cards.first?.suit else { return false }
        return cards.allSatisfy { $0.suit == firstSuit }
    }
    
    private static func isDescending(_ cards: [Card]) -> Bool {
        let sortedCards = cards.sorted { $0.rank.numericValue > $1.rank.numericValue }
        return cards == sortedCards
    }
    
    private static func sumEquals(_ cards: [Card]) -> Bool {
        let sum = cards.reduce(0) { $0 + $1.rank.numericValue }
        return sum == 15
    }
    
    private static func checkPokerHand(_ cards: [Card]) -> Bool {
        return hasThreeOfAKind(cards)
    }
    
    private static func isAllSameRank(_ cards: [Card]) -> Bool {
        guard let firstRank = cards.first?.rank else { return false }
        return cards.allSatisfy { $0.rank == firstRank }
    }
    
    private static func isRoyalCourt(_ cards: [Card]) -> Bool {
        let requiredRanks: Set<Card.Rank> = [.jack, .queen, .king]
        let cardRanks = Set(cards.map { $0.rank })
        return requiredRanks.isSubset(of: cardRanks)
    }
    
    private static func findThreeOfAKindRank(_ cards: [Card]) -> Card.Rank? {
        let ranks = cards.map { $0.rank }
        for rank in Card.Rank.allCases {
            if ranks.filter({ $0 == rank }).count >= 3 {
                return rank
            }
        }
        return nil
    }
    
    private static func findFlushSuit(_ cards: [Card]) -> Card.Suit? {
        guard let firstSuit = cards.first?.suit else { return nil }
        if cards.allSatisfy({ $0.suit == firstSuit }) {
            return firstSuit
        }
        return nil
    }
    
    private static func findStraightCards(_ cards: [Card]) -> Set<Card>? {
        let sortedCards = cards.sorted { $0.rank.numericValue < $1.rank.numericValue }
        for i in 0..<(sortedCards.count - 4) {
            let sequence = Array(sortedCards[i..<(i + 5)])
            if sequence[4].rank.numericValue - sequence[0].rank.numericValue == 4 {
                return Set(sequence)
            }
        }
        return nil
    }
    
    private static func findPairRank(_ cards: [Card]) -> Card.Rank? {
        let ranks = cards.map { $0.rank }
        for rank in Card.Rank.allCases {
            if ranks.filter({ $0 == rank }).count >= 2 {
                return rank
            }
        }
        return nil
    }
    
    private static func findPokerHandCards(_ cards: [Card]) -> Set<Card>? {
        if let rank = findThreeOfAKindRank(cards) {
            return Set(cards.filter { $0.rank == rank })
        }
        return nil
    }
    
    private static func findAllSameRank(_ cards: [Card]) -> Card.Rank? {
        guard let firstRank = cards.first?.rank else { return nil }
        if cards.allSatisfy({ $0.rank == firstRank }) {
            return firstRank
        }
        return nil
    }
} 