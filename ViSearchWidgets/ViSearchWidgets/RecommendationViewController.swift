//
//  RecommendationViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 8/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK

private let reuseIdentifier = "ViProductCardLayoutCell"

public protocol RecommendationViewControllerDelegate: class {
    func numOfProducts(controller: UIViewController ) -> Int
    func product(photoController: UIViewController, index: Int) -> ViProduct
}


open class RecommendationViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout{

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
    
    /// reload layout
    open func reloadLayout(){
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = itemSpacing
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.collectionView?.backgroundColor = backgroundColor
        layout.itemSize = itemSize
        
    }
    
    /// estimate product card item size based on image size in image config
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
    
    /// call ViSearch API and refresh the views
    open func refreshData() {
        if let searchParams = searchParams {
            
            // construct the fl based on schema mappings
            // need to merge the array to make sure that the returned data contain the relevant meta data in mapping
            let metaArr = self.schemaMapping.getMetaArrForSearch()
            let combinedArr = searchParams.fl + metaArr
            let flSet = Set(combinedArr)
            searchParams.fl = Array(flSet)
            
            ViSearch.sharedInstance.recommendation(
                params: searchParams,
                successHandler: {
                    (data : ViResponseData?) -> Void in
                    // check ViResponseData.hasError and ViResponseData.error for any errors return by ViSenze server
                    if let data = data {
                        if data.hasError {
                            let errMsgs =  data.error.joined(separator: ",")
                            print("Recommendation API error: \(errMsgs)")
                            
                            // TODO: display system busy message here
                            
                        }
                        else {
                            // display and refresh here
                            self.reqId = data.reqId
                            self.products = ViSchemaHelper.parseProducts(mapping: self.schemaMapping, data: data)
                            
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                            }
                            
                        }
                    }

            },
                failureHandler: {
                    (err) -> Void in
                    // Do something when request fails e.g. due to network error
                    print ("error: \\(err.localizedDescription)")
                    // TODO: display error message and tap to try again
            })
        }
        else {
            
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: Please setup search parameters to refresh data.")
            
        }
    }



}
