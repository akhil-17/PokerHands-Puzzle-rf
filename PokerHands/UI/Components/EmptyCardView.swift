import SwiftUI

public struct EmptyCardView: View {
    public enum Variant {
        case empty
        case suitOnly(Card.Suit)
        case rankOnly(Card.Rank)
    }
    
    let variant: Variant
    let isHighlighted: Bool
    
    public init(variant: Variant, isHighlighted: Bool) {
        self.variant = variant
        self.isHighlighted = isHighlighted
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            if case .rankOnly(let rank) = variant {
                Text(rank.rawValue)
                    .font(FontManager.shared.customFont(size: 24))
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
        EmptyCardView(variant: .empty, isHighlighted: false)
        EmptyCardView(variant: .suitOnly(.hearts), isHighlighted: false)
        EmptyCardView(variant: .rankOnly(.ace), isHighlighted: false)
    }
    .padding()
    .background(Color(hex: "191919"))
} 