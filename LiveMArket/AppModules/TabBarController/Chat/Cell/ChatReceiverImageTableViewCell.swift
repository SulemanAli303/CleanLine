//
//  ChatReceiverImageTableViewCell.swift
//  LiveMArket
//
//  Created by Rupesh E on 01/09/23.
//

import UIKit
import FirebaseStorage
import SDWebImage
class ChatReceiverImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var chatImageView: UIImageView!
    
    var rfcDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }
    
    var localDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        return formatter
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        chatImageView.image = nil
    }
    var chatData:ChatModel2?{
        didSet{
            let numberValue = NSNumber(value: chatData?.messageTimeStamp ?? 0)
            timeLabel.text = self.convertTimeStamp(createdAt: numberValue)
            
//            let storage = Storage.storage()
            // Convert the URL string to a URL
            if let url = URL(string: chatData?.ImageURL ??  "") {
                // Create a reference to the file using the URL


                if let downloadURL = SDImageCache.shared.imageFromCache(forKey: url.absoluteString){
                    chatImageView.image = downloadURL
                }
                else{
                    chatImageView.sd_setImage(with: url, completed: nil)
                }

//                let fileRef = storage.reference(forURL: url.absoluteString)

                // Download the file data
//                fileRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
//                    if let error = error {
//                        // Handle the download error
//                        print("Error downloading file: \(error.localizedDescription)")
//                    } else if let fileData = data {
//                        // Handle the downloaded file data
//                        // You can save it to a local file, display it, or perform any other necessary actions.
//                        // For example, if you want to display an image, you can do:
//                        if let image = UIImage(data: fileData) {
//                            // Display the image using an UIImageView
//                            self.chatImageView.image = image
//                        }
//                    }
//                }
            }
        }
    }
    
    func convertTimeStamp(createdAt: NSNumber?) -> String {
        guard let createdAt = createdAt else { return "a moment ago" }
        
        let converted = Date(timeIntervalSince1970: Double(truncating: createdAt) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        let dateString = dateFormatter.string(from: converted)
        
        let date = self.rfcDateFormatter.date(from: dateString)
        let localDate = self.localDateFormatter.string(from: date!)
        
        return localDate.changeTimeToFormat(frmFormat: "dd-MM-yyyy HH:mm:ss Z", toFormat: "hh:mm a")
        
    }
}
