//
//  ViFacet.swift
//  ViSearchSDK
//
//  Created by Hung on 7/2/17.
//  Copyright © 2017 Hung. All rights reserved.
//

import Foundation

open class ViFacet: NSObject {

    /// facet field name
    public var key   : String
    
    /// facet field items for string facets fields
    public var items : [ViFacetItem] = []
    
    // for numeric facet, a range will be return instead
    public var min: Int? = nil
    
    // for numeric facet, a range with min, max will be returned insted
    public var max: Int? = nil
    
    public init(key: String) {
        self.key = key
    }
    
    public init(key: String, items:  [ViFacetItem] ) {
        self.key = key
        self.items = items
    }

    
}
