//
//  popularHome.swift
//  HealthyWealthy
//
//  Created by Zain on 06/10/2022.
//

import UIKit

class SellerOrderCell: UICollectionViewCell {
    
    @IBOutlet weak var pinnedIcon: UIButton!
    @IBOutlet weak var videoIcon: UIButton!
    @IBOutlet weak var shareIcon: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
    var postData:PostCollection?{
        didSet{
            self.productImage.sd_setImage(with: URL(string: postData?.postsFiles?.first?.thumb_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            if postData?.postsFiles?.first?.extensions == "mp4"{
                videoIcon.isHidden = false
            }else{
                videoIcon.isHidden = true
            }
            if postData?.isDefaultPost == "1" || postData?.isDefaultPost == ""{
                pinnedIcon.isHidden = false
            }else{
                pinnedIcon.isHidden = true
            }
        }
    }
    
    
}
