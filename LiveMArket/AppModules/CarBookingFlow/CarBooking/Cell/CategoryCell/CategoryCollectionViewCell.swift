//
//  CategoryNameCollectionViewCell.swift
//  HealthyWealthy
//
//  Created by Zain on 10/10/2022.
//


import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, Registerable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var baseView: UIView!

    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
