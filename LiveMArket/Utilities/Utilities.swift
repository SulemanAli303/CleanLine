//
//  Utilities.swift
//  TCPF
//
//  Created by JJ on 30/12/22.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import CoreLocation
import AVKit
import GoogleMaps
import SwiftGifOrigin
class Utilities {
    static var activityIndicatorView: NVActivityIndicatorView!
    static var gifImageView: UIImageView!
    static var coverView: UIView!
    static var coverViewGif: UIView!

    public class func showIndicatorView(changeLoaderColor:Bool = false) {
        DispatchQueue.main.async {
            if activityIndicatorView != nil {
                activityIndicatorView.removeFromSuperview()
                coverView.removeFromSuperview()
            }
            
            
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            
            activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: NVActivityIndicatorType.ballPulseSync, color: Color.theme.color(), padding: 2.0)
            coverView = UIView(frame: keyWindow.frame)
//            if changeLoaderColor {
//                coverView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//            } else {
//                coverView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//            }
            coverView.backgroundColor = UIColor.clear

            coverView.addSubview(activityIndicatorView)
            activityIndicatorView.center = coverView.center
            keyWindow.addSubview(coverView)
            activityIndicatorView.startAnimating()
        }
    }
    
    public class func hideIndicatorView() {
        DispatchQueue.main.async {
            if activityIndicatorView != nil {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
                coverView.removeFromSuperview()
                activityIndicatorView = nil
                coverView = nil
            }
            activityIndicatorView?.removeFromSuperview()
            coverView?.removeFromSuperview()
        }
    }

    public class func showIndicatorViewGif(changeLoaderColor:Bool = false) {
        DispatchQueue.main.async {
            if gifImageView != nil {
                gifImageView.removeFromSuperview()
                coverViewGif.removeFromSuperview()
                activityIndicatorView = nil
                coverViewGif = nil
            }
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            gifImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
            gifImageView.image = UIImage.gif(name: "ic_loader")
            coverViewGif = UIView(frame: keyWindow.frame)
            coverViewGif.backgroundColor = UIColor.clear
            coverViewGif.addSubview(gifImageView)
            gifImageView.center = coverViewGif.center
            keyWindow.addSubview(coverViewGif)
        }
    }

    public class func hideIndicatorViewGif() {
        DispatchQueue.main.async {
            if gifImageView != nil {
                gifImageView.removeFromSuperview()
                coverViewGif.removeFromSuperview()
                gifImageView = nil
                coverViewGif = nil
            }
            gifImageView?.removeFromSuperview()
            coverViewGif?.removeFromSuperview()
        }
    }

    class func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    class func isValidEmail(email:String?) -> Bool {
        guard email != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    class func isValidName(testStr:String) -> Bool {
        guard testStr.count > 2, testStr.count < 18 else { return false }
        
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: testStr)
    }
    
    class func showWarningAlert(message: String, okayHandler: (()->())? = nil) {
        generateWarningFeedback()
        let alertView = AlertPopup.instanceFromNib()
        alertView.messageLabel.text = message
        alertView.okayAction = okayHandler
        alertView.show()
    }
    
    class func showQuestionAlert(message: String, okayHandler: (()->())? = nil) {
        generateWarningFeedback()
        let alertView = AlertPopupWithTwoButtons.instanceFromNib()
        alertView.messageLabel.text = message
        alertView.okayAction = okayHandler
        alertView.show()
    }

    class func hideAlertView() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        if let oldAlert = keyWindow.viewWithTag(999) {
            oldAlert.removeFromSuperview()
        }
    }

    class func showMultipleChoiceAlert(message: String, firstHandler: (()->())? = nil, secondHandler: (()->())? = nil) {
        generateWarningFeedback()
        let alertView = AlertPopupWithMultipleChoice.instanceFromNib()
        alertView.messageLabel.text = message
        alertView.firstAction = firstHandler
        alertView.secondAction = secondHandler
        alertView.show()
    }
    
    class func showSuccessAlert(message: String, okayHandler: (()->())? = nil) {
        generateSuccessFeedback()
        let alertView = AlertPopup.instanceFromNib()
        alertView.messageLabel.text = message
        alertView.okayAction = okayHandler
        alertView.show()
    }
    
    class func showAlertWithComments(message: String, okayHandler: ((String)->())? = nil) {
        generateWarningFeedback()
        let alertView = AlertPopupWithComments.instanceFromNib()
        alertView.messageLabel.text = message
        alertView.okayAction = okayHandler
        alertView.show()
    }
    class func generateSuccessFeedback() {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.success)
    }
    
    class func generateWarningFeedback() {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.warning)
    }
    
    public class func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    public class func getTheExtension(mimeType:String) -> String {
         switch mimeType {
         case "image/jpeg":
             return ".jpg"
         case "audio/aac":
             return ".aac"
         case "image/png":
             return ".png"
         case "image/gif":
             return ".gif"
         case "image/tiff":
             return ".tiff"
         case "application/pdf":
             return ".pdf"
         case "application/vnd":
             return ".xls"
         case "text/plain","application/octet-stream":
             return ".txt"
         case "application/msword":
             return ".doc"
         case "application/powerpoint":
             return ".ppt"
         case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
             return ".pptx"
         case "application/vnd.openxmlformats-officedocument.presentationml.slideshow":
             return ".ppsx"
         default:
             return ""
         }
     }

    class func isValidPassword(password: String?) -> Bool {
        guard password != nil else { return false }
        let regEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: password)
    }
    
