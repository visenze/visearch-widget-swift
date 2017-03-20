//
//  ViFacetItem.swift
//  ViSearchSDK
//
//  Created by Hung on 7/2/17.
//  Copyright © 2017 Hung. All rights reserved.
//

import Foundation

open class ViFacetItem: NSObject {
    public var value : String
    public var count : Int? = nil
    
    public init(value: String) {
        self.value = value
    }
    
    public init(value: String, count: Int?) {
        self.value = value
        self.count = count
    }
    
}
