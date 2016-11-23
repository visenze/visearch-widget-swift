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
    
    /// configure the collectionview cell before displaying
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath , cell: UICollectionViewCell)
    
    /// configure the layout if necessary
    func configureLayout(layout: UICollectionViewFlowLayout)
    
    /// product selection notification
    func didSelectProduct(collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct)
    
    /// action button tapped
    func actionBtnTapped(collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct)
    
    /// find similar button tapped
    func similarBtnTapped(collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct)
    
    /// successful search
    func searchSuccess( searchType: ViAPIEndPoints, reqId: String? , products: [ViProduct])
    
    /// failure search handler
    func searchFailed(err: Error?, apiErrors: [String])
    
}

// make all method optional
public extension ViSearchViewControllerDelegate{
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath , cell: UICollectionViewCell) {}
    func configureLayout(layout: UICollectionViewFlowLayout) {}
    func didSelectProduct(collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){}
    func actionBtnTapped(collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){}
    func similarBtnTapped(collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){}
    func searchSuccess( searchType: ViAPIEndPoints, reqId: String? , products: [ViProduct]){}
    func searchFailed(err: Error?, apiErrors: [String]){}
}

// subclass implementation
public protocol ViSearchViewControllerProtocol: class {
    // configure the flow layout
    func reloadLayout() -> Void
    
    // call Visearch API and refresh data
    func refreshData() -> Void
    
    // return custom footer view if necessary
    func footerView() -> UIView?
    
    // return custom header view if necessary
    func headerView() -> UIView?
    
}

open class ViBaseSearchViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ViSearchViewControllerProtocol, ViProductCellDelegate {
    
    public var collectionView : UICollectionView? {
        let resultsView = self.view as! ViSearchResultsView
        return resultsView.collectionView
    }
    
    public var collectionViewLayout: UICollectionViewLayout {
        let resultsView = self.view as! ViSearchResultsView
        return resultsView.collectionViewLayout
    }
    
    // for the title of the widget .. will be shown in header view
    public var titleLabel : UILabel?
    
    public weak var delegate: ViSearchViewControllerDelegate?
    
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
    
    // whether to enable Power by Visenze logo
    public var showPowerByViSenze : Bool = true
    
    // actual data
    public var products: [ViProduct] = [] {
        didSet {
            // make sure that this is run on ui thread
            DispatchQueue.main.async {
                self.reloadLayout()
            }
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
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK : setup method, can be override by subclass to do init
    open func setup(){
        self.titleLabel = UILabel()
        self.titleLabel?.textAlignment = .left
        self.titleLabel?.font = ViTheme.sharedInstance.default_widget_title_font
    }
    
    open override func loadView() {
        let searchResultsView = ViSearchResultsView(frame: .zero)
        self.view = searchResultsView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        
        // Register cell classes
        self.collectionView!.register(ViProductCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        reloadLayout()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ViProductCollectionViewCell
        
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
            cell.delegate = self
            
            if self.hasSimilarBtn {
                // wire up similar button action
                if let similarBtn = productView.viewWithTag(ViProductCardTag.findSimilarBtnTag.rawValue) as? UIButton {
                    // add event
                    similarBtn.addTarget(cell, action: #selector(ViProductCollectionViewCell.similarBtnTapped(sender:)), for: .touchUpInside)
                }
            }
            
            if self.hasActionBtn {
                // wire up similar button action
                if let actionBtn = productView.viewWithTag(ViProductCardTag.actionBtnTag.rawValue) as? UIButton {
                    // add event
                    actionBtn.addTarget(cell, action: #selector(ViProductCollectionViewCell.actionBtnTapped(sender:)), for: .touchUpInside)
                }
            }
            
        }
        
        if let delegate = delegate {
            delegate.configureCell(collectionView: collectionView, indexPath: indexPath, cell: cell)
        }
      
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            let product = products[indexPath.row]
            delegate.didSelectProduct(collectionView: collectionView, indexPath: indexPath, product: product)
        }
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
    
    
    
    /// to be override by subclasses. Subclass must call delegate configureLayout to allow further customatization
    open func reloadLayout(){
       
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        self.collectionView?.backgroundColor = backgroundColor
        layout.itemSize = itemSize
        
        
        let searchResultsView = self.view as! ViSearchResultsView
        
        // static header
        if self.headerSize.height > 0 {
            if let headerView = self.headerView() {
                searchResultsView.setHeader(headerView)
            }
        }
        searchResultsView.headerHeight = self.headerSize.height
        
        // static footer
        if self.footerSize.height > 0 {
            if let footerView = self.footerView() {
                searchResultsView.setFooter(footerView)
            }
        }
        searchResultsView.footerHeight = self.footerSize.height
          
    }
    
    /// to be implemented by subclasses
    open func refreshData(){}
    
   
    /// MARK: header
    
    open var headerSize : CGSize {
        if self.title != nil {
            return CGSize(width: self.view.bounds.width, height: ViTheme.sharedInstance.default_widget_title_font.lineHeight + 4)
        }
        return .zero
    }
    
    open func headerView() -> UIView? {
        if let title = self.title, let label = self.titleLabel {
            label.text = title
            label.sizeToFit()
            
            return label
        }
        return nil
    }
    
    
    /// MARK: footer - Power by ViSenze
    open func footerView() -> UIView? {
        
        if !showPowerByViSenze {
            return nil
        }
        
        let powerImgView = UIImageView(image: ViIcon.power_visenze)
        
        var width = footerSize.width
        var height = footerSize.height
        
        if let img = ViIcon.power_visenze {
            width = min(width, img.size.width)
            height = min(height, img.size.height)
        }
        
        powerImgView.frame = CGRect(x: (self.view.bounds.width - width ), y: 4 , width: width, height: height )
        powerImgView.backgroundColor = ViTheme.sharedInstance.default_btn_background_color
        
        return powerImgView
    }
    
    open var footerSize : CGSize {
        
        if !showPowerByViSenze {
            return CGSize.zero
        }
        
        // hide footer if there is no product
        if self.products.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: 100, height: 25)
    }

    
    /// MARK: action buttons
    
    @IBAction open func similarBtnTapped(_ cell: ViProductCollectionViewCell) {
        if let indexPath = self.collectionView?.indexPath(for: cell) {
            let product = products[indexPath.row]
            delegate?.similarBtnTapped(collectionView: self.collectionView!, indexPath: indexPath, product: product)
            
        }
    }
    
    @IBAction open func actionBtnTapped(_ cell: ViProductCollectionViewCell) {
        if let indexPath = self.collectionView?.indexPath(for: cell) {
            let product = products[indexPath.row]
            delegate?.actionBtnTapped(collectionView: self.collectionView!, indexPath: indexPath, product: product)
        }
    }
    

}
