//
//  ValidateFacePopup.swift
//  LiveMArket
//
//  Created by Shoaib Hassan's Macbook Pro M2 on 22/02/2024.
//

import UIKit

protocol FacePopupProtocol {

  func userFaceValidated()
}
class ValidateFacePopup: UIViewController {
    
    let vc = UIImagePickerController()
    var isVCPresendted = false
    var delegate: FacePopupProtocol!
    var selectedProfileImage : UIImage!

    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var successView: UIView!
    var overlayView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = UIScreen.main.bounds.size.height
        overlayView.frame = CGRect(x: 0, y: height*0.85 , width: UIScreen.main.bounds.size.width, height: height*0.15)
        overlayView.backgroundColor = UIColor.clear
        overlayView.tag = 12002

        let cameraViewHeight = height*0.15 // Adjust this ratio as needed
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.showsCameraControls = false
        vc.cameraDevice = .front
        vc.cameraOverlayView = overlayView
        vc.cameraCaptureMode = .photo
        vc.cameraViewTransform = CGAffineTransform(translationX: 0, y: cameraViewHeight)
        vc.delegate = self


        let aButton = UIButton(frame: CGRect(x: overlayView.center.x - 30, y: (overlayView.frame.height / 2) - 30, width: 60, height: 60))
        aButton.setBackgroundImage(UIImage(named: "Ellipse 15525"), for: .normal)
        aButton.addTarget(self, action: #selector(takePic(_:)), for: .touchUpInside)
        overlayView.addSubview(aButton)
        self.successView.isHidden = true
        
   }
    
    @IBAction func takePic(_ sender: UIButton) 
    {
        self.vc.takePicture()
    }
    
    @IBAction func proceed(_ sender: UIButton) {
        self.CameraSelection()
    }
    
    func updateProfileImg() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        let userFile:[String:[UIImage?]] = ["user_image" :[selectedProfileImage]]
        AuthenticationAPIManager.validateFaceImage(images:userFile, parameters: parameters) { response in
            switch response.status {
            case "1":
                self.faceValidationDone()
            default :
                Utilities.showWarningAlert(message: response.message ?? "") {
                    DispatchQueue.main.async {
                        self.CameraSelection()
                    }
                }
            }
        }
    }
    
    func faceValidationDone() {
        DispatchQueue.main.async {
            self.successView.isHidden = false
            self.mainView.isHidden = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.delegate != nil {
                    self.delegate.userFaceValidated()
                }
                self.vc.dismiss(animated: true)
                self.isVCPresendted = false
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
    
}

extension ValidateFacePopup  : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    func CameraSelection() {
        if !isVCPresendted {
            isVCPresendted = true
            present(vc, animated: true)
        }
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let originalImage = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        let orientation = originalImage.imageOrientation
        if orientation == .upMirrored || orientation == .leftMirrored || orientation == .rightMirrored || orientation == .downMirrored {
            guard let originalImage = originalImage.unmirrorImage() else {
                print("No image found")
                return
            }
            self.selectedProfileImage = originalImage
        } else {
            self.selectedProfileImage = originalImage
        }
        self.updateProfileImg()
    }
}
