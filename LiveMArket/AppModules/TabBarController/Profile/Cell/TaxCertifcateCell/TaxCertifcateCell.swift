//
//  NotificationTableViewCell.swift
//  The Driver
//
//  Created by Murteza on 16/09/2022.
//

import UIKit

class TaxCertifcateCell: UITableViewCell {



    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
