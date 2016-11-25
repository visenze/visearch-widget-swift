//
//  ViGridSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 24/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import LayoutKit

open class ViGridSearchViewController: ViBaseSearchViewController {

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
    
    /// generate the layout for number of products and filter button
    open func getLabelAndFilterLayout(emptyProductsTxt: String = "Similar Products",
                                      displayStringFormat: String = "%d Similar Products Found"   ) -> Layout{
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
                
                // TODO: add event handler for filter button click here
        }
            
        )
        
        let labelAndFilterLayout = StackLayout(
            axis: .horizontal,
            spacing: 0,
            sublayouts: [ labelEl, filterEl ]
        )
        
        return labelAndFilterLayout
    }
   
    
}
