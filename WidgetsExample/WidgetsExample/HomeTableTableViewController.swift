//
//  HomeTableTableViewController.swift
//  WidgetsExample
//
//  Created by Hung on 10/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK
import ViSearchWidgets

class HomeTableTableViewController: UITableViewController , ViSearchViewControllerDelegate{
    
    let limit = 100
    
    static let COLOR_SEARCH: String = "Search by Color"
    static let FIND_SIMILAR_SEARCH: String = "Find Similar"
    static let YOU_MAY_ALSO_LIKE_SEARCH: String = "You May Also Like"
    static let IMAGE_SEARCH: String = "Search by Image"
    static let CUSTOM_SEARCH_BAR: String = "Custom Search Bar"
    
    var demoItems : [String] = [FIND_SIMILAR_SEARCH , YOU_MAY_ALSO_LIKE_SEARCH, IMAGE_SEARCH , COLOR_SEARCH, CUSTOM_SEARCH_BAR ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check if client setup properly
        if !ViSearch.sharedInstance.isClientSetup() {
            alert(message: "Please setup the API client with access and secret key", title: "Error")
            
            // remove all items
            demoItems.removeAll()
            self.tableView.reloadData()
        }
        
        super.viewDidAppear(animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "solutionTableViewCell", for: indexPath)
        
        cell.textLabel?.text = demoItems[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if demoItems[indexPath.row] == HomeTableTableViewController.IMAGE_SEARCH {
            self.showSearchImageController()
        }
        else if demoItems[indexPath.row] == HomeTableTableViewController.YOU_MAY_ALSO_LIKE_SEARCH {
            
            // prevent going to segue if demo im_name is not setup
            if self.loadImNameForRecommendation() != nil {
                self.performSegue(withIdentifier: "startRecSegue", sender: tableView.cellForRow(at: indexPath) )
            }
            else {
                alert(message: "Please configure the sample im_name in SampleData.plist")
            }
        }
        else if demoItems[indexPath.row] == HomeTableTableViewController.FIND_SIMILAR_SEARCH {
            //find_similar_im_name
            if let im_name = self.loadKey(key: "find_similar_im_name") {
                // load similar
                self.showSimilarController(im_name)
            }
            else {
                alert(message: "Please configure the sample im_name in SampleData.plist")
            }

        }
        else if demoItems[indexPath.row] == HomeTableTableViewController.COLOR_SEARCH {
            if let color = self.loadKey(key: "color") {
                self.showColorSearchController(color)
            }
            else {
                alert(message: "Please configure the sample color in SampleData.plist")
            }
        }
        else if demoItems[indexPath.row] == HomeTableTableViewController.CUSTOM_SEARCH_BAR {
            self.performSegue(withIdentifier: "showCustomSearch", sender: tableView.cellForRow(at: indexPath) )
        }
    }
    
    // MARK: - Navigation
    
    func showSearchImageController() {
        
        
        let cameraViewController = CameraViewController(croppingEnabled: false, allowsLibraryAccess: true) { [weak self] image, asset in

            // user cancel photo taking
            if( image == nil) {
                self?.dismiss(animated: false, completion: nil)
                
                return
            }
            
            let controller = ViSearchImageViewController()
            
            // save recent photo
            controller.asset = asset
            
            let params = ViUploadSearchParams(image: image!)
            // upload higher res image i.e. max 1024
            params.img_settings = ViImageSettings(setting: .highQualitySetting)
            params.limit = self!.limit
            controller.searchParams = params
            
            controller.croppingEnabled = true
            controller.allowsLibraryAccess = true
            
            // copy other settings
            controller.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
            controller.filterItems = AppDelegate.loadFilterItemsFromPlist()
            
            controller.imageConfig.contentMode = .scaleAspectFill
            
            if controller.schemaMapping.discountPrice != nil  {
                if controller.schemaMapping.discountPrice!.characters.count > 0 {
                    controller.priceConfig.isStrikeThrough = true
                }
            }
            
            controller.productCardBorderColor = UIColor.lightGray
            controller.productCardBorderWidth = 0.7
            
            // configure product image size and product card size
            self?.configureSize(controller: controller)
            
            
            // set to same delegate
            controller.delegate = self
            self?.navigationController?.pushViewController(controller, animated: true)
            
            controller.refreshData()
            
            self?.dismiss(animated: false, completion: nil)
            
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    func showSimilarController(_ im_name: String) {
        if let params = ViSearchParams(imName: im_name) {
            
            let similarController = ViFindSimilarViewController()
            
            params.limit = self.limit
            
            similarController.searchParams = params
            
            // copy other settings
            similarController.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
            similarController.filterItems = AppDelegate.loadFilterItemsFromPlist()
            
            similarController.imageConfig.contentMode = .scaleAspectFill
            
            if similarController.schemaMapping.discountPrice != nil  {
                if similarController.schemaMapping.discountPrice!.characters.count > 0 {
                    similarController.priceConfig.isStrikeThrough = true
                }
            }

            similarController.productCardBorderColor = UIColor.lightGray
            similarController.productCardBorderWidth = 0.7
            
            // configure product image size and product card size
            self.configureSize(controller: similarController)
            
            // set to same delegate
            similarController.delegate = self
            self.navigationController?.pushViewController(similarController, animated: true)
            
            similarController.refreshData()
            
        }

    }
    
    func showColorSearchController(_ color: String) {
        
        if let params = ViColorSearchParams(color: color){
            let controller = ViColorSearchViewController()
            params.limit = self.limit
            
            controller.searchParams = params
            
            // copy other settings
            controller.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
            
            controller.filterItems = AppDelegate.loadFilterItemsFromPlist()
            
            controller.imageConfig.contentMode = .scaleAspectFill
            
            if controller.schemaMapping.discountPrice != nil  {
                if controller.schemaMapping.discountPrice!.characters.count > 0 {
                    controller.priceConfig.isStrikeThrough = true
                }
            }

            controller.productCardBorderColor = UIColor.lightGray
            controller.productCardBorderWidth = 0.7
           
            // configure product image size and product card size
            self.configureSize(controller: controller)
            
            // set to same delegate
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            
            controller.refreshData()
        }
        else {
            // color is probably invald
            alert(message: "Invalid color code. Please check value in SampleData.plist")
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "startRecSegue" {
            // load im_name for recommendation from plist file
            let controller = segue.destination as! YouMayLikeViewController
            controller.im_name = self.loadImNameForRecommendation()!
            
            // Get the cell that generated this segue.
//            if let selectedCell = sender as? UITableViewCell {   
//            }
        }
       
        // hide the back label in the next controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
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
        
//        print("size: \(controller.itemSize)")
    }
    
    // MARK: load sample data
    public func loadImNameForRecommendation() -> String? {
        return self.loadKey(key: "you_may_like_im_name")
    }
    
    // find_similar_im_name
    public func loadKey(key: String) -> String? {
        if let path = Bundle.main.path(forResource: "SampleData", ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: path)
            
            return dict![key] as? String
        }
        else {
            print("Unable to load SampleData keys plist. Please copy/add SampleData.plist to the project and configure the sample im_names ")
        }
        
        return nil
    }
    
    // MARK: ViSearchViewControllerDelegate
    func didSelectProduct(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct) {
        alert(message: "select product with im_name: \(product.im_name)" )
    }
    
    func actionBtnTapped(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){
        alert(message: "action button tapped , product im_name: \(product.im_name)" )
    }
    
    func similarBtnTapped(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){
        print("similar button tapped , product im_name: \(product.im_name)")
        
    }
    
    func searchFailed(sender: AnyObject, searchType: ViSearchType ,  err: Error?, apiErrors: [String]) {
        if err != nil {
            // network-related error
            // handle error here if necessary
            
            //alert (message: "error: \(err.localizedDescription)")
        }
        
        else if apiErrors.count > 0 {
            // api related error
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
    
}
