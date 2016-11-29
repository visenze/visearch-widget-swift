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
    public static func icon(_ name: String, _ renderMode : UIImageRenderingMode = .alwaysTemplate) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(renderMode)
    }
    
    public static let find_similar = ViIcon.icon("find_similar")
    
    // TODO: change this image later
    public static let like = ViIcon.icon("heart")
    
    public static let power_visenze = ViIcon.icon("power_visenze", .alwaysOriginal)
    
    public static let back = ViIcon.icon("back_icon")
    
    public static let filter = ViIcon.icon("filter")
    
    public static let color_pick = ViIcon.icon("color_pick")
    
    public static let tick = ViIcon.icon("tick")
    
    // choose from gallery
    public static let gallery = ViIcon.icon("album" , .alwaysOriginal)
    
    public static let info = ViIcon.icon("info" , .alwaysOriginal)
    
    public static let lights = ViIcon.icon("lights" , .alwaysOriginal)
    public static let lights_sel = ViIcon.icon("lights" )
    
    
    public static let reverse = ViIcon.icon("reverse" , .alwaysOriginal)
   
    public static let crop = ViIcon.icon("crop")
    
    public static let camera = ViIcon.icon("camera")
   
    public static let big_camera = ViIcon.icon("big_camera" , .alwaysOriginal)
    public static let big_camera_empty = ViIcon.icon("big_camera_empty", .alwaysOriginal)
    
    // camera related icons
    public static let placeholder = ViIcon.icon("placeholder" , .alwaysOriginal)
    public static let permissionsIcon = ViIcon.icon("permissionsIcon" , .alwaysOriginal)
    
    
    
}
