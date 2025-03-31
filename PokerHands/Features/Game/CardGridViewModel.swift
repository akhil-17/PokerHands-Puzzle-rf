import Foundation

public class CardGridViewModel: ObservableObject {
    @Published public var cards: [[Card?]] = Array(repeating: Array(repeating: nil, count: 5), count: 5)
    @Published public var emptyCardVariants: [[EmptyCardView.Variant]] = Array(repeating: Array(repeating: .empty, count: 5), count: 5)
    @Published public var rowConditions: [CardCondition] = []
    @Published public var columnConditions: [CardCondition] = []
    @Published public var solutionCards: [[Card?]] = []
    private var initialCards: [[Card?]] = []
    
    public init() {
        setupPrototypePuzzle()
        initialCards = cards
        solutionCards = initialCards
    }
    
    public func setupPrototypePuzzle() {
        // Set up the initial state
        CardGridState.shuffleInitialState(cards: &cards, emptyCardVariants: &emptyCardVariants)
        
        // Set up the conditions
        rowConditions = [
            .allHearts,
            .threeQueens,
            .ascendingSequence,
            .fourSevens,
            .allFaceCards
        ]
        
        columnConditions = [
            .threeOfAKind,
            .flush,
            .straight,
            .pair,
            .allSameSuit
        ]
        
        // Set up the solution
        solutionCards = [
            [Card(suit: .hearts, rank: .ace), Card(suit: .hearts, rank: .king), Card(suit: .hearts, rank: .queen), Card(suit: .hearts, rank: .jack), Card(suit: .hearts, rank: .ten)],
            [Card(suit: .diamonds, rank: .queen), Card(suit: .hearts, rank: .queen), Card(suit: .clubs, rank: .queen), Card(suit: .spades, rank: .king), Card(suit: .hearts, rank: .jack)],
            [Card(suit: .clubs, rank: .two), Card(suit: .diamonds, rank: .three), Card(suit: .hearts, rank: .four), Card(suit: .spades, rank: .five), Card(suit: .clubs, rank: .six)],
            [Card(suit: .spades, rank: .seven), Card(suit: .hearts, rank: .seven), Card(suit: .diamonds, rank: .seven), Card(suit: .clubs, rank: .seven), Card(suit: .spades, rank: .king)],
            [Card(suit: .diamonds, rank: .jack), Card(suit: .clubs, rank: .queen), Card(suit: .hearts, rank: .king), Card(suit: .spades, rank: .jack), Card(suit: .diamonds, rank: .queen)]
        ]
    }
    
    public func resetToInitialState() {
        CardGridState.resetToInitialState(cards: &cards, emptyCardVariants: &emptyCardVariants)
        setupPrototypePuzzle()
    }
    
    public func isConditionSatisfied(cards: [Card?], condition: CardCondition) -> Bool {
        return CardConditionLogic.isConditionSatisfied(cards: cards, condition: condition)
    }
    
    public func getSatisfyingCards(for condition: CardCondition, in cards: [Card?]) -> Set<Int> {
        return CardConditionLogic.getSatisfyingCards(for: condition, in: cards)
    }
    
    public func formatCondition(_ condition: CardCondition) -> String {
        return CardConditionLogic.formatCondition(condition)
    }
} 