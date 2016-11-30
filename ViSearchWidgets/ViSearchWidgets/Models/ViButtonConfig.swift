//
//  ViButtonConfig.swift
//  ViSearchWidgets
//
//  Created by Hung on 9/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// our image button config e.g. find similar where icon is on the left
public struct ViButtonConfig {

    /// button text on the right
    public var text: String = ""
    
    /// font for label
    public var font: UIFont
    
    /// will be used for text and tint color
    public var tintColor: UIColor
    
    /// image size
    public var size: CGSize

    /// background color
    public var backgroundColor: UIColor
    
    public var icon : UIImage?
    
    /// action to record for this button. The event will be recorded for analytics reporting tool
    /// action example: click, add_to_cart , add_to_wishlist
    public var actionToRecord : String? = nil
    
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
    
    public static var default_btn_config = ViButtonConfig()
    public static var default_similar_btn_config = ViButtonConfig(icon: ViIcon.find_similar)
    public static var default_action_btn_config = ViButtonConfig(
        tint_color: ViTheme.sharedInstance.default_action_btn_tint_color,
        size: ViTheme.sharedInstance.default_action_btn_size ,
        backgroundColor: ViTheme.sharedInstance.default_action_btn_background_color,
        icon: ViIcon.like , action_to_record: ViDefaultTrackingAction.ADD_TO_WISHLIST.rawValue )
}
