//
//  ImageViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 15/08/23.
//


import UIKit
import SDWebImage

class ImageViewController: BaseViewController {

    @IBOutlet weak var contentImageView: UIImageView!
    var urlString:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            // Now you have a valid URL
            self.contentImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_banner"))
        } else {
            // Handle the case where the URL string is invalid
            print("Invalid URL")
        }
        
        
    }
}

