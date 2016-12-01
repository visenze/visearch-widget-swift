//
//  ViFindSimilarViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 24/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK
import LayoutKit

open class ViFindSimilarViewController: ViGridSearchViewController {

    public var queryImageConfig = ViImageConfig()
    
    /// whethere to show query product
    open var showQueryProduct : Bool = false

    open var queryProduct: ViProduct? = nil
    
    /// generate the query image config from product card config, scale down by scale factor
    open func generateQueryImageConfig(scale: CGFloat) -> ViImageConfig {
        var config = ViImageConfig()
        
        config.contentMode = self.imageConfig.contentMode
        config.errImg = self.imageConfig.errImg
        config.loadingImg = self.imageConfig.loadingImg
        config.size = CGSize(width: (self.imageConfig.size.width * scale) , height: (self.imageConfig.size.height * scale) )
        
        return config
    }
    
    /// layout for header that contains query product and filter
    open override var headerLayout : Layout? {
        var allLayouts : [Layout] = []
        
        if let queryProduct = queryProduct {
            
            if showQueryProduct {
                var productLogoLayouts : [Layout] = []
                
                let productLayout = ViQueryProductLayout(imgUrl: queryProduct.imageUrl, imageConfig: self.queryImageConfig,
                                                         heading: queryProduct.heading, headingConfig: self.headingConfig,
                                                         label: queryProduct.label, labelConfig: self.labelConfig,
                                                         price: queryProduct.price, priceConfig: self.priceConfig,
                                                         discountPrice: queryProduct.discountPrice, discountPriceConfig: self.discountPriceConfig,
                                                         pricesHorizontalSpacing: ViProductCardLayout.default_spacing, labelLeftPadding: ViProductCardLayout.default_spacing)

                
                productLogoLayouts.append(productLayout)
                
                if showPowerByViSenze {
                    let powerByLayout = self.getPowerByVisenzeLayout()
                    productLogoLayouts.append(powerByLayout)
                }
                
                // add in the border view at bottom
                let divider = self.getDividerLayout()
                productLogoLayouts.append(divider)
                
                let productAndLogoStackLayout = StackLayout(
                    axis: .vertical,
                    spacing: 2,
                    sublayouts: productLogoLayouts
                )
                
                allLayouts.append(productAndLogoStackLayout)
            }

        }
        
        // label and filter layout
        let labelAndFilterLayout = self.getLabelAndFilterLayout(emptyProductsTxt: "Similar Products", displayStringFormat: "%d Similar Products Found")
        allLayouts.append(labelAndFilterLayout)
        
        let allStackLayout = StackLayout(
            axis: .vertical,
            spacing: 4,
            sublayouts: allLayouts
        )
        
        let insetLayout =  InsetLayout(
            insets: EdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            sublayout: allStackLayout
        )
        
        
        return insetLayout
        
    }
    
    /// since we show the logo below the query product, this is not necessary to show again
    open override var footerSize : CGSize {
        if showQueryProduct {
            return CGSize.zero
        }
        
        return super.footerSize
    }
    
    open override func setup(){
        super.setup()
        self.title = "Similar Products"
        // hide this as we will use the query product card and filter header instead
        self.showTitleHeader = false
    }
    
    /// call ViSearch API and refresh the views
    open override func refreshData() {
        if( searchParams != nil && (searchParams is ViSearchParams) ) {
        
            if let searchParams = searchParams {
                
                self.setMetaQueryParamsForSearch()
                
                // check whether filter set to apply the filter
                self.setFilterQueryParamsForSearch()
                
                // set up user agent
                ViSearch.sharedInstance.client?.userAgent = ViWidgetVersion.USER_AGENT
                
                ViSearch.sharedInstance.findSimilar(
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
                                
                                
                                self.delegate?.searchSuccess(searchType: ViSearchType.FIND_SIMILAR , reqId: data.reqId, products: self.products)
                                
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
