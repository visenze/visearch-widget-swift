import UIKit
import AVFoundation

/**
 * This extension provides the configuration of
 * constraints for CameraViewController.
 */
extension CameraViewController {
    
    
    /**
     * To attach the view to the edges of the superview, it needs
     to be pinned on the sides of the self.view, based on the
     edges of this superview.
     * This configure the cameraView to show, in real time, the
     * camera.
     */
    func configCameraViewConstraints() {
        [.left, .right, .top, .bottom].forEach({
            view.addConstraint(NSLayoutConstraint(
                item: cameraView,
                attribute: $0,
                relatedBy: .equal,
                toItem: view,
                attribute: $0,
                multiplier: 1.0,
                constant: 0))
        })
    }
    
  
    func configCameraButtonEdgeConstraint(_ statusBarOrientation: UIInterfaceOrientation) {
        view.autoRemoveConstraint(cameraButtonEdgeConstraint)
        
        let attribute : NSLayoutAttribute = {
            switch statusBarOrientation {
            case .portrait: return .bottom
            case .landscapeRight: return .bottom
            case .landscapeLeft: return .bottom
            default: return .bottom
            }
        }()
        
        cameraButtonEdgeConstraint = NSLayoutConstraint(
            item: cameraButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: -8 )
        view.addConstraint(cameraButtonEdgeConstraint!)
    }
    
    func configCameraButtonGravityConstraint(_ portrait: Bool) {
        view.autoRemoveConstraint(cameraButtonGravityConstraint)
        let attribute : NSLayoutAttribute =  .centerX
        cameraButtonGravityConstraint = NSLayoutConstraint(
            item: cameraButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: 0)
        view.addConstraint(cameraButtonGravityConstraint!)
    }
    
   
    /**
     * Remove the SwapButton constraints to be updated when
     * the device was rotated.
     */
    func removeSwapButtonConstraints() {
        view.autoRemoveConstraint(swapButtonEdgeConstraint)
        view.autoRemoveConstraint(swapButtonGravityConstraint)
        view.autoRemoveConstraint(swapWidthConstraint)
        view.autoRemoveConstraint(swapHeightConstraint)
    }
    
    func configSwapButtonSize(_ statusBarOrientation : UIInterfaceOrientation) {
        
        
        swapHeightConstraint = NSLayoutConstraint(
            item: swapButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: buttonSize)
        
        swapWidthConstraint = NSLayoutConstraint(
            item: swapButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: swapButton,
            attribute: .height,
            multiplier: 1.0,
            constant: 0)
        
        view.addConstraint(swapHeightConstraint!)
        view.addConstraint(swapWidthConstraint!)
        
    }
   
    func configSwapButtonEdgeConstraint(_ statusBarOrientation : UIInterfaceOrientation) {
        
        swapButtonEdgeConstraint = NSLayoutConstraint(
            item: swapButton,
            attribute: .top,
            relatedBy: .equal,
            toItem: view,
            attribute: .top,
            multiplier: 1.0,
            constant: spacingBtn )
        view.addConstraint(swapButtonEdgeConstraint!)
    }
    
   
    func configSwapButtonGravityConstraint(_ statusBarOrientation : UIInterfaceOrientation) {
                
        swapButtonGravityConstraint = NSLayoutConstraint(
            item: swapButton,
            attribute: .right,
            relatedBy: .equal,
            toItem: view,
            attribute: .right,
            multiplier: 1.0,
            constant: -spacingBtn )
        view.addConstraint(swapButtonGravityConstraint!)
    }
    
    func removeCloseButtonConstraints() {
        view.autoRemoveConstraint(closeButtonEdgeConstraint)
        view.autoRemoveConstraint(closeButtonGravityConstraint)
        view.autoRemoveConstraint(closeWidthConstraint)
        view.autoRemoveConstraint(closeHeightConstraint)
        
    }
    
    /**
     * Pin the close button to the left of the superview.
     */
    func configCloseButtonEdgeConstraint(_ statusBarOrientation : UIInterfaceOrientation) {
        
        let attribute : NSLayoutAttribute = .left
        
        closeButtonEdgeConstraint = NSLayoutConstraint(
            item: closeButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view ,
            attribute: attribute,
            multiplier: 1.0,
            constant:  16 )
        view.addConstraint(closeButtonEdgeConstraint!)
        
        
    }
    
    func configCloseButtonSize(_ statusBarOrientation : UIInterfaceOrientation) {
        
        closeHeightConstraint = NSLayoutConstraint(
            item: closeButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: buttonSize - 14)
        
        closeWidthConstraint = NSLayoutConstraint(
            item: closeButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: closeButton,
            attribute: .height,
            multiplier: 1.0,
            constant: 0)
        
        view.addConstraint(closeHeightConstraint!)
        view.addConstraint(closeWidthConstraint!)
        
        
    }
    
