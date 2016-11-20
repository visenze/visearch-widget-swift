//
//  ViProductCollectionViewCell.swift
//  ViSearchWidgets
//
//  Created by Hung on 20/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

public protocol ViProductCellDelegate: class {
    func similarBtnTapped(_ cell: ViProductCollectionViewCell)
    func actionBtnTapped(_ cell: ViProductCollectionViewCell)
}

/// subclass cell which wire up the buttons events and delegate
open class ViProductCollectionViewCell: UICollectionViewCell {
   
    public var delegate: ViProductCellDelegate?
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBAction public func similarBtnTapped(sender: UIButton) {
        self.delegate?.similarBtnTapped(self)
    }
    
    @IBAction public func actionBtnTapped(sender: UIButton) {
        self.delegate?.actionBtnTapped(self)
    }
}
