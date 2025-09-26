import Foundation
import SwiftUI

enum CustomFonts: String {
    case lato = "Merriweather_120pt-ExtraBold"
    case openSans = "Merriweather_120pt-Regular"
    case oswald = "Merriweather_120pt-SemiBold"
    case roboto = "Roboto"
    case tiltPrism = "TiltPrism"
}

enum CustomFontStyle: String {
    case bold = "-Bold"
    case light = "-Light"
    case medium = "-Medium"
    case regular = "-Regular"
    case semiBold = "-SemiBold"
    case thin = "-Thin"
}

enum CustomFontSize: CGFloat {
    case h0 = 36.0
    case h1 = 32.0
    case h2 = 25.0
    case h3 = 16.0
    case h4 = 8.0
}

extension Font {
    static func customFont(
        font: CustomFonts,
        style: CustomFontStyle,
        size: CustomFontSize,
        isScaled: Bool = true) -> Font {
            
            let fontName: String = font.rawValue + style.rawValue
            
            return Font.custom(fontName, size: size.rawValue)
        }
}
