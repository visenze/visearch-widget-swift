import UIKit
import Photos

/// For user to confirm whether to keep image after taking photo from camera, select image from photo library
/// optional to crop photo here
public class ConfirmViewController: UIViewController, UIScrollViewDelegate {
    
    public let imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var powerBy: UIImageView!
    @IBOutlet weak var cropOverlay: CropOverlay!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var centeringView: UIView!
    
    /// enable/disable cropping
    var allowsCropping: Bool = false
    
    /// vertical padding
    var verticalPadding: CGFloat = 30
    
    /// horizontal padding
    var horizontalPadding: CGFloat = 30
    
    /// complete call back
    public var onComplete: CameraViewCompletion?
    
    /// photo asset
    var asset: PHAsset!
    
    /// store the last cropping rect
    var lastNormalizedCropRect: CGRect = .zero
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - asset: recent taken/selected photo asset
    ///   - allowsCropping: enable/disable cropping
    public init(asset: PHAsset, allowsCropping: Bool) {
        self.allowsCropping = allowsCropping
        self.asset = asset
        
        var bundle = Bundle(for: CameraViewController.self)
        
        let identifier = bundle.bundleIdentifier
        if  (true == identifier?.hasPrefix("org.cocoapods") ) {
            let path = (bundle.bundlePath as NSString).appendingPathComponent("com.visenze.ui.bundle")
            bundle = Bundle(path: path)!
        }
        
        super.init(nibName: "ConfirmViewController", bundle: bundle)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Status Bar
    
    /// hide status bar
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// status bar animation
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    // MARK: Loading and rotation
    
    /// viewDidLoad
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1
        
        cropOverlay.isHidden = true
        
        guard let asset = asset else {
            return
        }
        
        let spinner = showSpinner()
        
        disable()

        _ = SingleImageFetcher()
            .setAsset(asset)
            .setTargetSize(largestPhotoSize())
            .onSuccess { image in
                self.configureWithImage(image)
                self.hideSpinner(spinner)
                self.enable()
            }
            .onFailure { error in
                self.hideSpinner(spinner)
            }
            .fetch()
        
        self.configureButtons()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let scale = calculateMinimumScale(view.frame.size)
        let frame = allowsCropping ? cropOverlay.frame : view.bounds

        scrollView.contentInset = calculateScrollViewInsets(frame)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
        centerScrollViewContents()
        centerImageViewOnRotate()
        
    }
    
    /// Rotation handling. Rearrange buttons, images and reset crop box after rotation
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // before rotation
        
