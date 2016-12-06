import UIKit
import AVFoundation

/// store constants used for camera functions
public class CameraGlobals {
    
    /// item spacing used in photo library picker
    internal let itemSpacing: CGFloat = 1
    
    /// number of columns in photo library picker
    internal let columns: CGFloat = 4
    
    /// screen scale
    internal let scale = UIScreen.main.scale
    
    /// singleton
    public static let shared = CameraGlobals()
    
    /// localization for error messages encounted in using camera
    public var stringsTable = "ViSearchWidgets"
    
    /// thumbnail for photo in library picker
    public var photoLibraryThumbnailSize : CGSize {
        let thumbnailDimension = (UIScreen.main.bounds.width - ((columns * itemSpacing) - itemSpacing))/columns
        return CGSize(width: thumbnailDimension, height: thumbnailDimension)
    }
    
    /// default camera position
    public var defaultCameraPosition = AVCaptureDevicePosition.back
}
