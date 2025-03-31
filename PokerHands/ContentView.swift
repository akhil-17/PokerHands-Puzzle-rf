//
//  ContentView.swift
//  PokerHands
//
//  Created by Akhil Dakinedi on 3/26/25.
//

import SwiftUI

class MoveHistoryViewModel: ObservableObject {
    @Published var moveHistory: [(from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?)] = []
    @Published var redoHistory: [(from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?)] = []
    
    func addMove(from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?) {
        print("Adding move to history - count: \(moveHistory.count)")
        moveHistory.append((from: from, to: to, fromCard: fromCard, toCard: toCard))
        // Clear redo history when a new move is made
        redoHistory.removeAll()
        print("Move history count after add: \(moveHistory.count)")
    }
    
    func undoLastMove() -> (from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?)? {
        print("Undoing last move - count: \(moveHistory.count)")
        if let move = moveHistory.popLast() {
            redoHistory.append(move)
            print("Move history count after undo: \(moveHistory.count)")
            print("Redo history count after undo: \(redoHistory.count)")
            return move
        }
        return nil
    }
    
    func redoLastMove() -> (from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?)? {
        print("Redoing last move - count: \(redoHistory.count)")
        if let move = redoHistory.popLast() {
            moveHistory.append(move)
            print("Move history count after redo: \(moveHistory.count)")
            print("Redo history count after redo: \(redoHistory.count)")
            return move
        }
        return nil
    }
    
    var canRedo: Bool {
        return !redoHistory.isEmpty
    }
}

struct RowConditionsView: View {
    let conditions: [CardCondition]
    let satisfiedRows: Set<Int>
    let viewModel: CardGridViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(40), spacing: 8), count: 1), spacing: 8) {
            ForEach(0..<5) { index in
                TextCardLeft(text: formatCondition(conditions[index]))
                    .foregroundColor(satisfiedRows.contains(index) ? Color(hex: "4CAF50") : .white)
                    .animation(.easeInOut, value: satisfiedRows.contains(index))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.trailing, 8)
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
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(60), spacing: 8), count: 5), spacing: 8) {
            ForEach(0..<5) { index in
                TextCardTop(text: formatCondition(conditions[index]))
                    .foregroundColor(satisfiedColumns.contains(index) ? Color(hex: "BA68C8") : .white)
                    .animation(.easeInOut, value: satisfiedColumns.contains(index))
            }
        }
        .padding(.leading, 38)
        .padding(.bottom, 0)
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
            let rowCards = viewModel.solutionCards[row]
            let satisfyingIndices = viewModel.getSatisfyingCards(for: viewModel.rowConditions[row], in: rowCards)
            if satisfyingIndices.contains(col) {
                print("Card at row \(row), col \(col) satisfies row condition")
                isRowSatisfied = true
            }
        }
        
        // Check if the card is part of a satisfied column condition
        if satisfiedColumns.contains(col) {
            let columnCards = viewModel.solutionCards.map { $0[col] }
            let satisfyingIndices = viewModel.getSatisfyingCards(for: viewModel.columnConditions[col], in: columnCards)
            if satisfyingIndices.contains(row) {
                print("Card at row \(row), col \(col) satisfies column condition")
                isColumnSatisfied = true
            }
        }
        
        return (isRowSatisfied, isColumnSatisfied)
    }
}

struct CustomNavigationBar: View {
    let title: String
    let onPreviousTap: () -> Void
    let onNextTap: () -> Void
    
    var body: some View {
        HStack {
            // Left button
            Button(action: onPreviousTap) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(hex: "333333"))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Center title
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Right button
            Button(action: onNextTap) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(hex: "333333"))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
        .padding(.bottom, 12)
        .background(Color(hex: "191919"))
    }
}

struct SolutionPreviewOverlay: View {
    let viewModel: CardGridViewModel
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            HStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // Column conditions at the top
                    ColumnConditionsView(
                        conditions: viewModel.columnConditions,
                        satisfiedColumns: Set(0..<5), // All columns are satisfied in solution
                        viewModel: viewModel
                    )
                    
