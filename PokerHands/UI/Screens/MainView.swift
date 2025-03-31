import SwiftUI

public struct MainView: View {
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
    
    public init() {}
    
    private var canUndo: Bool {
        let canUndo = currentPuzzleIndex == 0 && moveHistoryViewModel.moveHistory.count > 0
        print("MainView - canUndo: \(canUndo), moveHistory.count: \(moveHistoryViewModel.moveHistory.count)")
        return canUndo
    }
    
    private var canReset: Bool {
        return currentPuzzleIndex == 0 && moveHistoryViewModel.moveHistory.count > 0
    }
    
    public var body: some View {
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