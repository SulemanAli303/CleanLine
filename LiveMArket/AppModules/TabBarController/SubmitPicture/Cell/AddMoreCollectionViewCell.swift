//
//  AddMoreCollectionViewCell.swift
//  LiveMArket
//
//  Created by Rupesh E on 15/09/23.
//

import UIKit

class AddMoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellBgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBgView.addDashBorder()
    }

}
