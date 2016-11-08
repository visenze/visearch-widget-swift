//
//  ViProductCardLayout.swift
//  ViSearchWidgets
//
//  Created by Hung on 7/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import LayoutKit
import Kingfisher


/// Subviews tags enum. This is to make it easier to find views created by the product card layout
///
/// - productImgTag: tag for product image
/// - labelTag: tag for label
/// - headingTag: tag for heading label
/// - priceTag: tag for price
/// - discountPriceTag: tag for discount price
public enum ViProductCardTag : Int {
    
    case productImgTag
    case labelTag
    case headingTag
    case priceTag
    case discountPriceTag
    
}

open class ViProductCardLayout: StackLayout<UIView> {
    
    /// default regular font
    open static var default_font : UIFont = ViFont.regular(with: 16.0)
    
    /// default bold font
    open static var default_bold_font    : UIFont = ViFont.medium(with: 16.0)
    
    /// default string format for discounted price
    open static var default_discount_price_format : String = "Now $%.2f"
    
    /// default string format for price
    open static var default_price_format : String = "$%.2f"
    
    
    
    /// Constructor for productCard
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
                    img_url: URL,
                    img_size: CGSize,
                    img_contentMode: UIViewContentMode = .scaleToFill,
                    loading_img: UIImage? = nil,
                    err_img: UIImage? = nil,
                    
                    // label
                    label: String? = nil,
                    label_font: UIFont = default_bold_font,
                    label_text_color: UIColor = UIColor.black,
                    label_num_of_lines: Int = 1,
                    
                    // heading
                    heading: String,
                    heading_font: UIFont = default_font,
                    heading_text_color: UIColor = UIColor.black,
                    heading_num_of_lines: Int = 1,
                    
                    
                    // price
                    price: Float?,
                    price_font : UIFont = default_font,
                    price_text_color: UIColor = UIColor.black,
                    price_string_format: String = default_price_format,
                    price_strike_through: Bool = false,
                    
                    // discount price
                    discounted_price : Float?,
                    discounted_price_font : UIFont = default_font,
                    discounted_price_text_color: UIColor = UIColor.red,
                    discounted_price_string_format: String = default_discount_price_format,
                    discounted_price_strike_through: Bool = false,
                    
                    
                    prices_horizontal_spacing: CGFloat = 16.0,
                    label_left_padding: CGFloat = 8.0
                    
        )
    {
        
        // all layout
        var layouts : [Layout] = []
        
        // contain all layout below the image
        var labelLayouts : [Layout] = []
        
        let productImg = SizeLayout<UIImageView>(
            size: img_size,
            viewReuseId: "prodImg",
        
            config: { imageView in

                imageView.tag = ViProductCardTag.productImgTag.rawValue
                imageView.contentMode = img_contentMode
                imageView.kf.setImage(with: img_url, placeholder: loading_img , completionHandler: {
                    (image, error, cacheType, imageUrl) in
                    
                    // image: Image? `nil` means failed
                    // error: NSError? non-`nil` means failed
                    if (image == nil || (error != nil) ) {
                        if let err_img = err_img {
                            imageView.image = err_img
                        }
                       
                    }
                })

            }
        )
        layouts.append(productImg)
        
        if let label = label {
            let labelEl = LabelLayout(text: label,
                                      font: label_font,
                                      numberOfLines: label_num_of_lines,
                                      viewReuseId: "prodLabel" ,
                                      config:  { (label: UILabel) in
                                        label.textColor = label_text_color
                                        label.tag = ViProductCardTag.labelTag.rawValue
                                      }
                
            )
            labelLayouts.append(labelEl)
        }
        
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
        
        // price layouts , TODO: should give option to layout the labels from left or from right
        var priceLayouts : [Layout] = []
        
        if let price = price {
            
            if price_strike_through {
                let attributedText = NSAttributedString(string: String(format: price_string_format, price) ,
                                                        attributes: [
                                                            NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSStrikethroughColorAttributeName: price_text_color]
                )
                
                let priceEl = LabelLayout(attributedText: attributedText,
                                          font: price_font,
                                          numberOfLines: 1,
                                          viewReuseId: "priceLabel",
                                          config:  { (label: UILabel) in
                                            label.textColor = price_text_color
                                            label.tag = ViProductCardTag.priceTag.rawValue
                }
                )
                
                priceLayouts.append(priceEl)
            }
            else {
                let priceEl = LabelLayout(text: String(format: price_string_format, price),
                                          font: price_font,
                                          numberOfLines: 1,
                                          viewReuseId: "priceLabel",
                                          config:  { (label: UILabel) in
                                            label.textColor = price_text_color
                                            label.tag = ViProductCardTag.priceTag.rawValue
                }
                )
                
                priceLayouts.append(priceEl)
            }
        }
        
        if let discounted_price = discounted_price {
            
            if discounted_price_strike_through {
                // strike through style
                let attributedText = NSAttributedString(string: String(format: discounted_price_string_format, discounted_price) ,
                                                        attributes: [
                                                            NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSStrikethroughColorAttributeName: discounted_price_text_color]
                )

                
                let priceEl = LabelLayout(attributedText: attributedText,
                                          font: discounted_price_font,
                                          numberOfLines: 1,
                                          viewReuseId: "discountedPriceLabel",
                                          config: { (label: UILabel) in
                                            label.textColor = discounted_price_text_color
                                            label.tag = ViProductCardTag.discountPriceTag.rawValue
                                          }
                )
                priceLayouts.append(priceEl)
            }
            else {
                let priceEl = LabelLayout(text: String(format: discounted_price_string_format, discounted_price),
                                          font: discounted_price_font,
                                          numberOfLines: 1,
                                          viewReuseId: "discountedPriceLabel",
                                          config: { (label: UILabel) in
                                            label.textColor = discounted_price_text_color
                                            label.tag = ViProductCardTag.discountPriceTag.rawValue
                                          }
                )
                priceLayouts.append(priceEl)
            }
        }
        
        
        
        let pricesStackLayout = StackLayout(
            axis: .horizontal,
            spacing: prices_horizontal_spacing,
            sublayouts: priceLayouts
        )
        labelLayouts.append(pricesStackLayout)
        
        let insetLayout =  InsetLayout(
            insets: EdgeInsets(top: 4, left: label_left_padding, bottom: 4, right: label_left_padding),
            sublayout: StackLayout(
                axis: .vertical,
                spacing: 0,
                sublayouts: labelLayouts
            )
        )
        layouts.append(insetLayout)

        super.init(
            axis: .vertical,
            spacing: 4,
            sublayouts: layouts
        )
        
    }
}
