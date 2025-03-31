import SwiftUI

struct CardView: View {
    let card: Card
    let isSelected: Bool
    let isRowSatisfied: Bool
    let isColumnSatisfied: Bool
    
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
        .modifier(SelectionOverlay(isSelected: isSelected))
        .modifier(RowHighlightOverlay(isRowSatisfied: isRowSatisfied, isColumnSatisfied: isColumnSatisfied))
        .modifier(ColumnHighlightOverlay(isColumnSatisfied: isColumnSatisfied, isRowSatisfied: isRowSatisfied))
        .modifier(GradientGlowOverlay(isRowSatisfied: isRowSatisfied, isColumnSatisfied: isColumnSatisfied))
        .modifier(GradientBorderOverlay(isRowSatisfied: isRowSatisfied, isColumnSatisfied: isColumnSatisfied))
    }
}

struct SelectionOverlay: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 3 : 1)
        )
    }
}

struct RowHighlightOverlay: ViewModifier {
    let isRowSatisfied: Bool
    let isColumnSatisfied: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isRowSatisfied && !isColumnSatisfied {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "4CAF50").opacity(0.5), lineWidth: 6)
                            .blur(radius: 2)
                    }
                }
            )
            .overlay(
                Group {
                    if isRowSatisfied && !isColumnSatisfied {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "4CAF50"), lineWidth: 2)
                    }
                }
            )
    }
}

struct ColumnHighlightOverlay: ViewModifier {
    let isColumnSatisfied: Bool
    let isRowSatisfied: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isColumnSatisfied && !isRowSatisfied {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "BA68C8").opacity(0.5), lineWidth: 6)
                            .blur(radius: 2)
                    }
                }
            )
            .overlay(
                Group {
                    if isColumnSatisfied {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "BA68C8"), lineWidth: isRowSatisfied ? 1 : 2)
                    }
                }
            )
    }
}

struct GradientGlowOverlay: ViewModifier {
    let isRowSatisfied: Bool
    let isColumnSatisfied: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isRowSatisfied && isColumnSatisfied {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "4CAF50"),  // Green
                                        Color(hex: "BA68C8")   // Purple
                                    ],
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                ).opacity(0.5),
                                lineWidth: 8
                            )
                            .blur(radius: 4)
                    }
                }
            )
    }
}

struct GradientBorderOverlay: ViewModifier {
    let isRowSatisfied: Bool
    let isColumnSatisfied: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isRowSatisfied && isColumnSatisfied {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "4CAF50"),  // Green
                                        Color(hex: "BA68C8")   // Purple
                                    ],
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                ),
                                lineWidth: 2
                            )
                    }
                }
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
        CardView(card: Card(suit: .hearts, rank: .ace), isSelected: false, isRowSatisfied: false, isColumnSatisfied: false)
        CardView(card: Card(suit: .spades, rank: .king), isSelected: false, isRowSatisfied: true, isColumnSatisfied: false)
        CardView(card: Card(suit: .diamonds, rank: .queen), isSelected: false, isRowSatisfied: false, isColumnSatisfied: true)
        CardView(card: Card(suit: .clubs, rank: .jack), isSelected: false, isRowSatisfied: true, isColumnSatisfied: true)
        
        Divider()
        
        EmptyCardView(variant: .empty, isHighlighted: false)
        EmptyCardView(variant: .suitOnly(.hearts), isHighlighted: false)
        EmptyCardView(variant: .rankOnly(.ace), isHighlighted: false)
    }
    .padding()
    .background(Color(hex: "191919"))
} 