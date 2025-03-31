import Foundation

public struct Card: Identifiable, Equatable, Hashable {
    public let id = UUID()
    public let suit: Suit
    public let rank: Rank
    
    public init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }
    
    public enum Suit: String, CaseIterable {
        case hearts = "heart.fill"
        case diamonds = "diamond.fill"
        case clubs = "suit.club.fill"
        case spades = "suit.spade.fill"
        
        public var color: String {
            switch self {
            case .hearts, .diamonds:
                return "red"
            case .clubs, .spades:
                return "black"
            }
        }
    }
    
    public enum Rank: String, CaseIterable {
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case ten = "10"
        case jack = "J"
        case queen = "Q"
        case king = "K"
        case ace = "A"
        
        public var numericValue: Int {
            switch self {
            case .two: return 2
            case .three: return 3
            case .four: return 4
            case .five: return 5
            case .six: return 6
            case .seven: return 7
            case .eight: return 8
            case .nine: return 9
            case .ten: return 10
            case .jack: return 11
            case .queen: return 12
            case .king: return 13
            case .ace: return 14
            }
        }
        
        public func isFaceCard() -> Bool {
            switch self {
            case .jack, .queen, .king:
                return true
            default:
                return false
            }
        }
    }
} 