//
//  CategoryNameCollectionViewCell.swift
//  HealthyWealthy
//
//  Created by Zain on 10/10/2022.
//


import UIKit

class CategoryNameCollectionViewCell: UICollectionViewCell, Registerable {

    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var countLbl : UILabel!
    @IBOutlet weak var bagImg : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
