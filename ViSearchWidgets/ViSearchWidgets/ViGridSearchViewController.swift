//
//  ViGridSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 24/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import LayoutKit

open class ViGridSearchViewController: ViBaseSearchViewController , ViFilterViewControllerDelegate {

    // filter will be available only if filter option is set
    open var filterItems : [ViFilterItem] = []
    
    open var filterBtn : UIButton? = nil
    
    open var filterControllerTitle : String = "Filter by"
    
    open var headerLayout : Layout? {
        return nil
    }
    
    public override var itemSize: CGSize {
        didSet {
            // make sure image config width cannot exceed item width
            self.imageConfig.size.width = min(itemSize.width, self.imageConfig.size.width)
        }
    }
    
    public func setItemWidth(numOfColumns : Int) {
        self.setItemWidth(numOfColumns: numOfColumns, containerWidth: self.view.bounds.width)
    }
    
    // set item width for number of columns
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
    
    public func recalculateItemWidth(numOfColumns : Int) {
        self.setItemWidth(numOfColumns: numOfColumns)
    }
    
    /// spacing between rows
    public var rowSpacing  : CGFloat = 4.0 {
        didSet{
            reloadLayout()
        }
    }
    
    /// Estimate item width for given number of columns and max width of container
    ///
    /// - Parameters:
    ///   - numOfColumns: number of columns
    ///   - containerWidth: container width e.g. self.view.bounds
    /// - Returns: estimated width
    open func estimateItemWidth(numOfColumns : Int , containerWidth: CGFloat ) -> CGFloat {
        
        if(containerWidth <= 0) {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error : containerWidth is less than or equal to 0. Container may not initialize yet.")
            return 0;
        }
        
        // assumpt that will fit within 1 column
        if(numOfColumns < 2) {
            return floor(containerWidth) ;
        }
        
        // calculate the width based on spacing between items
        let itemWidth = (containerWidth - paddingLeft - paddingRight - CGFloat(numOfColumns - 1) * itemSpacing ) / CGFloat(numOfColumns)
        
        return itemWidth
    }
    
    open func estimateItemWidth(numOfColumns : Int ) -> CGFloat{
        return self.estimateItemWidth(numOfColumns: numOfColumns, containerWidth: self.view.bounds.width)
    }
    
    open func estimateItemSize(numOfColumns: Int, containerWidth: CGFloat ) -> CGSize {
        let width = self.estimateItemWidth(numOfColumns: 2, containerWidth: containerWidth)
        let constrainWidth = min(width, self.imageConfig.size.width )
        let height = self.estimateItemSize(constrainedToWidth: constrainWidth ).height
        return CGSize(width: width, height: height)
    }
    
    /// reload layout.. configure this as a horizontal layout
    open override func reloadLayout(){

        super.reloadLayout()
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = rowSpacing
        
        if let delegate = delegate {
            delegate.configureLayout(sender: self, layout: layout)
        }
        
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        if let layout = self.headerLayout {
            return layout.arrangement( origin: .zero , width: self.view.bounds.width ).frame.size
        }
        return CGSize.zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCollectionViewCellReuseIdentifier, for: indexPath)
        
        if let layout = self.headerLayout {
            layout.arrangement( origin: .zero , width:  self.view.bounds.width ).makeViews(in: view)
        }
        
        return view!
    }
    
    // MARK: layout helper methods
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
    
    /// generate the layout for number of products and filter button
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
    
    
    
    // MARK : filter methods
    open func filterBtnTap(sender: UIButton, forEvent event: UIEvent) {
        // open filter controller here
        let controller = ViFilterViewController()
        controller.title = self.filterControllerTitle
        controller.filterItems = self.filterItems
        controller.delegate = self
        
        // present this controller as modal view controller wrapped in navigation controller
        if(self.navigationController == nil) {
            
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            navController.modalTransitionStyle = .coverVertical
            
            self.delegate?.willShowFilterControler(sender: self, controller: controller)
            
            self.show(navController, sender: self)
        }
        else {
            
            self.delegate?.willShowFilterControler(sender: self, controller: controller)
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
    // need to be implemented by subclass
    open func applyFilter(){
        // default just dismiss controller
        if(self.navigationController == nil) {
             self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
       
        self.refreshData()
    }
    
    open func resetFilter(){
        
        // default just dismiss controller
        if(self.navigationController == nil) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
        // refresh data
        self.refreshData()
    
    }
    
    open func setFilterQueryParamsForSearch() {
        
        if let searchParams = self.searchParams {
            if self.filterItems.count > 0 {
                
                var fq : [String: String] = [:]
                
                // construct filter items items
                for filterItem in self.filterItems {
                    if !filterItem.isReset() {
                        fq[filterItem.schemaMapping] = filterItem.getFilterQueryValue()
                    }
                }
                
                searchParams.fq = fq
            }
            else {
                searchParams.fq.removeAll()
            }
        }

    }
    
    // MARK : viewWillAppear
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.filterBtn?.isHidden = (self.filterItems.count == 0)
    }

}
