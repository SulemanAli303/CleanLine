//
//  ChaletsListCell.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit

class GymBookingListCell: UITableViewCell {
    
    @IBOutlet weak var subscriptionTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var subscriptionDetailsLabel: UILabel!
    
    var base: UIViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func btnBookNow(_ sender: Any) {
        Coordinator.goToCharletsRoom(controller: base)
    }
    
    var packageData:Packages_list?{
        didSet{
            subscriptionTitleLabel.text = packageData?.package_name ?? ""
            subscriptionDetailsLabel.text = packageData?.package_description ?? ""
            priceLabel.text = packageData?.price ?? ""
            
            let priceVal = " \((Double(packageData?.price ?? "")) ?? 0.0) / "
            let convertedString = "\(packageData?.no_of_days ?? "1") \("Days".localiz())"
            
            let attributedString = NSMutableAttributedString(string: priceVal, attributes: [
                .font: UIFont(name: "Roboto-Bold", size: 22.0)!
            ])
            
            attributedString.append(NSAttributedString(string: convertedString, attributes: [
                .font: UIFont(name: "Roboto-Bold", size: 14.0)!,
                .baselineOffset: 0  // Adjust the offset to align the small text
            ]))
            
            priceLabel.attributedText = attributedString
            
        }
    }
    var currency:String?{
        didSet{
            currencyLabel.text = currency ?? ""
        }
    }
}
