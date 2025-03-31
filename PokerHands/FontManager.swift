import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {
        registerFonts()
    }
    
    func registerFonts() {
        // Register SF Compact Text Medium
        guard let textMediumURL = Bundle.main.url(forResource: "SF-Compact-Text-Medium", withExtension: "otf") else {
            print("Error: Could not find SF-Compact-Text-Medium font file in bundle")
            return
        }
        
        // Register SF Compact Rounded Semibold
        guard let roundedSemiboldURL = Bundle.main.url(forResource: "SF-Compact-Rounded-Semibold", withExtension: "otf") else {
            print("Error: Could not find SF-Compact-Rounded-Semibold font file in bundle")
            return
        }
        
        // Register SF Compact Rounded Bold
        guard let roundedBoldURL = Bundle.main.url(forResource: "SF-Compact-Rounded-Bold", withExtension: "otf") else {
            print("Error: Could not find SF-Compact-Rounded-Bold font file in bundle")
            return
        }
        
        var error: Unmanaged<CFError>?
        
        guard CTFontManagerRegisterFontsForURL(textMediumURL as CFURL, .process, &error) else {
            print("Error: Could not register SF-Compact-Text-Medium font: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
            return
        }
        
        guard CTFontManagerRegisterFontsForURL(roundedSemiboldURL as CFURL, .process, &error) else {
            print("Error: Could not register SF-Compact-Rounded-Semibold font: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
            return
        }
        
        guard CTFontManagerRegisterFontsForURL(roundedBoldURL as CFURL, .process, &error) else {
            print("Error: Could not register SF-Compact-Rounded-Bold font: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
            return
        }
        
        print("Successfully registered custom fonts")
    }
    
    func customFont(size: CGFloat) -> Font {
        return .custom("SF Compact Text Medium", size: size)
    }
    
    func roundedSemiboldFont(size: CGFloat) -> Font {
        return .custom("SF Compact Rounded Semibold", size: size)
    }
    
    func roundedBoldFont(size: CGFloat) -> Font {
        return .custom("SF Compact Rounded Bold", size: size)
    }
} 