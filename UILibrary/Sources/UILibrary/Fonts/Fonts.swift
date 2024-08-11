import SwiftUI

private enum NunitoSans: String, CaseIterable {
    case regular = "NunitoSans-Regular"
    case semiBold = "NunitoSans-SemiBold"
}

public extension Font {
    static let heading1 = Font.custom(NunitoSans.regular.rawValue, size: 20)
    
    static let body1 = Font.custom(NunitoSans.regular.rawValue, size: 16)
    static let body2 = Font.custom(NunitoSans.regular.rawValue, size: 18)
    static let body3 = Font.custom(NunitoSans.regular.rawValue, size: 14)
    static let body4 = Font.custom(NunitoSans.regular.rawValue, size: 12)
    
    static let button1 = Font.custom(NunitoSans.semiBold.rawValue, size: 18)
    static let button2 = Font.custom(NunitoSans.semiBold.rawValue, size: 16)
}

public extension Font {
    
    static func registerFonts() {
        NunitoSans.allCases
            .map(\.rawValue)
            .forEach(registerFont)
    }
    
    private static func registerFont(fontName: String) {
        guard
            let fontURL = Bundle.module.url(forResource: fontName, withExtension: "ttf"),
            let fontDataProvider = CGDataProvider (url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
            fatalError ("Couldn't create font from filename: \(fontName)")
        }
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
