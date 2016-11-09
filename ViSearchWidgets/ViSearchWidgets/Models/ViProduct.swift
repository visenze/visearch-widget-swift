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
    public var image: UIImage? = nil
    
    /// image url to load
    public var imageUrl : URL? = nil
    
    /// label e.g. for product brand
    public var label : String? = nil
    
    /// heading e.g. for product title
    public var heading: String? = nil
    
    /// price
    public var price: Float? = nil
    
    /// discounted price
    public var discountPrice : Float? = nil
    
    // MARK: constructors
    public init(image: UIImage, price: Float?){
        self.image = image
        self.price = price
    }
    
    public init(url: URL, price: Float?){
        self.imageUrl = url
        self.price = price
    }
    
    public convenience init?(urlString: String, price: Float?){
        if let url = URL(string: urlString) {
            self.init (url: url, price: price)
        }
        else {
            return nil;
        }
    }

    
}
