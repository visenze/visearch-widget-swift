//
//  BaseSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 10/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK

private let reuseIdentifier = "ViProductCardLayoutCell"

public protocol ViSearchViewControllerDelegate: class {
    func numOfProducts(controller: UIViewController ) -> Int
    func product(photoController: UIViewController, index: Int) -> ViProduct
}

// subclass implementation
public protocol ViSearchViewControllerProtocol: class {
    // configure the flow layout
    func reloadLayout() -> Void
    
    // call Visearch API and refresh data
    func refreshData() -> Void
}

open class ViBaseSearchViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout, ViSearchViewControllerProtocol {
    
    /// last known successful request Id to Visenze API
    public var reqId : String? = ""
    
    /// search parameters
    public var searchParams: ViSearchParams? = nil
    
    /// schema mappings to UI elements
    public var schemaMapping: ViProductSchemaMapping = ViProductSchemaMapping()
    
    // MARK: UI settings
    /// UI settings
    public var imageConfig: ViImageConfig = ViImageConfig()
    public var headingConfig: ViLabelConfig = ViLabelConfig.default_heading_config
    public var labelConfig: ViLabelConfig = ViLabelConfig.default_label_config
    public var priceConfig: ViLabelConfig = ViLabelConfig.default_price_config
    public var discountPriceConfig: ViLabelConfig = ViLabelConfig.default_discount_price_config
    
    // buttons
    public var hasSimilarBtn: Bool = true
    public var similarBtnConfig: ViButtonConfig = ViButtonConfig.default_similar_btn_config
    
    public var hasActionBtn: Bool = true
    public var actionBtnConfig: ViButtonConfig = ViButtonConfig.default_action_btn_config
    
    public var productCardBackgroundColor: UIColor = ViTheme.sharedInstance.default_product_card_background_color
    
    // actual data
    public var products: [ViProduct] = [] {
        didSet {
            reloadLayout()
        }
    }
    
    /// product card size
    public var itemSize: CGSize = CGSize(width: 10, height: 10) {
        didSet {
            reloadLayout()
        }
    }
    
    /// spacing between items on same row
    public var itemSpacing  : CGFloat = 4.0 {
        didSet{
            reloadLayout()
        }
    }
    
    /// background color
    public var backgroundColor  : UIColor = UIColor.white
    
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
        
        let product = products[indexPath.row]
        if let url =  product.imageUrl {
            let productCardLayout = ViProductCardLayout(
                imgUrl: url, imageConfig: self.imageConfig,
                heading: product.heading, headingConfig: self.headingConfig ,
                label: product.label, labelConfig: self.labelConfig,
                price: product.price, priceConfig: self.priceConfig,
                discountPrice: product.discountPrice, discountPriceConfig: self.discountPriceConfig,
                hasSimilarBtn: self.hasSimilarBtn, similarBtnConfig: self.similarBtnConfig,
                hasActionBtn: self.hasActionBtn, actionBtnConfig: self.actionBtnConfig,
                pricesHorizontalSpacing: ViProductCardLayout.default_spacing, labelLeftPadding: ViProductCardLayout.default_spacing)
            
            let productView = productCardLayout.arrangement( origin: .zero ,
                                                             width:  itemSize.width ,
                                                             height: itemSize.height).makeViews(in: cell.contentView)
            
            productView.backgroundColor = self.productCardBackgroundColor
        }
        return cell
    }
    
    // MARK : important methods
    
    /// estimate product card item size based on image size in image config
    /// override if necessary
    open func estimateItemSize() -> CGSize{
        
        let productCardLayout = ViProductCardLayout(
            imgUrl: nil, imageConfig: self.imageConfig,
            heading: self.schemaMapping.heading , headingConfig: self.headingConfig ,
            label: self.schemaMapping.label , labelConfig: self.labelConfig,
            price: (self.schemaMapping.price == nil ? nil : 0), priceConfig: self.priceConfig,
            discountPrice: (self.schemaMapping.discountPrice == nil ? nil : 0), discountPriceConfig: self.discountPriceConfig,
            hasSimilarBtn: self.hasSimilarBtn, similarBtnConfig: self.similarBtnConfig,
            hasActionBtn: self.hasActionBtn, actionBtnConfig: self.actionBtnConfig,
            pricesHorizontalSpacing: ViProductCardLayout.default_spacing, labelLeftPadding: ViProductCardLayout.default_spacing)
        
        return productCardLayout.arrangement(origin: .zero, width: self.imageConfig.size.width).frame.size
    }
    
    
    /// to be implemented by subclasses
    open func reloadLayout(){}
    
    /// to be implemented by subclasses
    open func refreshData(){}
    

}
