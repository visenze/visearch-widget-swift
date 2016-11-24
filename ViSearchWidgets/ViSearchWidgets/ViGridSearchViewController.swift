//
//  ViGridSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 24/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

open class ViGridSearchViewController: ViBaseSearchViewController {

    public func setItemWidth(numOfColumns : Int) {
        self.setItemWidth(numOfColumns: numOfColumns, containerWidth: self.view.bounds.width)
    }
    
    // set item width for number of columns
    public func setItemWidth(numOfColumns : Int, containerWidth: CGFloat) {
        if(containerWidth > 0 ) {
            let itemWidth = self.estimateItemWidth(numOfColumns: numOfColumns, containerWidth: containerWidth )
            
            // make sure image width is less than item width
            self.imageConfig.size.width = min(itemWidth, self.imageConfig.size.width)
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
   
    
}
