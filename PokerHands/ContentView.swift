//
//  ContentView.swift
//  PokerHands
//
//  Created by Akhil Dakinedi on 3/26/25.
//

import SwiftUI

struct RowConditionsView: View {
    let conditions: [CardCondition]
    let satisfiedRows: Set<Int>
    let viewModel: CardGridViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(60), spacing: 8), count: 5), alignment: .leading, spacing: 8) {
                ForEach(0..<5) { index in
                    TextCardTop(text: formatCondition(conditions[index]))
                        .foregroundColor(satisfiedRows.contains(index) ? .green : .white)
                        .animation(.easeInOut, value: satisfiedRows.contains(index))
                }
            }
        }
        .padding(.leading, 66)
    }
    
    private func formatCondition(_ condition: CardCondition) -> String {
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

struct ColumnConditionsView: View {
    let conditions: [CardCondition]
    let satisfiedColumns: Set<Int>
    let viewModel: CardGridViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(60))], spacing: 8) {
            ForEach(0..<5) { index in
                TextCardLeft(text: formatCondition(conditions[index]))
                    .foregroundColor(satisfiedColumns.contains(index) ? .green : .white)
                    .animation(.easeInOut, value: satisfiedColumns.contains(index))
            }
        }
        .padding(.leading, 6)
    }
    
    private func formatCondition(_ condition: CardCondition) -> String {
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

struct CardGridView: View {
    let cards: [[Card?]]
    let emptyCardVariants: [[EmptyCardView.Variant]]
    let selectedCard: (row: Int, col: Int)?
    let onCardTap: (Int, Int) -> Void
    let satisfiedRows: Set<Int>
    let satisfiedColumns: Set<Int>
    let viewModel: CardGridViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(60), spacing: 8), count: 5), spacing: 8) {
            ForEach(0..<5) { row in
                ForEach(0..<5) { col in
                    Group {
                        if let card = cards[row][col] {
                            let isSatisfied = isCardSatisfyingCondition(row: row, col: col)
                            CardView(
                                card: card,
                                isSelected: selectedCard.map { $0 == (row, col) } ?? false,
                                isSatisfied: isSatisfied
                            )
                        } else {
                            EmptyCardView(
                                variant: emptyCardVariants[row][col],
                                isHighlighted: selectedCard != nil
                            )
                        }
                    }
                    .contentShape(Rectangle()) // Make the entire area tappable
                    .onTapGesture {
                        print("Tapped position: row=\(row), col=\(col)")
                        onCardTap(row, col)
                    }
                }
            }
        }
        .padding(.trailing, 8)
    }
    
    private func isCardSatisfyingCondition(row: Int, col: Int) -> Bool {
        // Check if the card is part of a satisfied row condition
        if satisfiedRows.contains(row) {
            let rowCards = cards[row]
            let satisfyingIndices = viewModel.getSatisfyingCards(for: viewModel.rowConditions[row], in: rowCards)
            return satisfyingIndices.contains(col)
        }
        
        // Check if the card is part of a satisfied column condition
        if satisfiedColumns.contains(col) {
            let columnCards = cards.map { $0[col] }
            let satisfyingIndices = viewModel.getSatisfyingCards(for: viewModel.columnConditions[col], in: columnCards)
            return satisfyingIndices.contains(row)
        }
        
        return false
    }
}

struct ContentView: View {
    @StateObject private var viewModel = CardGridViewModel()
    @State private var selectedCard: (row: Int, col: Int)? = nil
    @State private var satisfiedRows: Set<Int> = []
    @State private var satisfiedColumns: Set<Int> = []
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    RowConditionsView(
                        conditions: viewModel.columnConditions,
                        satisfiedRows: satisfiedColumns,
                        viewModel: viewModel
                    )
                    
                    HStack(spacing: 0) {
                        ColumnConditionsView(
                            conditions: viewModel.rowConditions,
                            satisfiedColumns: satisfiedRows,
                            viewModel: viewModel
                        )
                        
                        CardGridView(
                            cards: viewModel.cards,
                            emptyCardVariants: viewModel.emptyCardVariants,
                            selectedCard: selectedCard,
                            onCardTap: handleCardTap,
                            satisfiedRows: satisfiedRows,
                            satisfiedColumns: satisfiedColumns,
                            viewModel: viewModel
                        )
                    }
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "191919"))
        .ignoresSafeArea()
        .onAppear {
            checkAllConditions()
        }
    }
    
    private func checkAllConditions() {
        print("\n=== Checking All Conditions ===")
        var newSatisfiedRows = Set<Int>()
        var newSatisfiedColumns = Set<Int>()
        
        // Check all rows
        print("\nChecking Rows:")
        for row in 0..<5 {
            let rowCards = viewModel.cards[row]
            print("\nRow \(row):")
            let rowCardStrings = rowCards.compactMap { (card: Card?) -> String? in
                guard let card = card else { return nil }
                return "\(card.suit) \(card.rank)"
            }
            print("Cards: \(rowCardStrings)")
            print("Condition: \(viewModel.rowConditions[row])")
            if viewModel.isConditionSatisfied(cards: rowCards, condition: viewModel.rowConditions[row]) {
                print("Row \(row) condition satisfied!")
                newSatisfiedRows.insert(row)
            }
        }
        
        // Check all columns
        print("\nChecking Columns:")
        for col in 0..<5 {
            let columnCards = viewModel.cards.map { $0[col] }
            print("\nColumn \(col):")
            let columnCardStrings = columnCards.compactMap { (card: Card?) -> String? in
                guard let card = card else { return nil }
                return "\(card.suit) \(card.rank)"
            }
            print("Cards: \(columnCardStrings)")
            print("Condition: \(viewModel.columnConditions[col])")
            if viewModel.isConditionSatisfied(cards: columnCards, condition: viewModel.columnConditions[col]) {
                print("Column \(col) condition satisfied!")
                newSatisfiedColumns.insert(col)
            }
        }
        
        print("\nUpdating satisfied sets:")
        print("Previous satisfied rows: \(satisfiedRows)")
        print("Previous satisfied columns: \(satisfiedColumns)")
        print("New satisfied rows: \(newSatisfiedRows)")
        print("New satisfied columns: \(newSatisfiedColumns)")
        
        // Update with animation
        withAnimation(.easeInOut(duration: 0.3)) {
            satisfiedRows = newSatisfiedRows
            satisfiedColumns = newSatisfiedColumns
        }
    }
    
    private func handleCardTap(row: Int, col: Int) {
        print("\n=== Card Tap ===")
        print("Tapped position: row=\(row), col=\(col)")
        
        if let selected = selectedCard {
            print("Selected card: row=\(selected.row), col=\(selected.col)")
            // If the target position is empty, move the card there
            if viewModel.cards[row][col] == nil {
                print("Moving card to empty position")
                viewModel.cards[row][col] = viewModel.cards[selected.row][selected.col]
                viewModel.cards[selected.row][selected.col] = nil
            } else {
                print("Swapping cards")
                let temp = viewModel.cards[selected.row][selected.col]
                viewModel.cards[selected.row][selected.col] = viewModel.cards[row][col]
                viewModel.cards[row][col] = temp
            }
            
            // Check all conditions after any card movement
            checkAllConditions()
            
            selectedCard = nil
        } else if viewModel.cards[row][col] != nil {
            print("Selecting card")
            selectedCard = (row, col)
        }
    }
}

#Preview {
    ContentView()
}
