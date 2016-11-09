//
//  ViewController.swift
//  WidgetsExample
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchWidgets

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
        
//        ViLabelConfig.default_label_config = ViLabelConfig(font: ViFont.bold(with: 26.0))

        
        let productView = productCardLayout.arrangement( origin: CGPoint(x: 10, y: 20) ,
                                       width: self.view.bounds.width / 2 ).makeViews()
        
        productView.backgroundColor = UIColor.white
        
        self.view.addSubview(productView)
        self.view.backgroundColor = UIColor.blue
        
        testRecController()
        
    }
    
    private func testRecController() {
        
        let prod = ViProduct(image: ViIcon.find_similar!, price: 3.0)
        let products : [ViProduct] = [ViProduct](repeating: prod, count: 1000)
        
        let controller = RecommendationViewController()
        controller.products = products
        controller.itemSize = CGSize(width: self.view.bounds.width / 2.5, height: 250)
        self.addChildViewController(controller)
        controller.view.frame = CGRect(x: 0, y: 320, width: self.view.bounds.width, height: 260)
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

