//
//  PhotoViewViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 19/05/23.
//

import UIKit

class PhotoViewViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBackWithTwo
        // Do any additional setup after loading the view.
        imageView.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    @IBAction func addPhotoAction(_ sender: UIButton) {
        Coordinator.goToSubmitPictureVideo(controller: self, isTakePicture: true, isLive: false)
    }
}
