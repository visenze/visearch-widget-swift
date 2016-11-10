//
//  RecommendationViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 8/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK

open class ViRecommendationViewController: ViBaseSearchViewController{

    /// reload layout
    open override func reloadLayout(){
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = itemSpacing
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.collectionView?.backgroundColor = backgroundColor
        layout.itemSize = itemSize
        
    }
    
    /// call ViSearch API and refresh the views
    open override func refreshData() {
        if let searchParams = searchParams {
            
            // construct the fl based on schema mappings
            // need to merge the array to make sure that the returned data contain the relevant meta data in mapping
            let metaArr = self.schemaMapping.getMetaArrForSearch()
            let combinedArr = searchParams.fl + metaArr
            let flSet = Set(combinedArr)
            searchParams.fl = Array(flSet)
            
            ViSearch.sharedInstance.recommendation(
                params: searchParams,
                successHandler: {
                    (data : ViResponseData?) -> Void in
                    // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                    if let data = data {
                        if data.hasError {
                            let errMsgs =  data.error.joined(separator: ",")
                            print("Recommendation API error: \(errMsgs)")
                            
                            // TODO: display system busy message here
                            
                        }
                        else {
                            // display and refresh here
                            self.reqId = data.reqId
                            self.products = ViSchemaHelper.parseProducts(mapping: self.schemaMapping, data: data)
                            
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                            }
                            
                        }
                    }

            },
                failureHandler: {
                    (err) -> Void in
                    // Do something when request fails e.g. due to network error
                    print ("error: \\(err.localizedDescription)")
                    // TODO: display error message and tap to try again
            })
        }
        else {
            
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Please setup search parameters to refresh data.")
            
        }
    }



}