                    HStack(spacing: -4) {
                        // Row conditions on the left
                        RowConditionsView(
                            conditions: viewModel.rowConditions,
                            satisfiedRows: Set(0..<5), // All rows are satisfied in solution
                            viewModel: viewModel
                        )
                        
                        // The grid
                        CardGridView(
                            cards: viewModel.solutionCards,
                            emptyCardVariants: viewModel.emptyCardVariants,
                            selectedCard: nil,
                            onCardTap: { _, _ in },
                            satisfiedRows: Set(0..<5),
                            satisfiedColumns: Set(0..<5),
                            viewModel: viewModel
                        )
                    }
                }
                .padding(.top, 6) // Add 6 points of top padding to shift the grid down
                
                Spacer()
            }
        }
    }
}

struct CustomBottomNavigationBar: View {
    let onUndoTap: () -> Void
    let onRedoTap: () -> Void
    let onResetTap: () -> Void
    let canUndo: Bool
    let canRedo: Bool
    let canReset: Bool
    let onSolutionPreviewPress: () -> Void
    let onSolutionPreviewRelease: () -> Void
    
    var body: some View {
        HStack {
            // Left stack of buttons with fixed width
            HStack(spacing: 8) {
                // Undo button or placeholder
                if canUndo {
                    Button(action: onUndoTap) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "333333"))
                            .clipShape(Circle())
                    }
                } else {
                    // Placeholder with same dimensions
                    Color.clear
                        .frame(width: 56, height: 56)
                }
                
                // Redo button or placeholder
                if canRedo {
                    Button(action: onRedoTap) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "333333"))
                            .clipShape(Circle())
                    }
                } else {
                    // Placeholder with same dimensions
                    Color.clear
                        .frame(width: 56, height: 56)
                }
            }
            .frame(width: 120) // Fixed width for the left container
            
            Spacer()
            
            // Center button
            Button(action: {}) {
                Image(systemName: "eye.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(hex: "333333"))
                    .clipShape(Circle())
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        onSolutionPreviewPress()
                    }
                    .onEnded { _ in
                        onSolutionPreviewRelease()
                    }
            )
            
            Spacer()
            
            // Right stack of buttons with fixed width
            HStack(spacing: 8) {
                // Reset button or placeholder
                if canReset {
                    Button(action: onResetTap) {
                        Image(systemName: "arrow.trianglehead.2.counterclockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "333333"))
                            .clipShape(Circle())
                    }
                } else {
                    // Placeholder with same dimensions
                    Color.clear
                        .frame(width: 56, height: 56)
                }
                
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color(hex: "333333"))
                        .clipShape(Circle())
                }
            }
            .frame(width: 120) // Fixed width for the right container
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 48)
        .background(Color(hex: "191919"))
    }
}

struct Puzzle1View: View {
    var body: some View {
        Text("Puzzle 1")
            .foregroundColor(.white)
    }
}

struct Puzzle2View: View {
    var body: some View {
        Text("Puzzle 2")
            .foregroundColor(.white)
    }
}

struct Puzzle3View: View {
    var body: some View {
        Text("Puzzle 3")
            .foregroundColor(.white)
    }
}

struct MainView: View {
    @State private var currentPuzzleIndex = 0
    @StateObject private var moveHistoryViewModel = MoveHistoryViewModel()
    @StateObject private var cardGridViewModel = CardGridViewModel()
    @State private var isShowingSolution = false
    
    private let puzzles = [
        (name: "Prototype puzzle", view: { moveHistoryViewModel, cardGridViewModel in AnyView(PokerHandsView(viewModel: cardGridViewModel, moveHistoryViewModel: moveHistoryViewModel)) }),
        (name: "Puzzle 1", view: { _, _ in AnyView(Puzzle1View()) }),
        (name: "Puzzle 2", view: { _, _ in AnyView(Puzzle2View()) }),
        (name: "Puzzle 3", view: { _, _ in AnyView(Puzzle3View()) })
    ]
    
