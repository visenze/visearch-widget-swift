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
    
    var demoItems : [String] = [FIND_SIMILAR_SEARCH , YOU_MAY_ALSO_LIKE_SEARCH, IMAGE_SEARCH , COLOR_SEARCH ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check if client setup properly
        if !ViSearch.sharedInstance.isClientSetup() {
            alert(message: "Please setup the API client with access and secret key", title: "Error")
            
            // remove all items
            demoItems.removeAll()
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
//            self.performSegue(withIdentifier: "showImageSearch", sender: self)
        }
        else if demoItems[indexPath.row] == HomeTableTableViewController.YOU_MAY_ALSO_LIKE_SEARCH {
            
            // prevent going to segue if demo im_name is not setup
            if let im_name = self.loadImNameForRecommendation() {
                self.performSegue(withIdentifier: "startRecSegue", sender: tableView.cellForRow(at: indexPath) )
            }
            else {
                alert(message: "Please configure the sample im_name in SampleData.plist")
            }
        }
        else if demoItems[indexPath.row] == HomeTableTableViewController.FIND_SIMILAR_SEARCH {
            //find_similar_im_name
            if let im_name = self.loadImName(key: "find_similar_im_name") {
                // load similar
                self.showSimilarController(im_name)
            }
            else {
                alert(message: "Please configure the sample im_name in SampleData.plist")
            }

        }
    }
    
    // MARK: - Navigation
    func showSimilarController(_ im_name: String) {
        if let params = ViSearchParams(imName: im_name) {
            
            let similarController = ViFindSimilarViewController()
            
            params.limit = 16
            
            similarController.searchParams = params
            
            // copy other settings
            similarController.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()
            let containerWidth = self.view.bounds.width
            
            let imageWidth = containerWidth / 2.5
            let imageHeight = imageWidth * 1.2
            
            // configure product image size
            similarController.imageConfig.size = CGSize(width: imageWidth, height: imageHeight )
            similarController.imageConfig.contentMode = .scaleAspectFill
            similarController.priceConfig.isStrikeThrough = true
            
            similarController.itemSize = similarController.estimateItemSize(numOfColumns: 2, containerWidth: containerWidth)
            
//            similarController.productCardBorderColor = UIColor.lightGray
//            similarController.productCardBorderWidth = 0.5
            
            // set to same delegate
            similarController.delegate = self
            self.navigationController?.pushViewController(similarController, animated: true)
            
            similarController.refreshData()
            
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
            if let selectedCell = sender as? UITableViewCell {
                
//                let indexPath = tableView.indexPath(for: selectedCell)!
//                let demoItem = demoItems[indexPath.row]
                
//                if demoItem == HomeTableViewController.COLOR_SEARCH {
//                    searchController.demoApi = ViAPIEndPoints.COLOR_SEARCH
//                }
//                else if demoItem == HomeTableViewController.FIND_SIMILAR_SEARCH {
//                    searchController.demoApi = ViAPIEndPoints.ID_SEARCH
//                }
//                else if demoItem == HomeTableViewController.YOU_MAY_ALSO_LIKE_SEARCH {
//                    searchController.demoApi = ViAPIEndPoints.REC_SEARCH
//                }
//                
//                searchController.navigationItem.title = demoItem
                
            }
        }
       
        
        // hide the back label in the next controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        
    }
    
    // MARK: load sample data
    public func loadImNameForRecommendation() -> String? {
        return self.loadImName(key: "you_may_like_im_name")
    }
    
    // find_similar_im_name
    public func loadImName(key: String) -> String? {
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
    
}
