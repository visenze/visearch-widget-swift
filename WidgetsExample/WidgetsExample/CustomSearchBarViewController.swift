//
//  CustomSearchBarViewController.swift
//  WidgetsExample
//
//  Created by Hung on 5/12/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK
import ViSearchWidgets

class CustomSearchBarViewController: UIViewController, ViColorPickerDelegate, UIPopoverPresentationControllerDelegate, ViSearchViewControllerDelegate {

    var colorParms: ViColorSearchParams? = nil
    
    // list of colors for the color picker in hex format e.g. e0b0ff, 2abab3
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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        // add in camera and color search buttons
        self.searchBar.placeholder = "Search"
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField {
            
            textFieldInsideSearchBar.rightView = self.getCameraColorSearchButtons()
            textFieldInsideSearchBar.rightViewMode = .always
        }
    }

    // MARK: get view
    
    /// Add color picker and search by image buttons to search bar
    ///
    /// - Returns: custom view to be put into the UITextField of UISearchBar
    public func getCameraColorSearchButtons() -> UIView {
        let customView = UIView()
        customView.autoresizingMask = [ .flexibleLeftMargin , .flexibleRightMargin ]
        
        let btnWidth = ViIcon.camera!.width + 4
        var floatWidth = btnWidth
        
        let button = UIButton(type: .custom)
        
        button.setImage(ViIcon.camera, for: .normal)
        button.setImage(ViIcon.camera, for: .highlighted)
        
        button.tintColor = UIColor.black
        button.tag = ViProductCardTag.cameraBtnTag.rawValue
        
        button.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        
        
        button.addTarget(self, action: #selector(self.openCameraView), for: .touchUpInside)
        customView.addSubview(button)
        
        let colorButton = UIButton(type: .custom)
        
        colorButton.setImage(ViIcon.color_pick, for: .normal)
        colorButton.setImage(ViIcon.color_pick, for: .highlighted)
        
        colorButton.tintColor = UIColor.black
        //colorButton.imageEdgeInsets = UIEdgeInsetsMake( 4, 4, 4, 4)
        colorButton.tag = ViProductCardTag.colorPickBtnTag.rawValue

        colorButton.addTarget(self, action: #selector(self.openColorPicker), for: .touchUpInside)
        colorButton.frame = CGRect(x: btnWidth + 4, y: 0, width: btnWidth, height: btnWidth)
        floatWidth = colorButton.frame.origin.x + btnWidth
        
        customView.addSubview(colorButton)
        
        customView.frame = CGRect(x: 0 , y: 0 , width: floatWidth , height: btnWidth )
        
        return customView
    }
    
    // MARK: color picker
    /// Open color picker view in a popover
    ///
    /// - Parameters:
    ///   - sender: color picker button
    ///   - event: button event
    public func openColorPicker(sender: UIButton, forEvent event: UIEvent) {
        
        // close the keyboard
        self.searchBar.resignFirstResponder()
        
        let controller = ViColorPickerModalViewController()
        controller.modalPresentationStyle = .popover
        controller.delegate = self
        controller.colorList = self.colorList
        controller.paddingLeft = 8
        controller.paddingRight = 8
        controller.preferredContentSize = CGSize(width: self.view.bounds.width, height: 300)
        
        if let colorParams = self.colorParms {
            controller.selectedColor = colorParams.color
        }
        
        if let popoverController = controller.popoverPresentationController {
            popoverController.backgroundColor = UIColor.white
            
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
            popoverController.delegate = self
            
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: UIPopoverPresentationControllerDelegate
    // important - this is needed so that a popover will be properly shown instead of fullscreen
    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                          traitCollection: UITraitCollection) -> UIModalPresentationStyle{
        return .none
    }

    // MARK: ViColorPickerDelegate
    public func didPickColor(sender: ViColorPickerModalViewController, color: String) {
        // set the color params
        
        self.colorParms = ViColorSearchParams(color: color)
        
        // refresh data
        let controller = ViColorSearchViewController()
        self.colorParms!.limit = 16
        
        controller.searchParams = self.colorParms
        
        // copy other settings
        controller.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
        
        controller.filterItems = AppDelegate.loadFilterItemsFromPlist()
        
        
        controller.imageConfig.contentMode = .scaleAspectFill
        controller.priceConfig.isStrikeThrough = true
        
        controller.productCardBorderColor = UIColor.lightGray
        controller.productCardBorderWidth = 0.7
        controller.itemSpacing = 0
        controller.rowSpacing = 0
        controller.delegate = self
        
        // configure product image size and product card size
        self.configureSize(controller: controller)
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        controller.refreshData()
        
        sender.dismiss(animated: false, completion: nil)
        
        
    }

    
    // MARK: camera
    /// Open camera to take picture
    ///
    /// - Parameters:
    ///   - sender: camera button
    ///   - event: button event
    public func openCameraView(sender: UIButton, forEvent event: UIEvent) {
        let cameraViewController = CameraViewController(croppingEnabled: false, allowsLibraryAccess: true) { [weak self] image, asset in
            
            // user cancel photo taking
            if( image == nil) {
                self?.dismiss(animated: true, completion: nil)
                
                return
            }
            
            let controller = ViSearchImageViewController()
            
            // save recent photo
            controller.asset = asset
            
            let params = ViUploadSearchParams(image: image!)
            params.limit = 16
            controller.searchParams = params
            
            controller.croppingEnabled = true
            controller.allowsLibraryAccess = true
            controller.delegate = self
            
            // copy other settings
            controller.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
            controller.filterItems = AppDelegate.loadFilterItemsFromPlist()
            
            // configure product image size
            controller.imageConfig.contentMode = .scaleAspectFill
            controller.priceConfig.isStrikeThrough = true
            
            controller.productCardBorderColor = UIColor.lightGray
            controller.productCardBorderWidth = 0.7
            controller.itemSpacing = 0
            controller.rowSpacing = 0
            
            // configure product image size and product card size
            self?.configureSize(controller: controller)
            
            // set to same delegate
            //controller.delegate = self
            self?.navigationController?.pushViewController(controller, animated: true)
            
            controller.refreshData()
            
            self?.dismiss(animated: false, completion: nil)
            
        }
        
        present(cameraViewController, animated: true, completion: nil)
        
    }


    func searchFailed(sender: AnyObject, searchType: ViSearchType , err: Error?, apiErrors: [String]) {
        if err != nil {
            // network error.. handle error if necessary
            //alert (message: "error: \(err.localizedDescription)")
        }
            
        else if apiErrors.count > 0 {
            // handle API errors if necessary
            //alert (message: "api error: \(apiErrors.joined(separator: ",") )")
        }
    }
    
    // update orientation
    func controllerWillTransition(controller: UIViewController , to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { context in
            if controller is ViGridSearchViewController {
                self.configureSize(controller: controller as! ViGridSearchViewController)
                (controller as? ViGridSearchViewController)?.collectionView?.reloadData()
            }
        }, completion: { context in
            
            // after rotate
            
        })
        
    }
    
    // MARK: controller configuration
    
    // configure controller size during different orientation
    public func configureSize(controller: ViGridSearchViewController) {
        let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
        let numOfColumns = isPortrait ? 2 : 4
        let containerWidth = UIScreen.main.bounds.size.width
        
        let imageWidth = isPortrait ? (UIScreen.main.bounds.size.width / 2.5) : (UIScreen.main.bounds.size.width / 4.5)
        let imageHeight = imageWidth * 1.2
        
        controller.imageConfig.size = CGSize(width: imageWidth, height: imageHeight )
        controller.itemSpacing = 0
        controller.rowSpacing = 0
        
        // this must be called last after setting schema mapping
        // the item size is dynamic and depdend on schema mapping
        // For example, if label is not provided, then the estimated height would be shorter
        controller.itemSize = controller.estimateItemSize(numOfColumns: numOfColumns, containerWidth: containerWidth)
    }
    
    

}
