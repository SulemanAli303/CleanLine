//
//  popularHome.swift
//  HealthyWealthy
//
//  Created by Zain on 06/10/2022.
//

import UIKit

class ResturantCell: UICollectionViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
    var data:PostCollection?{
        
        didSet{
            postImageView.sd_setImage(with: URL(string: data?.postsFiles?.first?.thumb_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            userProfileImage.sd_setImage(with: URL(string: data?.postedUserImageurl ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            locationLabel.text = data?.postCaption ?? ""
            profileNameLabel.text = data?.postedUserName ?? ""
        }
    }
    
    
}
