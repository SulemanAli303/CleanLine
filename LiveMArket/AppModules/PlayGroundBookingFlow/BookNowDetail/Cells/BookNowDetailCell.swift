//
//  BookingProductCell.swift
//  LiveMArket
//
//  Created by Zain on 18/01/2023.
//

import UIKit

class BookNowDetailCell: UITableViewCell {

    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var bookNow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var groundData:Grounds?{
        didSet{
            iconImageView.sd_setImage(with: URL(string: groundData?.primary_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            nameLabel.text = groundData?.name ?? ""
            areaLabel.text = "\(groundData?.area ?? "") \("sqft Area".localiz())"
           
        }
    }
    var currency:String?{
        didSet{
           
            let currency = self.currency ?? ""
            let priceVal = " \((Double(groundData?.price ?? "")) ?? 0.0) / "
            let convertedString = groundData?.price_type?.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
            
            let attributedString = NSMutableAttributedString(string: currency, attributes: [
                .font: UIFont(name: "Roboto-Regular", size: 14.0)!
            ])
            
            attributedString.append(NSMutableAttributedString(string: priceVal, attributes: [
                .font: UIFont(name: "Roboto-Bold", size: 20.0)!
            ]))
            
            attributedString.append(NSAttributedString(string: convertedString, attributes: [
                .font: UIFont(name: "Roboto-Regular", size: 14.0)!,
                .baselineOffset: 0  // Adjust the offset to align the small text
            ]))
            
            priceLabel.attributedText = attributedString
        }
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
    
}
