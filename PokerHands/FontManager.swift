import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {
        registerFonts()
    }
    
    func registerFonts() {
        guard let fontURL = Bundle.main.url(forResource: "SF-Compact-Text-Medium", withExtension: "otf") else {
            print("Error: Could not find font file in bundle")
            return
        }
        
        var error: Unmanaged<CFError>?
        
        guard CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) else {
            print("Error: Could not register font: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
            return
        }
        
        print("Successfully registered custom font")
    }
    
    func customFont(size: CGFloat) -> Font {
        return .custom("SF Compact Text Medium", size: size)
    }
} 