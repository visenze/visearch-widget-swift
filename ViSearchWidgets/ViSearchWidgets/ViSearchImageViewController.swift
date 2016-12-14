//
//  ViSearchImageViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 28/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK
import LayoutKit
import Photos

/// Search by Image widget. Search results will be displayed in a grid.
open class ViSearchImageViewController: ViGridSearchViewController {
    
    /// Tag for the float view containing color picker + filter buttons
    /// The floating view will appear when we scroll down
    let floatViewTag : Int = 999
    
    /// most recent photo asset that is loaded from photo library
    public var asset: PHAsset? = nil
    
    /// whether to enable cropping
    open var croppingEnabled : Bool = true
    
    /// whether to allow access to photo library to pick a photo
    open var allowsLibraryAccess : Bool = true
    
    /// Preview image view after photo is taken
    var queryImageView : UIImageView? = nil
    
    /// Crop button
    var cropBtn : UIButton? = nil

    /// preview image
    var previewImg: UIImage? = nil
    
    open override func setup(){
        super.setup()
        self.title = "Search By Image"
        // hide this as we will use the query image preview
        self.showTitleHeader = false
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
    
    /// Create the floating view that contains Filter + Camera buttons
    ///
    /// - Returns: generated view
    public func getFloatingView() -> UIView {
        let floatView = UIView()
        floatView.tag = self.floatViewTag
        floatView.autoresizingMask = [ .flexibleLeftMargin , .flexibleRightMargin ]
        
        let btnWidth = ViIcon.camera!.width + 12
        var floatWidth = btnWidth
        
        let button = UIButton(type: .custom)
        button.backgroundColor = ViTheme.sharedInstance.filter_btn_floating_background_color
        
        button.setImage(ViIcon.camera, for: .normal)
        button.setImage(ViIcon.camera, for: .highlighted)
        
        button.tintColor = ViTheme.sharedInstance.color_pick_btn_tint_color
        button.imageEdgeInsets = UIEdgeInsetsMake( 4, 4, 4, 4)
        button.tag = ViProductCardTag.cameraBtnTag.rawValue
        
        button.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        
        
        button.addTarget(self, action: #selector(self.openCameraView), for: .touchUpInside)
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

    
    /// layout for header that contains query image and filter
    open override var headerLayout : Layout? {
        var allLayouts : [Layout] = []
        
        var imgLogoLayouts : [Layout] = []
        
        // add color preview
        let imagePreviewLayout = SizeLayout<UIImageView>(
            width: 120,
            height: 120,
            alignment: .topLeading,
            flexibility: .inflexible,
            viewReuseId: nil,
            config: { v in
                
                v.contentMode = .scaleAspectFill
                v.clipsToBounds = true
                
                // take image from preview image first, if not available, then take from search parameters
                if let previewImg = self.previewImg {
                    v.image = previewImg
                }
                else if let params = self.searchParams as? ViUploadSearchParams {
                    v.image = params.image
                    self.previewImg = params.image
                }
                
                self.queryImageView = v
            }
        )
        
        // wrap color preview and color picker icon
        let cameraEl = SizeLayout<UIButton>(
            width: ViIcon.camera!.width + 8, height: ViIcon.camera!.height + 8,
            alignment: .bottomTrailing ,
            flexibility: .inflexible,
            viewReuseId: nil,
            config: { button in
                
                button.backgroundColor = ViTheme.sharedInstance.color_pick_btn_background_color
                
                button.setImage(ViIcon.camera, for: .normal)
                button.setImage(ViIcon.camera, for: .highlighted)
                
                button.tintColor = ViTheme.sharedInstance.color_pick_btn_tint_color
                button.imageEdgeInsets = UIEdgeInsetsMake( 4, 4, 4, 4)
                button.tag = ViProductCardTag.cameraBtnTag.rawValue
                
                button.addTarget(self, action: #selector(self.openCameraView), for: .touchUpInside)
                
            }
            
        )
        
        let cropEl = SizeLayout<UIButton>(
            width: ViIcon.crop!.width + 8, height: ViIcon.crop!.height + 8,
            alignment: .bottomTrailing ,
            flexibility: .inflexible,
            viewReuseId: nil,
            config: { button in
                
                button.backgroundColor = ViTheme.sharedInstance.color_pick_btn_background_color
                
                button.setImage(ViIcon.crop, for: .normal)
                button.setImage(ViIcon.crop, for: .highlighted)
                
                button.tintColor = ViTheme.sharedInstance.color_pick_btn_tint_color
                button.imageEdgeInsets = UIEdgeInsetsMake( 4, 4, 4, 4)
                button.tag = ViProductCardTag.cropBtnTag.rawValue
                
                button.addTarget(self, action: #selector(self.cropImg), for: .touchUpInside)
                
                self.cropBtn = button
                
                // hide this button initially, should be set only when asset is passed
                self.cropBtn?.isHidden = !(self.croppingEnabled && (self.asset != nil) )
                
            }
            
        )
        
        let cropAndCameraLayout = StackLayout(
            axis: .vertical,
            spacing: 2,
            alignment: .bottomTrailing ,
            sublayouts: [ cropEl, cameraEl]
        )
        
        
        let imgPreviewAndPickerLayout = StackLayout(
            axis: .horizontal,
            spacing: 2,
            sublayouts: [imagePreviewLayout , cropAndCameraLayout ]
        )
        
        imgLogoLayouts.append(imgPreviewAndPickerLayout)
        
        
        if showPowerByViSenze {
            let powerByLayout = self.getPowerByVisenzeLayout()
            imgLogoLayouts.append(powerByLayout)
        }
        
        // add in the border view at bottom
        let divider = self.getDividerLayout()
        imgLogoLayouts.append(divider)
        
        let productAndLogoStackLayout = StackLayout(
            axis: .vertical,
            spacing: 2,
            sublayouts: imgLogoLayouts
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
            viewReuseId: nil,
            sublayout: allStackLayout
        )
        
        
        return insetLayout
        
    }
    
    /// Open camera to take picture
    ///
    /// - Parameters:
    ///   - sender: camera button
    ///   - event: button event
    public func openCameraView(sender: UIButton, forEvent event: UIEvent) {
        // move cropping to the the later stage where we click on the crop button
        let cameraViewController = CameraViewController(croppingEnabled: false, allowsLibraryAccess: self.allowsLibraryAccess)
        { [weak self] image, asset in
            
            
            self?.dismiss(animated: true, completion: nil)
            
            // user cancel photo taking
            if( image == nil) {
                return
            }
            
            self?.asset = asset
            
            if let searchParams = self?.searchParams as? ViUploadSearchParams {
                searchParams.image = image
                self?.previewImg = image
                self?.refreshData()
                
                // reset scroll
                self?.resetScroll()
            }
            
            
        }
        
        present(cameraViewController, animated: true, completion: nil)
        
    }
    
    
    /// Open crop image view controller
    ///
    /// - Parameters:
    ///   - sender: crop button
    ///   - event: button event
    public func cropImg(sender: UIButton, forEvent event: UIEvent) {
        
        if let curAsset = self.asset {
            let confirmViewController = ConfirmViewController(asset: curAsset, allowsCropping: true)
            confirmViewController.onComplete = { image, asset in
                
                self.dismiss(animated: true, completion: nil)
                
                if let image = image {
                    
                    self.previewImg = image
                    
                    // save image here
                    if let searchParams = self.searchParams as? ViUploadSearchParams {
                        
                        if confirmViewController.allowsCropping {
                            
                            let cr = confirmViewController.lastNormalizedCropRect
                           
                            // we will pass the original image with the box for better search result
                            // cropped versions result in lower quality
                            if let img = confirmViewController.imageView.image {
                                
                                // verify that we crop box is valid
                                if cr.width < 0 || cr.height < 0 {
                                    // not valid, we use default cropped image
                                    searchParams.image = image
                                }
                                else {
                                    searchParams.image = img
                                    
                                    // pass in the crop box
                                    let targetX = floor( img.size.width  * cr.origin.x)
                                    let targetY = floor( img.size.height * cr.origin.y)
                                    let targetWidth = floor( img.size.width * cr.width)
                                    let targetHeight = floor(  img.size.height * cr.height)
                                    
                                    searchParams.box = ViBox(x1: Int(targetX),
                                                             y1: Int(targetY),
                                                             x2: Int(targetX + targetWidth) ,
                                                             y2: Int(targetY + targetHeight) )
                                    
                                    
                                }
                                
                            }
                            else {
                                searchParams.image = image
                            }
                            
                        }
                        else {
                            searchParams.image = image
                        }
                        
                        self.refreshData()
                        
                        // reset scroll
                        self.resetScroll()
                        
                    }
                    
                } else {
                    // user cancel
                }
            }
            confirmViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            present(confirmViewController, animated: true, completion: nil)
        }
        else {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: unable to find recent photo for cropping")
        }
        
    }
    
    
    /// since we show the Power by ViSenze image below the query product, it is not necessary to show again in the footer
    /// if query product is not available, then the Power by ViSenze image will appear in footer
    open override var footerSize : CGSize {
        return CGSize.zero
    }
    
    /// call ViSearch API and refresh the views
    open override func refreshData() {
        
        if( searchParams != nil && (searchParams is ViUploadSearchParams) ) {
            
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
                    
                    client.uploadSearch(
                        params: searchParams as! ViUploadSearchParams,
                        successHandler: {
                            (data : ViResponseData?) -> Void in
                            // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                            if let data = data {
                                if data.hasError {
                                    
                                    // clear products if there are errors
                                    self.products = []
                                    
                                    DispatchQueue.main.async {
                                        self.displayDefaultErrMsg(searchType: ViSearchType.SEARCH_BY_IMAGE , err: nil, apiErrors: data.error)
                                    }
                                    
                                    self.delegate?.searchFailed(sender: self, searchType: ViSearchType.SEARCH_BY_IMAGE ,  err: nil, apiErrors: data.error)
                                    
                                    DispatchQueue.main.async {
                                        self.collectionView?.reloadData()
                                    }

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
                                    
                                    self.delegate?.searchSuccess(sender: self, searchType: ViSearchType.SEARCH_BY_IMAGE , reqId: data.reqId, products: self.products)
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.collectionView?.reloadData()
                                        self.cropBtn?.isHidden = !(self.croppingEnabled && (self.asset != nil) )
                                    }
                                    
                                }
                            }
                            
                    },
                    failureHandler: {
                            (err) -> Void in
                        
                            // clear products if there are errors
                            self.products = []
                        
                            DispatchQueue.main.async {
                                self.displayDefaultErrMsg(searchType: ViSearchType.SEARCH_BY_IMAGE , err: err, apiErrors: [])
                            }
                            
                            self.delegate?.searchFailed(sender: self, searchType: ViSearchType.SEARCH_BY_IMAGE , err: err, apiErrors: [])
                            
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
            
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Search parameter must be ViUploadSearchParams type and is not nil.")
            
            
        }
    }

    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cropBtn?.isHidden = !(self.croppingEnabled && (self.asset != nil) )
        
    }

}
