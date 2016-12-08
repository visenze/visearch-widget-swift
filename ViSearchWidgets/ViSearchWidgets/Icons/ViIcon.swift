//
//  ViIcon.swift
//  ViSearchWidgets
//
//  Created by Hung on 8/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Helper to load icons. As icons might be loaded differently from CocoaPods or from embedded sources
/// This is simplify the process
public struct ViIcon{
    
    /// An internal reference to the icons bundle.
    private static var internalBundle: Bundle?
    
    /**
     A public reference to the icons bundle, that aims to detect
     the correct bundle to use i.e. whether loading from Cocoa Pods bundle
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
    
    /// Get the icon by the image name.
    ///
    /// - Parameters:
    ///   - name: icon image name
    ///   - renderMode: render mode
    /// - Returns: UIImage
    public static func icon(_ name: String, _ renderMode : UIImageRenderingMode = .alwaysTemplate) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(renderMode)
    }
    
    /// Find Similar icon
    public static let find_similar = ViIcon.icon("find_similar")
    
    /// Heart icon. Represent default action i.e. add to wishlist
    public static let like = ViIcon.icon("heart")
    
    /// Power by Visenze logo
    public static let power_visenze = ViIcon.icon("power_visenze", .alwaysOriginal)
    
    /// Back icon
    public static let back = ViIcon.icon("back_icon")
    
    /// Filter icon
    public static let filter = ViIcon.icon("filter")
    
    /// Color Picker icon . Used in Color Search widget
    public static let color_pick = ViIcon.icon("color_pick")
    
    /// Tick icon. Used in color picker to indicate current selected color
    public static let tick = ViIcon.icon("tick")
    
    /// image for no result
    public static let no_result = ViIcon.icon("no_result" )
    
    /// image for generice error
    public static let generic_err = ViIcon.icon("generic_err" , .alwaysOriginal )
    
    // Choose from photo library icon
    public static let gallery = ViIcon.icon("album" , .alwaysOriginal)
    
    /// Info icon. Used for taking photo user guide when using camera
    public static let info = ViIcon.icon("info" , .alwaysOriginal)
    
    /// Lights icon to indicate flash on/off
    public static let lights = ViIcon.icon("lights" , .alwaysOriginal)
    
    /// Lights icon to indicate flash on. Tintable
    public static let lights_sel = ViIcon.icon("lights" )
    
    /// For switching between back and front camera icon
    public static let reverse = ViIcon.icon("reverse" , .alwaysOriginal)
   
    /// Crop icon
    public static let crop = ViIcon.icon("crop")
    
    /// Camera icon. Inititate camera view
    public static let camera = ViIcon.icon("camera")
   
    /// Big button for taking photo in camera view
    public static let big_camera = ViIcon.icon("big_camera" , .alwaysOriginal)
    
    /// Empty circle button i.e. as OK button to indicate action will be performed
    public static let big_camera_empty = ViIcon.icon("big_camera_empty", .alwaysOriginal)
    
    // placeholder image when loading photos from photo library
    public static let placeholder = ViIcon.icon("placeholder" , .alwaysOriginal)
    
    /// Permission denied icon when trying to access camera / photo library
    public static let permissionsIcon = ViIcon.icon("permissionsIcon" , .alwaysOriginal)
    
}
