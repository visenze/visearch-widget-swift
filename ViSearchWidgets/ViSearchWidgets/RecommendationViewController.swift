//
//  RecommendationViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 8/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ViProductCardLayoutCell"

public protocol RecommendationViewControllerDelegate: class {
    func numOfProducts(controller: UIViewController ) -> Int
    func product(photoController: UIViewController, index: Int) -> ViProduct
}


open class RecommendationViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout{

    public var products: [ViProduct] = []
    
    public var itemSize: CGSize = .zero
    
    /// spacing between items on same row
    public var itemSpacing  : CGFloat = 4.0 {
        didSet{
            reloadLayout()
        }
    }
    
    /// MARK: init methods
    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        reloadLayout()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: UICollectionViewDataSource
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
//        let product = products[indexPath.row]
        
        ViButtonConfig.default_action_btn_config.tintColor = UIColor.red
        
        // testing
        let productCardLayout = ViProductCardLayout(
            img_url: URL(string: "http://images.asos-media.com/inv/media/2/7/6/9/6739672/black/image1xl.jpg")!,
            img_size: CGSize(width: self.view.bounds.width / 2, height: 150),
            img_contentMode: .scaleAspectFill,
            label: "ASOS \(indexPath.row)",
            heading: "Longline Coat \(indexPath.row) with Contrast Velvet Sleeves",
            price: 23.50,
            price_text_color: UIColor.gray,
            price_strike_through: true,
            discounted_price: 17.99
        )
        
        
        let productView = productCardLayout.arrangement( origin: .zero ,
                                                         width: itemSize.width ,
                                                         height: itemSize.height).makeViews(in: cell.contentView)
        
        productView.backgroundColor = UIColor.white
        
        return cell
    }
    
    // MARK: layout methods
    open func reloadLayout(){
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = itemSpacing
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.scrollDirection = .horizontal
        
        self.collectionView?.backgroundColor = UIColor.black
        
    }



}
