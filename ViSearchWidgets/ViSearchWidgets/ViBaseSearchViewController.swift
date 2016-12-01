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

public enum ViSearchType : Int {
    
    case FIND_SIMILAR
    
    case YOU_MAY_ALSO_LIKE
    
    case SEARCH_BY_IMAGE
    
    case SEARCH_BY_COLOR
    
}

public enum ViBorderType : Int {
    case TOP
    case BOTTOM
    case LEFT
    case RIGHT
}

public protocol ViSearchViewControllerDelegate: class {
    
    /// configure the collectionview cell before displaying
    func configureCell(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath , cell: UICollectionViewCell)
    
    /// configure the layout if necessary
    func configureLayout(sender: AnyObject, layout: UICollectionViewFlowLayout)
    
    /// product selection notification
    func didSelectProduct(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct)
    
    /// action button tapped
    func actionBtnTapped(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct)
    
    /// allow configuration of the FindSimilar controller when similar button is tapped
    func willShowSimilarControler(sender: AnyObject, controller: ViFindSimilarViewController, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct)
    
    /// find similar button tapped
    func similarBtnTapped(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct)
    
    /// allow configuration of the filter controller before showing
    func willShowFilterControler(sender: AnyObject, controller: ViFilterViewController)
    
    /// successful search
    func searchSuccess( searchType: ViSearchType, reqId: String? , products: [ViProduct])
    
    /// failure search handler
    func searchFailed(err: Error?, apiErrors: [String])
    
}

// make all method optional
public extension ViSearchViewControllerDelegate{
    func configureCell(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath , cell: UICollectionViewCell) {}
    func configureLayout(sender: AnyObject, layout: UICollectionViewFlowLayout) {}
    func didSelectProduct(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){}
    func actionBtnTapped(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){}
    func similarBtnTapped(sender: AnyObject, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){}
    func willShowSimilarControler(sender: AnyObject, controller: ViFindSimilarViewController, collectionView: UICollectionView, indexPath: IndexPath, product: ViProduct){}
    
    func willShowFilterControler(sender: AnyObject, controller: ViFilterViewController){}
    
    func searchSuccess( searchType: ViSearchType, reqId: String? , products: [ViProduct]){}
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
    
    public let headerCollectionViewCellReuseIdentifier = "ViHeaderReuseCellId"
    
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
    public var showTitleHeader: Bool = true
    
    public weak var delegate: ViSearchViewControllerDelegate?
    
    /// last known successful request Id to Visenze API
    public var reqId : String? = ""
    
    /// search parameters
    public var searchParams: ViBaseSearchParams? = nil
    
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
    public var productCardBorderColor: UIColor? = nil
    public var productCardBorderWidth : CGFloat = 0
    /// default draw all borders
    public var productBorderStyles : [ViBorderType] = [.LEFT , .RIGHT , .BOTTOM , .TOP]
    
    
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
    public var itemSize: CGSize = CGSize(width: 1, height: 1) {
        didSet {
            reloadLayout()
        }
    }
    
    /// spacing between items on same row.. item size may need to be re-calculated if this change
    public var itemSpacing  : CGFloat = 4.0 {
        didSet{
            reloadLayout()
        }
    }
    
    /// background color
    public var backgroundColor  : UIColor = UIColor.white
    
    public var paddingLeft: CGFloat = 0 {
        didSet{
            reloadLayout()
        }
    }

    public var paddingRight: CGFloat = 0 {
        didSet{
            reloadLayout()
        }
    }

    // MARK: init methods
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
        
