//
//  RecommendationViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 8/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK

/// You May Also Like widget. Search results are displayed in horizontal scroll view
open class ViRecommendationViewController: ViHorizontalSearchViewController{

    open override func setup(){
        super.setup()
        self.title = "You May Also Like"
    }

    /// call ViSearch API and refresh the views
    open override func refreshData() {
        
        if( searchParams != nil && (searchParams is ViSearchParams) ) {
            
            if let searchParams = searchParams {
                
                // hide err message if any
                self.hideMsgView()
                
                self.setMetaQueryParamsForSearch()
                
                var client = self.searchClient
                if client == nil {
                    client = ViSearch.sharedInstance.client
                }
                
                if let client = client {
                
                    // set up user agent
                    client.userAgent = ViWidgetVersion.USER_AGENT
                    
                    client.findSimilar(
                        params: searchParams as! ViSearchParams,
                        successHandler: {
                            (data : ViResponseData?) -> Void in
                            // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                            if let data = data {
                                if data.hasError {
                                    
                                    // clear products if there are errors
                                    self.products = []
                                    
                                    DispatchQueue.main.async {
                                        self.displayDefaultErrMsg(searchType: ViSearchType.YOU_MAY_ALSO_LIKE , err: nil, apiErrors: data.error)
                                    }
                                    
                                    self.delegate?.searchFailed(sender: self, searchType: ViSearchType.YOU_MAY_ALSO_LIKE , err: nil, apiErrors: data.error)
                                }
                                else {
                                    
                                    // display and refresh here
                                    self.reqId = data.reqId
                                    self.products = ViSchemaHelper.parseProducts(mapping: self.schemaMapping, data: data)
                                    
                                    if(self.products.count == 0 ){
                                        DispatchQueue.main.async {
                                            self.displayNoResultsFoundMsg()
                                        }
                                    }
                                    
                                    self.delegate?.searchSuccess(sender: self, searchType: ViSearchType.YOU_MAY_ALSO_LIKE , reqId: data.reqId, products: self.products)
                                    
                                   
                                }
                                
                                DispatchQueue.main.async {
                                    self.collectionView?.reloadData()
                                }
                            }

                    },
                        failureHandler: {
                            (err) -> Void in
                            
                            // clear products if there are errors
                            self.products = []
                            
                            // display default error here
                            DispatchQueue.main.async {
                                self.displayDefaultErrMsg(searchType: ViSearchType.YOU_MAY_ALSO_LIKE , err: err, apiErrors: [])
                            }
                            
                            self.delegate?.searchFailed(sender: self, searchType: ViSearchType.YOU_MAY_ALSO_LIKE , err: err, apiErrors: [])
                            
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                            }
                    })
                }
                else {
                    print("\(type(of: self)).\(#function)[line:\(#line)] - error: client is not initialized.")
                }
            }
        }
        else {
            
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Search parameter must be ViSearchParams type and is not nil.")
            
        }
    }



}
