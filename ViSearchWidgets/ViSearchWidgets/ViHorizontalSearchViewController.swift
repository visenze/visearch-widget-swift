//
//  ViHorizontalSearchViewController.swift
//  ViSearchWidgets
//
//  Created by Hung on 21/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

open class ViHorizontalSearchViewController: ViBaseSearchViewController {

    /// reload layout.. configure this as a horizontal layout
    open override func reloadLayout(){
        super.reloadLayout()
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        
        if let delegate = delegate {
            delegate.configureLayout(layout: layout)
        }
    
    }
    
    
}
