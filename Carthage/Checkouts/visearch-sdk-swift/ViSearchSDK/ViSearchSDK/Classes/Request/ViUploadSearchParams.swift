//
//  ViUploadSearchParams.swift
//  ViSearchSDK
//
//  Created by Hung on 6/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import Foundation
import UIKit

/// construct upload search parameter requests. See http://developers.visenze.com/api/?shell#search-by-image for more details
public class ViUploadSearchParams: ViBaseSearchParams {
    
    // MARK: properties
    public var im_url : String?
    public var im_id  : String?
    public var box    : ViBox?
    
    // image for upload
    public var img_settings : ViImageSettings = ViImageSettings()
    public var image : UIImage?
    private var compressed_image : UIImage?
    private var compressed_image_data : Data?
    
    public init(image: UIImage){
        self.image = image
        im_id = nil
        im_url = nil
    }
    
    public init?(im_id : String){
        if im_id.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: im_id parameter is missing")
            return nil
        }
        self.im_id = im_id
        image = nil
        im_url = nil
    }
    
    public init?(im_url : String){
        if im_url.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: im_url parameter is missing")
            return nil
        }
        self.im_url = im_url
        im_id = nil
        image = nil
    }
    
    /// return the compressed/resize image data before uploading
    public func generateCompressImageForUpload() -> Data?
    {
        if let image = image {
        
            let quality = self.img_settings.quality;
            
            // maxWidth should not larger than 1024 pixels
            let maxWidth = CGFloat( (self.img_settings.maxWidth > 1024) ? 1024: self.img_settings.maxWidth );
            
            var actualHeight : CGFloat = image.size.height * image.scale;
            var actualWidth  : CGFloat = image.size.width * image.scale;
            let maxHeight : CGFloat = maxWidth
            var imgRatio : CGFloat = actualWidth/actualHeight;
            let maxRatio : CGFloat = maxWidth/maxHeight;
            
            if (actualHeight > maxHeight || actualWidth > maxWidth) {
                if(imgRatio < maxRatio){
                    //adjust width according to maxHeight
                    imgRatio = maxHeight / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = maxHeight;
                }
                else if(imgRatio > maxRatio){
                    //adjust height according to maxWidth
                    imgRatio = CGFloat(self.img_settings.maxWidth) / actualWidth;
                    actualHeight = imgRatio * actualHeight;
                    actualWidth = maxWidth;
                }else{
                    actualHeight = maxHeight;
                    actualWidth = maxWidth;
                }
            }
            
            let rect : CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight);
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0);
            image.draw(in: rect)
            let img = UIGraphicsGetImageFromCurrentImageContext();
            let imageData : Data = UIImageJPEGRepresentation(img!, CGFloat(quality))!;
            UIGraphicsEndImageContext();
            
            self.compressed_image_data = imageData
            self.compressed_image = UIImage(data: imageData)
            
            return imageData
        }
        
        return nil
    }
    
    
    public override func toDict() -> [String: Any] {
        var dict = super.toDict()
        
        if let image = image {
            // add in box parameters
            if let box = box {
                
                if let compressed_image = compressed_image {
                    
                    let scale : CGFloat =
                        (compressed_image.size.height > compressed_image.size.width) ?
                            compressed_image.size.height * compressed_image.scale / (image.size.height * image.scale)
                        : compressed_image.size.width * compressed_image.scale / (image.size.width * image.scale);
                    
                    let scaleX1 = Int(scale * CGFloat(box.x1) )
                    let scaleX2 = Int(scale * CGFloat(box.x2) )
                    let scaleY1 = Int(scale * CGFloat(box.y1) )
                    let scaleY2 = Int(scale * CGFloat(box.y2) )
                        
                    dict["box"] = "\(scaleX1),\(scaleY1),\(scaleX2),\(scaleY2)"
                    
                }
                else{
                    dict["box"] = "\(box.x1),\(box.y1),\(box.x2),\(box.y2)"
                }
            }
            
        }
        else if let im_url = im_url {
            dict["im_url"] = im_url
        }
        else if let img_id = im_id {
            dict["im_id"] = img_id
        }
        else{
            print ("image or im_url or im_id must be provided. Request likely will fail")
        }
        
        return dict;
    }
    
}
