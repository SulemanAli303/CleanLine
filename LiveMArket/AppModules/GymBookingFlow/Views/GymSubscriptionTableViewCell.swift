//
//  GymSubscriptionTableViewCell.swift
//  LiveMArket
//
//  Created by Greeniitc on 15/05/23.
//

import UIKit

class GymSubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBgView: UIView!
    @IBOutlet weak var subscriptionButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data:PackageList?{
        didSet{
            subscriptionButton.setTitle(data?.package_name ?? "", for: .normal)
        }
    }
    
    
    
}
