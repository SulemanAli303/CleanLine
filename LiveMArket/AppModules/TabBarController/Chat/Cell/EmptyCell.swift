//
//  EmptyCell.swift
//  CounselHub
//
//  Created by ZAFAR on 20/08/2022.
//

import UIKit

class EmptyCell: UITableViewCell {

    @IBOutlet weak var lblmessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
