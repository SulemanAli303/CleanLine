//
//  WinnerCollectionViewCell.swift
//  Winam
//
//  Created by Zain on 24/02/2022.
//

import UIKit



class ShowPicCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var btnImg: UIImageView!
    var actionBlock: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapButton(sender: UIButton) {
            actionBlock?()
    }

}
