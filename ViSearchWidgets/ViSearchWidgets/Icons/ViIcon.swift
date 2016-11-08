//
//  ViIcon.swift
//  ViSearchWidgets
//
//  Created by Hung on 8/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

public struct ViIcon{
    /// An internal reference to the icons bundle.
    private static var internalBundle: Bundle?
    
    /**
     A public reference to the icons bundle, that aims to detect
     the correct bundle to use.
     */
    public static var bundle: Bundle {
        if nil == ViIcon.internalBundle {
            ViIcon.internalBundle = Bundle(for: ViFont.self)
            
            // for cocoa pods bundle handling
            let url = ViIcon.internalBundle!.resourceURL!
            let b = Bundle(url: url.appendingPathComponent("com.visenze.icons.bundle"))
            if let v = b {
                ViIcon.internalBundle = v
            }
        }
        return ViIcon.internalBundle!
    }
    
    /// Get the icon by the file name.
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    public static let find_similar = ViIcon.icon("find_similar")
    

}
