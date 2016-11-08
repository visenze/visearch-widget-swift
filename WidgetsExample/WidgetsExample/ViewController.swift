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
        
        let productView = productCardLayout.arrangement( origin: CGPoint(x: 10, y: 80) ,
                                       width: self.view.bounds.width / 2 ).makeViews()
        
        productView.backgroundColor = UIColor.white
        
        // test views
//        for v in productView.subviews {
//            print("\(v)")
//        }
        
        self.view.addSubview(productView)
        
        self.view.backgroundColor = UIColor.blue
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

