//
//  BookingProductCell.swift
//  LiveMArket
//
//  Created by Zain on 18/01/2023.
//

import UIKit
import SDWebImage

class CarBookingCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var pieceView: UIStackView!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var piecesCountLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
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
    
    var productData:Products?{
        didSet{
            productImageView.sd_setImage(with: URL(string: productData?.image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            productNameLabel.text = productData?.product_name ?? ""
            productCountLabel.text = ("\(productData?.quantity ?? "") Products")
            pieceView.isHidden = true
        }
    }
    
    
    
}
