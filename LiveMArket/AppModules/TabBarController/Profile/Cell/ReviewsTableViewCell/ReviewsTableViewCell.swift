//
//  NotificationTableViewCell.swift
//  The Driver
//
//  Created by Murteza on 16/09/2022.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {


    @IBOutlet weak var reviewMessageLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    
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
    var review:DriverReviewList?{
        didSet{
            reviewMessageLabel.text = review?.driver_review ?? ""
            rateLabel.text = "\(Double(review?.driver_rating ?? "") ?? 0.0)"
            dateLabel.text = self.formatDate(date: review?.review_date ?? "")
            customerNameLabel.text = review?.customer?.name ?? ""
        }
    }
    var commonReview:ReviewList?{
        didSet{
            reviewMessageLabel.text = commonReview?.review ?? ""
            rateLabel.text = "\(Double(commonReview?.rating ?? "") ?? 0.0)"
            dateLabel.text = self.formatDate(date: commonReview?.review_date ?? "")
            customerNameLabel.text = commonReview?.customer?.name ?? ""
        }
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "d MMM yyyy h:mm a"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone.current
        if let dateDisplay = showDate {
            let resultString = inputFormatter.string(from: dateDisplay)
            return resultString
        }else{
            return date
        }
    }
}
