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

    /// font for label
    public var font: UIFont
    
    /// text color , will be used for text and tint color
    public var textColor: UIColor
    
    /// image size
    public var size: CGSize

    /// background color
    public var backgroundColor: UIColor
    
    public init(font: UIFont = ViTheme.sharedInstance.default_font,
                text_color: UIColor = ViTheme.sharedInstance.default_txt_color,
                size: CGSize = ViTheme.sharedInstance.default_btn_size,
                backgroundColor: UIColor = ViTheme.sharedInstance.default_btn_background_color
        )
    {
        self.font = font;
        self.textColor = text_color
        self.size = size
        self.backgroundColor = backgroundColor
    }
    
    public static var default_btn_config = ViButtonConfig()

}
