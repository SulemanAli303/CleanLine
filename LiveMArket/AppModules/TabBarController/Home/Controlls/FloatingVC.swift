//
//  EnterDigit.swift
//  HealthyWealthy
//
//  Created by Zain on 13/10/2022.
//

import UIKit
import DPOTPView
import FittedSheets
import QuartzCore


protocol FloatingVCDelegate: AnyObject {
    func goToVideo ()
    func goToImage ()
    func goToLive ()
}
class FloatingVC: UIViewController {
    @IBOutlet weak var btn: UIButton!
    weak var delegate : FloatingVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btn.rotate360Degrees()
    }
    
    @IBAction func videoBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
        if SessionManager.isLoggedIn() {
            delegate?.goToVideo()
        }else {
            Coordinator.setRoot(controller: self)
        }
    }
    @IBAction func imageBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
        
        if SessionManager.isLoggedIn() {
            delegate?.goToImage()
        }else {
            Coordinator.setRoot(controller: self)
        }
    }
    @IBAction func LiveBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
        if SessionManager.isLoggedIn() {
            delegate?.goToLive()
        }else {
            Coordinator.setRoot(controller: self)
        }
    }
    
    @IBAction func cross(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
extension UIButton {
    func rotate360Degrees(duration: CFTimeInterval = 0.3, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 1.5)
        rotateAnimation.duration = duration

        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
