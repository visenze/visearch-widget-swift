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
    
    // record the time for some basic performance tests
    let findSimilarStopWatch = StopWatch(name: "findSimilar")
    let imageSearchStopWatch = StopWatch(name: "imageSearch")
    let colorSearchStopWatch = StopWatch(name: "colorSearch")
    
    // number of cell to display when we stop the timer i.e. after 4 cells display, we stop the timer
    var numOfCellsToTrack : Int = 4
    var curNumOfDisplayedCell: Int = 0
    
    // only record for first search
    var firstSearch : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check if client setup properly
        if !ViSearch.sharedInstance.isClientSetup() {
            alert(message: "Please setup the API client with app key or access/secret key", title: "Error")
            
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
        
        self.firstSearch = true
        
        let cameraViewController = CameraViewController(croppingEnabled: false, allowsLibraryAccess: true) { [weak self] image, asset in

            // user cancel photo taking
            if( image == nil) {
                self?.dismiss(animated: false, completion: nil)
                
                return
            }
            
            print("======= Start Image Search =================")
            
            self?.curNumOfDisplayedCell = 0
            self?.imageSearchStopWatch.reset()
            self?.imageSearchStopWatch.resume()
            
            let controller = ViSearchImageViewController()
            
            // save recent photo
            controller.asset = asset
            
            let params = ViUploadSearchParams(image: image!)
            // upload higher res image i.e. max 1024
            params.img_settings = ViImageSettings(setting: .highQualitySetting)
            params.limit = self!.limit
            // for retriveing additional meta data e.g. for displaying in detail page
            // params.fl = ["category"]
            
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
        
        self.firstSearch = true
    
        if let params = ViSearchParams(imName: im_name) {
            self.curNumOfDisplayedCell = 0
            print("======= Start Similar Search =================")
            findSimilarStopWatch.reset()
            findSimilarStopWatch.resume()
            
            let similarController = ViFindSimilarViewController()
            
            params.limit = self.limit
            // for retriveing additional meta data e.g. for displaying in detail page
//            params.fl = ["category"]
            
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
        
        self.firstSearch = true
        
        if let params = ViColorSearchParams(color: color){
            print("======= Start Color Search =================")
            
            self.curNumOfDisplayedCell = 0
            colorSearchStopWatch.reset()
            colorSearchStopWatch.resume()
            
            let controller = ViColorSearchViewController()
            params.limit = self.limit
            // for retriveing additional meta data e.g. for displaying in detail page
            // params.fl = ["category"]
            
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
        
        // print out meta dict. you can use this for displaying product details
        if let dict = product.metadataDict {
            print("\(dict)")
        }
        
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
            
            //alert (message: "error: \(err!.localizedDescription)")
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
    
    func configureCell(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath , cell: UICollectionViewCell) {
        
        if self.firstSearch {
            self.curNumOfDisplayedCell += 1
            
            if self.curNumOfDisplayedCell == self.numOfCellsToTrack {
                if sender is ViFindSimilarViewController {
                    
                    self.findSimilarStopWatch.pause()
                    print("Time taken for findSimilar display (in second): \(self.findSimilarStopWatch.elapsedTimeStep) , number of displayed cell: \(self.curNumOfDisplayedCell) ")
                    
                    print("Total time taken (in second): \(self.findSimilarStopWatch.elapsedTime) ")
                    
                    print("===== End Similar Search ============")
                }
                else if sender is ViColorSearchViewController {
                    
                    self.colorSearchStopWatch.pause()
                    print("Time taken for colorSearch display (in second): \(self.colorSearchStopWatch.elapsedTimeStep) , number of displayed cell: \(self.curNumOfDisplayedCell) ")
                    
                    print("Total time taken (in second): \(self.colorSearchStopWatch.elapsedTime) ")
                    
                    print("===== End Color Search ============")
                }
                else if sender is ViSearchImageViewController {
                    
                    self.imageSearchStopWatch.pause()
                    print("Time taken for imageSearch display (in second): \(self.imageSearchStopWatch.elapsedTimeStep) , number of displayed cell: \(self.curNumOfDisplayedCell) ")
                    
                    print("Total time taken (in second): \(self.imageSearchStopWatch.elapsedTime) ")
                    
                    print("===== End Image Search ============")
                }
                self.firstSearch = false
                
            }
        }
        
        
    }
    
    func searchSuccess( sender: AnyObject, searchType: ViSearchType, reqId: String? , products: [ViProduct])
    {
        if !self.firstSearch {
            return
        }
        
        if sender is ViFindSimilarViewController {
            
            // show elasped time
            self.findSimilarStopWatch.pause()
            print("Time taken for findSimilar API search (in second): \(self.findSimilarStopWatch.elapsedTime)")
            self.findSimilarStopWatch.resume()
        }
        else if sender is ViColorSearchViewController {
            
            // show elasped time
            self.colorSearchStopWatch.pause()
            print("Time taken for colorSearch API search (in second): \(self.colorSearchStopWatch.elapsedTime)")
            self.colorSearchStopWatch.resume()
            
        }
        else if sender is ViSearchImageViewController {
            
            // show elasped time
            self.imageSearchStopWatch.pause()
            print("Time taken for imageSearch API search (in second): \(self.imageSearchStopWatch.elapsedTime)")
            self.imageSearchStopWatch.resume()
            
        }
        
    }
    
   
    
}
