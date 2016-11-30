//
//  RecommendationViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 8/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK

/// you may also like default to horizontal scroll view
open class ViRecommendationViewController: ViHorizontalSearchViewController{

    open override func setup(){
        super.setup()
        self.title = "You May Also Like"
    }

    /// call ViSearch API and refresh the views
    open override func refreshData() {
        
        if( searchParams != nil && (searchParams is ViSearchParams) ) {
            
            if let searchParams = searchParams {
                
                self.setMetaQueryParamsForSearch()
                
                ViSearch.sharedInstance.recommendation(
                    params: searchParams as! ViSearchParams,
                    successHandler: {
                        (data : ViResponseData?) -> Void in
                        // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                        if let data = data {
                            if data.hasError {
                                let errMsgs =  data.error.joined(separator: ",")
                                print("API error: \(errMsgs)")
                                
                                // TODO: display system busy message here
                                self.delegate?.searchFailed(err: nil, apiErrors: data.error)
                            }
                            else {
                                
                                // display and refresh here
                                self.reqId = data.reqId
                                self.products = ViSchemaHelper.parseProducts(mapping: self.schemaMapping, data: data)
                                
                                
                                self.delegate?.searchSuccess(searchType: ViSearchType.YOU_MAY_ALSO_LIKE , reqId: data.reqId, products: self.products)
                                
                                DispatchQueue.main.async {
                                    self.collectionView?.reloadData()
                                }
                                
                            }
                        }

                },
                    failureHandler: {
                        (err) -> Void in
                        // Do something when request fails e.g. due to network error
                        // print ("error: \\(err.localizedDescription)")
                        // TODO: display error message and tap to try again
                        self.delegate?.searchFailed(err: err, apiErrors: [])
                        
                })
            }
        }
        else {
            
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Search parameter must be ViSearchParams type and is not nil.")
            
        }
    }



}
