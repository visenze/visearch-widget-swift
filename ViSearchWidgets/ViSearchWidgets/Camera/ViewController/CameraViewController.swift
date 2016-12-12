
import UIKit
import AVFoundation
import Photos

public typealias CameraViewCompletion = (UIImage?, PHAsset?) -> Void

public extension CameraViewController {
    
    // MARK: Photo Library Picker
    
    /// Open photo library to pick photo
    public class func imagePickerViewController(croppingEnabled: Bool, completion: @escaping CameraViewCompletion) -> UINavigationController {
        let imagePicker = PhotoLibraryViewController()
        let navigationController = UINavigationController(rootViewController: imagePicker)
        
        navigationController.navigationBar.barTintColor = UIColor.black
        navigationController.navigationBar.barStyle = UIBarStyle.black
        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        imagePicker.onSelectionComplete = { [weak imagePicker] asset in
            if let asset = asset {
                let confirmController = ConfirmViewController(asset: asset, allowsCropping: croppingEnabled)
                confirmController.onComplete = { [weak imagePicker] image, asset in
                    if let image = image, let asset = asset {
                        completion(image, asset)
                    } else {
                        imagePicker?.dismiss(animated: true, completion: nil)
                    }
                }
                confirmController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                imagePicker?.present(confirmController, animated: true, completion: nil)
            } else {
                completion(nil, nil)
            }
        }
        
        return navigationController
    }
}

