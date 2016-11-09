//
//  ViProductSchemaMapping.swift
//  ViSearchWidgets
//
//  Created by Hung on 9/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Mapping from schema to product fields for displaying in a single product card UI element
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
    
    public init(){
        
    }
    
}
