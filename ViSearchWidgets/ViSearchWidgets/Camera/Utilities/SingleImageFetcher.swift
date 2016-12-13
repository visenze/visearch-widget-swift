import UIKit
import Photos

public typealias SingleImageFetcherSuccess = (UIImage) -> Void
public typealias SingleImageFetcherFailure = (NSError) -> Void

/// fetch single image from photo library for cropping
public class SingleImageFetcher {
    private let errorDomain = "com.visenze.singleImageSaver"
    
    private var success: SingleImageFetcherSuccess?
    private var failure: SingleImageFetcherFailure?
    
    private var asset: PHAsset?
    private var targetSize = PHImageManagerMaximumSize
    private var cropRect: CGRect?
    
    public init() { }
    
    public func onSuccess(_ success: @escaping SingleImageFetcherSuccess) -> Self {
        self.success = success
        return self
    }
    
    public func onFailure(_ failure: @escaping SingleImageFetcherFailure) -> Self {
        self.failure = failure
        return self
    }
    
    public func setAsset(_ asset: PHAsset) -> Self {
        self.asset = asset
        return self
    }
    
    public func setTargetSize(_ targetSize: CGSize) -> Self {
        self.targetSize = targetSize
        return self
    }
    
    public func setCropRect(_ cropRect: CGRect) -> Self {
        self.cropRect = cropRect
        return self
    }
    
    public func fetch() -> Self {
        _ = PhotoLibraryAuthorizer { error in
            if error == nil {
                self._fetch()
            } else {
                self.failure?(error!)
            }
        }
        return self
    }
    
    private func _fetch() {
    
        guard let asset = asset else {
            let error = errorWithKey("error.cant-fetch-photo", domain: errorDomain)
            failure?(error)
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        //options.isSynchronous = true

        if let cropRect = cropRect {

            options.normalizedCropRect = cropRect
            options.resizeMode = .exact
            
            let targetWidth = floor(CGFloat(asset.pixelWidth) * cropRect.width)
            let targetHeight = floor(CGFloat(asset.pixelHeight) * cropRect.height)
            
//            let dimension = max(min(targetHeight, targetWidth), 1024 * CameraGlobals.shared.scale)
//            targetSize = CGSize(width: dimension, height: dimension)
            
            targetSize = CGSize(width: targetWidth, height: targetHeight)
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            if let image = image {
//                print("crop: \(self.cropRect)")
//                print("img size: \(image.size) , target: \(self.targetSize)")
//                print("======")
                if let cr = self.cropRect {
                    // cropping, fix ios 8 bug. in ios8, it does not return the cropped version but the scaled down version
                    // we will implement our own cropping in this case
                    if self.targetSize.width < image.size.width || self.targetSize.height < image.size.height {
//                        print ("self crop: ow: \(asset.pixelWidth) , h : \(asset.pixelHeight)")
                        
                        let targetX = floor( image.size.width  * cr.origin.x)
                        let targetY = floor( image.size.height * cr.origin.y)
                        let targetWidth = floor(image.size.width  * cr.width)
                        let targetHeight = floor(image.size.height * cr.height)
                        
                        let newCr = CGRect(x: targetX, y: targetY, width: targetWidth, height: targetHeight)
                        
                        let cropedImg = image.getImageInRect(rect: newCr)
                        self.success?(cropedImg)
                    }
                    else {
                        self.success?(image)
                    }
                }
                else {
                    self.success?(image)
                }
            } else {
                let error = errorWithKey("error.cant-fetch-photo", domain: self.errorDomain)
                self.failure?(error)
            }
        }
    }
}
