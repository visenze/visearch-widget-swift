import UIKit
import AVFoundation

public class CameraGlobals {
    internal let itemSpacing: CGFloat = 1
    internal let columns: CGFloat = 4
    internal let scale = UIScreen.main.scale
    
    public static let shared = CameraGlobals()
    
    public var bundle = Bundle(for: CameraViewController.self)
    
    public var stringsTable = "ViSearchWidgets"
    
    public var photoLibraryThumbnailSize : CGSize {
        let thumbnailDimension = (UIScreen.main.bounds.width - ((columns * itemSpacing) - itemSpacing))/columns
        return CGSize(width: thumbnailDimension, height: thumbnailDimension)
    }
    public var defaultCameraPosition = AVCaptureDevicePosition.back
}