        coordinator.animate(alongsideTransition: { context in
            
            // during rotate
            let scale = self.calculateMinimumScale(size)
            var frame = self.view.bounds
            
            if self.allowsCropping {
                
                frame = self.cropOverlay.frame
                let centeringFrame = self.centeringView.frame
                var origin: CGPoint
                
                if size.width > size.height { // landscape
                    let offset = (size.width - centeringFrame.height)
                    let expectedX = (centeringFrame.height/2 - frame.height/2) + offset
                    origin = CGPoint(x: expectedX, y: frame.origin.x)
                } else {
                    let expectedY = (centeringFrame.width/2 - frame.width/2)
                    origin = CGPoint(x: frame.origin.y, y: expectedY)
                }
                
                frame.origin = origin
            } else {
                frame.size = size
            }
            
            self.scrollView.contentInset = self.calculateScrollViewInsets(frame)
            self.scrollView.minimumZoomScale = scale
            self.scrollView.zoomScale = scale
            self.centerScrollViewContents()
            self.centerImageViewOnRotate()
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
        }, completion: { context in
            
            // after rotate
            
        })
    }
    
    // MARK: UI configuration
    
    /// Configure buttons look and feel, background images, colors
    public func configureButtons() {
        
        // TODO: move this to ViTheme in later version
        self.confirmButton.backgroundColor = UIColor.clear
        self.cancelButton.backgroundColor = UIColor.colorWithHexString("#343434", alpha: 1.0)!
        self.cancelButton.tintColor = UIColor.white
        self.cancelButton.setImage(ViIcon.back, for: .normal)
        
        self.confirmButton.setBackgroundImage(ViIcon.big_camera_empty, for: .normal)
        self.confirmButton.setTitle("OK", for: .normal)
        self.confirmButton.setTitleColor(UIColor.black, for: .normal)
        self.confirmButton.titleLabel?.font = ViFont.medium(with: 24)
        self.confirmButton.titleEdgeInsets = UIEdgeInsetsMake(-4, -4, 0, 0)
        
        powerBy.image = ViIcon.power_visenze
    }
    
    private func configureWithImage(_ image: UIImage) {
        if allowsCropping {
            cropOverlay.isHidden = false
        } else {
            cropOverlay.isHidden = true
        }
        
        buttonActions()
        
        imageView.image = image
        imageView.sizeToFit()
        view.setNeedsLayout()
    }
    
    private func buttonActions() {
        confirmButton.action = { [weak self] in self?.confirmPhoto() }
        cancelButton.action = { [weak self] in self?.cancel() }
    }
    
    //MARK: Helper methods
    
    private func calculateMinimumScale(_ size: CGSize) -> CGFloat {
        var _size = size
        
        if allowsCropping {
            _size = cropOverlay.frame.size
        }
        
        guard let image = imageView.image else {
            return 1
        }
        
        let scaleWidth = _size.width / image.size.width
        let scaleHeight = _size.height / image.size.height
        
        var scale: CGFloat
        
        if allowsCropping {
            scale = max(scaleWidth, scaleHeight)
        } else {
            scale = min(scaleWidth, scaleHeight)
        }
        
        return scale
    }
    
    private func calculateScrollViewInsets(_ frame: CGRect) -> UIEdgeInsets {
        let bottom = view.frame.height - (frame.origin.y + frame.height)
        let right = view.frame.width - (frame.origin.x + frame.width)
        let insets = UIEdgeInsets(top: frame.origin.y, left: frame.origin.x, bottom: bottom, right: right)
        return insets
    }
    
    private func centerImageViewOnRotate() {
        if allowsCropping {
            let size = allowsCropping ? cropOverlay.frame.size : scrollView.frame.size
            
            let scrollInsets = scrollView.contentInset
            let imageSize = imageView.frame.size
            var contentOffset = CGPoint(x: -scrollInsets.left, y: -scrollInsets.top)
            contentOffset.x -= (size.width - imageSize.width) / 2
            contentOffset.y -= (size.height - imageSize.height) / 2
            scrollView.contentOffset = contentOffset
        }
    }
    
    private func centerScrollViewContents() {
        let size = allowsCropping ? cropOverlay.frame.size : scrollView.frame.size
        let imageSize = imageView.frame.size
        var imageOrigin = CGPoint.zero
        
        if imageSize.width < size.width {
            imageOrigin.x = (size.width - imageSize.width) / 2
        }
        
        if imageSize.height < size.height {
            imageOrigin.y = (size.height - imageSize.height) / 2
        }
        
        imageView.frame.origin = imageOrigin
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func showSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .white
        spinner.center = view.center
        spinner.startAnimating()
        
        view.addSubview(spinner)
        view.bringSubview(toFront: spinner)
        
        return spinner
    }
    
    func hideSpinner(_ spinner: UIActivityIndicatorView) {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    func disable() {
        confirmButton.isEnabled = false
    }
    
    func enable() {
        confirmButton.isEnabled = true
    }
    
    //MARK: Actions
    internal func cancel() {
        onComplete?(nil, nil)
    }
    
    internal func confirmPhoto() {
        
        disable()
        
        imageView.isHidden = true
        cropOverlay.isHidden = true
        
        let spinner = showSpinner()

        var fetcher = SingleImageFetcher()
            .onSuccess { image in
                self.onComplete?(image, self.asset)
                self.hideSpinner(spinner)
                self.enable()
           }
            .onFailure { error in            
                self.hideSpinner(spinner)
                self.showNoImageScreen(error)
            }
            .setAsset(asset)
        
        if allowsCropping {
            
            var cropRect = cropOverlay.frame
            cropRect.origin.x += scrollView.contentOffset.x
            cropRect.origin.y += scrollView.contentOffset.y
            
            let normalizedX = cropRect.origin.x / imageView.frame.width
            let normalizedY = cropRect.origin.y / imageView.frame.height
            
            let normalizedWidth = cropRect.width / imageView.frame.width
            let normalizedHeight = cropRect.height / imageView.frame.height
            
            let rect = normalizedRect(CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight), orientation: imageView.image!.imageOrientation)
            self.lastNormalizedCropRect = rect
            fetcher = fetcher.setCropRect(rect)
        }
        
        fetcher = fetcher.fetch()
    }
    
    
    /// Show error if cannot fetch image e.g. user denied access
    ///
    /// - Parameter error: error
    public func showNoImageScreen(_ error: NSError) {
        let permissionsView = PermissionsView(frame: view.bounds)
        
        let desc = localizedString("error.cant-fetch-photo.description")
        
        permissionsView.configureInView(view, title: error.localizedDescription, descriptiom: desc, completion: cancel)
    }
    
}
