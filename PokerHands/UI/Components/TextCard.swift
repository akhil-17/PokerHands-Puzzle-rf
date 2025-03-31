import SwiftUI

public struct TextCardLeft: View {
    let text: String
    let textColor: Color
    
    public init(text: String, textColor: Color = .white) {
        self.text = text
        self.textColor = textColor
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.clear)
                .frame(width: 40, height: 80)
            
            Text(text)
                .font(FontManager.shared.customFont(size: 12))
                .multilineTextAlignment(.trailing)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 4)
                .foregroundColor(textColor)
        }
    }
}

public struct TextCardTop: View {
    let text: String
    let textColor: Color
    
    public init(text: String, textColor: Color = .white) {
        self.text = text
        self.textColor = textColor
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.clear)
                .frame(width: 60, height: 80)
            
            Text(text)
                .font(FontManager.shared.customFont(size: 12))
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .padding(.horizontal, 4)
                .padding(.bottom, 8)
                .foregroundColor(textColor)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        TextCardLeft(text: "All Hearts", textColor: Color(hex: "efefef"))
            .animation(.easeInOut, value: false)
        TextCardTop(text: "3 of a kind")
    }
    .padding()
    .background(Color(hex: "191919"))
} 