//
//  ViButtonConfig.swift
//  ViSearchWidgets
//
//  Created by Hung on 9/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Configuration for buttons e.g. Find Similar, Action, etc
public struct ViButtonConfig {

    /// optional button text
    public var text: String = ""
    
    /// font for button title label
    public var font: UIFont
    
    /// will be used for text and tint color
    public var tintColor: UIColor
    
    /// button image size
    public var size: CGSize

    /// button background color
    public var backgroundColor: UIColor
    
    /// button image
    public var icon : UIImage?
    
    /// action to record for this button. The event will be recorded for analytics reporting tool
    /// action example: click, add_to_cart , add_to_wishlist
    public var actionToRecord : String? = nil
    
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - text: button text
    ///   - font: button font
    ///   - tint_color: button tint color
    ///   - size: button size
    ///   - backgroundColor: button background color
    ///   - icon: button icon
    ///   - action_to_record: action to record for ViSenze tracking analytics e.g. for measuring CTR when user triggers an action after search
    public init(text : String = "",
                font: UIFont = ViTheme.sharedInstance.default_font,
                tint_color: UIColor = ViTheme.sharedInstance.default_btn_tint_color,
                size: CGSize = ViTheme.sharedInstance.default_btn_size,
                backgroundColor: UIColor = ViTheme.sharedInstance.default_btn_background_color,
                icon: UIImage? = nil,
                action_to_record: String? = nil
        )
    {
        self.text = text
        self.font = font
        self.tintColor = tint_color
        self.size = size
        self.backgroundColor = backgroundColor
        self.icon = icon
        self.actionToRecord = action_to_record
    }
    
    /// default button configuration
    public static var default_btn_config = ViButtonConfig()
    
    /// default configuration for "Find Similar" button
    public static var default_similar_btn_config = ViButtonConfig(size: ViTheme.sharedInstance.default_similar_btn_size, icon: ViIcon.find_similar)
    
    /// default configuration for action button. Default to heart icon with tracked action set to add to wish list
    public static var default_action_btn_config = ViButtonConfig(
        tint_color: ViTheme.sharedInstance.default_action_btn_tint_color,
        size: ViTheme.sharedInstance.default_action_btn_size ,
        backgroundColor: ViTheme.sharedInstance.default_action_btn_background_color,
        icon: ViIcon.like , action_to_record: ViDefaultTrackingAction.ADD_TO_WISHLIST.rawValue )
}
