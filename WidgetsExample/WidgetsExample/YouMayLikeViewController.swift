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
                let controller = segue.destination as! ViRecommendationViewController
                
                controller.delegate = self
                
                let imageWidth = self.view.bounds.width / 2.5
                let imageHeight = imageWidth * 1.2
                
                // configure product image size
                controller.imageConfig.size = CGSize(width: imageWidth, height: imageHeight )
                controller.imageConfig.contentMode = .scaleToFill
                
                // configure search parameter
                controller.searchParams = ViSearchParams(imName: im_name)
                
                // to retrieve more meta data , configure the below
    //            controller.searchParams?.fl = ["category"]
                
                // configure schema mapping to product UI elements
                controller.schemaMapping.heading = "im_title"
                controller.schemaMapping.label = "brand"
                controller.schemaMapping.price = "price"

                // configure discount price if necessary
                controller.schemaMapping.discountPrice = "price"
                controller.priceConfig.isStrikeThrough = true
                
    //            controller.backgroundColor = UIColor.black
                
                // IMPORTANT: this must be called last after schema mapping as we calculate based on whether a field is available
                // e.g. if label is nil in the mapping, then it will not be included in the calculation
                controller.itemSize = controller.estimateItemSize()
                
                controller.collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: controller.itemSize.height )
                
                // update constraint to fit container view to the collection view exactly
                containerHeightConstraint.constant = controller.itemSize.height
                
                controller.refreshData()
            }
            else {
                alert(message: "Please set up im_name in SampleData.plist")
            }
            
        }
        
    }
    
    // MARK: ViSearchViewControllerDelegate
    func didSelectProduct(collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct) {
        alert(message: "select product with im_name: \(product.im_name)" )
    }
    

}
