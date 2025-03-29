import SwiftUI

struct CardView: View {
    let card: Card
    let isSelected: Bool
    let isSatisfied: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(card.rank.rawValue)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(card.suit.color == "red" ? Color(hex: "F00000") : Color(hex: "000000"))
            
            Image(systemName: card.suit.rawValue)
                .font(.system(size: 24))
                .frame(width: 24, height: 24)
                .foregroundColor(card.suit.color == "red" ? Color(hex: "F00000") : Color(hex: "000000"))
        }
        .frame(width: 60, height: 80)
        .background(Color(hex: "efefef"))
        .cornerRadius(8)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 3 : 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSatisfied ? Color(hex: "4CAF50").opacity(0.5) : Color.clear, lineWidth: 6)
                .blur(radius: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSatisfied ? Color(hex: "4CAF50") : Color.clear, lineWidth: 2)
        )
    }
}

struct EmptyCardView: View {
    enum Variant {
        case empty
        case suitOnly(Suit)
        case rankOnly(Rank)
    }
    
    let variant: Variant
    let isHighlighted: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            if case .rankOnly(let rank) = variant {
                Text(rank.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "666666"))
            } else if case .suitOnly = variant {
                Color.clear
                    .frame(height: 24)
            } else {
                Color.clear
                    .frame(height: 24)
            }
            
            if case .suitOnly(let suit) = variant {
                Image(systemName: suit.rawValue)
                    .font(.system(size: 24))
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "666666"))
            } else if case .rankOnly = variant {
                Color.clear
                    .frame(height: 24)
            } else {
                Color.clear
                    .frame(height: 24)
            }
        }
        .frame(width: 60, height: 80)
        .background(Color.clear)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isHighlighted ? Color.blue : Color(hex: "666666"), lineWidth: isHighlighted ? 3 : 1)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        CardView(card: Card(suit: .hearts, rank: .ace), isSelected: false, isSatisfied: false)
        CardView(card: Card(suit: .spades, rank: .king), isSelected: false, isSatisfied: false)
        CardView(card: Card(suit: .diamonds, rank: .queen), isSelected: false, isSatisfied: false)
        CardView(card: Card(suit: .clubs, rank: .jack), isSelected: false, isSatisfied: false)
        
        Divider()
        
        EmptyCardView(variant: .empty, isHighlighted: false)
        EmptyCardView(variant: .suitOnly(.hearts), isHighlighted: false)
        EmptyCardView(variant: .rankOnly(.ace), isHighlighted: false)
    }
    .padding()
    .background(Color(hex: "191919"))
} 