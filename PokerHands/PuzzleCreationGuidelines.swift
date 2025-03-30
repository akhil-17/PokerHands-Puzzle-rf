/// PuzzleCreationGuidelines.swift
/// Reference file for creating valid poker hand puzzles

import Foundation

/// Guidelines for creating valid puzzles:
/// 1. Always ensure both row and column conditions are being satisfied
/// 2. Do not use duplicate cards (each card shows up only once)
/// 3. Intersection cards don't need to satisfy both row and column conditions
/// 4. Individually validate each condition
/// 5. If puzzle isn't solvable, update conditions and/or cards

enum PuzzleValidator {
    /// Validates if a set of cards contains any duplicates
    static func hasDuplicates(_ cards: [Card]) -> Bool {
        var seenCards = Set<String>()
        for card in cards {
            let cardString = "\(card.suit) \(card.rank)"
            if seenCards.contains(cardString) {
                return true
            }
            seenCards.insert(cardString)
        }
        return false
    }
    
    /// Validates if a row condition is satisfied
    static func validateRowCondition(cards: [Card?], condition: CardCondition) -> Bool {
        let validCards = cards.compactMap { $0 }
        
        switch condition {
        case .allHearts:
            return validCards.allSatisfy { $0.suit == .hearts }
            
        case .threeQueens:
            return validCards.filter { $0.rank == .queen }.count == 3
            
        case .ascendingSequence:
            let values = validCards.map { $0.rank.numericValue }.sorted()
            return values == Array(values[0]...(values[0] + values.count - 1))
            
        case .fourSevens:
            return validCards.filter { $0.rank == .seven }.count == 4
            
        case .allFaceCards:
            return validCards.allSatisfy { $0.rank.isFaceCard() }
            
        default:
            return false
        }
    }
    
    /// Validates if a column condition is satisfied
    static func validateColumnCondition(cards: [Card?], condition: CardCondition) -> Bool {
        let validCards = cards.compactMap { $0 }
        
        switch condition {
        case .threeOfAKind:
            let rankCounts = Dictionary(grouping: validCards, by: { $0.rank })
            return rankCounts.values.contains { $0.count >= 3 }
            
        case .flush:
            return validCards.allSatisfy { $0.suit == validCards[0].suit }
            
        case .straight:
            let values = validCards.map { $0.rank.numericValue }.sorted()
            return values == Array(values[0]...(values[0] + values.count - 1))
            
        case .pair:
            let rankCounts = Dictionary(grouping: validCards, by: { $0.rank })
            return rankCounts.values.contains { $0.count >= 2 }
            
        default:
            return false
        }
    }
    
    /// Validates an entire puzzle setup
    static func validatePuzzle(cards: [[Card?]], rowConditions: [CardCondition], columnConditions: [CardCondition]) -> (isValid: Bool, issues: [String]) {
        var issues: [String] = []
        
        // Check for duplicates
        let allCards = cards.flatMap { $0 }.compactMap { $0 }
        if hasDuplicates(allCards) {
            issues.append("Puzzle contains duplicate cards")
        }
        
        // Validate row conditions
        for (i, row) in cards.enumerated() {
            if !validateRowCondition(cards: row, condition: rowConditions[i]) {
                issues.append("Row \(i) condition (\(rowConditions[i])) is not satisfied")
            }
        }
        
        // Validate column conditions
        for col in 0..<cards[0].count {
            let column = cards.map { $0[col] }
            if !validateColumnCondition(cards: column, condition: columnConditions[col]) {
                issues.append("Column \(col) condition (\(columnConditions[col])) is not satisfied")
            }
        }
        
        return (issues.isEmpty, issues)
    }
    
    /// Example usage for validating a new puzzle:
    static func exampleValidation() {
        let cards: [[Card?]] = [
            // Example puzzle setup
            [Card(suit: .hearts, rank: .ace), Card(suit: .hearts, rank: .king), Card(suit: .hearts, rank: .queen), Card(suit: .hearts, rank: .jack), Card(suit: .hearts, rank: .ten)],
            // ... add more rows
        ]
        
        let rowConditions: [CardCondition] = [.allHearts, .threeQueens, .ascendingSequence, .fourSevens, .allFaceCards]
        let columnConditions: [CardCondition] = [.threeOfAKind, .flush, .straight, .pair, .pair]
        
        let (isValid, issues) = validatePuzzle(cards: cards, rowConditions: rowConditions, columnConditions: columnConditions)
        
        if !isValid {
            print("Puzzle validation failed:")
            issues.forEach { print("- \($0)") }
        }
    }
} 