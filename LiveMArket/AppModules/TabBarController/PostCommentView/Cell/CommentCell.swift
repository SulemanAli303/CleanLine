//
//  CommentCell.swift
//  LiveMArket
//
//  Created by Zain on 26/01/2023.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var transparent: UIView!
    @IBOutlet weak var img: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    var userComment:LiveStreamComments? {
        didSet {
            userImg.sd_setImage(with: URL(string: userComment?.commentedUserImageurl ?? ""),placeholderImage: UIImage(named: "profile"))
            userNameLbl.text = userComment?.commentedUserName
            commentLbl.text = userComment?.comment
            timeLbl.text = Helper.convertTimestampFromString(timeStamp: userComment?.commentAt ?? "")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
