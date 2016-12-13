//
//  ViGridSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 24/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import LayoutKit

/// Display search results in a grid
/// This is the base class for "Find Similar" , "Search By Color" , "Search By Image" widgets (ViFindSimilarViewController, ViColorSearchViewController, ViSearchImageViewController)
/// The products are layouted using collectionView flow layout which will push product items to the next line based on the item size
open class ViGridSearchViewController: ViBaseSearchViewController , ViFilterViewControllerDelegate {

    /// store the header layout height of collection view
    /// The header includes the query product (for Find Similar), the color preview box (for color search) , image preview box (for search by image)
    public var headerLayoutHeight : CGFloat = 0
    
    /// store the filter configuration and also selected filter options
    open var filterItems : [ViFilterItem] = []
    
    // filter button will be shown only if the filter items are set i.e. count > 0
    open var filterBtn : UIButton? = nil
    
    /// title for filter controller
    open var filterControllerTitle : String = "Filter by"
    
    /// Disable the static header of parent class. This is different from headerLayoutHeight which is refering to the header within collectionView
    open var headerLayout : Layout? {
        return nil
    }
    
    /// product card item size
    public override var itemSize: CGSize {
        didSet {
            // make sure image config width cannot exceed item width
            self.imageConfig.size.width = min(itemSize.width, self.imageConfig.size.width)
        }
    }
    
    /// spacing between rows
    public var rowSpacing  : CGFloat = 4.0 {
        didSet{
            reloadLayout()
        }
    }
    
    // MARK: Item Sizing Methods
    
    /// calculate and set item width (for product card) constrained within view.bounds.width
    /// The items will display nicely within the specified number of columns after setting
    /// Note: if the view is not yet displayed and self.view.bounds.width is 0, no action will be taken
    ///
    /// - Parameter numOfColumns: number of columns
    public func setItemWidth(numOfColumns : Int) {
        self.setItemWidth(numOfColumns: numOfColumns, containerWidth: self.view.bounds.width)
    }
    
    /// calculate and set item width (for product card) constrained within containerWidth
    /// The items will display nicely within the specified number of columns after setting
    ///
    /// - Parameter numOfColumns: number of columns
    /// - Parameter containerWidth: width of the container
    public func setItemWidth(numOfColumns : Int, containerWidth: CGFloat) {
        if(containerWidth > 0 ) {
            let itemWidth = self.estimateItemWidth(numOfColumns: numOfColumns, containerWidth: containerWidth )
            
            // make sure image width is less than item width
            self.itemSize.width = itemWidth
        }
        else {
              print("\(type(of: self)).\(#function)[line:\(#line)] - error : containerWidth is less than or equal to 0. Unable to set")
        }
    }
    
    
    /// Refers to setItemWidth
    ///
    /// - Parameter numOfColumns: number of columns to fit in
    public func recalculateItemWidth(numOfColumns : Int) {
        self.setItemWidth(numOfColumns: numOfColumns)
    }
    
   
    /// Estimate item width for given number of columns and max width of container
    /// The items will display nicely within the specified number of columns if set to the estimated width
    ///
    /// - Parameters:
    ///   - numOfColumns: number of columns
    ///   - containerWidth: container width e.g. self.view.bounds. Must be > 0.
    /// - Returns: estimated width
    open func estimateItemWidth(numOfColumns : Int , containerWidth: CGFloat ) -> CGFloat {
        
        if(containerWidth <= 0) {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error : containerWidth is less than or equal to 0. Container may not initialize yet.")
            return 0
        }
        
        // assumpt that will fit within 1 column
        if(numOfColumns < 2) {
            return floor(containerWidth) 
        }
        
        // calculate the width based on spacing between items
        let itemWidth = (containerWidth - paddingLeft - paddingRight - CGFloat(numOfColumns - 1) * itemSpacing ) / CGFloat(numOfColumns)
        
        return itemWidth
    }
    
    
    /// Refers to estimateItemWidth(numOfColumns : Int , containerWidth: CGFloat ) 
    /// Helper method which set containerWidth to self.view.bounds.width. Note: will not work if self.view.bounds.width = 0
    ///
    /// - Parameter numOfColumns: number of columns
    /// - Returns: estimated item width
    open func estimateItemWidth(numOfColumns : Int ) -> CGFloat{
        return self.estimateItemWidth(numOfColumns: numOfColumns, containerWidth: self.view.bounds.width)
    }
    
    
    /// Estimate item size so that it can fit within specified number of columns, constrained to containerWidth
    ///
    /// - Parameters:
    ///   - numOfColumns: number of columns
    ///   - containerWidth: container width
    /// - Returns: item size
    open func estimateItemSize(numOfColumns: Int, containerWidth: CGFloat ) -> CGSize {
        let width = self.estimateItemWidth(numOfColumns: numOfColumns, containerWidth: containerWidth)
        let constrainWidth = min(width, self.imageConfig.size.width )
        let height = self.estimateItemSize(constrainedToWidth: constrainWidth ).height
        return CGSize(width: width, height: height)
    }
    
