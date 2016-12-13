//
//  ViRangeTableViewCell.swift
//  ViSearchWidgets
//
//  Created by Hung on 30/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import Foundation

/// Table view cell for range filter. This will contain the range filter title, the range slider and the upper/lower labels
/// The upper/lower labels will be updated when the range filter upper/lower thumbs are dragged.
open class ViRangeTableViewCell: UITableViewCell {

    /// associated range filter item
    open var filterItem: ViFilterItemRange? = nil {
        didSet {
            if let filterItem = self.filterItem {
                self.titleLabel?.text = filterItem.title
                self.rangeSlider?.maximumValue = Double(filterItem.max)
                self.rangeSlider?.minimumValue = Double(filterItem.min)
                self.rangeSlider?.upperValue = Double(filterItem.selectedUpper)
                self.rangeSlider?.lowerValue = Double(filterItem.selectedLower)
                
                // update frame for upper and lower
                self.upperLabel?.text = String(format: "%d", filterItem.selectedUpper)
                self.lowerLabel?.text = String(format: "%d", filterItem.selectedLower)
                
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    /// left padding which need to take into account the indentation and separate inset of table view
    var paddingLeft : CGFloat  {
        return self.indentationWidth * CGFloat(self.indentationLevel) + self.separatorInset.left + self.separatorInset.right
    }
    
    /// Range slider
    open var rangeSlider : ViRangeSlider? = nil
    
    /// Display title
    open var titleLabel : UILabel? = nil
    
    // lower value label e.g. selected lower price
    open var lowerLabel : UILabel? = nil
    
    /// upper value label e.g. selected upper price
    open var upperLabel : UILabel? = nil
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        // make sure these are hidden as we are not using
        self.textLabel?.isHidden = true
        self.detailTextLabel?.isHidden = true
        
    }
    
    /// create all views and init
    open func setup() {
        self.autoresizingMask = [.flexibleWidth]
        
        self.titleLabel = UILabel(frame: .zero)
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.font = ViTheme.sharedInstance.default_filter_row_title_font
        self.contentView.addSubview(self.titleLabel!)
        
        self.lowerLabel = UILabel(frame: .zero)
        self.lowerLabel?.numberOfLines = 1
        self.lowerLabel?.font = ViTheme.sharedInstance.default_filter_row_desc_font
        self.lowerLabel?.text = ""
        self.lowerLabel?.textAlignment = .center
        self.contentView.addSubview(self.lowerLabel!)
        
        self.upperLabel = UILabel(frame: .zero)
        self.upperLabel?.numberOfLines = 1
        self.upperLabel?.font = ViTheme.sharedInstance.default_filter_row_desc_font
        self.upperLabel?.text = ""
        self.upperLabel?.textAlignment = .center
        self.contentView.addSubview(self.upperLabel!)
        
        self.rangeSlider = ViRangeSlider(frame: .zero)
        self.contentView.addSubview(self.rangeSlider!)
        
        self.rangeSlider?.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
        
    }
    
    
    /// Range slider change events. Upper / lower labels will be updated accordingly.
    /// Selected value for filterItem will also be updated
    ///
    /// - Parameter rangeSlider: the changed rangeSlider
    open func rangeSliderValueChanged(_ rangeSlider: ViRangeSlider) {
        filterItem?.selectedLower = lround(rangeSlider.lowerValue)
        filterItem?.selectedUpper = lround(rangeSlider.upperValue)
        
        self.upperLabel?.text = String(format: "%d", filterItem!.selectedUpper)
        self.lowerLabel?.text = String(format: "%d", filterItem!.selectedLower)
        
        // update frame for upper and lower label
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let titleLabel = self.titleLabel , let lowerLabel = self.lowerLabel ,
            let upperLabel = self.upperLabel , let rangeSlider = self.rangeSlider {
            
            let paddingLeft = self.paddingLeft
            let commonWidth = self.contentView.bounds.width  - paddingLeft * 2
            
            titleLabel.frame = CGRect(x: paddingLeft,
                                        y: 4,
                                        width: commonWidth  ,
                                        height: (titleLabel.font.lineHeight + 4 ) )
            
            let priceLabelY = titleLabel.frame.origin.y + titleLabel.frame.size.height
            
            let lowerWidth = lowerLabel.font.stringSize(string: lowerLabel.text!, constrainedToWidth: Double(commonWidth)).width
            let upperWidth = upperLabel.font.stringSize(string: upperLabel.text!, constrainedToWidth: Double(commonWidth)).width
            
            var lowerLabelX = paddingLeft
            var upperLabelX = paddingLeft
            
            
            rangeSlider.frame = CGRect(x: paddingLeft,
                                       y: priceLabelY + lowerLabel.font.lineHeight + 4,
                                       width: commonWidth ,
                                       height: 30 )
            
//            if(rangeSlider.maximumValue != rangeSlider.minimumValue) {
//                
//                // center
//                lowerLabelX = rangeSlider.lowerThumbLayer.frame.minX + paddingLeft + 2
//                upperLabelX = rangeSlider.upperThumbLayer.frame.minX + paddingLeft + 2
//            }

            // fix lower label to left and upper label to right
            lowerLabelX = rangeSlider.frame.origin.x + 2
            upperLabelX = rangeSlider.frame.origin.x + rangeSlider.frame.size.width - 28
            
            lowerLabel.frame = CGRect(      x: lowerLabelX,
                                            y: priceLabelY,
                                            width: lowerWidth ,
                                            height: lowerLabel.font.lineHeight + 4 )
            
            upperLabel.frame = CGRect(      x: upperLabelX,
                                            y: priceLabelY,
                                            width: upperWidth ,
                                            height: upperLabel.font.lineHeight + 4 )
            
            
           
        }
    
        
    }

}
