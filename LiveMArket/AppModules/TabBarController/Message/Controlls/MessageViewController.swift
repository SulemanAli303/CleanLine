//
//  MessageViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit
import FittedSheets
class MessageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("openOptionsMessage"), object: nil)
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        OpenPopUp()
    }
    
    func OpenPopUp(){
        let  controller =  AppStoryboard.Floating.instance.instantiateViewController(withIdentifier: "FloatingVC") as! FloatingVC
        controller.delegate = self
        let sheet = SheetViewController(
            controller: controller,
            sizes: [.fullscreen],
            options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
        sheet.minimumSpaceAbovePullBar = 0
        sheet.dismissOnOverlayTap = false
        sheet.dismissOnPull = false
        sheet.contentBackgroundColor = .clear
        self.present(sheet, animated: true, completion: nil)
    }
    
}
extension MessageViewController: FloatingVCDelegate {
    func goToLive() {
        Coordinator.goToLive(controller: self)
    }
    func goToVideo() {
        Coordinator.goToTakeVideo(controller: self)
    }
    func goToImage() {
        Coordinator.goToTakePicture(controller: self)
    }
}
