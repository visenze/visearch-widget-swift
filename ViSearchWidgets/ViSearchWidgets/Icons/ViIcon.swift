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
    public static let gallery = ViIcon.icon("album")
    
    public static let info = ViIcon.icon("info")
    
    public static let lights = ViIcon.icon("lights")
    
    public static let reverse = ViIcon.icon("reverse")
   
    public static let crop = ViIcon.icon("crop")
    
    public static let camera = ViIcon.icon("camera")
   
    public static let big_camera = ViIcon.icon("big_camera")
    
    // camera related icons
    public static let placeholder = ViIcon.icon("placeholder" , .alwaysOriginal)
    public static let cameraButton = ViIcon.icon("cameraButton" , .alwaysOriginal)
    public static let cameraButtonHighlighted = ViIcon.icon("cameraButtonHighlighted" , .alwaysOriginal)
    public static let closeButton = ViIcon.icon("closeButton" , .alwaysOriginal)
    public static let swapButton = ViIcon.icon("swapButton" , .alwaysOriginal)
    public static let libraryButton = ViIcon.icon("libraryButton" , .alwaysOriginal)
    public static let flashAutoIcon = ViIcon.icon("flashAutoIcon" , .alwaysOriginal)
    public static let flashOnIcon = ViIcon.icon("flashOnIcon" , .alwaysOriginal)
    public static let flashOffIcon = ViIcon.icon("flashOffIcon" , .alwaysOriginal)
    public static let retakeButton = ViIcon.icon("retakeButton" , .alwaysOriginal)
    public static let permissionsIcon = ViIcon.icon("permissionsIcon" , .alwaysOriginal)
    public static let libraryCancel = ViIcon.icon("libraryCancel" , .alwaysOriginal)
    public static let confirmButton = ViIcon.icon("confirmBtn" , .alwaysOriginal)
    
    
    
    public static func getFlashIcon(name: String) -> UIImage? {
        if name == "flashOnIcon" {
            return ViIcon.flashOnIcon
        }
        if name == "flashOffIcon" {
            return ViIcon.flashOffIcon
        }
        
        return ViIcon.flashAutoIcon
        
    }
    
    
    
}
