//
//  UILabel+Visenze.swift
//  ViSearchWidgets
//
//  Created by Hung on 4/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

extension UILabel {

    
    /// Set strike through text for this label e.g to indicate old pricing before discount
    ///
    /// - Parameters:
    ///   - text: text
    ///   - color: strike through text color
    func setStrikethrough(text:String, color:UIColor = UIColor.black) {
        let attributedText = NSAttributedString(string: text ,
                                                attributes: [
                                                        NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSStrikethroughColorAttributeName: color]
                                                )
        self.attributedText = attributedText
    }
    
    
    /// Set line height for label
    ///
    /// - Parameter lineHeight: lineheight
    func setLineHeight(lineHeight: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text.characters.count))
            self.attributedText = attributeString
        }
    }
}
