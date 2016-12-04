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

    public var im_name : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedRecSegue" {
            
            if let im_name = self.im_name {
                let controller = segue.destination as! ViRecommendationViewController
                
                controller.delegate = self
                let containerWidth = self.view.bounds.width
                
                // this will let 2.5 images appear on screen
                let imageWidth = controller.estimateItemWidth(2.5, containerWidth: containerWidth)
                let imageHeight = imageWidth * 1.2
                
                // configure product image size
                controller.imageConfig.size = CGSize(width: imageWidth, height: imageHeight )
                controller.imageConfig.contentMode = .scaleAspectFill
                
                // configure search parameter
                controller.searchParams = ViSearchParams(imName: im_name)
                
                // to retrieve more meta data , configure the below
    //            controller.searchParams?.fl = ["category"]
                
                // configure schema mapping to product UI elements
                
//                controller.schemaMapping.heading = "im_title"
//                controller.schemaMapping.label = "brand"
//                controller.schemaMapping.price = "price"
                
                controller.schemaMapping = AppDelegate.loadSampleSchemaMappingFromPlist()

                // configure discount price if necessary
                controller.schemaMapping.discountPrice = "price"
                controller.priceConfig.isStrikeThrough = true
                
    //            controller.backgroundColor = UIColor.black
                controller.paddingLeft = 8.0
                
                // IMPORTANT: this must be called last after schema mapping as we calculate the item size based on whether a field is available
                // e.g. if label is nil in the mapping, then it will not be included in the height calculation of product card
                controller.itemSize = controller.estimateItemSize()
                
                controller.refreshData()
                
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

    func willShowSimilarControler(sender: AnyObject, controller: ViFindSimilarViewController, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){
        
        // set border for find similar
//        controller.productCardBorderWidth = 0.7
//        controller.productCardBorderColor = UIColor.lightGray
//        controller.productBorderStyles = [.BOTTOM, .RIGHT]
        
//        controller.itemSpacing = 0
        // must recalculate item width
//        controller.setItemWidth(numOfColumns: 2, containerWidth: self.view.bounds.width)
        controller.hasActionBtn = false
//        controller.rowSpacing = 0
//        controller.showQueryProduct = false
        
    }
    

}
