//
//  LiveFloatView.swift
//  LiveMArket
//
//  Created by Rupesh E on 18/10/23.
//

import Foundation
import UIKit

class LiveFloatView{
    
    static let shared = LiveFloatView()
    
    var mainBackgroundView = UIView()
    //let popView = UIView(frame: CGRect(x: 20, y: 100, width: 100, height: 150))
    var currentController = UIViewController()
    
    /// Setup PopUp View show
    ///
    /// - Parameter popView: showing View
    func showPopup(popView:UIView,button:UIButton,hideBgClick:Bool) {
        mainBackgroundView = UIView(frame: UIScreen.main.bounds)
        if !hideBgClick{
            //Button
            button.frame = mainBackgroundView.frame
        }
        mainBackgroundView.addSubview(button)
        mainBackgroundView.isHidden = false
        mainBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        popView.center = mainBackgroundView.center
        popView.isHidden = false
        //view.layoutIfNeeded()
        mainBackgroundView.addSubview(popView)
        
        (UIApplication.shared.delegate as? AppDelegate)?.window?.addSubview(mainBackgroundView)
        
    }
    
    
    func showPopup(popView:UIView, image:UIImage,controller:UIViewController){
        //mainBackgroundView = UIView(frame: UIScreen.main.bounds)
        //mainBackgroundView.isHidden = false
        //mainBackgroundView.backgroundColor = UIColor(hexString: "#F8F8F8")
        currentController  = controller
        popView.frame = CGRect(x: 20, y: 100, width: 100, height: 150)
        popView.layer.cornerRadius = 8
        popView.layer.masksToBounds = true
        popView.isHidden = false
        popView.backgroundColor = .red
        //view.layoutIfNeeded()
        //mainBackgroundView.addSubview(popView)
        (UIApplication.shared.delegate as? AppDelegate)?.window?.addSubview(popView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        popView.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        popView.addGestureRecognizer(tapGesture)
        
        let closeButton = UIButton(frame: CGRect(x: popView.frame.width - 30, y: 5, width: 20, height: 20))
        closeButton.setTitle("X", for: .normal)
        closeButton.addTarget(self, action: #selector(closePiP), for: .touchUpInside)
        popView.addSubview(closeButton)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
        imageView.image = image
        popView.addSubview(imageView)
    }
    
    @objc func closePiP() {
//        popView.isHidden = true
//        popView.removeFromSuperview()
        // Optionally, you can release resources and remove the PiP view from the window
    }
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: popView)
//        popView.center = CGPoint(x: popView.center.x + translation.x, y: popView.center.y + translation.y)
//        gesture.setTranslation(.zero, in: popView)
    }
    @objc func handleTap(_ gesture: UIPanGestureRecognizer) {
//        popView.removeFromSuperview()
//        Coordinator.goToLive(controller: currentController)
    }
    
    /// Removeing showing popup view
    ///
    /// - Parameter popView: showing View
    func removePopup(popView:UIView) {
        mainBackgroundView.removeFromSuperview()
        mainBackgroundView.isHidden = true
        popView.isHidden = true
    }
}
