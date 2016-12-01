//
//  ViProductSchemaMapping.swift
//  ViSearchWidgets
//
//  Created by Hung on 9/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Mapping from data feed schema to product fields for displaying in a single product card UI element
/// Refer to http://developers.visenze.com/setup/#Configure-schema-fields for more details
public struct ViProductSchemaMapping {
    
    /// mapping for product image url, default to im_url
    public var productUrl : String = "im_url"
    
    /// mapping for heading e.g. product title or product name
    public var heading : String? = nil
    
    /// mapping for label field e.g product brand
    public var label : String? = nil
    
    /// mapping for product price field
    public var price: String? = nil
    
    /// mapping for discount price field
    public var discountPrice: String? = nil
    
    /// constructor
    public init(){
        
    }
    
    /// construct fl meta array to be passed to search API
    /// the meta data will then be returned in ViSenze search API response
    /// Refers to this link for more details: http://developers.visenze.com/api/?shell#advanced-parameters
    public func getMetaArrForSearch() -> [String] {
        var fl : [String] = []
        
        fl.append(productUrl)
        
        if let val = heading {
            fl.append(val)
        }
        
        if let val = label {
            fl.append(val)
        }
        
        if let val = price {
            fl.append(val)
        }
        
        if let val = discountPrice {
            fl.append(val)
        }
        
        return fl
    }

}
