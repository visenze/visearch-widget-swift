//
//  ViHorizontalSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 21/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Display the search results in a horizontal scroll view
/// This is used currently by "You May Also Like" widget i.e. ViRecommendationViewController
open class ViHorizontalSearchViewController: ViBaseSearchViewController {

    // MARK: collectionview datasource and delegate
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        var s = CGSize(width: self.view.bounds.width, height: 0)
        
        let searchResultsView = self.view as! ViSearchResultsView
        if searchResultsView.showMsgView {
            s.height += searchResultsView.msgView.frame.size.height
        }
        else {
            return CGSize.zero
        }
        
        return s
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCollectionViewCellReuseIdentifier, for: indexPath)
        
        // add err if necessary
        let searchResultsView = self.view as! ViSearchResultsView
        if searchResultsView.showMsgView {
            var oldFrame = searchResultsView.msgView.frame
            oldFrame.origin.y = 8
            oldFrame.origin.x = self.paddingLeft
            searchResultsView.msgView.frame = oldFrame
            view?.addSubview(searchResultsView.msgView)
        }
        
        return view!
    }
    
    // MARK: layout methods
    
    /// Given the number of visible items (products) to appear on the containerWidth, return the estimated item width
    /// The items are displayed in a horizontal scroll view. The width of the visible rectange is containerWidth.
    /// The scroll view contain size may be much larger than containerWidth
    /// We want a number of items (itemsVisibleOnContainerCount) to be shown in the visible rectange
    ///
    /// - Parameters:
    ///   - itemsVisibleOnContainerCount: number of items visible on container e.g. 2.5 mean 2 items will appear on screen + half partial item will show
    ///   - containerWidth: container width e.g. self.view.bounds
    /// - Returns: estimated width for an item i.e. a product card
    open func estimateItemWidth(_ itemsVisibleOnContainerCount : CGFloat , containerWidth: CGFloat) -> CGFloat {
        
        if(containerWidth <= 0) {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error : containerWidth is less than or equal to 0. Container may not initialize yet.")
            return 0
        }
        
        // assumpt that will fit within 1 column
        if(itemsVisibleOnContainerCount < 2) {
            return floor(containerWidth)
        }
        
        // calculate the width based on spacing between items
        let itemWidth = floor(  (containerWidth - CGFloat(itemsVisibleOnContainerCount - 1) * itemSpacing ) / CGFloat(itemsVisibleOnContainerCount))
        
        return itemWidth
    }
    
    
    /// Given the number of visible items (products) to appear on this view, return the estimated item width
    /// The items are displayed in a horizontal scroll view. The width of the visible rectange is self.view.bounds.width.
    /// We want a number of items (itemsVisibleOnContainerCount) to be shown in the visible rectange
    /// Note: this method will return 0 if the current view controller is not yet displayed i.e. view.bounds.width is 0
    ///
    /// - Parameter itemsVisibleOnContainerCount: number of items visible on container 
    ///   e.g. 2.5 mean 2 items will appear on screen + half partial item will show
    /// - Returns: estimated width for an item
    open func estimateItemWidth(_ itemsVisibleOnContainerCount : CGFloat ) -> CGFloat {
        return self.estimateItemWidth(itemsVisibleOnContainerCount, containerWidth: self.view.bounds.width)
    }

    /// reload layout.. configure layout as a horizontal layout
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
