//
//  ViFilterTableView.swift
//  ViSearchWidgets
//
//  Created by Hung on 30/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Custom view which include a tableView + power by Visenze image and OK button at the footer
open class ViFilterTableView: UIView {

    /// table view for filter
    public var tableView: UITableView?
    
    /// power by ViSenze image
    public let powerImgView = UIImageView(image: ViIcon.power_visenze)
    
    /// OK button at the bottom. This is hidden for now
    private let okBtn : UIButton = UIButton(type: .custom)
    
    /// container for footer
    public var footerViewContainer: UIView = UIView()
    
    /// footer height
    public var footerHeight : CGFloat = 25
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    /// Init all views
    func setup() {
        self.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.addSubview(self.tableView!)
        
        self.addSubview(self.footerViewContainer)
        
        powerImgView.autoresizingMask = [ .flexibleLeftMargin , .flexibleRightMargin ]
        footerViewContainer.backgroundColor = UIColor.black
        
//        self.okBtn.setBackgroundImage(ViIcon.big_camera_empty, for: .normal)
//        self.okBtn.setTitle("OK", for: .normal)
//        self.okBtn.setTitleColor(UIColor.black, for: .normal)
//        self.okBtn.titleLabel?.font = ViFont.medium(with: 24)
//        self.okBtn.titleEdgeInsets = UIEdgeInsetsMake(-4, -4, 0, 0)
        
//        footerViewContainer.addSubview(okBtn)
        
        self.addSubview(powerImgView)
        self.bringSubview(toFront: powerImgView)
        
    }
    
    /// Set frame for power by visenze image
    public func setPowerByVisenzeFrame() {
        
        var width : CGFloat = 100
        var height : CGFloat = 25
        
        if let img = ViIcon.power_visenze {
            width = min(width, img.size.width)
            height = min(height, img.size.height)
        }
        
        // position at bottom
        powerImgView.frame = CGRect(x: (self.bounds.width - width - 2),
                                    y: (self.bounds.height - height - 2) ,
                                    width: width, height: height )
        
    }

    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // view has not been init
        if(self.bounds.height == 0)
        {
            self.tableView?.frame = .zero
            self.footerViewContainer.frame = .zero
            return
        }
        
        let footerViewHeight = max(footerHeight , 0)
        
        self.footerViewContainer.frame = CGRect(x: 0,
                                                y: self.bounds.size.height - footerViewHeight ,
                                                width: self.bounds.size.width,
                                                height: footerViewHeight)
        
        self.okBtn.frame = CGRect(x: self.footerViewContainer.frame.width * 0.5 - 32,
                                  y: (footerViewHeight - 64) / 2,
                                  width: 64,
                                  height: 64)
        
        self.tableView?.frame = CGRect(x: 0,
                                            y: 0,
                                            width: self.bounds.size.width ,
                                            height: self.bounds.size.height - footerViewHeight
        )
        
        setPowerByVisenzeFrame()
        
    }
    
    public func setFooter(_ footerView: UIView) {
        for view in self.footerViewContainer.subviews{
            view.removeFromSuperview()
        }
        
        self.footerViewContainer.addSubview(footerView)
    }
}
