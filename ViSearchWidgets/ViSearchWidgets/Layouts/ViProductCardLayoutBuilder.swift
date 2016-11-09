//
//  ViProductCardLayoutBuilder.swift
//  ViSearchWidgets
//
//  Created by Hung on 9/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// simplify construction of product card layout
open class ViProductCardLayoutBuilder: NSObject {

    public var imgUrl: String
    public var imageConfig: ViImageConfig
    
    public var heading: String?
    public var headingConfig: ViLabelConfig = ViLabelConfig()
    
    public var label: String? = nil
    public var labelConfig: ViLabelConfig = ViLabelConfig.default_label_config
    
    public var price: Float?
    public var priceConfig: ViLabelConfig = ViLabelConfig.default_price_config
    
    public var discountPrice : Float?
    public var discountPriceConfig: ViLabelConfig = ViLabelConfig.default_discount_price_config
    
    public var hasSimilarBtn: Bool = true
    
    public var similarBtnTxt: String = ""
    public var similarBtnConfig: ViButtonConfig = ViButtonConfig.default_btn_config
    public var pricesHorizontalSpacing: CGFloat = 6.0
    public var labelLeftPadding: CGFloat = 6.0
    
    
    public init(imgUrl: String , imageConfig: ViImageConfig) {
        self.imgUrl = imgUrl
        self.imageConfig = imageConfig
        
    }
    
    public func setImg(imgUrl: String,  config: ViImageConfig) -> ViProductCardLayoutBuilder{
        self.imgUrl = imgUrl
        self.imageConfig = config
        return self
    }
    
    public func setLabel(label: String?,  config: ViLabelConfig)  -> ViProductCardLayoutBuilder{
        self.label = label
        self.labelConfig = config
        
        return self
    }
    
    public func removeLabel() -> ViProductCardLayoutBuilder{
        self.label = nil
        return self
    }
    
    public func setHeading(heading: String,  config: ViLabelConfig) -> ViProductCardLayoutBuilder{
        self.heading = heading
        self.headingConfig = config
        
        return self
    }
    
    public func removeHeading() -> ViProductCardLayoutBuilder{
        self.heading = nil
        return self
    }
    
    public func setPrice(price: Float?,  config: ViLabelConfig = ViLabelConfig.default_price_config) -> ViProductCardLayoutBuilder {
        self.price = price
        self.priceConfig = config
        return self
    }
    
    public func removePrice() -> ViProductCardLayoutBuilder{
        self.price = nil
        return self
    }
    
    public func setDiscountPrice(price: Float?,  config: ViLabelConfig = ViLabelConfig.default_discount_price_config) -> ViProductCardLayoutBuilder {
        self.discountPrice = price
        self.discountPriceConfig = config
        
        return self
    }
    
    public func removeDiscountPrice(){
        self.discountPrice = nil
    }
    
    public func setSimilarBtn(similarBtnTxt: String = "",
                              similarBtnConfig: ViButtonConfig = ViButtonConfig.default_btn_config) -> ViProductCardLayoutBuilder{
        self.similarBtnTxt = similarBtnTxt
        self.similarBtnConfig = similarBtnConfig
        self.hasSimilarBtn = true
        
        return self
    }
    
    public func removeSimilarBtn() -> ViProductCardLayoutBuilder{
        self.hasSimilarBtn = false
        return self
    }
    
    public func createLayout() -> ViProductCardLayout?{
        if let url = URL(string: self.imgUrl)
        {
            return ViProductCardLayout(imgUrl: url,
                                   imageConfig: self.imageConfig,
                                   heading: self.heading, headingConfig: self.headingConfig,
                                   label: self.label, labelConfig: self.labelConfig,
                                   price: self.price, priceConfig: self.priceConfig,
                                   discountPrice: self.discountPrice, discountPriceConfig: self.discountPriceConfig,
                                   hasSimilarBtn: self.hasSimilarBtn, similarBtnTxt: self.similarBtnTxt,
                                   similarBtnConfig: self.similarBtnConfig,
                                   pricesHorizontalSpacing: self.pricesHorizontalSpacing, labelLeftPadding: self.labelLeftPadding)
        }
        
        print ("Invalid url: \(imgUrl) . Unable to create card layout")
        
        return nil
    }
    
    
}
