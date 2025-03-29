import SwiftUI

struct TextCardLeft: View {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(FontManager.shared.customFont(size: 13))
            .multilineTextAlignment(.trailing)
            .lineLimit(4)
            .padding(.trailing, 8)
            .frame(width: 60, height: 80, alignment: .trailing)
    }
}

struct TextCardTop: View {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(FontManager.shared.customFont(size: 13))
            .multilineTextAlignment(.center)
            .lineLimit(4)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
            .frame(width: 60, height: 80, alignment: .bottomLeading)
    }
}

#Preview {
    VStack(spacing: 20) {
        TextCardLeft(text: "Royal Flush")
        TextCardLeft(text: "Straight Flush")
        TextCardLeft(text: "4 of a Kind")
        TextCardLeft(text: "Full House")
        TextCardLeft(text: "Flush")
        
        Divider()
        
        TextCardTop(text: "Royal Flush")
        TextCardTop(text: "Straight Flush")
        TextCardTop(text: "4 of a Kind")
        TextCardTop(text: "Full House")
        TextCardTop(text: "Flush")
    }
    .padding()
    .background(Color(hex: "191919"))
} 