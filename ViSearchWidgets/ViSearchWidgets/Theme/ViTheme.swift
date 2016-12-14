//
//  ViTheme.swift
//  ViSearchWidgets
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Theme for ViSenze widgets
/// quick and easy way to configure various UI settings such as font/color in all the widgets
public class ViTheme: NSObject {

    /// default regular font, used for 'heading' , 'price' labels in product card
    public var default_font : UIFont = ViFont.regular(with: 11.0)
    
    /// default bold font. Used as default for 'label' in product card
    public var default_bold_font : UIFont = ViFont.medium(with: 11.0)
    
    /// Font for a filter row title e.g. "Category" , "Brand"
    public var default_filter_row_title_font : UIFont = ViFont.medium(with: 16.0)
    
    /// Font for a filter row description e.g. selected categories, selected brands, selected prices in range
    public var default_filter_row_desc_font : UIFont = ViFont.regular(with: 14.0)
    
    /// Selected color for range filter i.e. the color between selected lower and upper numbers e.g lower/upper prices
    public var default_filter_track_color : UIColor = UIColor.colorWithHexString("#B66C6C", alpha: 1.0)!
    
    /// default color for search error messages
    public var default_err_msg_tint_color : UIColor = UIColor.colorWithHexString("#B66C6C", alpha: 1.0)!
    
    /// default color for image in error messages
    public var default_err_msg_img_tint_color : UIColor = UIColor.colorWithHexString("#EB9689", alpha: 1.0)!
    
    
    /// default font for widget title
    public var default_widget_title_font : UIFont = ViFont.medium(with: 16.0)
    
    /// default string format for discounted price
    public var default_discount_price_format : String = "Now $%.2f"
    
    /// default string format for price
    public var default_price_format : String = "$%.2f"
    
    /// default font for find similar button
    public var default_btn_font : UIFont = ViFont.regular(with: 11.0)
    
    /// default text color
    public var default_txt_color: UIColor = UIColor.black
    
    /// default color for discounted price label
    public var default_discounted_price_text_color : UIColor = UIColor.red
    
    /// default text color
    public var default_btn_tint_color: UIColor = UIColor.colorWithHexString("#777777", alpha: 1.0)!
    
    /// default button background color e.g. Find Similar button
    public var default_btn_background_color: UIColor = UIColor.colorWithHexString("#F2F0F0", alpha: 1.0)!
    
    /// background color for filter button
    public var filter_btn_background_color: UIColor = UIColor.colorWithHexString("#999898", alpha: 1.0)!
    
    public var filter_btn_floating_background_color: UIColor = UIColor.colorWithHexString("#000000", alpha: 0.7)!
    
    /// tint color for filter button
    public var filter_btn_tint_color: UIColor = UIColor.white
    
    /// background color for color picker button
    public var color_pick_btn_background_color: UIColor = UIColor.colorWithHexString("#999898", alpha: 1.0)!
    
    /// tint color for color picker button
    public var color_pick_btn_tint_color: UIColor = UIColor.white
    
    /// back button color
    public var back_btn_background_color: UIColor =  UIColor.colorWithHexString("#000000", alpha: 0.7)!
    
    /// tint color for back button
    public var back_btn_tint_color: UIColor = UIColor.white
    
    /// default action button background color i.e. clear or no background
    public var default_action_btn_background_color: UIColor = UIColor.clear
    
    /// action button tint color
    public var default_action_btn_tint_color: UIColor = UIColor.red
    
    /// default button size 
    public var default_btn_size: CGSize = CGSize(width: 34, height: 34)
    
    /// default similar button size e.g. Find Similar button size with icon on the left and text at the right
    public var default_similar_btn_size: CGSize = CGSize(width: 34, height: 44)
    
    /// default action button size
    public var default_action_btn_size: CGSize = CGSize(width: 40, height: 40)
    
    /// default product card background color
    public var default_product_card_background_color = UIColor.white
    
    /// title for select image from photo library
    public var default_select_photo_title : String = "Select photo"
    
    /// Scale for query product image compare to the product image in search results
    public var default_query_product_image_scale: CGFloat = 0.7
    
    /// singleton instance. Used this to configure the global theme settings
    public static let sharedInstance : ViTheme = ViTheme()
    
    private override init(){
        super.init()
    }
    
    
}
