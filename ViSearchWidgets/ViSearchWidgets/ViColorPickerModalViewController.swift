//
//  ViColorPickerModalViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 25/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ViColorCell"
private let headerCollectionViewCellReuseIdentifier = "ViHeaderCell"

public protocol ViColorPickerDelegate: class {
    func didPickColor(sender: ViColorPickerModalViewController, color: String)
}

open class ViColorPickerModalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    open var colorList: [String] = []
    
    public var collectionView : UICollectionView? {
        let resultsView = self.view as! ViSearchResultsView
        return resultsView.collectionView
    }
    
    public var collectionViewLayout: UICollectionViewLayout {
        let resultsView = self.view as! ViSearchResultsView
        return resultsView.collectionViewLayout
    }

    public var titleLabel : UILabel?
    public var showTitleHeader: Bool = true
    
    public weak var delegate: ViColorPickerDelegate?
    
    public var itemSize: CGSize = CGSize(width: 44, height: 44) {
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
    
    // whether to enable Power by Visenze logo
    public var showPowerByViSenze : Bool = true
    
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
        
        self.title = "Pick a color:"
        self.titleLabel?.text = self.title
        
        // Important: without this the header above collection view will appear behind the navigation bar
        self.edgesForExtendedLayout = []
    }
    
    open override func loadView() {
        let searchResultsView = ViSearchResultsView(frame: .zero)
        self.view = searchResultsView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        
        // Register cell classes
        self.collectionView!.register(ViProductCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCollectionViewCellReuseIdentifier)
        
        reloadLayout()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return .zero
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let color = colorList[indexPath.row]
        cell.contentView.backgroundColor = UIColor.colorWithHexString(color, alpha: 1.0)
        
        return cell
    
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            let color = colorList[indexPath.row]
            delegate.didPickColor(sender: self, color: color)
        }
    }
    
    open func reloadLayout(){
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.footerReferenceSize = .zero
        layout.scrollDirection = .vertical
       
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
    
    // MARK: header
    
    open var headerSize : CGSize {
        if !showTitleHeader {
            return .zero
        }
        
        if self.title != nil {
            return CGSize(width: self.view.bounds.width, height: ViTheme.sharedInstance.default_widget_title_font.lineHeight + 16)
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
            var labelFrame = label.frame
            labelFrame.origin.y = labelFrame.origin.y + 3
            
            label.frame = labelFrame
            
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
        
        return powerImgView
    }
    
    open var footerSize : CGSize {
        
        if !showPowerByViSenze {
            return CGSize.zero
        }
        
        // hide footer if there is no color
        if self.colorList.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: 100, height: 25)
    }


}
