//
//  FullScreenViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 20/04/23.
//

import UIKit
import ImageSlideshow

class FullScreenViewController: BaseViewController {
    
    @IBOutlet weak var sliderView: ImageSlideshow!
    
    var imageURLArray:[String] = []
    var localSource : [AlamofireSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        configerSlider(imageArray: imageURLArray)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    
    
    /// Image Slider
    /// - Parameter imageArray: image array
    func configerSlider(imageArray:[String]) {
        localSource.removeAll()
        for imageUrl in imageArray {
            if let url = URL(string: imageUrl){
                localSource.append(contentsOf: [AlamofireSource(url: url, placeholder: UIImage(named: ""))])
            }
        }
        sliderView.slideshowInterval = 4.0
        sliderView.zoomEnabled = false
        sliderView.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 5))
        //sliderView.backgroundColor = .red
        sliderView.contentScaleMode = UIViewContentMode.scaleAspectFit
        //sliderView.activityIndicator = DefaultActivityIndicator()
        //sliderView.delegate = self
        sliderView.setImageInputs(localSource)
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        if let _ = self.navigationController?.popViewController(animated: true) {} else {
            self.dismiss(animated: true)
        }
        
    }
    
}
