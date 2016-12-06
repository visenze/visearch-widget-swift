//
//  ViImageConfig.swift
//  ViSearchWidgets
//
//  Created by Hung on 9/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

/// Configuration for product image
public struct ViImageConfig {
    
    /// image size
    public var size: CGSize
    
    /// image view content mode
    public var contentMode: UIViewContentMode
    
    /// loading image
    public var loadingImg: UIImage?
    
    /// error image if network fails or broken link
    public var errImg: UIImage?
    
    /// init image config
    ///
    /// - Parameters:
    ///   - size: image size
    ///   - contentMode: content mode for uiimageview
    ///   - loadingImg: loading image
    ///   - errImg: error image
    public init( size: CGSize = CGSize(width: 150 , height: 240),
                 contentMode: UIViewContentMode = ViImageConfig.default_content_mode,
                 loadingImg: UIImage? = nil,
                 errImg: UIImage? = nil){
       
        // TODO: add configuration for loading image animation later e.g. fading
        
        self.size = size
        self.contentMode = contentMode
        self.loadingImg = loadingImg
        self.errImg = errImg
    }
    
    /// Default image view content mode
    public static var default_content_mode : UIViewContentMode = .scaleToFill
}

