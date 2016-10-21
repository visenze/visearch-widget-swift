import UIKit


// MARK: - extension for UIColor to generate hex string
extension UIColor {
    
    /// return hex string for UIColor in form of XXXXXX (6 characters without the #)
    ///
    /// - returns: 6 characters hex string
    public func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
    
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
