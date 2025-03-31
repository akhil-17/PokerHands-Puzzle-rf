import Foundation

public class MoveHistoryViewModel: ObservableObject {
    @Published public var moveHistory: [(from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?)] = []
    @Published public var redoHistory: [(from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?)] = []
    
    public init() {}
    
    public func addMove(from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?) {
        print("Adding move to history - count: \(moveHistory.count)")
        moveHistory.append((from: from, to: to, fromCard: fromCard, toCard: toCard))
        // Clear redo history when a new move is made
        redoHistory.removeAll()
        print("Move history count after add: \(moveHistory.count)")
    }
    
    public func undoLastMove() -> (from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?)? {
        print("Undoing last move - count: \(moveHistory.count)")
        if let move = moveHistory.popLast() {
            redoHistory.append(move)
            print("Move history count after undo: \(moveHistory.count)")
            print("Redo history count after undo: \(redoHistory.count)")
            return move
        }
        return nil
    }
    
    public func redoLastMove() -> (from: (row: Int, col: Int), to: (row: Int, col: Int), fromCard: Card?, toCard: Card?)? {
        print("Redoing last move - count: \(redoHistory.count)")
        if let move = redoHistory.popLast() {
            moveHistory.append(move)
            print("Move history count after redo: \(moveHistory.count)")
            print("Redo history count after redo: \(redoHistory.count)")
            return move
        }
        return nil
    }
    
    public var canRedo: Bool {
        return !redoHistory.isEmpty
    }
} 