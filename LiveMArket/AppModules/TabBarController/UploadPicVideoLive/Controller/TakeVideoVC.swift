//
//  TakePictureVC.swift
//  LiveMArket
//
//  Created by Zain on 25/01/2023.
//

import CoreLocation
import UIKit
import AVFoundation
import MobileCoreServices
import Photos


class TakeVideoVC: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    @IBOutlet var cameraView: UIView!
    let cameraManager = CameraManager()
    
    @IBOutlet weak var galleryFirstimage: UIImageView!
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var allPhotos : PHFetchResult<PHAsset>? = nil
    var videoEditDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPermissions()
        shouldPrompToAppSettings = true
        videoGravity = .resizeAspectFill
        cameraDelegate = self
        maximumVideoDuration = 20.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        flashMode = .auto
        videoQuality = .resolution1920x1080
        //flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        captureButton.buttonEnabled = false

        
    }
    func setPermissions() {
        cameraManager.askUserForCameraPermission { permissionGranted in
            
            if permissionGranted {
                let fetchOptions = PHFetchOptions()
                fetchOptions.fetchLimit = 1
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
                self.allPhotos = PHAsset.fetchAssets(with: fetchOptions)
                let firstImage = self.allPhotos?.lastObject?.getAssetThumbnail()
             
                DispatchQueue.main.async {
                    if firstImage != nil {
                        self.galleryFirstimage.image = firstImage
                    }
                }
                //self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureButton.delegate = self
    }
    
    // MARK: - ViewController
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = true
        
        cameraManager.writeFilesToPhoneLibrary = false
        
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
    }
    
    
//    fileprivate func addCameraToView() {
//        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.videoWithMic)
//        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
//
//            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) -> Void in }))
//
//            self?.present(alertController, animated: true, completion: nil)
//        }
//    }
    @IBAction func changeCameraDevice() {
        //cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switchCamera()
    }
    @IBAction func muteAction(_ sender: Any) {
    }
    @IBAction func flashAction(_ sender: UIButton) {
        toggleFlashAnimation()
    }
    @IBAction func Close() {
        self.navigationController?.popViewController(animated: true)
        Constants.shared.uploadVideoArray.removeAll()
    }
    @IBAction func moveToUpload() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.videoQuality = .typeHigh
        imagePickerController.videoMaximumDuration = 60
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.allowsEditing = false
//        if #available(iOS 11.0, *) {
//            imagePickerController.videoExportPreset = AVAssetExportPreset1920x1080
//        }
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func flashButtonAction(_ sender: UIButton) {
        toggleFlashAnimation()
    }
    @IBAction func audioBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func pictureBtnAction(_ sender: Any) {
        
        if let navigationController = navigationController {
            let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "TakePictureVC") as! TakePictureVC
            var viewControllers = navigationController.viewControllers
            viewControllers.removeLast() // Remove the current view controller
            viewControllers.append(VC) // Add the new view controller
            
            navigationController.setViewControllers(viewControllers, animated: true)
        }
    }
    
    @IBAction func liveBtnAction(_ sender: Any) {
        
        if let navigationController = navigationController {
            if #available(iOS 15.0, *) {
                let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "LiveVC") as! LiveVC
                var viewControllers = navigationController.viewControllers
                viewControllers.removeLast() // Remove the current view controller
                viewControllers.append(VC) // Add the new view controller
                
                navigationController.setViewControllers(viewControllers, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    
    func navigateToPreview(url:URL){
        let  newVC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        newVC.videoURL = url
        Constants.shared.uploadVideoArray.removeAll()
        Constants.shared.uploadVideoArray.append(url)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //MARK: Video Handler
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
        //        let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "PhotoViewViewController") as! PhotoViewViewController
        //        VC.image = photo
        //        Constants.shared.uploadImageArray.append(photo)
        //        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        showButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
//        let newVC = VideoViewController(videoURL: url)
//        Constants.shared.uploadVideoArray.append(url)
//        self.navigationController?.pushViewController(newVC, animated: true)
        videoEditDone = false
//        if UIVideoEditorController.canEditVideo(atPath: url.relativePath) {
//            let editController = UIVideoEditorController()
//            editController.videoPath = url.relativePath
//            editController.delegate = self
//            editController.videoQuality = .typeHigh
//            present(editController, animated:true)
//        }
        
        navigateToPreview(url: url)
        
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
}


// UI Animations
extension TakeVideoVC {
    
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            // self.flashButton.alpha = 0.0
            // self.flipCameraButton.alpha = 0.0
        }
    }
    
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            //self.flashButton.alpha = 1.0
            // self.flipCameraButton.alpha = 1.0
        }
    }
    
    fileprivate func focusAnimationAt(_ point: CGPoint) {
//        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
//        focusView.center = point
//        focusView.alpha = 0.0
//        view.addSubview(focusView)
//
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
//            focusView.alpha = 1.0
//            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
//        }) { (success) in
//            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
//                focusView.alpha = 0.0
//                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
//            }) { (success) in
//                focusView.removeFromSuperview()
//            }
//        }
    }
    
    fileprivate func toggleFlashAnimation() {
        //flashEnabled = !flashEnabled
        if flashMode == .auto{
            flashMode = .on
            //flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
        }else if flashMode == .on{
            flashMode = .off
            //flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
        }else if flashMode == .off{
            flashMode = .auto
            //flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        }
    }
}
extension TakeVideoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print(videoURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigateToPreview(url: videoURL)
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
}


extension TakeVideoVC: UIVideoEditorControllerDelegate {
    func videoEditorController(_ editor: UIVideoEditorController,
       didSaveEditedVideoToPath editedVideoPath: String) {
        if(!videoEditDone){
            videoEditDone = true
            let url  = NSURL(fileURLWithPath: editedVideoPath)
            if let videoURL = url as? URL {
                navigateToPreview(url: videoURL)
            }
            dismiss(animated:true)
        }
    }

    func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
       dismiss(animated:true)
    }

    func videoEditorController(_ editor: UIVideoEditorController,
               didFailWithError error: Error) {
       print("an error occurred: \(error.localizedDescription)")
       dismiss(animated:true)
    }
}