    /**
     * Add the constraint for the CloseButton, based on
     * the device orientation. Pin Close button to top of the superview
     */
    func configCloseButtonGravityConstraint(_ statusBarOrientation : UIInterfaceOrientation) {
        
        let attribute : NSLayoutAttribute = .top
        
        closeButtonGravityConstraint = NSLayoutConstraint(
            item: closeButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: (spacingBtn + 4)  )
        view.addConstraint(closeButtonGravityConstraint!)
    }
    
    func removePowerViewConstraints() {
        view.autoRemoveConstraint(powerEdgeConstraint)
        view.autoRemoveConstraint(powerWidthConstraint)
        view.autoRemoveConstraint(powerHeightConstraint)
        view.autoRemoveConstraint(powerGravityConstraint)
    }
    func configPowerConstraint(_ statusBarOrientation : UIInterfaceOrientation) {
        // size
        powerHeightConstraint = NSLayoutConstraint(
            item: powerView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: ViIcon.power_visenze!.height )
        
        powerWidthConstraint = NSLayoutConstraint(
            item: powerView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: ViIcon.power_visenze!.width )
        
        view.addConstraint(powerHeightConstraint!)
        view.addConstraint(powerWidthConstraint!)
        
        // left constraint
        let attribute : NSLayoutAttribute = .left
        
        powerGravityConstraint = NSLayoutConstraint(
            item: powerView,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: spacingBtn )
        view.addConstraint(powerGravityConstraint!)
        
        // bottom contrain
        let botAttribute : NSLayoutAttribute = .bottom
        
        powerEdgeConstraint = NSLayoutConstraint(
            item: powerView,
            attribute: botAttribute,
            relatedBy: .equal,
            toItem: view,
            attribute: botAttribute,
            multiplier: 1.0,
            constant: -spacingBtn )
        view.addConstraint(powerEdgeConstraint!)

    }
    
    
    func removeInfoButtonConstraints() {
        view.autoRemoveConstraint(infoButtonEdgeConstraint)
        view.autoRemoveConstraint(infoButtonGravityConstraint)
        view.autoRemoveConstraint(infoWidthConstraint)
        view.autoRemoveConstraint(infoHeightConstraint)
    }
    
    func configInfoButtonConstraint(_ statusBarOrientation : UIInterfaceOrientation) {
        
        // size
        infoHeightConstraint = NSLayoutConstraint(
            item: infoButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: buttonSize + 8)
        
        infoWidthConstraint = NSLayoutConstraint(
            item: infoButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: infoButton,
            attribute: .height,
            multiplier: 1.0,
            constant: 0)
        
        view.addConstraint(infoHeightConstraint!)
        view.addConstraint(infoWidthConstraint!)
        
        // right constraint
        let attribute : NSLayoutAttribute = .right
        
        infoButtonGravityConstraint = NSLayoutConstraint(
            item: infoButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant:  -(6 + buttonSize * 2)  )
        view.addConstraint(infoButtonGravityConstraint!)
        
        // top constraint
        let topAttribute : NSLayoutAttribute = .top
        
        infoButtonEdgeConstraint = NSLayoutConstraint(
            item: infoButton,
            attribute: topAttribute,
            relatedBy: .equal,
            toItem: view,
            attribute: topAttribute,
            multiplier: 1.0,
            constant:  6 )
        view.addConstraint(infoButtonEdgeConstraint!)
        
        
    }
    
    
    /**
     * Remove the LibraryButton constraints to be updated when
     * the device was rotated.
     */
    func removeLibraryButtonConstraints() {
        view.autoRemoveConstraint(libraryButtonEdgeConstraint)
        view.autoRemoveConstraint(libraryButtonGravityConstraint)
        view.autoRemoveConstraint(libraryWidthConstraint)
        view.autoRemoveConstraint(libraryHeightConstraint)
        
    }
    
    func configLibraryEdgeButtonConstraint(_ statusBarOrientation : UIInterfaceOrientation) {

        let attribute : NSLayoutAttribute = .bottom
        
        libraryButtonEdgeConstraint = NSLayoutConstraint(
            item: libraryButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: -spacingBtn )
        view.addConstraint(libraryButtonEdgeConstraint!)
        
    }
    
    
    func configLibraryGravityButtonConstraint(_ statusBarOrientation: UIInterfaceOrientation) {
         let attribute : NSLayoutAttribute =  .right
        
        libraryButtonGravityConstraint = NSLayoutConstraint(
            item: libraryButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: -spacingBtn * 2 )
        view.addConstraint(libraryButtonGravityConstraint!)
    }
    
    func configLibraryButtonSize(_ statusBarOrientation : UIInterfaceOrientation) {
        
        libraryHeightConstraint = NSLayoutConstraint(
            item: libraryButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: buttonSize + 8)
        
        libraryWidthConstraint = NSLayoutConstraint(
            item: libraryButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: libraryButton,
            attribute: .height,
            multiplier: 1.0,
            constant: 0)
        
        view.addConstraint(libraryHeightConstraint!)
        view.addConstraint(libraryWidthConstraint!)
        
        
    }
    
