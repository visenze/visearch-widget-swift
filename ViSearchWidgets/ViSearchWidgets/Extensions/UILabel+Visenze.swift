//
//  UILabel+Visenze.swift
//  ViSearchWidgets
//
//  Created by Hung on 4/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

extension UILabel {

    func setStrikethrough(text:String, color:UIColor = UIColor.black) {
        let attributedText = NSAttributedString(string: text ,
                                                attributes: [
                                                        NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSStrikethroughColorAttributeName: color]
                                                )
        self.attributedText = attributedText
    }
    
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
