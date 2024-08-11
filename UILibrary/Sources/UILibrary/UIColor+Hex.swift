import SwiftUI

internal struct RGBRatio: Equatable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
}

internal enum HexMappingError: Error, Equatable {
    case noSharpSymbol
    case unableToMapHexCode
}

public extension UIColor {

    static func hex(_ hex: String) -> UIColor {
        guard let color = try? RGBRatio(hex) else {
            fatalError("Incorrect hex candidate \(hex)")
        }
        return UIColor(red: color.red, green: color.green, blue: color.blue, alpha: 1)
    }
}

extension RGBRatio {

    init(_ hex: String) throws {
        var colorString = hex.uppercased()
        guard colorString.remove(at: colorString.startIndex) == "#" else {
            throw HexMappingError.noSharpSymbol
        }
        guard colorString.allSatisfy(\.isHexDigit), colorString.count == 6 else {
            throw HexMappingError.unableToMapHexCode
        }
        var rgbValue: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)
        self = RGBRatio(
            red: CGFloat((rgbValue & 0xFF_0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0x00_FF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0x00_00FF)/255.0
        )
    }
}
