//
//  BookingProductCell.swift
//  LiveMArket
//
//  Created by Zain on 18/01/2023.
//

import UIKit
import SDWebImage

class PGBookingProductCell: UITableViewCell {

    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groundImageView: UIImageView!
    @IBOutlet weak var countView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    var groundData:GroundBookingDetailsGround?{
        didSet{
            nameLabel.text = groundData?.ground_name ?? ""
            groundImageView.sd_setImage(with: URL(string: groundData?.primary_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            areaLabel.text = "\(groundData?.area ?? "") \("sqft Area".localiz())"
            priceLabel.text = "\(groundData?.currency_code ?? "") \(groundData?.ground_price ?? "")/\("hr".localiz())"
        }
    }
}
