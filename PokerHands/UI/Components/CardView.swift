import SwiftUI

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
                                    stops: [
                                        .init(color: Color(hex: "4CAF50"), location: 0),    // Green at 0%
                                        .init(color: Color(hex: "4CAF50"), location: 0.25),  // Green at 25%
                                        .init(color: Color(hex: "BA68C8"), location: 0.75),  // Purple at 75%
                                        .init(color: Color(hex: "BA68C8"), location: 1)      // Purple at 100%
                                    ],
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                ).opacity(0.5),
                                lineWidth: 6
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
                                    stops: [
                                        .init(color: Color(hex: "4CAF50"), location: 0),    // Green at 0%
                                        .init(color: Color(hex: "4CAF50"), location: 0.48),  // Green at 48%
                                        .init(color: Color(hex: "BA68C8"), location: 0.52),  // Purple at 52%
                                        .init(color: Color(hex: "BA68C8"), location: 1)      // Purple at 100%
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
                            .blur(radius: 5)
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
    let isRowSatisfied: Bool
    let isColumnSatisfied: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isColumnSatisfied && !isRowSatisfied {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "BA68C8").opacity(0.5), lineWidth: 6)
                            .blur(radius: 5)
                    }
                }
            )
            .overlay(
                Group {
                    if isColumnSatisfied && !isRowSatisfied {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "BA68C8"), lineWidth: 2)
                    }
                }
            )
    }
}

struct SelectionOverlay: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "0084FF"), lineWidth: 2)
                    }
                }
            )
    }
}

struct CardHighlightModifier: ViewModifier {
    let isSelected: Bool
    let isRowSatisfied: Bool
    let isColumnSatisfied: Bool
    
    func body(content: Content) -> some View {
        content
            .modifier(GradientGlowOverlay(isRowSatisfied: isRowSatisfied, isColumnSatisfied: isColumnSatisfied))
            .modifier(GradientBorderOverlay(isRowSatisfied: isRowSatisfied, isColumnSatisfied: isColumnSatisfied))
            .modifier(RowHighlightOverlay(isRowSatisfied: isRowSatisfied, isColumnSatisfied: isColumnSatisfied))
            .modifier(ColumnHighlightOverlay(isRowSatisfied: isRowSatisfied, isColumnSatisfied: isColumnSatisfied))
            .modifier(SelectionOverlay(isSelected: isSelected))
    }
}

public struct CardView: View {
    let card: Card
    let isSelected: Bool
    let isRowSatisfied: Bool
    let isColumnSatisfied: Bool
    
    public init(card: Card, isSelected: Bool, isRowSatisfied: Bool, isColumnSatisfied: Bool) {
        self.card = card
        self.isSelected = isSelected
        self.isRowSatisfied = isRowSatisfied
        self.isColumnSatisfied = isColumnSatisfied
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            Text(card.rank.rawValue)
                .font(FontManager.shared.roundedBoldFont(size: 24))
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
        .modifier(CardHighlightModifier(
            isSelected: isSelected,
            isRowSatisfied: isRowSatisfied,
            isColumnSatisfied: isColumnSatisfied
        ))
    }
} 
