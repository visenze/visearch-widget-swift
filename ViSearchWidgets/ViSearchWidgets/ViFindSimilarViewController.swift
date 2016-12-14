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

/// Find Similar widget. Search results are displayed in a grid
open class ViFindSimilarViewController: ViGridSearchViewController {

    /// Tag for the float view containing the filter button
    /// The floating view will appear when we scroll down
    let floatViewTag : Int = 999
    
    /// Configuration for query image
    public var queryImageConfig = ViImageConfig()
    
    /// show/hide query product
    open var showQueryProduct : Bool = false

    /// Query product from previous screen e.g. user taps on Similar button on a product in the search results
    open var queryProduct: ViProduct? = nil
    
    /// generate the query image config from product card config, scale down by scale factor
    /// scale should generally be less than 1. Default number is in ViTheme.default_query_product_image_scale
    open func generateQueryImageConfig(scale: CGFloat) -> ViImageConfig {
        var config = ViImageConfig()
        
        config.contentMode = self.imageConfig.contentMode
        config.errImg = self.imageConfig.errImg
        config.loadingImg = self.imageConfig.loadingImg
        config.size = CGSize(width: (self.imageConfig.size.width * scale) , height: (self.imageConfig.size.height * scale) )
        
        return config
    }
    
    /// layout for header that contains query product and filter button
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
    
    /// since we show the Power by ViSenze image below the query product, it is not necessary to show again in the footer
    /// if query product is not available, then the Power by ViSenze image will appear in footer
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
                
                // hide err message if any
                self.hideMsgView()
                
                self.setMetaQueryParamsForSearch()
                
                // check whether filter set to apply the filter
                self.setFilterQueryParamsForSearch()
                
                
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
                                        self.displayDefaultErrMsg(searchType: ViSearchType.FIND_SIMILAR , err: nil, apiErrors: data.error)
                                    }
                                    
                                    self.delegate?.searchFailed(sender: self, searchType: ViSearchType.FIND_SIMILAR , err: nil, apiErrors: data.error)
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
                                    
                                    self.delegate?.searchSuccess(sender: self, searchType: ViSearchType.FIND_SIMILAR , reqId: data.reqId, products: self.products)
                                    
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
                            
                            DispatchQueue.main.async {
                                self.displayDefaultErrMsg(searchType: ViSearchType.FIND_SIMILAR , err: err, apiErrors: [])
                            }

                            self.delegate?.searchFailed(sender: self, searchType: ViSearchType.FIND_SIMILAR , err: err, apiErrors: [])
                            
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

    // MARK: Scroll methods
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkHeaderGone(scrollView)
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                       willDecelerate decelerate: Bool)
    {
        self.checkHeaderGone(scrollView)
    }
    
    
    /// Create the floating view that contains Filter + Color Picker buttons
    ///
    /// - Returns: generated view
    public func getFloatingView() -> UIView {
        let floatView = UIView()
        floatView.tag = self.floatViewTag
        floatView.autoresizingMask = [ .flexibleLeftMargin , .flexibleRightMargin ]
        
        let btnWidth = ViIcon.color_pick!.width + 12
        var floatWidth = btnWidth
        
        if false == self.filterBtn?.isHidden {
            // filter
            let filterButton = UIButton(type: .custom)
            
            filterButton.backgroundColor = ViTheme.sharedInstance.filter_btn_floating_background_color
            
            filterButton.setImage(ViIcon.filter, for: .normal)
            filterButton.setImage(ViIcon.filter, for: .highlighted)
            
            filterButton.tintColor = ViTheme.sharedInstance.filter_btn_tint_color
            filterButton.imageEdgeInsets = UIEdgeInsetsMake( 4, 4, 4, 4)
            filterButton.tag = ViProductCardTag.filterBtnTag.rawValue
            
            filterButton.addTarget(self, action: #selector(self.filterBtnTap), for: .touchUpInside)
            filterButton.frame = CGRect(x: 8, y: 0, width: btnWidth, height: btnWidth)
            floatWidth = filterButton.frame.origin.x + btnWidth
            
            floatView.addSubview(filterButton)
        }
        
        floatView.frame = CGRect(x: self.view.bounds.width - floatWidth - 8 , y: 0 , width: floatWidth , height: btnWidth )
        
        return floatView
    }
    
    /// reset scroll and move collectionView back to top
    open func resetScroll() {
        self.collectionView?.contentOffset = .zero
        // hide filter btn
        if let floatView = self.view.viewWithTag(self.floatViewTag) {
            floatView.isHidden = true
        }
        
    }
    
    /// check scroll view position, if below header , then overlay filter + color buttons on top
    open func checkHeaderGone(_ scrollView: UIScrollView) {
        if self.headerLayoutHeight == 0 {
            return
        }
        
        var floatView : UIView? = self.view.viewWithTag(self.floatViewTag)
        if  floatView == nil {
            floatView = self.getFloatingView()
            floatView?.isHidden = true
            self.view.addSubview(floatView!)
            self.view.bringSubview(toFront: floatView!)
        }
        
        if scrollView.contentOffset.y > self.headerLayoutHeight {
            floatView?.isHidden = false
        }
        else {
            floatView?.isHidden = true
        }
    }
    
   
}