//    class func logoutAction() {
//        Utilities.showQuestionAlert(message: "Are you sure want to logout?") {
//            SessionManager.clearLoginSession()
//            Coordinator.gotoTabBar()
//        }
//    }
    

    class func convertToDegrees(_ coordinate: String?) -> CLLocationDegrees? {
        if let coord = coordinate {
            if let doubleCoord = Double(coord) {
                if let degreeCoord = CLLocationDegrees(exactly: doubleCoord) {
                    return degreeCoord
                }
            }
        }
        return nil
    }

    class func convertToDegrees(_ coordinate: Double?) -> CLLocationDegrees? {
        if let coord = coordinate {
            if let degreeCoord = CLLocationDegrees(exactly: coord) {
                return degreeCoord
            }
        }
        return nil
    }
    
    class func checkCountryCodeSymble(str : Character, text : String) -> String  {
        let numOccurrences = text.filter{ $0 == str }.count
        print(text)
        var phoneCode = text
        if numOccurrences > 0 {
            for i in 0..<numOccurrences {
                phoneCode = phoneCode.replacingOccurrences(of: "+", with: "")
            }
            phoneCode = "\(str)\(phoneCode)"
            return phoneCode
        }else{
            phoneCode = "\(str)\(phoneCode)"
            return phoneCode
        }
    }
    class func playStartListening() {
        let systemSoundID: SystemSoundID = 1113

        //Change from record mode to play mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .videoRecording, policy: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Error \(error)")
        }
        AudioServicesPlaySystemSoundWithCompletion(systemSoundID) {
//            completion()
        }
    }
    
    class func playStopListening() {
        let systemSoundID: SystemSoundID = 1114

        //Change from record mode to play mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Error \(error)")
        }
        AudioServicesPlaySystemSoundWithCompletion(systemSoundID) {
            //do the recognition
        }
    }
    class func addToCartAnimation(vc: UIViewController?, frame: CGRect, image: UIImage?) {
        let imgViewTemp = UIImageView(frame: frame)
        imgViewTemp.image = image
        imgViewTemp.layer.cornerRadius = 10
        imgViewTemp.clipsToBounds = true
        imgViewTemp.contentMode = .scaleAspectFill
        imgViewTemp.alpha = 0
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(imgViewTemp)
        
        let fromPoint = CGPoint(x: frame.origin.x + frame.size.width/2, y: (frame.origin.y + frame.size.height/2))
        
       // let toPoint = CGPoint(x: (base?.navigationController?.navigationBar.frame.width ?? 0)-40, y: (base?.navigationController?.navigationBar.frame.height ?? 0)-20)
        
        let toPoint = CGPoint(x: ((vc?.tabBarController?.tabBar.frame.width)! - 40 ), y: ((vc?.tabBarController?.tabBar.frame.origin.y ?? 0))-50)
        
        let animGroup = getCartAnimationGroup(fromPoint: fromPoint, toPoint: toPoint, imageView: imgViewTemp)
//        animGroup.completionBlock { (_, _) in
//            imgViewTemp.removeFromSuperview()
//        }
        imgViewTemp.layer.add(animGroup, forKey: "curvedAnim")
    }
    
    
    class func getCartAnimationGroup(fromPoint: CGPoint, toPoint: CGPoint, imageView: UIImageView) -> CAAnimationGroup {
        let moveAnim = CABasicAnimation(keyPath: "position")
        moveAnim.fromValue = NSValue(cgPoint: fromPoint)
        moveAnim.toValue = NSValue(cgPoint: toPoint)
        moveAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        moveAnim.fillMode = CAMediaTimingFillMode.forwards
        
        let scaleAnim = CABasicAnimation(keyPath: "transform")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0))
        scaleAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnim.fillMode = CAMediaTimingFillMode.forwards
        
        let opacityAnim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnim.fromValue = NSNumber(value: 1.0)
        opacityAnim.toValue = NSNumber(value: 0)
        opacityAnim.timingFunction = CAMediaTimingFunction(name: .easeIn)
        opacityAnim.fillMode = CAMediaTimingFillMode.forwards
        
        let cornerRadiusAnim = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        cornerRadiusAnim.fromValue = 50
        cornerRadiusAnim.toValue = imageView.frame.height/2
        cornerRadiusAnim.fillMode = CAMediaTimingFillMode.forwards
        
        let animGroup = CAAnimationGroup()
        animGroup.setValue("curvedAnim", forKey: "animationName")
        animGroup.animations = [moveAnim, scaleAnim, opacityAnim, cornerRadiusAnim]
        animGroup.duration = 0.8
        return animGroup
    }
    
