//
//  CategoryNameCollectionViewCell.swift
//  HealthyWealthy
//
//  Created by Zain on 10/10/2022.
//


import UIKit

class AmenitiesOptionCell: UICollectionViewCell, Registerable {

    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var outView: UIView!
    @IBOutlet weak var leftImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with text: String) {
           namelbl.text = text
            
            let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: namelbl.frame.size.height)
            let attributes = [NSAttributedString.Key.font: namelbl.font]
            
            let textWidth = (text as NSString).boundingRect(
                with: maxSize,
                options: .usesLineFragmentOrigin,
                attributes: attributes as [NSAttributedString.Key : Any],
                context: nil
            ).size.width
            
            // You can also add some padding to the calculated width if needed
            let padding: CGFloat = 35 // Example padding value
            
            let calculatedWidth = ceil(textWidth) + padding
            contentView.widthAnchor.constraint(equalToConstant: calculatedWidth).isActive = true
        }
}
