import SwiftUI

public struct CustomNavigationBar: View {
    let title: String
    let onPreviousTap: () -> Void
    let onNextTap: () -> Void
    
    public init(title: String, onPreviousTap: @escaping () -> Void, onNextTap: @escaping () -> Void) {
        self.title = title
        self.onPreviousTap = onPreviousTap
        self.onNextTap = onNextTap
    }
    
    public var body: some View {
        HStack {
            // Left button
            Button(action: onPreviousTap) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(hex: "333333"))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Center title
            Text(title)
                .font(FontManager.shared.customFont(size: 20))
                .foregroundColor(.white)
            
            Spacer()
            
            // Right button
            Button(action: onNextTap) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(hex: "333333"))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
        .padding(.bottom, 12)
        .background(Color(hex: "191919"))
    }
} 