//
//  ViFont.swift
//  ViSearchWidgets
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Font helper class. Load font bundle and check if the bundle is generated from Cocoa Pods
/// Default font used in all widgets are Roboto
/// For customization, refer to ViTheme method
public class ViFont: NSObject {
    
    /// Thin with size font. Will load custom font and fall back to system font if not available.
    ///
    /// - parameter size: font size
    ///
    /// - returns: UIFont
    public static func thin(with size: CGFloat) -> UIFont {
        ViFont.loadFontIfNeeded(name: "Roboto-Thin")
        
        if let f = UIFont(name: "Roboto-Thin", size: size) {
            return f
        }
        
        print("Unable to load thin custom font")
        
        // fallback
        return UIFont.systemFont(ofSize: size)
    }
    
    /// Light with size font. Will load custom font and fall back to system font if not available.
    ///
    /// - parameter size: font size
    ///
    /// - returns: UIFont
    public static func light(with size: CGFloat) -> UIFont {
        ViFont.loadFontIfNeeded(name: "Roboto-Light")
        
        if let f = UIFont(name: "Roboto-Light", size: size) {
            return f
        }
        
        print("Unable to load light custom font")
        
        
        // fall back to system font
        return UIFont.systemFont(ofSize: size)
    }
    
  
    ///  Regular with size font. Will load custom font and fall back to system font if not available.
    ///
    /// - parameter size: font size
    ///
    /// - returns: UIFont
    public static func regular(with size: CGFloat) -> UIFont {
        ViFont.loadFontIfNeeded(name: "Roboto-Regular")
        
        if let f = UIFont(name: "Roboto-Regular", size: size) {
            return f
        }
        
        print("Unable to load regular custom font")
        
        
        // fall back to system font
        return UIFont.systemFont(ofSize: size)
    }
    
  
    /// Medium with size font. Will load custom font and fall back to system font if not available.
    ///
    /// - parameter size: font size
    ///
    /// - returns: UIFont
    public static func medium(with size: CGFloat) -> UIFont {
        ViFont.loadFontIfNeeded(name: "Roboto-Medium")
        
        if let f = UIFont(name: "Roboto-Medium", size: size) {
            return f
        }
        
        print("Unable to load Medium custom font")
        
        
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    /// Bold with size font. Will load custom font and fall back to system font if not available.
    ///
    /// - parameter size: font size
    ///
    /// - returns: UIFont
    public static func bold(with size: CGFloat) -> UIFont {
        ViFont.loadFontIfNeeded(name: "Roboto-Bold")
        
        if let f = UIFont(name: "Roboto-Bold", size: size) {
            return f
        }
        
        print("Unable to load Bold custom font")
        
        
        return UIFont.boldSystemFont(ofSize: size)
    }

    

    /// Loads a given font if needed.
    ///
    /// - parameter name: font name
    public static func loadFontIfNeeded(name: String) {
        FontLoader.loadFontIfNeeded(name: name)
    }
    
}

/// Loads custom fonts
private class FontLoader {
    /// A Dictionary of the fonts already loaded.
    static var loadedFonts: Dictionary<String, String> = Dictionary<String, String>()
    
    static func loadFontIfNeeded(name: String) {
        let loadedFont: String? = FontLoader.loadedFonts[name]
        
        if nil == loadedFont && nil == UIFont(name: name, size: 1) {
            FontLoader.loadedFonts[name] = name
            
            let bundle = Bundle(for: FontLoader.self)
            let identifier = bundle.bundleIdentifier
            
            // if installed from Cocoa Pods, then need to do extra handling
            let fontURL = true == identifier?.hasPrefix("org.cocoapods") ? bundle.url(forResource: name, withExtension: "ttf", subdirectory: "com.visenze.fonts.bundle") : bundle.url(forResource: name, withExtension: "ttf")
            
            if let v = fontURL {
                let data = NSData(contentsOf: v as URL)!
                let provider = CGDataProvider(data: data)!
                let font = CGFont(provider)
                
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    let errorDescription = CFErrorCopyDescription(error!.takeUnretainedValue())
                    let nsError = error!.takeUnretainedValue() as Any as! Error
                    NSException(name: .internalInconsistencyException, reason: errorDescription as? String, userInfo: [NSUnderlyingErrorKey: nsError as Any]).raise()
                }
            }
        }
    }
}
