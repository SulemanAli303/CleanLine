//
//  FollowingsTableViewCell.swift
//  LiveMArket
//
//  Created by Rupesh E on 04/07/23.
//

import UIKit

protocol FollowingProtocol{
    func unFollowing(userID:String)
}

class FollowingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unFollowButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var delegate:FollowingProtocol?
    var profileUserID:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setGradientBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var userID:String?{
        didSet{
            profileUserID = userID ?? ""
        }
    }
    
    var data:FollowList?{
        
        didSet{
            nameLabel.text = data?.name ?? ""
            locationLabel.text = data?.location_name ?? ""
            profileImageView.sd_setImage(with: URL(string: data?.user_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            
            if profileUserID != SessionManager.getUserData()?.id ?? ""{
                unFollowButton.isHidden = true
            }
        }
    }

    
    
    @IBAction func unFollowButtonAction(_ sender: UIButton) {
        self.delegate?.unFollowing(userID: data?.user_id ?? "")
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.profileImageView.bounds
        gradientLayer.cornerRadius = self.profileImageView.bounds.width/2
        
        self.profileImageView.layer.insertSublayer(gradientLayer, at:0)
    }
}
