//
//  ViProduct.swift
//  ViSearchWidgets
//
//  Created by Hung on 25/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

open class ViProduct: NSObject {

    // MARK: properties
    
    /// underlying image. This take precendence over image url. If set, image url will be ignored
    public var image: UIImage?
    
    /// image url to load
    public var image_url : URL?
    
    /// placeholder image when image is loading
    public var placeholder_image : UIImage?
    
    /// error image for failed loading
    public var error_image: UIImage?
    
    /// label e.g. for product brand
    public var label : String?
    
    /// heading e.g. for product title
    public var heading: String?
    
    /// price
    public var price: Float?
    
    /// discounted price
    public var discounted_price : Float?
    
    // MARK: constructors
    public init(image: UIImage, price: Float?){
        self.image = image
        self.price = price
    }
    
    public init(url: URL, price: Float?){
        self.image_url = url
        self.price = price
    }
    
    public convenience init?(url_string: String, price: Float?){
        if let url = URL(string: url_string) {
            self.init (url: url, price: price)
        }
        else {
            return nil;
        }
    }

    
}
