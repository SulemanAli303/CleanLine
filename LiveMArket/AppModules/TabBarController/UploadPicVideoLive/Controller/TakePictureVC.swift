//
//  TakePictureVC.swift
//  LiveMArket
//
//  Created by Zain on 25/01/2023.
//

import CoreLocation
import UIKit
import AVFoundation
import Photos
import OpalImagePicker

class TakePictureVC: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    @IBOutlet weak var galleryFirstImageView: UIImageView!
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    @IBOutlet var cameraView: UIView!
    let cameraManager = CameraManager()
    var allPhotos : PHFetchResult<PHAsset>? = nil
    var imageMultiPicker = OpalImagePickerController()
    
   // var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var imagesArray : [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPermissions()
        isImageType = true
        videoGravity = .resizeAspect
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        flashMode = .auto
        //flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        captureButton.buttonEnabled = false
    }
    
    func setPermissions() {
        /*
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
                        self.galleryFirstImageView.image = firstImage
                    }
                }
                
                self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    // Fallback on earlier versions
                }
            }
        }*/
        
        let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        //access granted
                        let fetchOptions = PHFetchOptions()
                        fetchOptions.fetchLimit = 1
                        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
                        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
                        self.allPhotos = PHAsset.fetchAssets(with: fetchOptions)
                        let firstImage = self.allPhotos?.lastObject?.getAssetThumbnail()
                     
                        DispatchQueue.main.async {
                            if firstImage != nil {
                                self.galleryFirstImageView.image = firstImage
                            }
                        }
                        
                        self.addCameraToView()
                    } else {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                })
            }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureButton.delegate = self
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
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        
    }
    
    // MARK: - ViewController
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = true
        
        cameraManager.writeFilesToPhoneLibrary = false
        
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
    }
    
    @IBAction func flsahAction(_ sender: Any) {
        toggleFlashAnimation()
    }
    
    @IBAction func videoBtnAction(_ sender: Any) {
        
        if let navigationController = navigationController {
            let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "TakeVideoVC") as! TakeVideoVC
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
    
    fileprivate func addCameraToView() {
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) -> Void in }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func takephoto(_ sender: UIButton) {
        
        
    }
    @IBAction func changeCameraDevice() {
        //cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switchCamera()
    }
    @IBAction func Close() {
        if  Constants.shared.uploadImageArray.isEmpty {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func moveToUpload() {
//        imagePickerController.sourceType = .savedPhotosAlbum
//        imagePickerController.delegate = self
//        imagePickerController.mediaTypes = ["public.image"]
//        present(imagePickerController, animated: true, completion: nil)
        
        imageMultiPicker = OpalImagePickerController()
        imageMultiPicker.imagePickerDelegate = self
        imageMultiPicker.allowedMediaTypes =  Set([PHAssetMediaType.image])
        imageMultiPicker.maximumSelectionsAllowed = 5 - Constants.shared.uploadImageArray.count
        imageMultiPicker.modalPresentationStyle = .fullScreen
        present(imageMultiPicker, animated: true, completion: nil)
    }
    
    func navigateToPreview(images:[UIImage]){
        /*
        let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "PhotoViewViewController") as! PhotoViewViewController
        VC.image = image
        Constants.shared.uploadImageArray.append(image)
        self.navigationController?.pushViewController(VC, animated: true)
        */
        //Constants.shared.uploadImageArray.removeAll()
        Constants.shared.uploadImageArray.append(contentsOf:images)
        Coordinator.goToSubmitPictureVideo(controller: self, isTakePicture: true, isLive: false)
    }
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        imagesArray.removeAll()
        if Constants.shared.uploadImageArray.count == 5{
            Utilities.showWarningAlert(message:  "You can post maximum five images only.") {
                self.imagesArray = Constants.shared.uploadImageArray
                self.navigateToPreview(images: self.imagesArray)
            }
        }else{
            //imagesArray = Constants.shared.uploadImageArray
            imagesArray.append(photo)
            navigateToPreview(images: imagesArray)
        }
        
    }
    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
//        print("Did Begin Recording")
//        //captureButton.growButton()
//       // hideButtons()
//    }
    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
//        print("Did finish Recording")
//        captureButton.shrinkButton()
//        showButtons()
//    }
    
//    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
//        //let newVC = VideoViewController(videoURL: url)
//        //self.navigationController?.pushViewController(newVC, animated: true)
//    }
    
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

public extension Data {
    func printExifData() {
        let cfdata: CFData = self as CFData
        let imageSourceRef = CGImageSourceCreateWithData(cfdata, nil)
        let imageProperties = CGImageSourceCopyMetadataAtIndex(imageSourceRef!, 0, nil)!
        
        let mutableMetadata = CGImageMetadataCreateMutableCopy(imageProperties)!
        
        CGImageMetadataEnumerateTagsUsingBlock(mutableMetadata, nil, nil) { _, tag in
            print(CGImageMetadataTagCopyName(tag)!, ":", CGImageMetadataTagCopyValue(tag)!)
            return true
        }
    }
}

// UI Animations
extension TakePictureVC {
    
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
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
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
//extension TakePictureVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        //imgRoom.image  = tempImage
//        self.dismiss(animated: true, completion: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.navigateToPreview(image: tempImage)
//        }
//    }
//
//}
extension TakePictureVC: OpalImagePickerControllerDelegate {
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset,
                             targetSize: CGSize(width: 1080 , height: 1350),
                             contentMode: .aspectFit,
                             options: option,
                             resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        //Save Images, update UI
        self.imagesArray.removeAll()
        
        for items in assets {
            let img = self.getUIImage(asset: items)
            if(img != nil){
                self.imagesArray.append(img!)
            }
        }
        navigateToPreview(images: imagesArray)
        //Dismiss Controller
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 1
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return NSLocalizedString("External", comment: "External (title for UISegmentedControl)")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return URL(string: "https://placeimg.com/500/500/nature")
    }
}
