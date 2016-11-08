//
//  UIFont+Visenze.swift
//  ViSearchWidgets
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

extension UIFont {
    
    
    /// get size for string of this font
    ///
    /// - parameter string: a string
    /// - parameter width:  constrained width
    ///
    /// - returns: string size for constrained width
    open func stringSize(string: String, constrainedToWidth width: Double) -> CGSize {
        return string.boundingRect(with: CGSize(width: width, height: DBL_MAX),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSFontAttributeName: self],
                                   context: nil).size
    }

}
