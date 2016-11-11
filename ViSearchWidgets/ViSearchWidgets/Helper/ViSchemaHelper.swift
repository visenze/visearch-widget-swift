//
//  ViSchemaHelper.swift
//  ViSearchWidgets
//
//  Created by Hung on 10/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK

/// extract the products info from schema mapping
public class ViSchemaHelper: NSObject {

    public static func parseProducts(mapping: ViProductSchemaMapping, data: ViResponseData)
        -> [ViProduct]{
        var arr : [ViProduct] = []
        
        // construct products
        for imageResult in data.result {
            var url = imageResult.im_url
            var heading: String? = nil
            var label : String? = nil
            var price: Float? = nil
            var discountPrice: Float? = nil
            
            if let dict = imageResult.metadataDict {
                if mapping.productUrl != "im_url" {
                    url =  dict[mapping.productUrl] as? String
                }
                
                // extract other fields
                if let key = mapping.heading {
                    heading = dict[key] as? String
                }
                
                if let key = mapping.label {
                    label = dict[key] as? String
                }
                
                if let key = mapping.price {
                    if let priceNum = dict[key] as? String {
                        price = Float(priceNum)
                        
                        if price == nil {
                            print("\(type(of: self)).\(#function)[line:\(#line)] - Unable to convert price to number: \(priceNum)")
                        }
                    }
                }
                
                if let key = mapping.discountPrice {
                    if let discountPriceNum = dict[key] as? String {
                        discountPrice =  Float(discountPriceNum)
                        
                        if discountPrice == nil {
                            print("\(type(of: self)).\(#function)[line:\(#line)] - Unable to convert discount price to number: \(discountPriceNum)")
                        }
                    }
                }
            }
            
            if let url = url, let product = ViProduct(im_name: imageResult.im_name, urlString: url, price: price) {
                product.heading = heading
                product.label = label
                product.discountPrice = discountPrice
                product.metadataDict = imageResult.metadataDict
                
                arr.append(product)
            }
            else {
                print("\(type(of: self)).\(#function)[line:\(#line)] - error: invalid url: \(url) ")
                
            }
            
            
        }
        
        return arr
    }
}
