import SwiftUI

public struct CardGridView: View {
    let cards: [[Card?]]
    let emptyCardVariants: [[EmptyCardView.Variant]]
    let selectedCard: (row: Int, col: Int)?
    let onCardTap: (Int, Int) -> Void
    let satisfiedRows: Set<Int>
    let satisfiedColumns: Set<Int>
    let viewModel: CardGridViewModel
    
    public init(
        cards: [[Card?]],
        emptyCardVariants: [[EmptyCardView.Variant]],
        selectedCard: (row: Int, col: Int)?,
        onCardTap: @escaping (Int, Int) -> Void,
        satisfiedRows: Set<Int>,
        satisfiedColumns: Set<Int>,
        viewModel: CardGridViewModel
    ) {
        self.cards = cards
        self.emptyCardVariants = emptyCardVariants
        self.selectedCard = selectedCard
        self.onCardTap = onCardTap
        self.satisfiedRows = satisfiedRows
        self.satisfiedColumns = satisfiedColumns
        self.viewModel = viewModel
    }
    
    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(60), spacing: 8), count: 5), spacing: 8) {
            ForEach(0..<5) { row in
                CardRowView(
                    row: row,
                    cards: cards[row],
                    emptyCardVariants: emptyCardVariants[row],
                    selectedCard: selectedCard,
                    onCardTap: onCardTap,
                    satisfiedRows: satisfiedRows,
                    satisfiedColumns: satisfiedColumns,
                    viewModel: viewModel
                )
            }
        }
        .padding(.trailing, 8)
    }
}

private struct CardRowView: View {
    let row: Int
    let cards: [Card?]
    let emptyCardVariants: [EmptyCardView.Variant]
    let selectedCard: (row: Int, col: Int)?
    let onCardTap: (Int, Int) -> Void
    let satisfiedRows: Set<Int>
    let satisfiedColumns: Set<Int>
    let viewModel: CardGridViewModel
    
    var body: some View {
        ForEach(0..<5) { col in
            CardCellView(
                row: row,
                col: col,
                card: cards[col],
                emptyCardVariant: emptyCardVariants[col],
                selectedCard: selectedCard,
                onCardTap: onCardTap,
                satisfiedRows: satisfiedRows,
                satisfiedColumns: satisfiedColumns,
                viewModel: viewModel
            )
        }
    }
}

private struct CardCellView: View {
    let row: Int
    let col: Int
    let card: Card?
    let emptyCardVariant: EmptyCardView.Variant
    let selectedCard: (row: Int, col: Int)?
    let onCardTap: (Int, Int) -> Void
    let satisfiedRows: Set<Int>
    let satisfiedColumns: Set<Int>
    let viewModel: CardGridViewModel
    
    var body: some View {
        Group {
            if let card = card {
                let (isRowSatisfied, isColumnSatisfied) = isCardSatisfyingConditions()
                CardView(
                    card: card,
                    isSelected: selectedCard.map { $0 == (row, col) } ?? false,
                    isRowSatisfied: isRowSatisfied,
                    isColumnSatisfied: isColumnSatisfied
                )
            } else {
                EmptyCardView(
                    variant: emptyCardVariant,
                    isHighlighted: selectedCard != nil
                )
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("CardCellView tapped - row: \(row), col: \(col)")
            onCardTap(row, col)
        }
    }
    
    private func isCardSatisfyingConditions() -> (row: Bool, column: Bool) {
        var isRowSatisfied = false
        var isColumnSatisfied = false
        
        // Check if the card is part of a satisfied row condition
        if satisfiedRows.contains(row) {
            let rowCards = viewModel.cards[row]
            let satisfyingIndices = viewModel.getSatisfyingCards(for: viewModel.rowConditions[row], in: rowCards)
            if satisfyingIndices.contains(col) {
                print("Card at row \(row), col \(col) satisfies row condition")
                isRowSatisfied = true
            }
        }
        
        // Check if the card is part of a satisfied column condition
        if satisfiedColumns.contains(col) {
            let columnCards = viewModel.cards.map { $0[col] }
            let satisfyingIndices = viewModel.getSatisfyingCards(for: viewModel.columnConditions[col], in: columnCards)
            if satisfyingIndices.contains(row) {
                print("Card at row \(row), col \(col) satisfies column condition")
                isColumnSatisfied = true
            }
        }
        
        return (isRowSatisfied, isColumnSatisfied)
    }
} 