    private var canUndo: Bool {
        let canUndo = currentPuzzleIndex == 0 && moveHistoryViewModel.moveHistory.count > 0
        print("MainView - canUndo: \(canUndo), moveHistory.count: \(moveHistoryViewModel.moveHistory.count)")
        return canUndo
    }
    
    private var canReset: Bool {
        return currentPuzzleIndex == 0 && moveHistoryViewModel.moveHistory.count > 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    CustomNavigationBar(title: puzzles[currentPuzzleIndex].name, onPreviousTap: navigateToPreviousPuzzle, onNextTap: navigateToNextPuzzle)
                        .safeAreaInset(edge: .top) {
                            Color.clear.frame(height: 0)
                        }
                    
                    Spacer()
                    
                    if currentPuzzleIndex == 0 {
                        PokerHandsView(viewModel: cardGridViewModel, moveHistoryViewModel: moveHistoryViewModel)
                    } else {
                        puzzles[currentPuzzleIndex].view(moveHistoryViewModel, cardGridViewModel)
                    }
                    
                    Spacer()
                    
                    CustomBottomNavigationBar(
                        onUndoTap: {
                            print("Undo button tapped")
                            if let lastMove = moveHistoryViewModel.undoLastMove() {
                                print("Undoing move from (\(lastMove.from.row), \(lastMove.from.col)) to (\(lastMove.to.row), \(lastMove.to.col))")
                                // Restore both cards to their original positions
                                cardGridViewModel.cards[lastMove.from.row][lastMove.from.col] = lastMove.fromCard
                                cardGridViewModel.cards[lastMove.to.row][lastMove.to.col] = lastMove.toCard
                            }
                        },
                        onRedoTap: {
                            print("Redo button tapped")
                            if let lastMove = moveHistoryViewModel.redoLastMove() {
                                print("Redoing move from (\(lastMove.from.row), \(lastMove.from.col)) to (\(lastMove.to.row), \(lastMove.to.col))")
                                // Restore both cards to their swapped positions
                                cardGridViewModel.cards[lastMove.from.row][lastMove.from.col] = lastMove.toCard
                                cardGridViewModel.cards[lastMove.to.row][lastMove.to.col] = lastMove.fromCard
                            }
                        },
                        onResetTap: {
                            print("Reset button tapped")
                            // Reset the puzzle to its initial state
                            cardGridViewModel.resetToInitialState()
                            // Clear the move history
                            moveHistoryViewModel.moveHistory.removeAll()
                            moveHistoryViewModel.redoHistory.removeAll()
                        },
                        canUndo: canUndo,
                        canRedo: moveHistoryViewModel.canRedo,
                        canReset: canReset,
                        onSolutionPreviewPress: {
                            isShowingSolution = true
                        },
                        onSolutionPreviewRelease: {
                            isShowingSolution = false
                        }
                    )
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 0)
                    }
                }
                
                if isShowingSolution {
                    SolutionPreviewOverlay(viewModel: cardGridViewModel)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "191919"))
        .ignoresSafeArea()
        .onChange(of: moveHistoryViewModel.moveHistory.count) { oldCount, newCount in
            print("MainView - Move history count changed from: \(oldCount) to: \(newCount)")
            print("MainView - Can undo: \(currentPuzzleIndex == 0 && newCount > 0)")
        }
    }
    
    private func navigateToNextPuzzle() {
        withAnimation {
            currentPuzzleIndex = (currentPuzzleIndex + 1) % puzzles.count
        }
    }
    
    private func navigateToPreviousPuzzle() {
        withAnimation {
            currentPuzzleIndex = (currentPuzzleIndex - 1 + puzzles.count) % puzzles.count
        }
    }
}

struct PokerHandsView: View {
    @ObservedObject var viewModel: CardGridViewModel
    @ObservedObject var moveHistoryViewModel: MoveHistoryViewModel
    @State private var selectedCard: (row: Int, col: Int)? = nil
    @State private var satisfiedRows: Set<Int> = []
    @State private var satisfiedColumns: Set<Int> = []
    
    var body: some View {
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

#Preview("Unsolved State") {
    return MainView()
}

#Preview("Solved State") {
    return MainView()
}