        // Important: without this the header above collection view will appear behind the navigation bar
        self.edgesForExtendedLayout = []
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
        self.collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCollectionViewCellReuseIdentifier)
        
        reloadLayout()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return .zero
    }
    
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
            
            if let borderColor = self.productCardBorderColor {
                if self.productBorderStyles.count == 4 {
                    productView.addBorder(width: self.productCardBorderWidth, color: borderColor)
                }
                else {
                    for style in self.productBorderStyles {
                        switch style {
                            case .BOTTOM:
                                productView.addBorderBottom(size: self.productCardBorderWidth, color: borderColor)
                            
                            case .LEFT:
                                productView.addBorderLeft(size: self.productCardBorderWidth, color: borderColor)
                            
                            case .RIGHT:
                                productView.addBorderRight(size: self.productCardBorderWidth, color: borderColor)
                            
                            case .TOP:
                                productView.addBorderTop(size: self.productCardBorderWidth, color: borderColor)
                            
                        }
                    }
                }

            }
            
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
            delegate.configureCell(sender: self, collectionView: collectionView, indexPath: indexPath, cell: cell)
        }
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            let product = products[indexPath.row]
            
            if let reqId = self.reqId {
                let params = ViTrackParams(reqId: reqId, action: ViDefaultTrackingAction.CLICK.rawValue)
                params?.imName = product.im_name
                
                ViSearch.sharedInstance.track(params: params!) { (success, error) in
                    
                }
            }
            
            delegate.didSelectProduct(sender: self, collectionView: collectionView, indexPath: indexPath, product: product)
        }
    }
    
    // MARK : important methods
    
    /// estimate product card item size based on image size in image config
    /// override if necessary
    open func estimateItemSize() -> CGSize{
        return self.estimateItemSize(constrainedToWidth: self.imageConfig.size.width)
    }
    
    /// estimate product card item size for a max width of width
    open func estimateItemSize(constrainedToWidth maxWidth: CGFloat) -> CGSize{
        
        let productCardLayout = ViProductCardLayout(
            imgUrl: nil, imageConfig: self.imageConfig,
            heading: self.schemaMapping.heading , headingConfig: self.headingConfig ,
            label: self.schemaMapping.label , labelConfig: self.labelConfig,
            price: (self.schemaMapping.price == nil ? nil : 0), priceConfig: self.priceConfig,
            discountPrice: (self.schemaMapping.discountPrice == nil ? nil : 0), discountPriceConfig: self.discountPriceConfig,
            hasSimilarBtn: self.hasSimilarBtn, similarBtnConfig: self.similarBtnConfig,
            hasActionBtn: self.hasActionBtn, actionBtnConfig: self.actionBtnConfig,
            pricesHorizontalSpacing: ViProductCardLayout.default_spacing, labelLeftPadding: ViProductCardLayout.default_spacing)
        
        return productCardLayout.arrangement(origin: .zero, width: maxWidth).frame.size
    }
    
    /// to be override by subclasses. Subclass must call delegate configureLayout to allow further customatization
    open func reloadLayout(){
       
        // initial setup will skeep this
        if self.itemSize.width < 2 {
            return
        }
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.footerReferenceSize = .zero
        self.collectionView?.backgroundColor = backgroundColor
        self.view.backgroundColor = backgroundColor
        layout.itemSize = itemSize
        
        let searchResultsView = self.view as! ViSearchResultsView
        
        searchResultsView.paddingLeft = paddingLeft
        searchResultsView.paddingRight = paddingRight
        
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
        
        searchResultsView.setNeedsLayout()
        searchResultsView.layoutIfNeeded()
          
    }
    
    open func setMetaQueryParamsForSearch() {
        
        if let searchParams = self.searchParams {
            // construct the fl based on schema mappings
            // need to merge the array to make sure that the returned data contain the relevant meta data in mapping
            let metaArr = self.schemaMapping.getMetaArrForSearch()
            let combinedArr = searchParams.fl + metaArr
            let flSet = Set(combinedArr)
            searchParams.fl = Array(flSet)
        }
        
    }
    
    /// to be implemented by subclasses
    open func refreshData(){}
    
   
    // MARK: header
    
    open var headerSize : CGSize {
        if !showTitleHeader {
            return .zero
        }
        
        if self.title != nil {
            return CGSize(width: self.view.bounds.width, height: ViTheme.sharedInstance.default_widget_title_font.lineHeight + 4)
        }
        return .zero
    }
    
    open func headerView() -> UIView? {
        if !showTitleHeader {
            return nil
        }
        
        if let title = self.title, let label = self.titleLabel {
            label.text = title
            label.sizeToFit()
            
            return label
        }
        return nil
    }
    
    
    // MARK: footer - Power by ViSenze
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
        
        powerImgView.frame = CGRect(x: (self.view.bounds.width - width - 2), y: 4 , width: width, height: height )
        powerImgView.backgroundColor = ViTheme.sharedInstance.default_btn_background_color
        
        // fix rotation issue
        powerImgView.autoresizingMask = [ .flexibleLeftMargin , .flexibleRightMargin ]
        
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

    
    // MARK: action buttons
    
    @IBAction open func similarBtnTapped(_ cell: ViProductCollectionViewCell) {
        if let indexPath = self.collectionView?.indexPath(for: cell) {
            let product = products[indexPath.row]
            
            // go to similar button page
            if let params = ViSearchParams(imName: product.im_name) , let curParams = self.searchParams {
            
                let similarController = ViFindSimilarViewController()
                
                // copy parameters over
                
                // copy all the parameters over from original query
                params.fl = curParams.fl
                params.fq = curParams.fq
                params.detection = curParams.detection
                params.getAllFl = curParams.getAllFl
                params.limit = 16
                
                similarController.searchParams = params
                
                // copy other settings
                similarController.schemaMapping = self.schemaMapping
                
                similarController.imageConfig = self.imageConfig
                
                similarController.labelConfig = self.labelConfig
                similarController.headingConfig = self.headingConfig
                similarController.priceConfig = self.priceConfig
                similarController.discountPriceConfig = self.discountPriceConfig
                similarController.hasActionBtn = self.hasActionBtn
                similarController.actionBtnConfig = self.actionBtnConfig
                similarController.hasSimilarBtn = self.hasSimilarBtn
                similarController.similarBtnConfig = self.similarBtnConfig
                similarController.showPowerByViSenze = self.showPowerByViSenze
                similarController.productCardBackgroundColor = self.productCardBackgroundColor
                similarController.backgroundColor = self.backgroundColor
                similarController.itemSpacing = self.itemSpacing
                if self is ViGridSearchViewController {
                    let gridController = self as! ViGridSearchViewController
                    similarController.rowSpacing = gridController.rowSpacing
                    
                    // copy the filtering parameters also
                    similarController.filterControllerTitle = gridController.filterControllerTitle
                    
                    // copy the filter params
                    if gridController.filterItems.count > 0 {
                        var filterItems : [ViFilterItem] = []
                        
                        for filterItem in gridController.filterItems {
                            filterItems.append(filterItem.clone())
                        }
                        
                        similarController.filterItems = filterItems
                    }
                    
                }
                
                similarController.productCardBorderColor = self.productCardBorderColor
                similarController.productCardBorderWidth = self.productCardBorderWidth
                
                let width = similarController.estimateItemWidth(numOfColumns: 2, containerWidth: self.view.bounds.width)
                // make sure image width is less than item width
                similarController.imageConfig.size.width = min(width, similarController.imageConfig.size.width)
                let similarItemSize = CGSize(width: width, height: self.itemSize.height )
                
                similarController.itemSize = similarItemSize
                
                similarController.setItemWidth(numOfColumns: 2, containerWidth: self.view.bounds.width)
                similarController.showTitleHeader = false
                similarController.queryProduct = product
                
                similarController.queryImageConfig = similarController.generateQueryImageConfig(scale: 0.7)
                similarController.showQueryProduct = true
                
                // set to same delegate
                similarController.delegate = self.delegate
                
                // present this controller as modal view controller wrapped in navigation controller
                if(self.navigationController == nil) {
                    let backItem = UIBarButtonItem(image: ViIcon.back, style: .plain, target: self, action: #selector(dimissSimilarController))
                    similarController.navigationItem.leftBarButtonItem = backItem
                    
                    let navController = UINavigationController(rootViewController: similarController)
                    navController.modalPresentationStyle = .fullScreen
                    navController.modalTransitionStyle = .coverVertical
                    
                    delegate?.willShowSimilarControler(sender: self, controller: similarController, collectionView: self.collectionView!, indexPath: indexPath, product: product)
                    
                    // TODO: test this flow when navigation controller is not available
                    self.show(navController, sender: self)
                }
                else {
                    
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
                    
                    delegate?.willShowSimilarControler(sender: self, controller: similarController, collectionView: self.collectionView!, indexPath: indexPath, product: product)
                    
                    self.navigationController?.pushViewController(similarController, animated: true)
                }
                
                
                similarController.refreshData()
                
            }
            
            delegate?.similarBtnTapped(sender: cell, collectionView: self.collectionView!, indexPath: indexPath, product: product)
        }
    }
    
    @IBAction open func actionBtnTapped(_ cell: ViProductCollectionViewCell) {
        if let indexPath = self.collectionView?.indexPath(for: cell) {
            let product = products[indexPath.row]
            
            if let reqId = self.reqId, let action = self.actionBtnConfig.actionToRecord {
                let params = ViTrackParams(reqId: reqId, action: action)
                params?.imName = product.im_name
                
                ViSearch.sharedInstance.track(params: params!) { (success, error) in
                    
                }
            }
            
            delegate?.actionBtnTapped(sender: cell, collectionView: self.collectionView!, indexPath: indexPath, product: product)
        }
    }
    
    open func dimissSimilarController() {
        self.dismiss(animated: true, completion: nil)
    }
    

}
