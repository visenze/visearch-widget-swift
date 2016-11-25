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
    
    public init(text : String = "",
                font: UIFont = ViTheme.sharedInstance.default_font,
                tint_color: UIColor = ViTheme.sharedInstance.default_btn_tint_color,
                size: CGSize = ViTheme.sharedInstance.default_btn_size,
                backgroundColor: UIColor = ViTheme.sharedInstance.default_btn_background_color,
                icon: UIImage? = nil
        )
    {
        self.text = text
        self.font = font
        self.tintColor = tint_color
        self.size = size
        self.backgroundColor = backgroundColor
        self.icon = icon
    }
    
    public static var default_btn_config = ViButtonConfig()
    public static var default_similar_btn_config = ViButtonConfig(icon: ViIcon.find_similar)
    public static var default_action_btn_config = ViButtonConfig(tint_color: ViTheme.sharedInstance.default_action_btn_tint_color,backgroundColor: ViTheme.sharedInstance.default_action_btn_background_color, icon: ViIcon.like)
}
