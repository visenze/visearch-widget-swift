//
//  ViewController.swift
//  WidgetsExample
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchWidgets
import ViSearchSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test single product card
        let productCardLayout = ViProductCardLayout(
            img_url: URL(string: "http://images.asos-media.com/inv/media/2/7/6/9/6739672/black/image1xl.jpg")!,
            img_size: CGSize(width: self.view.bounds.width / 2, height: 200),
            img_contentMode: .scaleAspectFill,
            label: "ASOS Made In Kenya",
            heading: "Longline Coat with Contrast Velvet Sleeves",
            price: 2330.22,
            price_text_color: UIColor.gray,
            price_strike_through: true,
            discounted_price: 1799.99
        )
        
        let productView = productCardLayout.arrangement( origin: CGPoint(x: 10, y: 20) ,
                                       width: self.view.bounds.width / 2 ).makeViews()
        
        productView.backgroundColor = UIColor.white
        
        self.view.addSubview(productView)
        self.view.backgroundColor = UIColor.blue
        
        testRecController()
        
    }
    
    private func testRecController() {
        
        
        let controller = RecommendationViewController()
        

        controller.imageConfig.size = CGSize(width: self.view.bounds.width / 2.5, height: (self.view.bounds.width / 2.5) * 1.2 )
        controller.imageConfig.contentMode = .scaleToFill
        
        // optional: set item size
        // controller.itemSize = CGSize(width: self.view.bounds.width / 2.5, height: 250)
        controller.searchParams = ViSearchParams(imName: "HouseOfFraser-211740291")
        controller.searchParams?.fl = ["im_cate"]
        controller.searchParams?.queryInfo = true
        
        controller.schemaMapping.heading = "im_title"
        controller.schemaMapping.label = "brand"
        controller.schemaMapping.price = "price"
        
        controller.schemaMapping.discountPrice = "price"
        controller.priceConfig.isStrikeThrough = true
        
//        controller.backgroundColor = UIColor.black
        
        // must be called last after schema mapping as we calculate based on whether the field is available
        controller.itemSize = controller.estimateItemSize()
        
        controller.view.frame = CGRect(x: 0, y: 320, width: self.view.bounds.width, height: controller.itemSize.height )
        
        
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        
        controller.refreshData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

