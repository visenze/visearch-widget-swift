//
//  ViColorSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 25/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK
import LayoutKit

/// Search by Color widget. Search results will be displayed in a grid
open class ViColorSearchViewController: ViGridSearchViewController , UIPopoverPresentationControllerDelegate, ViColorPickerDelegate {

    /// Tag for the float view containing color picker + filter buttons
    /// The floating view will appear when we scroll down
    let floatViewTag : Int = 999
    
    // default list of colors in the color picker in hex format e.g. e0b0ff, 2abab3
    open var colorList: [String] = [
        "000000" , "555555" , "9896a4" ,
        "034f84" , "00afec" , "98ddde" ,
        "00ffff" , "f5977d" , "91a8d0",
        "ea148c" , "f53321" , "d66565" ,
        "ff00ff" , "a665a7" , "e0b0ff" ,
        "f773bd" , "f77866" , "7a2f04" ,
        "cc9c33" , "618fca" , "79c753" ,
        "228622" , "4987ec" , "2abab3" ,
        "ffffff"
    ]
    
    open override func setup(){
        super.setup()
        self.title = "Search By Color"
        // hide this as we will use the query color picker
        self.showTitleHeader = false
    }
    
    /// layout for header that contains query product and filter
    open override var headerLayout : Layout? {
        var allLayouts : [Layout] = []
        
        var colorLogoLayouts : [Layout] = []
        
        // add color preview
        let colorPreviewLayout = SizeLayout<UIView>(
                                         width: 120,
                                         height: 120,
                                         alignment: .topLeading,
                                         flexibility: .inflexible,
                                         config: { v in
                                            
                                            if let colorParams = self.searchParams as? ViColorSearchParams {
                                                v.backgroundColor = UIColor.colorWithHexString(colorParams.color, alpha: 1.0)
                                            }
                                         }
        )
        
        // wrap color preview and color picker icon
        let colorPickerEl = SizeLayout<UIButton>(
            width: ViIcon.color_pick!.width + 8, height: ViIcon.color_pick!.height + 8,
            alignment: .bottomTrailing ,
            flexibility: .inflexible,
            viewReuseId: nil,
            config: { button in
                
                button.backgroundColor = ViTheme.sharedInstance.color_pick_btn_background_color
                
                button.setImage(ViIcon.color_pick, for: .normal)
                button.setImage(ViIcon.color_pick, for: .highlighted)
                
                button.tintColor = ViTheme.sharedInstance.color_pick_btn_tint_color
                button.imageEdgeInsets = UIEdgeInsetsMake( 4, 4, 4, 4)
                button.tag = ViProductCardTag.colorPickBtnTag.rawValue
                
                button.addTarget(self, action: #selector(self.openColorPicker), for: .touchUpInside)
                
            }
            
        )
        
        let colorPreviewAndPickerLayout = StackLayout(
            axis: .horizontal,
            spacing: 2,
            sublayouts: [colorPreviewLayout , colorPickerEl]
        )
        
        colorLogoLayouts.append(colorPreviewAndPickerLayout)
        
    
        if showPowerByViSenze {
            let powerByLayout = self.getPowerByVisenzeLayout()
            colorLogoLayouts.append(powerByLayout)
        }
        
        // add in the border view at bottom
        let divider = self.getDividerLayout()
        colorLogoLayouts.append(divider)
        
        let productAndLogoStackLayout = StackLayout(
            axis: .vertical,
            spacing: 2,
            sublayouts: colorLogoLayouts
        )
        
        allLayouts.append(productAndLogoStackLayout)
        
        
        // label and filter layout
        let labelAndFilterLayout = self.getLabelAndFilterLayout(emptyProductsTxt: "Products Found", displayStringFormat: "%d Products Found")
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
        
        let button = UIButton(type: .custom)
        button.backgroundColor = ViTheme.sharedInstance.filter_btn_floating_background_color
        
        button.setImage(ViIcon.color_pick, for: .normal)
        button.setImage(ViIcon.color_pick, for: .highlighted)
        
        button.tintColor = ViTheme.sharedInstance.color_pick_btn_tint_color
        button.imageEdgeInsets = UIEdgeInsetsMake( 4, 4, 4, 4)
        button.tag = ViProductCardTag.colorPickBtnTag.rawValue
        
        button.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        
        
        button.addTarget(self, action: #selector(self.openColorPicker), for: .touchUpInside)
        floatView.addSubview(button)
        
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
            filterButton.frame = CGRect(x: btnWidth + 8, y: 0, width: btnWidth, height: btnWidth)
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
    
    
    /// Open color picker view in a popover
    ///
    /// - Parameters:
    ///   - sender: color picker button
    ///   - event: button event
    public func openColorPicker(sender: UIButton, forEvent event: UIEvent) {
        let controller = ViColorPickerModalViewController()
        controller.modalPresentationStyle = .popover
        controller.delegate = self
        controller.colorList = self.colorList
        controller.paddingLeft = 8
        controller.paddingRight = 8
        controller.preferredContentSize = CGSize(width: self.view.bounds.width, height: 300)
        
        if( searchParams != nil && (searchParams is ViColorSearchParams) ) {
            if let colorParams = searchParams as? ViColorSearchParams {
                controller.selectedColor = colorParams.color
            }
        }
        
        if let popoverController = controller.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            popoverController.delegate = self 
            
        }
        
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // important - this is needed so that a popover will be properly shown instead of fullscreen
    /// return .none to display as popover (ios 8.3+)
    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                            traitCollection: UITraitCollection) -> UIModalPresentationStyle{
        return .none
    }
    
    /// return .none to display as popover (ios 8.0 - 8.2)
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: ViColorPickerDelegate
    public func didPickColor(sender: ViColorPickerModalViewController, color: String) {
        
        // set the color params 
        if let colorParams = self.searchParams as? ViColorSearchParams {
            
            let oldColor = colorParams.color
            
            if oldColor != color {
                // reset the filter
                for filterItem in self.filterItems {
                    filterItem.reset()
                }
            }
            
            colorParams.color = color
            
            sender.dismiss(animated: true, completion: nil)
            
            // update preview box and refresh data
            self.refreshData()
            
            // reset scroll
            self.resetScroll()
            
        }
    }

    
    /// since we show the Power by ViSenze image below the query product, it is not necessary to show again in the footer
    /// if query product is not available, then the Power by ViSenze image will appear in footer
    open override var footerSize : CGSize {
        return CGSize.zero
    }

    /// call ViSearch API and refresh the views
    open override func refreshData() {
        
        if( searchParams != nil && (searchParams is ViColorSearchParams) ) {
            
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
                                    
                    client.colorSearch(
                        params: searchParams as! ViColorSearchParams,
                        successHandler: {
                            (data : ViResponseData?) -> Void in
                            // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                            if let data = data {
                                if data.hasError {
                                    // clear products if there are errors
                                    self.products = []
                                    
                                    DispatchQueue.main.async {
                                        self.displayDefaultErrMsg(searchType: ViSearchType.SEARCH_BY_COLOR ,
                                                                  err: nil, apiErrors: data.error)
                                    }
                                    
                                    self.delegate?.searchFailed(sender: self, searchType: ViSearchType.SEARCH_BY_COLOR ,err: nil, apiErrors: data.error)
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
                                    
                                    self.delegate?.searchSuccess(sender: self, searchType: ViSearchType.SEARCH_BY_COLOR , reqId: data.reqId, products: self.products)
                                    
                                   
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
                                self.displayDefaultErrMsg(searchType: ViSearchType.SEARCH_BY_COLOR , err: err, apiErrors: [])
                            }
                            
                            self.delegate?.searchFailed(sender: self, searchType: ViSearchType.SEARCH_BY_COLOR , err: err, apiErrors: [])
                            
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
            
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Search parameter must be ViColorSearchParams type and is not nil.")
            
            
        }
    }
    
}
