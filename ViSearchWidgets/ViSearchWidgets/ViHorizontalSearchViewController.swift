//
//  ViHorizontalSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 21/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

open class ViHorizontalSearchViewController: ViBaseSearchViewController {

    /// Estimate item width if want to show number of visible items fit within certain width
    ///
    /// - Parameters:
    ///   - itemsVisibleOnContainerCount: number of items visible on container e.g. 2.5 mean 2 items will appear on screen + half partial item will show
    ///   - containerWidth: container width e.g. self.view.bounds
    /// - Returns: estimated width
    open func estimateItemWidth(_ itemsVisibleOnContainerCount : CGFloat , containerWidth: CGFloat) -> CGFloat {
        
        if(containerWidth <= 0) {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error : containerWidth is less than or equal to 0. Container may not initialize yet.")
            return 0;
        }
        
        // assumpt that will fit within 1 column
        if(itemsVisibleOnContainerCount < 2) {
            return floor(containerWidth) ;
        }
        
        // calculate the width based on spacing between items
        let itemWidth = floor(  (containerWidth - CGFloat(itemsVisibleOnContainerCount - 1) * itemSpacing ) / CGFloat(itemsVisibleOnContainerCount))
        
        return itemWidth
    }
    
    open func estimateItemWidth(_ itemsVisibleOnContainerCount : CGFloat ) -> CGFloat {
        return self.estimateItemWidth(itemsVisibleOnContainerCount, containerWidth: self.view.bounds.width)
    }

    /// reload layout.. configure this as a horizontal layout
    open override func reloadLayout(){
        super.reloadLayout()
        
        // set view
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        if let delegate = delegate {
            delegate.configureLayout(sender: self, layout: layout)
        }
    
    }
    
    
}
