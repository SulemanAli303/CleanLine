//
//  ChatTableViewCell.swift
//  Stepago
//
//  Created by Mac User on 30/04/19.
//  Copyright © 2019 Hassan Izhar. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBAction func profileButtonAction(_ sender: Any) {
        profileAction?(self)
    }
    @IBOutlet weak var otherseenimg: UIImageView!
    var profileAction: ((ChatTableViewCell) -> Void)?
    
    @IBOutlet weak var sendseenimg: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var triangleImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        if languageBool {
            triangleImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        } else {
//            triangleImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        }
    }

}
