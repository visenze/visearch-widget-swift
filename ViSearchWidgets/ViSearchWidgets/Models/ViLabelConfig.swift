//
//  ViLabelConfig.swift
//  ViSearchWidgets
//
//  Created by Hung on 9/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Configuration for a label e.g. heading, label, price, discount price label
public struct ViLabelConfig {
    
    /// font for label
    public var font: UIFont
    
    /// text color
    public var textColor: UIColor
    
    /// number of lines
    public var numOfLines: Int = 1
    
    /// whether to strike trough the text e.g. to indicate original price before discount
    public var isStrikeThrough: Bool = false
    
    /// string format for formatting numbers such as price, discount price (Optional)
    public var numberStringFormat : String = ViTheme.sharedInstance.default_price_format
    
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - font: font to use. If not provided, will use default font in ViTheme
    ///   - text_color: text color. If not provided, use default text color in ViTheme
    ///   - num_of_lines: number of lines. Default to 1
    ///   - is_strike_through: whether to strike through the text
    ///   - numberStringFormat: number format for prices labels
    public init(font: UIFont = ViTheme.sharedInstance.default_font,
                text_color: UIColor = ViTheme.sharedInstance.default_txt_color ,
                num_of_lines: Int = 1,
                is_strike_through: Bool = false,
                numberStringFormat : String = ViTheme.sharedInstance.default_price_format
                ){
        self.font = font
        self.textColor = text_color
        self.numOfLines = num_of_lines
        self.isStrikeThrough = is_strike_through
    }
    
    /// default label config
    public static var default_label_config = ViLabelConfig(font: ViTheme.sharedInstance.default_bold_font)
    
    /// default heading config
    public static var default_heading_config = ViLabelConfig()
    
    // default config for price
    public static var default_price_config = ViLabelConfig(numberStringFormat: ViTheme.sharedInstance.default_price_format)
    
    // default config for discount price
    public static var default_discount_price_config = ViLabelConfig(
        text_color: ViTheme.sharedInstance.default_discounted_price_text_color,
        numberStringFormat: ViTheme.sharedInstance.default_discount_price_format)
    
    
}
