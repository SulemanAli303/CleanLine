//
//  CategoryNameCollectionViewCell.swift
//  HealthyWealthy
//
//  Created by Zain on 10/10/2022.
//


import UIKit
import Cosmos

class RatingCells: UICollectionViewCell, Registerable {

  
    @IBOutlet weak var outView: UIView!
    @IBOutlet weak var rating: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
}
