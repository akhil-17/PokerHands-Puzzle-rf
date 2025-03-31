import SwiftUI

public struct PokerHandsView: View {
    @ObservedObject var viewModel: CardGridViewModel
    @ObservedObject var moveHistoryViewModel: MoveHistoryViewModel
    @State private var selectedCard: (row: Int, col: Int)? = nil
    @State private var satisfiedRows: Set<Int> = []
    @State private var satisfiedColumns: Set<Int> = []
    
    public init(viewModel: CardGridViewModel, moveHistoryViewModel: MoveHistoryViewModel) {
        self.viewModel = viewModel
        self.moveHistoryViewModel = moveHistoryViewModel
    }
    
    public var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 0) {
                // Column conditions at the top
                ColumnConditionsView(
                    conditions: viewModel.columnConditions,
                    satisfiedColumns: satisfiedColumns,
                    viewModel: viewModel
                )
                
                HStack(spacing: -4) {
                    // Row conditions on the left
                    RowConditionsView(
                        conditions: viewModel.rowConditions,
                        satisfiedRows: satisfiedRows,
                        viewModel: viewModel
                    )
                    
                    // The grid
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
                let card = viewModel.cards[selected.row][selected.col]
                viewModel.cards[row][col] = card
                viewModel.cards[selected.row][selected.col] = nil
                moveHistoryViewModel.addMove(from: selected, to: (row, col), fromCard: card, toCard: nil)
            } else {
                print("Swapping cards")
                let fromCard = viewModel.cards[selected.row][selected.col]
                let toCard = viewModel.cards[row][col]
                viewModel.cards[selected.row][selected.col] = toCard
                viewModel.cards[row][col] = fromCard
                moveHistoryViewModel.addMove(from: selected, to: (row, col), fromCard: fromCard, toCard: toCard)
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