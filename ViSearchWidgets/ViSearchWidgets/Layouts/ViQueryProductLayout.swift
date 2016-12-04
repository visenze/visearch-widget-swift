//
//  ViQueryProductLayout.swift
//  ViSearchWidgets
//
//  Created by Hung on 24/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import LayoutKit
import Kingfisher

/// This is almost the same as product card
/// used for displaying the search query product i.e. the product that is being searched during "Find Similar"
/// the product info are displayed on the right of the image (for product card in search results, the info is displayed below image)
open class ViQueryProductLayout: StackLayout<UIView> {
    
    public static var default_spacing : CGFloat = 6.0
    
    /// constructor helper
    public convenience init(
        imgUrl: URL?, imageConfig: ViImageConfig,
        heading: String? , headingConfig: ViLabelConfig = ViLabelConfig(),
        label: String? = nil, labelConfig: ViLabelConfig = ViLabelConfig.default_label_config,
        price: Float?, priceConfig: ViLabelConfig = ViLabelConfig.default_price_config,
        discountPrice : Float?,
        discountPriceConfig: ViLabelConfig = ViLabelConfig.default_discount_price_config,
        pricesHorizontalSpacing: CGFloat = ViProductCardLayout.default_spacing,
        labelLeftPadding: CGFloat = ViProductCardLayout.default_spacing
        ){
        
        self.init(
            // image settings
            img_url: imgUrl,
            img_size: imageConfig.size,
            img_contentMode: imageConfig.contentMode,
            loading_img: imageConfig.loadingImg,
            err_img: imageConfig.errImg,
            
            // label
            label: label,
            label_font: labelConfig.font,
            label_text_color: labelConfig.textColor,
            label_num_of_lines: labelConfig.numOfLines,
            
            // heading
            heading: heading,
            heading_font: headingConfig.font,
            heading_text_color: headingConfig.textColor,
            heading_num_of_lines: headingConfig.numOfLines,
            
            // price
            price: price,
            price_font : priceConfig.font,
            price_text_color: priceConfig.textColor,
            price_string_format: priceConfig.numberStringFormat,
            price_strike_through: priceConfig.isStrikeThrough,
            
            // discount price
            discounted_price : discountPrice,
            discounted_price_font : discountPriceConfig.font,
            discounted_price_text_color: discountPriceConfig.textColor,
            discounted_price_string_format: discountPriceConfig.numberStringFormat,
            discounted_price_strike_through: discountPriceConfig.isStrikeThrough,
            
            // spacing
            prices_horizontal_spacing: pricesHorizontalSpacing,
            label_left_padding: labelLeftPadding
        )
    }
    
    
    /// Constructor for query product card
    ///
    /// - Parameters:
    ///   - img_url: product image url
    ///   - img_size: product image size
    ///   - img_contentMode: contentMode for ImageView
    ///   - loading_img: loading/placeholder image
    ///   - err_img: error image (when fail to download)
    ///   - label: label text e.g. to display product brand
    ///   - label_font: label font, default to Roboto Bold
    ///   - label_text_color: label text color, default to black
    ///   - label_num_of_lines: number of lines for label, default 1 line
    ///   - heading: heading text e.g. to display product name or title
    ///   - heading_font: heading font , default to Roboto Regular
    ///   - heading_text_color: heading text color, default to black
    ///   - heading_num_of_lines: number of lines for heading label, default 1 line
    ///   - price: product price
    ///   - price_font: product price font, default to Roboto Regular
    ///   - price_text_color: product price label text color, default to red color
    ///   - price_string_format: string format to display price, must include .f specifier e.g. %.2f
    ///   - price_strike_through: whether to strike through the price e.g. during discount, default to no
    ///   - discounted_price: discounted product price
    ///   - discounted_price_font: discounted price label font , default to Roboto Regular
    ///   - discounted_price_text_color: discounted price label text color , default to gray color and strike through
    ///   - discounted_price_string_format: string format to display discounted price, must include .f specifier e.g. %.2f
    ///   - discounted_price_strike_through: whether to strike through discounted price label, default to no
    ///   - prices_horizontal_spacing: spacing between price and discounted price label
    ///   - label_left_padding: padding of labels from parent left
    public init(
        // image settings
        img_url: URL?,
        img_size: CGSize,
        img_contentMode: UIViewContentMode = ViImageConfig.default_content_mode,
        loading_img: UIImage? = nil,
        err_img: UIImage? = nil,
        
        // label
        label: String? = nil,
        label_font: UIFont = ViTheme.sharedInstance.default_bold_font,
        label_text_color: UIColor = ViTheme.sharedInstance.default_txt_color,
        label_num_of_lines: Int = 1,
        
        // heading
        heading: String? = nil,
        heading_font: UIFont = ViTheme.sharedInstance.default_font,
        heading_text_color: UIColor = ViTheme.sharedInstance.default_txt_color,
        heading_num_of_lines: Int = 1,
        
        
        // price
        price: Float?,
        price_font : UIFont = ViTheme.sharedInstance.default_font,
        price_text_color: UIColor = ViTheme.sharedInstance.default_txt_color,
        price_string_format: String = ViTheme.sharedInstance.default_price_format,
        price_strike_through: Bool = false,
        
        // discount price
        discounted_price : Float?,
        discounted_price_font : UIFont = ViTheme.sharedInstance.default_font,
        discounted_price_text_color: UIColor = ViTheme.sharedInstance.default_discounted_price_text_color,
        discounted_price_string_format: String = ViTheme.sharedInstance.default_discount_price_format,
        discounted_price_strike_through: Bool = false,
        
        // spacing
        prices_horizontal_spacing: CGFloat = default_spacing,
        label_left_padding: CGFloat = default_spacing
        
        )
    {
        
        // all layout
        var layouts : [Layout] = []
        
        // contain all layout below the image
        var labelLayouts : [Layout] = []
        
        // for label and find similar button
        var labelAndSimilarBtnLayouts : [Layout] = []
        
        let productImg = ViProductCardLayout.createProductImageLayout(
            img_url: img_url, img_size: img_size,
            img_contentMode: img_contentMode,
            loading_img: loading_img, err_img: err_img ,
            
            has_action_btn: false,
            action_btn_icon: nil,
            action_btn_txt: "" ,
            action_btn_font: ViButtonConfig.default_action_btn_config.font,
            action_btn_size: ViButtonConfig.default_action_btn_config.size,
            action_btn_background_color: ViButtonConfig.default_action_btn_config.backgroundColor,
            action_btn_tint_color: ViButtonConfig.default_action_btn_config.tintColor
            
        )
        
        layouts.append(productImg)
        
        if let label = label {
            let labelEl = LabelLayout(text: label,
                                      font: label_font,
                                      numberOfLines: label_num_of_lines,
                                      alignment: .centerLeading ,
                                      viewReuseId: "prodLabel" ,
                                      config:  { (label: UILabel) in
                                        label.textColor = label_text_color
                                        label.tag = ViProductCardTag.labelTag.rawValue
            }
                
            )
            labelLayouts.append(labelEl)
        }
        
        
        if let heading = heading {
            let headingEl = LabelLayout(text: heading,
                                        font: heading_font,
                                        numberOfLines: heading_num_of_lines,
                                        viewReuseId: "headingLabel",
                                        config:  { (label: UILabel) in
                                            label.textColor = heading_text_color
                                            label.tag = ViProductCardTag.headingTag.rawValue
            }
                
            )
            labelLayouts.append(headingEl)
        }
        
        // price layouts , TODO: should give option to layout the labels from left or from right
        var priceLayouts : [Layout] = []
        
        if let price = price {
            
            let priceEl = ViProductCardLayout.createPriceLayout(price: price, price_font: price_font, price_text_color: price_text_color, price_string_format: price_string_format, price_strike_through: price_strike_through)
            priceLayouts.append(priceEl)
            
        }
        
        if let discounted_price = discounted_price {
            
            let discountPriceEl = ViProductCardLayout.createDiscountPriceLayout(discounted_price: discounted_price, discounted_price_font: discounted_price_font, discounted_price_text_color: discounted_price_text_color, discounted_price_string_format: discounted_price_string_format, discounted_price_strike_through: discounted_price_strike_through)
            priceLayouts.append(discountPriceEl)
            
        }
        
        let pricesStackLayout = StackLayout(
            axis: .horizontal,
            spacing: prices_horizontal_spacing,
            sublayouts: priceLayouts
        )
        labelLayouts.append(pricesStackLayout)
        
        if labelLayouts.count > 0 {
            labelAndSimilarBtnLayouts.append(StackLayout(
                axis: .vertical,
                spacing: 2,
                sublayouts: labelLayouts
            ))
        }
        
        if(labelAndSimilarBtnLayouts.count > 0) {
            let labelAndSimilarBtnLayoutsContainer = StackLayout(
                axis: .horizontal,
                spacing: 4,
                sublayouts: labelAndSimilarBtnLayouts
            )
            
            let insetLayout =  InsetLayout(
                insets: EdgeInsets(top: 2, left: label_left_padding, bottom: 4, right: label_left_padding),
                sublayout: labelAndSimilarBtnLayoutsContainer
            )
            layouts.append(insetLayout)
        }
        
        super.init(
            axis: .horizontal,
            spacing: 4,
            sublayouts: layouts
        )
        
    }
}
