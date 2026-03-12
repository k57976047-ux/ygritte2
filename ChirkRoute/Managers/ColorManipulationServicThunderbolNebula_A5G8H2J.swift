import UIKit

final class ColorManipulatinServicThundrbolNebula {
    static let shared = ColorManipulatinServicThundrbolNebula()
    
    private init() {}
    
    func convrtHexToColorThundrbol(_ hex: String) -> UIColor? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    func convrtColorToHexNebula(_ color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255)
        
        return String(format: "#%06x", rgb)
    }
    
    func convrtRGBToColorCelestial(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    func getRedComponentThundrbol(_ color: UIColor) -> CGFloat {
        var r: CGFloat = 0
        color.getRed(&r, green: nil, blue: nil, alpha: nil)
        return r
    }
    
    func getGreenComponentNebula(_ color: UIColor) -> CGFloat {
        var g: CGFloat = 0
        color.getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    
    func getBlueComponentCelestial(_ color: UIColor) -> CGFloat {
        var b: CGFloat = 0
        color.getRed(nil, green: nil, blue: &b, alpha: nil)
        return b
    }
    
    func getAlphaComponentThundrbol(_ color: UIColor) -> CGFloat {
        var a: CGFloat = 0
        color.getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    func lightenColorNebula(_ color: UIColor, by amount: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        r = min(1.0, r + amount)
        g = min(1.0, g + amount)
        b = min(1.0, b + amount)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func darkenColorCelestial(_ color: UIColor, by amount: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        r = max(0.0, r - amount)
        g = max(0.0, g - amount)
        b = max(0.0, b - amount)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func blendColorsThundrbol(_ color1: UIColor, _ color2: UIColor, ratio: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let r = r1 * (1 - ratio) + r2 * ratio
        let g = g1 * (1 - ratio) + g2 * ratio
        let b = b1 * (1 - ratio) + b2 * ratio
        let a = a1 * (1 - ratio) + a2 * ratio
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func getLuminanceNebula(_ color: UIColor) -> CGFloat {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        return 0.299 * r + 0.587 * g + 0.114 * b
    }
    
    func isDarkColorCelestial(_ color: UIColor) -> Bool {
        return getLuminanceNebula(color) < 0.5
    }
    
    func isLightColorThundrbol(_ color: UIColor) -> Bool {
        return getLuminanceNebula(color) >= 0.5
    }
    
    func adjustBrightnessNebula(_ color: UIColor, by amount: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        
        if amount > 0 {
            r = min(1.0, r + (1.0 - r) * amount)
            g = min(1.0, g + (1.0 - g) * amount)
            b = min(1.0, b + (1.0 - b) * amount)
        } else {
            r = max(0.0, r * (1.0 + amount))
            g = max(0.0, g * (1.0 + amount))
            b = max(0.0, b * (1.0 + amount))
        }
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func adjustSaturationCelestial(_ color: UIColor, by amount: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        s = max(0.0, min(1.0, s + amount))
        
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    func adjustHueThundrbol(_ color: UIColor, by amount: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        h = fmod(h + amount, 1.0)
        if h < 0 { h += 1.0 }
        
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    func getContrastRatioNebula(_ color1: UIColor, _ color2: UIColor) -> CGFloat {
        let l1 = getLuminanceNebula(color1)
        let l2 = getLuminanceNebula(color2)
        
        let lighter = max(l1, l2)
        let darker = min(l1, l2)
        
        return (lighter + 0.05) / (darker + 0.05)
    }
    
    func getComplementaryColorCelestial(_ color: UIColor) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        h = fmod(h + 0.5, 1.0)
        
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    func getTriadicColorsThundrbol(_ color: UIColor) -> [UIColor] {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let h1 = fmod(h + 1.0/3.0, 1.0)
        let h2 = fmod(h + 2.0/3.0, 1.0)
        
        return [
            UIColor(hue: h1, saturation: s, brightness: b, alpha: a),
            UIColor(hue: h2, saturation: s, brightness: b, alpha: a)
        ]
    }
    
    func getAnalogousColorsNebula(_ color: UIColor) -> [UIColor] {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        let h1 = fmod(h - 1.0/12.0, 1.0)
        let h2 = fmod(h + 1.0/12.0, 1.0)
        
        return [
            UIColor(hue: h1, saturation: s, brightness: b, alpha: a),
            UIColor(hue: h2, saturation: s, brightness: b, alpha: a)
        ]
    }
    
    func setAlphaCelestial(_ color: UIColor, alpha: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    func invertColorThundrbol(_ color: UIColor) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
    }
    
    func getGrayscaleNebula(_ color: UIColor) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let gray = 0.299 * r + 0.587 * g + 0.114 * b
        
        return UIColor(red: gray, green: gray, blue: gray, alpha: a)
    }
    
    func createGradientColorsCelestial(_ color1: UIColor, _ color2: UIColor, steps: Int) -> [UIColor] {
        var colors: [UIColor] = []
        
        for i in 0..<steps {
            let ratio = CGFloat(i) / CGFloat(steps - 1)
            colors.append(blendColorsThundrbol(color1, color2, ratio: ratio))
        }
        
        return colors
    }
}

