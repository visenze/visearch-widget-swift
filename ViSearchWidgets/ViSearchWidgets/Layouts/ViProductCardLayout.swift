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
    case findSimilarBtnTag
    case actionBtnTag
    
}


/// Layout for a single product card
open class ViProductCardLayout: StackLayout<UIView> {
    
    public static var default_spacing : CGFloat = 6.0
    
    public convenience init(
        imgUrl: URL?, imageConfig: ViImageConfig,
        heading: String? , headingConfig: ViLabelConfig = ViLabelConfig(),
        label: String? = nil, labelConfig: ViLabelConfig = ViLabelConfig.default_label_config,
        price: Float?, priceConfig: ViLabelConfig = ViLabelConfig.default_price_config,
        discountPrice : Float?,
        discountPriceConfig: ViLabelConfig = ViLabelConfig.default_discount_price_config,
        hasSimilarBtn: Bool = true,
        similarBtnConfig: ViButtonConfig = ViButtonConfig.default_similar_btn_config ,
        hasActionBtn: Bool = true,
        actionBtnConfig: ViButtonConfig = ViButtonConfig.default_action_btn_config ,
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
            
            // similar button configuration
            has_similar_btn: hasSimilarBtn,
            similar_btn_icon: similarBtnConfig.icon,
            similar_btn_txt : similarBtnConfig.text ,
            similar_btn_font: similarBtnConfig.font,
            similar_btn_size: similarBtnConfig.size,
            similar_btn_background_color: similarBtnConfig.backgroundColor,
            similar_btn_tint_color: similarBtnConfig.tintColor,
            
            // action button configuration
            has_action_btn: hasActionBtn,
            action_btn_icon: actionBtnConfig.icon,
            action_btn_txt: actionBtnConfig.text , // default to empty
            action_btn_font: actionBtnConfig.font,
            action_btn_size: actionBtnConfig.size,
            action_btn_background_color: actionBtnConfig.backgroundColor,
            action_btn_tint_color: actionBtnConfig.tintColor,

            
            // spacing
            prices_horizontal_spacing: pricesHorizontalSpacing,
            label_left_padding: labelLeftPadding
        )
    }
    
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
    ///   - has_similar_btn: whether to display similar button
    ///   - similar_btn_txt: text for similar button, default to empty
    ///   - similar_btn_icon: icon for similar button
    ///   - similar_btn_font: font for similar button title text
    ///   - similar_btn_size: size for similar button
    ///   - similar_btn_background_color: background color for similar button
    ///   - similar_btn_tint_color: tint color for similar button i.e. text color and image color
    ///   - has_action_btn: whether to display action button
    ///   - action_btn_txt: text for action button, default to empty
    ///   - action_btn_icon: icon for action button
    ///   - action_btn_font: font for action button title text
    ///   - action_btn_size: size for action button
    ///   - action_btn_background_color: background color for action button
    ///   - action_btn_tint_color: tint color for action button i.e. text color and image color
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
                    
                    // similar button configuration
                    has_similar_btn: Bool = true,
                    similar_btn_icon: UIImage? = ViButtonConfig.default_similar_btn_config.icon,
                    similar_btn_txt: String = ViButtonConfig.default_similar_btn_config.text , // default to empty
                    similar_btn_font: UIFont = ViButtonConfig.default_similar_btn_config.font,
                    similar_btn_size: CGSize = ViButtonConfig.default_similar_btn_config.size,
                    similar_btn_background_color: UIColor = ViButtonConfig.default_similar_btn_config.backgroundColor,
                    similar_btn_tint_color: UIColor = ViButtonConfig.default_similar_btn_config.tintColor,
                    
                    // action button configuration e.g. like icon
                    has_action_btn: Bool = true,
                    action_btn_icon: UIImage? = ViButtonConfig.default_action_btn_config.icon,
                    action_btn_txt: String =  ViButtonConfig.default_action_btn_config.text , // default to empty
                    action_btn_font: UIFont = ViButtonConfig.default_action_btn_config.font,
                    action_btn_size: CGSize = ViButtonConfig.default_action_btn_config.size,
                    action_btn_background_color: UIColor = ViButtonConfig.default_action_btn_config.backgroundColor,
                    action_btn_tint_color: UIColor = ViButtonConfig.default_action_btn_config.tintColor,
        
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
            
            has_action_btn: has_action_btn,
            action_btn_icon: action_btn_icon,
            action_btn_txt: action_btn_txt ,
            action_btn_font: action_btn_font,
            action_btn_size: action_btn_size,
            action_btn_background_color: action_btn_background_color,
            action_btn_tint_color: action_btn_tint_color

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
        
        // find similar
        if has_similar_btn {
            let findSimilarBtnLayout =
                SizeLayout<UIButton>(
                    width: similar_btn_size.width, height: similar_btn_size.height,
                    alignment: .topTrailing,
                    flexibility: .inflexible,
                    // prevent recycling of buttons , will cause problem if set when scrolling in collectionview
                    viewReuseId: nil,
                    config: { button in
                        button.backgroundColor = similar_btn_background_color
                        
                        button.setTitle(similar_btn_txt, for: .normal)
                        button.setTitle(similar_btn_txt, for: .highlighted)
                        
                        button.titleLabel?.font = similar_btn_font
                        
                        button.setTitleColor(similar_btn_tint_color, for: .normal)
                        button.setTitleColor(similar_btn_tint_color, for: .highlighted)
                        
                        button.setImage(similar_btn_icon, for: .normal)
                        button.setImage(similar_btn_icon, for: .highlighted)
                        
                        button.tintColor = similar_btn_tint_color
                        button.imageEdgeInsets = UIEdgeInsetsMake( 0, 4, 0, 4)
                        button.tag = ViProductCardTag.findSimilarBtnTag.rawValue
                        
                }
            )
            labelAndSimilarBtnLayouts.append(findSimilarBtnLayout)
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
            axis: .vertical,
            spacing: 2,
            sublayouts: layouts
        )
        
    }
    
    
    // MARK : create layouts helpers
    private static func createPriceLayout(
        price: Float,
        price_font : UIFont ,
        price_text_color: UIColor ,
        price_string_format: String ,
        price_strike_through: Bool
    ) -> LabelLayout<UILabel>
    {
        if price_strike_through {
            let attributedText = NSAttributedString(string: String(format: price_string_format, price) ,
                                                    attributes: [
                                                        NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSStrikethroughColorAttributeName: price_text_color]
            )
            
            return LabelLayout(attributedText: attributedText,
                                      font: price_font,
                                      numberOfLines: 1,
                                      viewReuseId: "priceLabel",
                                      config:  { (label: UILabel) in
                                        label.textColor = price_text_color
                                        label.tag = ViProductCardTag.priceTag.rawValue
                                      }
            )
            

        }
        else {
            return LabelLayout(text: String(format: price_string_format, price),
                                      font: price_font,
                                      numberOfLines: 1,
                                      viewReuseId: "priceLabel",
                                      config:  { (label: UILabel) in
                                        label.textColor = price_text_color
                                        label.tag = ViProductCardTag.priceTag.rawValue
                                      }
            )
            
        }
    }
    
    private static func createDiscountPriceLayout(
       discounted_price : Float,
       discounted_price_font : UIFont ,
       discounted_price_text_color: UIColor ,
       discounted_price_string_format: String ,
       discounted_price_strike_through: Bool ) -> LabelLayout<UILabel>{
        
        if discounted_price_strike_through {
            // strike through style
            let attributedText = NSAttributedString(string: String(format: discounted_price_string_format, discounted_price) ,
                                                    attributes: [
                                                        NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSStrikethroughColorAttributeName: discounted_price_text_color]
            )
            
            
            return LabelLayout(   attributedText: attributedText,
                                  font: discounted_price_font,
                                  numberOfLines: 1,
                                  viewReuseId: "discountedPriceLabel",
                                  config: { (label: UILabel) in
                                    label.textColor = discounted_price_text_color
                                    label.tag = ViProductCardTag.discountPriceTag.rawValue
                                  }
            )
            
        }
        else {
            return LabelLayout(   text: String(format: discounted_price_string_format, discounted_price),
                                  font: discounted_price_font,
                                  numberOfLines: 1,
                                  viewReuseId: "discountedPriceLabel",
                                  config: { (label: UILabel) in
                                    label.textColor = discounted_price_text_color
                                    label.tag = ViProductCardTag.discountPriceTag.rawValue
                                  }
            )
            
        }
    }
    
    
    private static func createProductImageLayout(
          img_url: URL?,
          img_size: CGSize,
          img_contentMode: UIViewContentMode,
          loading_img: UIImage? ,
          err_img: UIImage?,
          
            // action button configuration e.g. like icon
            has_action_btn: Bool = true,
            action_btn_icon: UIImage? = ViIcon.like,
            action_btn_txt: String = "" , // default to empty
            action_btn_font: UIFont = ViTheme.sharedInstance.default_btn_font,
            action_btn_size: CGSize = ViTheme.sharedInstance.default_btn_size,
            action_btn_background_color: UIColor = ViTheme.sharedInstance.default_action_btn_background_color,
            action_btn_tint_color: UIColor = ViTheme.sharedInstance.default_txt_color
        
        
        )
        -> SizeLayout<ViImageView>{
            
            
        
        return SizeLayout<ViImageView>(
            size: img_size,
            viewReuseId: nil,
            
            config: { viImageView in
                viImageView.tag = ViProductCardTag.productImgTag.rawValue
                
                if let imageView = viImageView.imageView {
                    
                    imageView.contentMode = img_contentMode
                    
                    // TODO: configure animation effect for loading image, e.g. fading when load
                    if let img_url = img_url {
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
                    imageView.clipsToBounds = true
                    
                    // configure the action btn
                    if has_action_btn {
                        if let button = viImageView.actionBtn {
                            button.isHidden = false
                            viImageView.actionBtnSize = action_btn_size
                            button.backgroundColor = action_btn_background_color
                            
                            button.setTitle(action_btn_txt, for: .normal)
                            button.setTitle(action_btn_txt, for: .highlighted)
                            
                            button.titleLabel?.font = action_btn_font
                            
                            button.setTitleColor(action_btn_tint_color, for: .normal)
                            button.setTitleColor(action_btn_tint_color, for: .highlighted)
                            
                            button.setImage(action_btn_icon, for: .normal)
                            button.setImage(action_btn_icon, for: .highlighted)
                            
                            button.tintColor = action_btn_tint_color
                            button.imageEdgeInsets = UIEdgeInsetsMake( 0, 4, 0, 4)
                            button.tag = ViProductCardTag.actionBtnTag.rawValue
                            
                        }
                    }
                    else {
                        viImageView.actionBtn?.isHidden = true
                    }
                }
                
            }
        )
    }
}
