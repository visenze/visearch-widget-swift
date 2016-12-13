//
//  ViProduct.swift
//  ViSearchWidgets
//
//  Created by Hung on 25/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Model to hold data for product card
/// Based on the provided schema mapping and ViSenze API response, data will be populated in this class
/// Represent a single product
open class ViProduct: NSObject {

    // MARK: properties
    
    /// im_name for image, identify this image in ViSenze API
    public var im_name: String
    
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
    
    /// meta data dictionary retrieved from visenze API
    public var metadataDict: [String : Any]? = nil
    
    // MARK: constructors
    public init(im_name: String, url: URL, price: Float?){
        self.imageUrl = url
        self.price = price
        self.im_name = im_name
    }
    
    public convenience init?(im_name: String, urlString: String, price: Float? = nil){
        if let url = URL(string: urlString) {
            self.init (im_name: im_name, url: url, price: price)
        }
        else {
            return nil
        }
    }

    
}
