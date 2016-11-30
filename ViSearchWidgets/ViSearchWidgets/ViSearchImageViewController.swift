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

open class ViSearchImageViewController: ViGridSearchViewController {

    // most recent photo asset
    public var asset: PHAsset? = nil
    open var croppingEnabled : Bool = true
    open var allowsLibraryAccess : Bool = true
    
    var queryImageView : UIImageView? = nil
    var cropBtn : UIButton? = nil
    
    open override func setup(){
        super.setup()
        self.title = "Search By Image"
        // hide this as we will use the query image preview
        self.showTitleHeader = false
    }
    
    /// layout for header that contains query product and filter
    open override var headerLayout : Layout? {
        var allLayouts : [Layout] = []
        
        var imgLogoLayouts : [Layout] = []
        
        // add color preview
        let imagePreviewLayout = SizeLayout<UIImageView>(
            width: 120,
            height: 120,
            alignment: .topLeading,
            flexibility: .inflexible,
            config: { v in
                
                v.contentMode = .scaleAspectFill
                v.clipsToBounds = true
                
                if let params = self.searchParams as? ViUploadSearchParams {
                    v.image = params.image
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
            sublayout: allStackLayout
        )
        
        
        return insetLayout
        
    }
    
   
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
                self?.refreshData()
            }
            
            
        }
        
        present(cameraViewController, animated: true, completion: nil)
        
    }
    
    public func cropImg(sender: UIButton, forEvent event: UIEvent) {
        
        if let curAsset = self.asset {
            let confirmViewController = ConfirmViewController(asset: curAsset, allowsCropping: true)
            confirmViewController.onComplete = { image, asset in
                
                self.dismiss(animated: true, completion: nil)
                
                if let image = image, let asset = asset {
                    // save image here
                    if let searchParams = self.searchParams as? ViUploadSearchParams {
                        searchParams.image = image
                        self.refreshData()
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
    
    
    /// since we show the logo below the color preview box it is not necessary to show again
    open override var footerSize : CGSize {
        return CGSize.zero
    }
    
    /// call ViSearch API and refresh the views
    open override func refreshData() {
        
        if( searchParams != nil && (searchParams is ViUploadSearchParams) ) {
            
            if let searchParams = searchParams {
                
                self.setMetaQueryParamsForSearch()
                
                // check whether filter set to apply the filter
                self.setFilterQueryParamsForSearch()
                
                
                ViSearch.sharedInstance.uploadSearch(
                    params: searchParams as! ViUploadSearchParams,
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
                                
                                
                                self.delegate?.searchSuccess(searchType: ViSearchType.SEARCH_BY_IMAGE , reqId: data.reqId, products: self.products)
                                
                                DispatchQueue.main.async {
                                    
                                    self.collectionView?.reloadData()
                                    self.cropBtn?.isHidden = !(self.croppingEnabled && (self.asset != nil) )
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
            
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Search parameter must be ViUploadSearchParams type and is not nil.")
            
            
        }
    }

    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cropBtn?.isHidden = !(self.croppingEnabled && (self.asset != nil) )
        
    }

}