    /// Configure layout as vertical layout
    open override func reloadLayout(){

        super.reloadLayout()
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = rowSpacing
        
        if let delegate = delegate {
            delegate.configureLayout(sender: self, layout: layout)
        }
        
    }
    
    // MARK: collectionview datasource and delegate
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        var s = CGSize(width: self.view.bounds.width, height: 0)
        
        if let layout = self.headerLayout {
            let headerSize = layout.arrangement( origin: .zero , width: self.view.bounds.width ).frame.size
            s.height += headerSize.height
        }
        
        let searchResultsView = self.view as! ViSearchResultsView
        if searchResultsView.showMsgView {
            s.height += searchResultsView.msgView.frame.size.height
        }
        
        return s
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCollectionViewCellReuseIdentifier, for: indexPath)
        
        var errViewY : CGFloat = 0
        
        if let layout = self.headerLayout {
            let arrangement = layout.arrangement( origin: .zero , width:  self.view.bounds.width )
            errViewY = arrangement.frame.size.height
            arrangement.makeViews(in: view)
        }
        
        // add err if necessary
        let searchResultsView = self.view as! ViSearchResultsView
        if searchResultsView.showMsgView {
            var oldFrame = searchResultsView.msgView.frame
            oldFrame.origin.y = errViewY + 8
            oldFrame.origin.x = self.paddingLeft + 8
            searchResultsView.msgView.frame = oldFrame
            view?.addSubview(searchResultsView.msgView)
        }
        
        return view!
    }
    
    // MARK: layout helper methods
    
    
    /// Generate layout for Power By ViSenze image
    ///
    /// - Returns: layout
    public func getPowerByVisenzeLayout() -> Layout {
        let scaleRatio :CGFloat = 1.1
        let powerByLayout = SizeLayout<UIImageView>(
            width: ViIcon.power_visenze!.width / scaleRatio, height: ViIcon.power_visenze!.height / scaleRatio,
            alignment: .topLeading ,
            flexibility: .inflexible,
            viewReuseId: nil,
            config: { img in
                img.image = ViIcon.power_visenze
                img.backgroundColor = ViTheme.sharedInstance.default_btn_background_color
                img.clipsToBounds = true
            }
            
        )
        
        return powerByLayout
    }
    
    
    /// Generate gray divider
    ///
    /// - Returns: layout
    public func getDividerLayout() -> Layout {
        let divider = SizeLayout<UIView>(height: 0.5,
                                         alignment: .fill,
                                         flexibility: .flexible,
                                         config: { v in
                                            v.backgroundColor = UIColor.lightGray
                                            
                                            v.autoresizingMask = [ .flexibleWidth ]
                                            
                                        }
        )

        return divider
    }
    
    /// generate the layout for number of searched products and filter button at the right
    open func getLabelAndFilterLayout(emptyProductsTxt: String = "Products Found",
                                      displayStringFormat: String = "%d Products Found"   ) -> Layout{
        var displayTxt = emptyProductsTxt
        
        if self.products.count > 0 {
            displayTxt = String(format: displayStringFormat, self.products.count)
        }
        
        let labelEl = LabelLayout(text: displayTxt,
                                  font: ViFont.medium(with: 16.0),
                                  numberOfLines: 1,
                                  alignment: .centerLeading ,
                                  viewReuseId: nil ,
                                  config:  { (label: UILabel) in
                                    
                                    label.textColor = self.headingConfig.textColor
                                    // label.tag = ViProductCardTag.labelTag.rawValue
                                 }
            
        )
        
        
        let filterEl = SizeLayout<UIButton>(
            width: ViIcon.filter!.width + 8, height: ViIcon.filter!.height + 8,
            alignment: .centerTrailing ,
            flexibility: .inflexible,
            viewReuseId: nil,
            config: { button in
                
                button.backgroundColor = ViTheme.sharedInstance.filter_btn_background_color
                
                button.setImage(ViIcon.filter, for: .normal)
                button.setImage(ViIcon.filter, for: .highlighted)
                
                button.tintColor = ViTheme.sharedInstance.filter_btn_tint_color
                button.imageEdgeInsets = UIEdgeInsetsMake( 4, 4, 4, 4)
                button.tag = ViProductCardTag.filterBtnTag.rawValue
                
                button.addTarget(self, action: #selector(self.filterBtnTap), for: .touchUpInside)
                button.isHidden = (self.filterItems.count == 0)
                
                // fix rotation issue
                button.autoresizingMask = [ .flexibleLeftMargin , .flexibleRightMargin ]
                
                self.filterBtn = button
            }
            
        )
        
        let labelAndFilterLayout = StackLayout(
            axis: .horizontal,
            spacing: 0,
            sublayouts: [ labelEl, filterEl ]
        )
        
        return labelAndFilterLayout
    }
    
    // MARK: Filter helper methods
    
    
    /// Action taken when user tapped on filter button
    /// This will open the filter view controller
    ///
    /// - Parameters:
    ///   - sender: filter button
    ///   - event: button event
    open func filterBtnTap(sender: UIButton, forEvent event: UIEvent) {
        // open filter controller here
        let controller = ViFilterViewController()
        controller.title = self.filterControllerTitle
        controller.initFilterItems = self.filterItems
        controller.delegate = self
        
        // present this controller as modal view controller wrapped in navigation controller
        if(self.navigationController == nil) {
            
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            navController.modalTransitionStyle = .coverVertical
            
            self.delegate?.willShowFilterController(sender: self, controller: controller)
            
            self.show(navController, sender: self)
        }
        else {
            
            // hide back item
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
            
            self.delegate?.willShowFilterController(sender: self, controller: controller)
            
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
    /// need to be implemented by subclass
    /// Triggered when user taps on "Done" button for the Filter controller
    /// The filter parameters will be applied and a new search is triggered
    open func applyFilter(_ filterItems : [ViFilterItem]){
        
        self.filterItems = filterItems
        
        // default just dismiss controller
        if(self.navigationController == nil) {
             self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
       
        self.refreshData()
        
        // reset scroll
        self.collectionView?.contentOffset = .zero
    }
    
    /// call back when filter is reset
    open func resetFilter(){
        
    }
    
    /// Set the filter query parameters before calling search API
    open func setFilterQueryParamsForSearch() {
        
        if let searchParams = self.searchParams {
            if self.filterItems.count > 0 {
                
                var fq : [String: String] = [:]
                
                // construct filter items items
                for filterItem in self.filterItems {
                    // always set filter
                    fq[filterItem.schemaMapping] = filterItem.getFilterQueryValue()
                    
                }
                
                searchParams.fq = fq
            }
            else {
                searchParams.fq.removeAll()
            }
        }

    }
    
    // MARK: View appear methods
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.filterBtn?.isHidden = (self.filterItems.count == 0)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        // for later computation in scrolling
        self.headerLayoutHeight = self.collectionView(self.collectionView!, layout: self.collectionViewLayout, referenceSizeForHeaderInSection: 0).height
        
    }
    

}
