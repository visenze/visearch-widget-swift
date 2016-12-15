//
//  YouMayLikeViewController.swift
//  WidgetsExample
//
//  Created by Hung on 11/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK
import ViSearchWidgets

class YouMayLikeViewController: UIViewController, ViSearchViewControllerDelegate {

    // for some basic time tracking
    let recStopWatch = StopWatch(name: "Recommendation")
    // only record for first search
    var firstSearch : Bool = true
    
    // number of cell to display when we stop the timer i.e. after 4 cells display, we stop the timer
    var numOfCellsToTrack : Int = 3
    var curNumOfDisplayedCell: Int = 0
    
    public var im_name : String?
    var controller: ViRecommendationViewController? = nil
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
       super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedRecSegue" {
            
            if let im_name = self.im_name {
                if let controller = segue.destination as? ViRecommendationViewController {
                    
                    self.firstSearch = true
                    self.curNumOfDisplayedCell = 0
                    print("======= Start You May Also Like Search =================")
                    recStopWatch.reset()
                    recStopWatch.resume()
                    
                    self.controller = controller
                    controller.delegate = self
                    
                    controller.imageConfig.contentMode = .scaleAspectFill
                    
                    // configure search parameter
                    controller.searchParams = ViSearchParams(imName: im_name)
                    controller.searchParams?.limit = 16
                    
                    // to retrieve more meta data , configure the below
        //            controller.searchParams?.fl = ["category"]
                    
                    // configure schema mapping to product UI elements
                    
    //                controller.schemaMapping.heading = "im_title"
    //                controller.schemaMapping.label = "brand"
    //                controller.schemaMapping.price = "price"
                    
                    controller.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()

                    // configure discount price if necessary
                    if controller.schemaMapping.discountPrice != nil  {
                        if controller.schemaMapping.discountPrice!.characters.count > 0 {
                            controller.priceConfig.isStrikeThrough = true
                        }
                    }
                    
        //            controller.backgroundColor = UIColor.black
                    controller.paddingLeft = 8.0
                    
                    // configure product image size and item size
                    self.configureSize(controller: controller)
                    
                    controller.refreshData()
                }
            }
            else {
                alert(message: "Please set up im_name in SampleData.plist")
            }
            
        }
        
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

    func willShowSimilarController(sender: AnyObject, controller: ViFindSimilarViewController, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){
        
        // only do this from current controller
        if sender is ViRecommendationViewController {
            controller.itemSpacing = 0
            controller.rowSpacing = 0
            controller.productCardBorderWidth = 0.7
            controller.productCardBorderColor = UIColor.lightGray

            self.configureSimilarSize(controller: controller)
            
            controller.filterItems = AppDelegate.loadFilterItemsFromPlist()
            controller.delegate = self
        }
        
    }
    
    func searchFailed(sender: AnyObject, searchType: ViSearchType , err: Error?, apiErrors: [String]) {
        if err != nil {
            // network error.. display custom error if necessary
            //alert (message: "error: \(err.localizedDescription)")
        }
            
        else if apiErrors.count > 0 {
            // network error.. display custom error if necessary
            //alert (message: "api error: \(apiErrors.joined(separator: ",") )")
        }
    }
    
    // configular the similar controller after clicking on find similar button
    func controllerWillTransition(controller: UIViewController , to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { context in
            // during rotate
            if controller is ViGridSearchViewController {
                self.configureSimilarSize(controller: controller as! ViGridSearchViewController)
                (controller as? ViGridSearchViewController)?.collectionView?.reloadData()
            }
            else if controller is ViRecommendationViewController {
                
            }
            
        }, completion: { context in
            
            // after rotate
            
        })
        
    }
    
    func searchSuccess( sender: AnyObject, searchType: ViSearchType, reqId: String? , products: [ViProduct])
    {
        if !self.firstSearch {
            return
        }
        
        if sender is ViRecommendationViewController {
            
            // show elasped time
            self.recStopWatch.pause()
            print("Time taken for recommendation API search (in second): \(self.recStopWatch.elapsedTime)")
            self.recStopWatch.resume()
        }
       
    }
    
    func configureCell(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath , cell: UICollectionViewCell) {
        
        if self.firstSearch {
            self.curNumOfDisplayedCell += 1
            
            if self.curNumOfDisplayedCell == self.numOfCellsToTrack {
                if sender is ViRecommendationViewController {
                    
                    self.recStopWatch.pause()
                    print("Time taken for recommendation display (in second): \(self.recStopWatch.elapsedTimeStep) , number of displayed cell: \(self.curNumOfDisplayedCell) ")
                    
                    print("Total time taken (in second): \(self.recStopWatch.elapsedTime) ")
                    
                    print("===== End You May Also Like Search ============")
                }
            
                self.firstSearch = false
                
            }
        }
        
        
    }

    
    
    //MARK: size configuration
    public func configureSize(controller: ViRecommendationViewController) {
        let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
        let containerWidth = self.view.bounds.width
        
        // this will let 2.5 images appear on screen for portrait and 4.5 for landscape
        let imageWidth = controller.estimateItemWidth(isPortrait ? 2.5 : 4.5, containerWidth: containerWidth)
        let imageHeight = min(imageWidth * 1.2, 140 )
        
        // configure product image size
        controller.imageConfig.size = CGSize(width: imageWidth, height: imageHeight )
        
        // IMPORTANT: this must be called last after schema mapping as we calculate the item size based on whether a field is available
        // e.g. if label is nil in the mapping, then it will not be included in the height calculation of product card
        controller.itemSize = controller.estimateItemSize()
        
        self.containerHeightConstraint.constant = controller.itemSize.height + 70
    }
    
    // configure similar controller size during different orientation i.e. when user clicks on Find Similar button
    public func configureSimilarSize(controller: ViGridSearchViewController) {
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
        
        // print("size: \(controller.itemSize)")
    }


    
    

}