/// Open camera to take photo. This view controller will include user guide info button, flash button and reverse camera button
public class CameraViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let buttonSize : CGFloat = 52
    let spacingBtn : CGFloat = 10
    
    
    // MARK: Default Info Text
    
    /// title for info popover. Default to "How to Use"
    public var infoTitle : String = "How to Use"
    
    /// Default instruction on how to take photo
    public var infoTxt : String = "Snap a photo of an item you'd like to find, and we'll search our store to find a match or something very similar."
    
    /// Tips for using camera button
    public var infoCameraTxt : String = "Photograph the item straight-on in bright lighting for the best search results."
    
    /// Tips for using flash button
    public var infoFlashTxt : String = "Use the flash if there isn't enough light"
    
    // MARK: -
    
    var didUpdateViews = false
    var allowCropping = false
    var animationRunning = false
    
    var lastInterfaceOrientation : UIInterfaceOrientation?
    var onCompletion: CameraViewCompletion?
    var volumeControl: VolumeControl?
    
    var animationDuration: TimeInterval = 0.5
    var animationSpring: CGFloat = 0.5
    var rotateAnimation: UIViewAnimationOptions = .curveLinear
    
    var cameraButtonEdgeConstraint: NSLayoutConstraint?
    var cameraButtonGravityConstraint: NSLayoutConstraint?
    
    var closeButtonEdgeConstraint: NSLayoutConstraint?
    var closeButtonGravityConstraint: NSLayoutConstraint?
    var closeWidthConstraint: NSLayoutConstraint?
    var closeHeightConstraint: NSLayoutConstraint?
    
    var swapButtonEdgeConstraint: NSLayoutConstraint?
    var swapButtonGravityConstraint: NSLayoutConstraint?
    var swapWidthConstraint: NSLayoutConstraint?
    var swapHeightConstraint: NSLayoutConstraint?
    
    var infoButtonEdgeConstraint: NSLayoutConstraint?
    var infoButtonGravityConstraint: NSLayoutConstraint?
    var infoWidthConstraint: NSLayoutConstraint?
    var infoHeightConstraint: NSLayoutConstraint?
    
    var libraryButtonEdgeConstraint: NSLayoutConstraint?
    var libraryButtonGravityConstraint: NSLayoutConstraint?
    var libraryWidthConstraint: NSLayoutConstraint?
    var libraryHeightConstraint: NSLayoutConstraint?
    
    var flashButtonEdgeConstraint: NSLayoutConstraint?
    var flashButtonGravityConstraint: NSLayoutConstraint?
    var flashWidthConstraint: NSLayoutConstraint?
    var flashHeightConstraint: NSLayoutConstraint?
    
    var cameraOverlayEdgeOneConstraint: NSLayoutConstraint?
    var cameraOverlayEdgeTwoConstraint: NSLayoutConstraint?
    var cameraOverlayWidthConstraint: NSLayoutConstraint?
    var cameraOverlayCenterConstraint: NSLayoutConstraint?
    
    
    /// show/hide Power by ViSenze logo
    public var showPowerByViSenze : Bool = true
    
    var powerEdgeConstraint: NSLayoutConstraint?
    var powerGravityConstraint: NSLayoutConstraint?
    var powerWidthConstraint: NSLayoutConstraint?
    var powerHeightConstraint: NSLayoutConstraint?
    
    // MARK: UI elements
    
    /// Camera view
    public let cameraView : CameraView = {
        let cameraView = CameraView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()
    
    /// Crop grid overlay. This is not enabled currently. Cropping only work within ConfirmViewController
    let cameraOverlay : CropOverlay = {
        let cameraOverlay = CropOverlay()
        cameraOverlay.translatesAutoresizingMaskIntoConstraints = false
        return cameraOverlay
    }()
    
    /// camera button for taking photo
    public let cameraButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setImage( ViIcon.big_camera, for: .normal)
        button.setImage( ViIcon.big_camera, for: .highlighted)
        return button
    }()
    
    /// close camera button. Default to back arrow icon
    public let closeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ViIcon.back, for: .normal)
        button.backgroundColor = ViTheme.sharedInstance.back_btn_background_color
        button.tintColor = ViTheme.sharedInstance.back_btn_tint_color
        button.clipsToBounds = true
        return button
    }()
    
    /// Info button. For showing user guide
    public let infoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ViIcon.info, for: .normal)
        return button
    }()
    
    /// Power by ViSenze
    public let powerView : UIImageView = {
        let view = UIImageView(image: ViIcon.power_visenze)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// swap/reverse front and back camera button
    public let swapButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ViIcon.reverse, for: .normal)
        return button
    }()
    
    /// select photo from library button
    public let libraryButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ViIcon.gallery, for: .normal)
        return button
    }()
    
    /// turn on/off flash button
    public let flashButton : UIButton = {
        // the frame has no effect here as it will be override by constrain
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ViIcon.lights, for: .normal)
        return button
    }()
    
    // MARK: - Constructors
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - croppingEnabled: enable/disable cropping after taking photo
    ///   - allowsLibraryAccess: whether to allow user select image from photo library
    ///   - completion: callback after taking photo / selecting photo from library
    public init(croppingEnabled: Bool, allowsLibraryAccess: Bool = true, completion: @escaping CameraViewCompletion) {
        super.init(nibName: nil, bundle: nil)
        onCompletion = completion
        allowCropping = croppingEnabled
        
//        cameraOverlay.isHidden = !allowCropping
        cameraOverlay.isHidden = true
        
        libraryButton.isEnabled = allowsLibraryAccess
        libraryButton.isHidden = !allowsLibraryAccess
    }
  
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: status bar
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    // MARK: -
    
    /**
     * Configure the background of the superview to black
     * and add the views on this superview. Then, request
     * the update of constraints for this superview.
     */
    public override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.black
        [cameraView,
            cameraOverlay,
            cameraButton,
            closeButton,
            flashButton,
            swapButton,
            libraryButton,
            infoButton,
            powerView].forEach({ self.view.addSubview($0) })
        
        powerView.isHidden = !self.showPowerByViSenze
        view.setNeedsUpdateConstraints()
    }
    
    /**
     * Setup the constraints when the app is starting or rotating the screen.
     * To avoid the override/conflict of stable constraint, these
     * stable constraint are one time configurable.
     * Any other dynamic constraint are configurable when the
     * device is rotating, based on the device orientation.
     */
    override public func updateViewConstraints() {

        if !didUpdateViews {
            configCameraViewConstraints()
            didUpdateViews = true
        }
        
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        let portrait = statusBarOrientation.isPortrait
        
        configCameraButtonEdgeConstraint(statusBarOrientation)
        configCameraButtonGravityConstraint(portrait)
        
        removeCloseButtonConstraints()
        configCloseButtonEdgeConstraint(statusBarOrientation)
        configCloseButtonGravityConstraint(statusBarOrientation)
        configCloseButtonSize(statusBarOrientation)
        
        removeInfoButtonConstraints()
        configInfoButtonConstraint(statusBarOrientation)
        
        removePowerViewConstraints()
        configPowerConstraint(statusBarOrientation)
        
        removeSwapButtonConstraints()
        configSwapButtonSize(statusBarOrientation)
        configSwapButtonEdgeConstraint(statusBarOrientation)
        configSwapButtonGravityConstraint(statusBarOrientation)

        removeLibraryButtonConstraints()
        configLibraryEdgeButtonConstraint(statusBarOrientation)
        configLibraryGravityButtonConstraint(statusBarOrientation)
        configLibraryButtonSize(statusBarOrientation)
        
        configFlashEdgeButtonConstraint(statusBarOrientation)
        configFlashGravityButtonConstraint(statusBarOrientation)
        configFlashButtonSize(statusBarOrientation)
        
        let padding : CGFloat = portrait ? 16.0 : -16.0
        removeCameraOverlayEdgesConstraints()
        configCameraOverlayEdgeOneContraint(portrait, padding: padding)
        configCameraOverlayEdgeTwoConstraint(portrait, padding: padding)
        configCameraOverlayWidthConstraint(portrait)
        configCameraOverlayCenterConstraint(portrait)
        
        rotate(actualInterfaceOrientation: statusBarOrientation)
        
        super.updateViewConstraints()
    }
    
    /**
     * Add observer to check when the camera has started,
     * enable the volume buttons to take the picture,
     * configure the actions of the buttons on the screen,
     * check the permissions of access of the camera and
     * the photo library.
     * Configure the camera focus when the application
     * start, to avoid any bluried image.
     */
    public override func viewDidLoad() {
        super.viewDidLoad()
        addCameraObserver()
        addRotateObserver()
        setupVolumeControl()
        setupActions()
        checkPermissions()
        cameraView.configureFocus()
    }

    /**
     * Start the session of the camera.
     */
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraView.startSession()
    }
    
    /**
     * Enable the button to take the picture when the
     * camera is ready.
     */
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if cameraView.session?.isRunning == true {
            notifyCameraReady()
        }
    }
    
    /**
     * Update constraints during rotation
     */
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
         lastInterfaceOrientation = UIApplication.shared.statusBarOrientation
        
        if animationRunning {
            return
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        coordinator.animate(alongsideTransition: { animation in
            self.view.setNeedsUpdateConstraints()
            
            }, completion: { _ in
                CATransaction.commit()
        })
    }
    
    /**
     * Observer the camera status, when it is ready,
     * it calls the method cameraReady to enable the
     * button to take the picture.
     */
    private func addCameraObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notifyCameraReady),
            name: NSNotification.Name.AVCaptureSessionDidStartRunning,
            object: nil)
    }
    
    /**
     * Observer the device orientation to update the
     * orientation of CameraView.
     */
    private func addRotateObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(rotateCameraView),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)
    }
    
    internal func notifyCameraReady() {
        cameraButton.isEnabled = true
    }
    
    /**
     * Attach the take of picture for any volume button.
     */
    private func setupVolumeControl() {
        volumeControl = VolumeControl(view: view) { [weak self] _ in
            if self?.cameraButton.isEnabled == true {
              self?.capturePhoto()
            }
        }
    }
    
    /**
     * Configure the action for every button on this
     * layout.
     */
    private func setupActions() {
        infoButton.action = { [weak self] in self?.showInfo() }
        
        cameraButton.action = { [weak self] in self?.capturePhoto() }
        swapButton.action = { [weak self] in self?.swapCamera() }
        libraryButton.action = { [weak self] in self?.showLibrary() }
        closeButton.action = { [weak self] in self?.close() }
        flashButton.action = { [weak self] in self?.toggleFlash() }
    }
    
    /**
     * Toggle the buttons status, based on the actual
     * state of the camera.
     */
    private func toggleButtons(enabled: Bool) {
        [cameraButton,
            closeButton,
            swapButton,
            libraryButton].forEach({ $0.isEnabled = enabled })
    }
    
    func rotateCameraView() {
        cameraView.rotatePreview()
    }
    
    /**
     * This method will rotate the buttons based on
     * the last and actual orientation of the device.
     */
    internal func rotate(actualInterfaceOrientation: UIInterfaceOrientation) {
        
        if lastInterfaceOrientation != nil {
            let lastTransform = CGAffineTransform(rotationAngle: CGFloat(radians(currentRotation(
                lastInterfaceOrientation!, newOrientation: actualInterfaceOrientation))))
            self.setTransform(transform: lastTransform)
        }

        let transform = CGAffineTransform(rotationAngle: 0)
        animationRunning = true
        
        /**
         * Dispach delay to avoid any conflict between the CATransaction of rotation of the screen
         * and CATransaction of animation of buttons.
         */

        let time: DispatchTime = DispatchTime.now() + Double(1 * UInt64(NSEC_PER_SEC)/10)
        DispatchQueue.main.asyncAfter(deadline: time) {
            
            CATransaction.begin()
            CATransaction.setDisableActions(false)
            CATransaction.commit()
            
            UIView.animate(
                withDuration: self.animationDuration,
                delay: 0.1,
                usingSpringWithDamping: self.animationSpring,
                initialSpringVelocity: 0,
                options: self.rotateAnimation,
                animations: {
                self.setTransform(transform: transform)
                }, completion: { _ in
                    self.animationRunning = false
            })
            
        }
    }
    
    func setTransform(transform: CGAffineTransform) {
        self.closeButton.transform = transform
        self.swapButton.transform = transform
        self.libraryButton.transform = transform
        self.flashButton.transform = transform
    }
    
    /**
     * Validate the permissions of the camera and
     * library, if the user do not accept these
     * permissions, it shows an view that notifies
     * the user that it not allow the permissions.
     */
    private func checkPermissions() {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) != .authorized {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                DispatchQueue.main.async() {
                    if !granted {
                        self.showNoPermissionsView()
                    }
                }
            }
        }
    }
    
    /**
     * Generate the view of no permission.
     */
    private func showNoPermissionsView(library: Bool = false) {
        let permissionsView = PermissionsView(frame: view.bounds)
        let title: String
        let desc: String
        
        if library {
            title = localizedString("permissions.library.title")
            desc = localizedString("permissions.library.description")
        } else {
            title = localizedString("permissions.title")
            desc = localizedString("permissions.description")
        }
        
        permissionsView.configureInView(view, title: title, descriptiom: desc, completion: close)
    }
    
    /**
     * This method will be called when the user
     * try to take the picture.
     * It will lock any button while the shot is
     * taken, then, realease the buttons and save
     * the picture on the device.
     */
    internal func capturePhoto() {
        guard let output = cameraView.imageOutput,
            let connection = output.connection(withMediaType: AVMediaTypeVideo) else {
            return
        }
        
        if connection.isEnabled {
            toggleButtons(enabled: false)
            cameraView.capturePhoto { image in
                guard let image = image else {
                    self.toggleButtons(enabled: true)
                    return
                }
                self.saveImage(image: image)
            }
        }
    }
    
    internal func saveImage(image: UIImage) {
        let spinner = showSpinner()
        cameraView.preview.isHidden = true
        
        _ = SingleImageSaver()
            .setImage(image)
            .onSuccess { asset in
                
                DispatchQueue.main.async {
                    self.hideSpinner(spinner)
                }
                
                self.layoutCameraResult(asset: asset)
            }
            .onFailure { error in
                DispatchQueue.main.async {
                    self.hideSpinner(spinner)
                }
                
                self.toggleButtons(enabled: true)
                self.showNoPermissionsView(library: true)
                self.cameraView.preview.isHidden = false
            }
            .save()
    }
    
    internal func close() {
        onCompletion?(nil, nil)
    }
    
    
    // MARK: buttons actions
    internal func showLibrary() {
        let imagePicker = CameraViewController.imagePickerViewController(croppingEnabled: allowCropping) { image, asset in

            defer {
                self.dismiss(animated: true, completion: nil)
            }

            guard let image = image, let asset = asset else {
                return
            }
            
            self.onCompletion?(image, asset)
        }
        
        present(imagePicker, animated: true) {
            self.cameraView.stopSession()
        }
    }
    
    internal func toggleFlash() {
        cameraView.cycleFlash()
        
        guard let device = cameraView.device else {
            return
        }
  
        let image = device.flashMode == .on ?  ViIcon.lights_sel : ViIcon.lights
        flashButton.setImage(image, for: .normal)
        if device.flashMode == .on {
            flashButton.tintColor = UIColor.white
        }
        
    }
    
    internal func swapCamera() {
        cameraView.swapCameraInput()
        flashButton.isHidden = cameraView.currentPosition == AVCaptureDevicePosition.front
        infoButton.isHidden = cameraView.currentPosition == AVCaptureDevicePosition.front
    }
    
    internal func showInfo() {
        let controller = UIViewController()
        controller.modalPresentationStyle = .popover
        
        let deviceWidth =  min( UIScreen.main.bounds.size.width , UIScreen.main.bounds.size.height)
        
        controller.preferredContentSize = CGSize(width: deviceWidth, height: 250)
        
        let label = UILabel(frame: CGRect(x: 10, y: 6, width: deviceWidth - 20, height: 30))
        label.text = self.infoTitle
        label.textAlignment = .center
        label.font = ViFont.medium(with: 20)
        label.textColor = UIColor.white
        controller.view.addSubview(label)
        
        let txtFont = ViFont.regular(with: 14)
        let textview = UITextView()
        textview.frame = CGRect(x: 10, y: (label.frame.origin.y + label.frame.size.height ),
                                width: deviceWidth - 20,
                                height: 80)
        textview.isEditable = false
        textview.text = self.infoTxt
        textview.font = txtFont
        textview.textColor = UIColor.white
        textview.backgroundColor = UIColor.clear
        textview.sizeToFit()
        
        controller.view.addSubview(textview)
        
        // add camera icon
        let cameraIconView = UIImageView(image: ViIcon.big_camera)
        cameraIconView.clipsToBounds = true
        cameraIconView.frame = CGRect(x: textview.frame.origin.x,
                                      y: textview.frame.origin.y + textview.frame.size.height + 4,
                                      width: 40, height: 40)
        controller.view.addSubview(cameraIconView)
        
        // camera text
        let cameraLabelX : CGFloat = cameraIconView.frame.origin.x + cameraIconView.frame.size.width + 8
        let cameraLabel = UILabel(frame: CGRect(x: cameraLabelX ,
                                                y: cameraIconView.frame.origin.y,
                                                width: textview.frame.size.width - cameraIconView.frame.size.width - 8,
                                                height: 40 ))
        cameraLabel.text = self.infoCameraTxt
        cameraLabel.textAlignment = .left
        cameraLabel.numberOfLines = 2
        cameraLabel.font = txtFont
        cameraLabel.textColor = UIColor.white
        controller.view.addSubview(cameraLabel)
        
        // add flash
        let flashIconView = UIImageView(image: ViIcon.lights)
        flashIconView.clipsToBounds = true
        flashIconView.frame = CGRect(x: cameraIconView.frame.origin.x,
                                      y: cameraIconView.frame.origin.y + cameraIconView.frame.size.height + 8,
                                      width: 40, height: 40)
//        flashIconView.tintColor = UIColor.white
        controller.view.addSubview(flashIconView)
        
        let flashLabelX : CGFloat = flashIconView.frame.origin.x + flashIconView.frame.size.width + 8
        let flashLabel = UILabel(frame: CGRect(x: flashLabelX ,
                                                y: flashIconView.frame.origin.y,
                                                width: textview.frame.size.width - flashIconView.frame.size.width - 8,
                                                height: 40 ))
        flashLabel.text = self.infoFlashTxt
        flashLabel.textAlignment = .left
        flashLabel.numberOfLines = 2
        flashLabel.font = txtFont
        flashLabel.textColor = UIColor.white
        controller.view.addSubview(flashLabel)
        
        if let popoverController = controller.popoverPresentationController {
            popoverController.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.6)
            popoverController.sourceView = self.infoButton
            popoverController.sourceRect = self.infoButton.bounds
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            popoverController.delegate = self
        }
        
        self.present(controller, animated: false, completion: nil)
    }
    
    // MARK: -
    
    internal func layoutCameraResult(asset: PHAsset) {
        cameraView.stopSession()
        startConfirmController(asset: asset)
        toggleButtons(enabled: true)
    }
    
    private func startConfirmController(asset: PHAsset) {
        let confirmViewController = ConfirmViewController(asset: asset, allowsCropping: allowCropping)
        confirmViewController.onComplete = { image, asset in
            if let image = image, let asset = asset {
                self.onCompletion?(image, asset)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        confirmViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(confirmViewController, animated: true, completion: nil)
    }
    
    // MARK: UIPopoverPresentationControllerDelegate
    
    /// important - this is needed so that a popover (info guide text) will be shown instead of fullscreen
    /// for ios 8.3+
    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                          traitCollection: UITraitCollection) -> UIModalPresentationStyle{
        return .none
    }
    
    /// return .none to display as popover (ios 8.0 - 8.2)
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: Spinner animation
    
    private func showSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .white
        spinner.center = view.center
        spinner.startAnimating()
        
        view.addSubview(spinner)
        view.bringSubview(toFront: spinner)
        
        return spinner
    }
    
    private func hideSpinner(_ spinner: UIActivityIndicatorView) {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }

    
}
