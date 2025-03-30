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
                        .foregroundColor(satisfiedRows.contains(index) ? Color(hex: "4CAF50") : .white)
                        .animation(.easeInOut, value: satisfiedRows.contains(index))
                }
            }
        }
        .padding(.leading, 66)
    }
    
    private func formatCondition(_ condition: CardCondition) -> String {
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
}

struct ColumnConditionsView: View {
    let conditions: [CardCondition]
    let satisfiedColumns: Set<Int>
    let viewModel: CardGridViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(60))], spacing: 8) {
            ForEach(0..<5) { index in
                TextCardLeft(text: formatCondition(conditions[index]))
                    .foregroundColor(satisfiedColumns.contains(index) ? Color(hex: "BA68C8") : .white)
                    .animation(.easeInOut, value: satisfiedColumns.contains(index))
            }
        }
        .padding(.leading, 6)
    }
    
    private func formatCondition(_ condition: CardCondition) -> String {
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
                            let (isRowSatisfied, isColumnSatisfied) = isCardSatisfyingConditions(row: row, col: col)
                            CardView(
                                card: card,
                                isSelected: selectedCard.map { $0 == (row, col) } ?? false,
                                isRowSatisfied: isRowSatisfied,
                                isColumnSatisfied: isColumnSatisfied
                            )
                        } else {
                            EmptyCardView(
                                variant: emptyCardVariants[row][col],
                                isHighlighted: selectedCard != nil
                            )
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print("Tapped position: row=\(row), col=\(col)")
                        onCardTap(row, col)
                    }
                }
            }
        }
        .padding(.trailing, 8)
    }
    
    private func isCardSatisfyingConditions(row: Int, col: Int) -> (row: Bool, column: Bool) {
        var isRowSatisfied = false
        var isColumnSatisfied = false
        
        // Check if the card is part of a satisfied row condition
        if satisfiedRows.contains(row) {
            let rowCards = cards[row]
            let satisfyingIndices = viewModel.getSatisfyingCards(for: viewModel.rowConditions[row], in: rowCards)
            if satisfyingIndices.contains(col) {
                print("Card at row \(row), col \(col) satisfies row condition")
                isRowSatisfied = true
            }
        }
        
        // Check if the card is part of a satisfied column condition
        if satisfiedColumns.contains(col) {
            let columnCards = cards.map { $0[col] }
            let satisfyingIndices = viewModel.getSatisfyingCards(for: viewModel.columnConditions[col], in: columnCards)
            if satisfyingIndices.contains(row) {
                print("Card at row \(row), col \(col) satisfies column condition")
                isColumnSatisfied = true
            }
        }
        
        return (isRowSatisfied, isColumnSatisfied)
    }
}

struct ContentView: View {
    @StateObject private var viewModel: CardGridViewModel
    @State private var selectedCard: (row: Int, col: Int)? = nil
    @State private var satisfiedRows: Set<Int> = []
    @State private var satisfiedColumns: Set<Int> = []
    
    init(viewModel: CardGridViewModel = CardGridViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    RowConditionsView(
                        conditions: viewModel.rowConditions,
                        satisfiedRows: satisfiedRows,
                        viewModel: viewModel
                    )
                    
                    HStack(spacing: 0) {
                        ColumnConditionsView(
                            conditions: viewModel.columnConditions,
                            satisfiedColumns: satisfiedColumns,
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

#Preview("Unsolved State") {
    // Create a ContentView with a shuffled viewModel
    ContentView(viewModel: CardGridViewModel(shuffleCards: true))
}

#Preview("Solved State") {
    // Create a ContentView with a solved viewModel
    ContentView(viewModel: CardGridViewModel(shuffleCards: false))
}
