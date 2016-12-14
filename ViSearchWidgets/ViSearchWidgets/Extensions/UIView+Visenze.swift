//
//  UIView+Visenze.swift
//  ViSearchWidgets
//
//  Created by Hung on 24/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// various helper methods for uiview
extension UIView {
    
    /// quick access to x
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    /// quick access to y
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }

    /// shorthand for view width
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    /// shorthand for view height
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    
    /// Set corner radius
    ///
    /// - Parameter radius: radius
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// add shadow for view
    public func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }
    
    
    /// Add border
    ///
    /// - Parameters:
    ///   - width: border thickness
    ///   - color: border color
    public func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
    
    
    /// add only top border
    ///
    /// - Parameters:
    ///   - size: border thickness
    ///   - color: border color
    public func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    
    /// add only top border with padding
    ///
    /// - Parameters:
    ///   - size: border thickness
    ///   - color: border color
    ///   - padding: padding to size
    public func addBorderTopWithPadding(size: CGFloat, color: UIColor, padding: CGFloat) {
        addBorderUtility(x: padding, y: 0, width: frame.width - padding*2, height: size, color: color)
    }
    
    /// add only bottom border
    ///
    /// - Parameters:
    ///   - size: border thickness
    ///   - color: border color
    public func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    
    /// add only left border
    ///
    /// - Parameters:
    ///   - size: border thickness
    ///   - color: border color
    public func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    
    /// add only right border
    ///
    /// - Parameters:
    ///   - size: border thickness
    ///   - color: border color
    public func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    
    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    
    /// remove constraint
    ///
    /// - Parameter constraint: existing constraint
    public func autoRemoveConstraint(_ constraint : NSLayoutConstraint?) {
        if constraint != nil {
            self.removeConstraint(constraint!)
        }
    }
    
    
    /// Draw circle over view
    ///
    /// - Parameters:
    ///   - fillColor: fill color
    ///   - strokeColor: stroke color
    ///   - strokeWidth: stroke width
    public func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        self.layer.addSublayer(shapeLayer)
    }
    
    
    /// Draw stroke
    ///
    /// - Parameters:
    ///   - width: stroke width
    ///   - color: stroke color
    public func drawStroke(width: CGFloat, color: UIColor) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: 0)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
        
    }


}
