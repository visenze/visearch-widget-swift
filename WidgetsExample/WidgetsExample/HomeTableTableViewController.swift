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
    
    func showSearchImageController() {
        
        
        let cameraViewController = CameraViewController(croppingEnabled: false, allowsLibraryAccess: true) { [weak self] image, asset in

            
            self?.dismiss(animated: true, completion: nil)
            
            // user cancel photo taking
            if( image == nil) {
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
            
            // copy other settings
            controller.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
            controller.filterItems = AppDelegate.loadFilterItemsFromPlist()
            
            
            let containerWidth = self!.view.bounds.width
            
            let imageWidth = containerWidth / 2.5
            let imageHeight = imageWidth * 1.2
            
            // configure product image size
            controller.imageConfig.size = CGSize(width: imageWidth, height: imageHeight )
            controller.imageConfig.contentMode = .scaleAspectFill
            controller.priceConfig.isStrikeThrough = true
            
            controller.productCardBorderColor = UIColor.lightGray
            controller.productCardBorderWidth = 0.7
            controller.itemSpacing = 0
            controller.rowSpacing = 0
            
            controller.itemSize = controller.estimateItemSize(numOfColumns: 2, containerWidth: containerWidth)
            
            // set to same delegate
            controller.delegate = self
            self?.navigationController?.pushViewController(controller, animated: true)
            
            controller.refreshData()
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    func showSimilarController(_ im_name: String) {
        if let params = ViSearchParams(imName: im_name) {
            
            let similarController = ViFindSimilarViewController()
            
            params.limit = 16
            
            similarController.searchParams = params
            
            // copy other settings
            similarController.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
            similarController.filterItems = AppDelegate.loadFilterItemsFromPlist()
            
            
            let containerWidth = self.view.bounds.width
            
            let imageWidth = containerWidth / 2.5
            let imageHeight = imageWidth * 1.2
            
            // configure product image size
            similarController.imageConfig.size = CGSize(width: imageWidth, height: imageHeight )
            similarController.imageConfig.contentMode = .scaleAspectFill
            similarController.priceConfig.isStrikeThrough = true
            
            similarController.productCardBorderColor = UIColor.lightGray
            similarController.productCardBorderWidth = 0.7
            similarController.itemSpacing = 0
            similarController.rowSpacing = 0
            
            similarController.itemSize = similarController.estimateItemSize(numOfColumns: 2, containerWidth: containerWidth)
            
            // set to same delegate
            similarController.delegate = self
            self.navigationController?.pushViewController(similarController, animated: true)
            
            similarController.refreshData()
            
        }

    }
    
    func showColorSearchController(_ color: String) {
        
        if let params = ViColorSearchParams(color: color){
            let controller = ViColorSearchViewController()
            params.limit = 16
            
            controller.searchParams = params
            
            // copy other settings
            controller.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
            
            controller.filterItems = AppDelegate.loadFilterItemsFromPlist()
            
            let containerWidth = self.view.bounds.width
            
            let imageWidth = containerWidth / 2.5
            let imageHeight = imageWidth * 1.2
            
            // configure product image size
            controller.imageConfig.size = CGSize(width: imageWidth, height: imageHeight )
            controller.imageConfig.contentMode = .scaleAspectFill
            controller.priceConfig.isStrikeThrough = true
            
            controller.productCardBorderColor = UIColor.lightGray
            controller.productCardBorderWidth = 0.7
            controller.itemSpacing = 0
            controller.rowSpacing = 0
            
            controller.itemSize = controller.estimateItemSize(numOfColumns: 2, containerWidth: containerWidth)
            
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
    
    func searchFailed(err: Error?, apiErrors: [String]) {
        if let err = err {
            // most likely network error
            alert (message: "error: \(err.localizedDescription)")
        }
        
        else if apiErrors.count > 0 {
            alert (message: "api error: \(apiErrors.joined(separator: ",") )")
        }
    }
    
}