    func configFlashButtonSize(_ statusBarOrientation : UIInterfaceOrientation) {
        
        // add width and height constraint for button
        view.autoRemoveConstraint(flashWidthConstraint)
        view.autoRemoveConstraint(flashHeightConstraint)
        
        flashHeightConstraint = NSLayoutConstraint(
            item: flashButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: buttonSize)
        
        flashWidthConstraint = NSLayoutConstraint(
            item: flashButton,
            attribute: .width,
            relatedBy: .equal,
            toItem: flashButton,
            attribute: .height,
            multiplier: 1.0,
            constant: 0)
        
        view.addConstraint(flashHeightConstraint!)
        view.addConstraint(flashWidthConstraint!)
        
        
    }
    
   
    func configFlashEdgeButtonConstraint(_ statusBarOrientation: UIInterfaceOrientation) {
        view.autoRemoveConstraint(flashButtonEdgeConstraint)
        
         let attribute : NSLayoutAttribute =  .top
        
        flashButtonEdgeConstraint = NSLayoutConstraint(
            item: flashButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant:  spacingBtn )
        view.addConstraint(flashButtonEdgeConstraint!)
    }
    
   
    func configFlashGravityButtonConstraint(_ statusBarOrientation: UIInterfaceOrientation) {
        view.autoRemoveConstraint(flashButtonGravityConstraint)
        
        let attribute : NSLayoutAttribute = .right
        
        flashButtonGravityConstraint = NSLayoutConstraint(
            item: flashButton,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant:  -(spacingBtn + buttonSize) )
        view.addConstraint(flashButtonGravityConstraint!)
    }
    
    /**
     * Used to create a perfect square for CameraOverlay.
     * This method will determinate the size of CameraOverlay,
     * if portrait, it will use the width of superview to
     * determinate the height of the view. Else if landscape,
     * it uses the height of the superview to create the width
     * of the CameraOverlay.
     */
    func configCameraOverlayWidthConstraint(_ portrait: Bool) {
        view.autoRemoveConstraint(cameraOverlayWidthConstraint)
        cameraOverlayWidthConstraint = NSLayoutConstraint(
            item: cameraOverlay,
            attribute: portrait ? .height : .width,
            relatedBy: .equal,
            toItem: cameraOverlay,
            attribute: portrait ? .width : .height,
            multiplier: 1.0,
            constant: 0)
        view.addConstraint(cameraOverlayWidthConstraint!)
    }
    
    /**
     * This method will center the relative position of
     * CameraOverlay, based on the biggest size of the
     * superview.
     */
    func configCameraOverlayCenterConstraint(_ portrait: Bool) {
        view.autoRemoveConstraint(cameraOverlayCenterConstraint)
        let attribute : NSLayoutAttribute = portrait ? .centerY : .centerX
        cameraOverlayCenterConstraint = NSLayoutConstraint(
            item: cameraOverlay,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: 0)
        view.addConstraint(cameraOverlayCenterConstraint!)
    }
    
    /**
     * Remove the CameraOverlay constraints to be updated when
     * the device was rotated.
     */
    func removeCameraOverlayEdgesConstraints() {
        view.autoRemoveConstraint(cameraOverlayEdgeOneConstraint)
        view.autoRemoveConstraint(cameraOverlayEdgeTwoConstraint)
    }
    
    /**
     * It needs to get a determined smallest size of the screen
     to create the smallest size to be used on CameraOverlay.
     It uses the orientation of the screen to determinate where
     the view will be pinned.
     */
    func configCameraOverlayEdgeOneContraint(_ portrait: Bool, padding: CGFloat) {
        let attribute : NSLayoutAttribute = portrait ? .left : .bottom
        cameraOverlayEdgeOneConstraint = NSLayoutConstraint(
            item: cameraOverlay,
            attribute: attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: padding)
        view.addConstraint(cameraOverlayEdgeOneConstraint!)
    }
    
    /**
     * It needs to get a determined smallest size of the screen
     to create the smallest size to be used on CameraOverlay.
     It uses the orientation of the screen to determinate where
     the view will be pinned.
     */
    func configCameraOverlayEdgeTwoConstraint(_ portrait: Bool, padding: CGFloat) {
        let attributeTwo : NSLayoutAttribute = portrait ? .right : .top
        cameraOverlayEdgeTwoConstraint = NSLayoutConstraint(
            item: cameraOverlay,
            attribute: attributeTwo,
            relatedBy: .equal,
            toItem: view,
            attribute: attributeTwo,
            multiplier: 1.0,
            constant: -padding)
        view.addConstraint(cameraOverlayEdgeTwoConstraint!)
    }
    
}
