//
//  NotificationsCell.swift
//  LiveMArket
//
//  Created by Zain on 01/02/2023.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBAction func removeButtonAction(_ sender: Any) {
        removeAction?(self)
    }
    var removeAction: ((NotificationsCell)->())?
    
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!

    var notification: NotificationModel? {
        didSet {
          //  titleLabel.text = notification?.title ?? ""
            descriptionLabel.text = notification?.title ?? ""
            if let date = notification?.createdAt {
                dateTimeLabel.text = self.formatDate(date: date)
              //  date.changeTimeToFormat(frmFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd/MM/yyyy")
            }
            
        }
    }
    
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "d MMM yyyy h:mma"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone.current
        if let dateDisplay = showDate {
            let resultString = inputFormatter.string(from: dateDisplay)
            return resultString
        }else{
            return date
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
      //  titleLabel.text = ""
        descriptionLabel.text = ""
    }
    
}
