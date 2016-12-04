import UIKit
import Photos

public typealias PhotoLibraryAuthorizerCompletion = (NSError?) -> Void


/// Handle authorization for photo library access
class PhotoLibraryAuthorizer {

    private let errorDomain = "com.visenze.imageFetcher"

    private let completion: PhotoLibraryAuthorizerCompletion

    init(completion: @escaping PhotoLibraryAuthorizerCompletion) {
        self.completion = completion
        handleAuthorization(status: PHPhotoLibrary.authorizationStatus())
    }
    
    func onDeniedOrRestricted(completion: PhotoLibraryAuthorizerCompletion) {
        let error = errorWithKey("error.access-denied", domain: errorDomain)
        completion(error)
    }
    
    func handleAuthorization(status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(handleAuthorization)
            break
        case .authorized:
            DispatchQueue.main.async {
                self.completion(nil)
            }
            break
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.onDeniedOrRestricted(completion: self.completion)
            }
            break
        }
    }
}
