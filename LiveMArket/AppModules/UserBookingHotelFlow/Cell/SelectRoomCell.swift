//
//  ChaletsListCell.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit

class SelectRoomCell: UITableViewCell {
    var base: UIViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func btnBookNow(_ sender: Any) {
        Coordinator.goToBookNoww(controller: base,room_ID: "")
    }
}
