//
//  MoreOptionsViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 09/01/23.
//

import UIKit
import FittedSheets
class MoreOptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        OpenPopUp()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    func OpenPopUp(){
        Constants.shared.uploadImageArray.removeAll()
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
extension MoreOptionsViewController: FloatingVCDelegate {
    func goToLive() {
        self.tabBarController?.selectedIndex = 0
        Coordinator.goToLive(controller: self)
    }
    func goToVideo() {
        self.tabBarController?.selectedIndex = 0
        Coordinator.goToTakeVideo(controller: self)
    }
    func goToImage() {
        self.tabBarController?.selectedIndex = 0
        Coordinator.goToTakePicture(controller: self)
    }
}
