//
//  UIColors+Visenze.swift
//  ViSearchWidgets
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/**
 UIColor extension that add a whole bunch of utility functions like:
 - HTML/CSS RGB format conversion (i.e. 0x124672)
 - lighter color
 - darker color
 - color with modified brightness
 - color with hex string
 */
public extension UIColor {
 
    ///  Construct a UIColor using an HTML/CSS RGB formatted value and an alpha value
    ///
    /// - parameter rgbValue: rgb value
    /// - parameter alpha:    color alpha
    ///
    /// - returns: UIColor instance
    public class func colorWithRGB(rgbValue : UInt, alpha : CGFloat = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    /// Construct a UIColor by hex string. The hex string can start with # or without #
    ///
    /// - parameter hexString: 6 characters hexstring if without hash, or 7 characters with hash
    /// - parameter alpha:     alpha value
    ///
    /// - returns: UIColor
    public class func colorWithHexString(_ hexString: String, alpha: CGFloat) -> UIColor? {
    
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1))
        }
        
        guard let hexVal = Int(hex, radix: 16) else {
            print("Unable to create color. Invalid hex string: \(hexString)" )
            return nil
        }
        
        return UIColor.colorWithRGB(rgbValue: UInt(hexVal), alpha : alpha)
    }
    
    /// Returns a lighter color by the provided percentage
    ///
    /// - parameter percent: lighting percentage
    ///
    /// - returns: lighter UIColor
    public func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent))
    }
    
    /// Returns a darker color by the provided percentage
    ///
    /// - parameter percent: darker percentage
    ///
    /// - returns: darker UIColor
    public func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent))
    }
    
    /// Return a modified color using the brightness factor provided
    ///
    /// - parameter factor: brightness factor
    ///
    /// - returns: modified color
    public func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self
        }
    }
    
}