//    class func addToCartAnimation(vc: UIViewController?, frame: CGRect, image: UIImage?) {
//        let imgViewTemp = UIImageView(frame: frame)
//        imgViewTemp.image = image
//        imgViewTemp.layer.cornerRadius = 10
//        imgViewTemp.clipsToBounds = true
//        imgViewTemp.contentMode = .scaleAspectFill
//        imgViewTemp.alpha = 0
//
//        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
//        currentWindow?.addSubview(imgViewTemp)
//
//        let fromPoint = CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2)
//
//       // let toPoint = CGPoint(x: (base?.navigationController?.navigationBar.frame.width ?? 0)-40, y: (base?.navigationController?.navigationBar.frame.height ?? 0)-20)
//
//        let toPoint = CGPoint(x: ((vc?.tabBarController?.tabBar.frame.width)!/2 ), y: ((vc?.tabBarController?.tabBar.frame.origin.y ?? 0))-20)
//
//        let animGroup = getCartAnimationGroup(fromPoint: fromPoint, toPoint: toPoint, imageView: imgViewTemp)
////        animGroup.completionBlock { (_, _) in
////            imgViewTemp.removeFromSuperview()
////        }
//        imgViewTemp.layer.add(animGroup, forKey: "curvedAnim")
//    }
    class func presentPlacePicker(vc: UIViewController?,countryCode : String = "",cityName : String = "") {
        let placePickerVC = UIStoryboard(name: "PlacePicker", bundle: nil).instantiateViewController(withIdentifier: "ODAddressPickerViewController") as! ODAddressPickerViewController

        placePickerVC.delegate = vc as? PlacePickerDelegate
        placePickerVC.titleString = "Select Location"
        placePickerVC.countryCode = countryCode
        placePickerVC.cityName = cityName
        let navVC = UINavigationController.init(rootViewController: placePickerVC)
        navVC.modalPresentationStyle = .fullScreen
        vc?.present(navVC, animated: true, completion: nil)
    }
}
