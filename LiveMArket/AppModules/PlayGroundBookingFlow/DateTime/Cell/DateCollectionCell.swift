//
//  DateCollectionCell.swift
//  Maharani
//
//  Created by Zain on 12/01/2022.
//

import UIKit

class DateCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var itemDay: UILabel!
    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var dateData: GroundBookingDate?{
        didSet{
            itemDay.text = dateData?.day ?? ""
            itemDate.text = dateData?.date ?? ""
        }
    }

}
