//
//  ChatVC.swift
//  CounselHub
//
//  Created by Zain on 12/07/2022.
//

import UIKit
import SDWebImage
class ChatCell: UITableViewCell {
    
    @IBOutlet weak var unReadView: UIView!
    @IBOutlet weak var activeimage: UIImageView!
    @IBOutlet weak var seenimg: UIImageView!
    var chatArray: ChatMainModel? {
        didSet {
            
//            var item = chatArray
//            var spl = item?.lastMessage?.channelId?.split(separator: ":") ?? []
//            var user_id = 0
//            for usr in spl.enumerated() {
//                var string = usr.element
//                if(string != String(SessionManager.getUserData()?.id ?? 0)){
//                    user_id = Int(string) ?? 0
//                    break
//                }
//            }
//
//            var senderInfo = chatArray?.members?["\(user_id)"] as? [String:Any]
//            message.text = chatArray?.lastMessage?.text ?? ""
//            name.text = senderInfo?["name"] as? String
//            avatarImageView.sd_setImage(with: URL(string: senderInfo?["imageUrl"] as? String ?? ""), placeholderImage: UIImage(named:"userimg"))
//            var timeStamp = chatArray?.lastMessage?.timeStamp ?? 0
//            //timeStamp =  timeStamp*1000
//            let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp))
//            let formatter = DateFormatter()
//            formatter.dateFormat = "HH:mm"
//            //time.text = "\(formatter.string(from: date as Date))"
//            time.text = ""
            
        }
    }
    
    var chatModel: ChatListModel? {
        didSet {
            message.text = chatModel?.message
            
//            var item = chatModel
//
//            message.text = item?.message ?? ""
//            if(item?.user?.user_type == "user"){
//                name.text = item?.user?.name ?? ""
//                if(item?.user?.user_post_as == "1"){
//                    name.text = item?.user?.anonymous_name
//                    avatarImageView.image  = UIImage(named: "circle")
//                }else {
//                    avatarImageView.sd_setImage(with: URL(string: item?.user?.user_image ?? ""), placeholderImage: UIImage(named:"userimg"))
//                }
//            }else {
//                name.text = item?.user?.company_name ?? ""
//                avatarImageView.sd_setImage(with: URL(string: item?.user?.user_image ?? ""), placeholderImage: UIImage(named:"userimg"))
//            }
//
//            if let timeStamp = item?.updatedAtUTS {
//                //timeStamp =  timeStamp*1000
//                let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp))
//                let formatter = DateFormatter()
//                formatter.dateFormat = "HH:mm"
//                time.text =   convertTimestamp2(timeStamp: timeStamp)   //"\(formatter.string(from: date as Date))"
//            }
//            time.text = ""
//
//            if item?.user?.is_active == true  {
//                self.activeimage.image =  UIImage(named: "Ellipse 741")
//            } else {
//                self.activeimage.image =  UIImage(named: "inactive-")
//            }
//
//            if item?.read == "1"  {
//                self.seenimg.image =  UIImage(named: "seen-")
//            } else {
//                self.seenimg.image =  UIImage(named: "unseen-")
//            }
       }
    }
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func convertTimestamp2(timeStamp:NSNumber, short:Bool? = false) -> String {
        let converted = Date(timeIntervalSince1970: Double(truncating: timeStamp) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        let myString = dateFormatter.string(from: converted)
        
        let date = rfcDateFormatter.date(from: myString)
        let dateLocal = localDateFormatter.date(from: myString)
        guard let finalDate = date ?? dateLocal else {return myString}
        let localDate = self.localDateFormatter.string(from: finalDate)
        
        let dateObj = dateFormatter.date(from: localDate)!
        let newDateFormatter = DateFormatter()
        //newDateFormatter.dateStyle = .short
        // newDateFormatter.timeStyle = .short
        newDateFormatter.dateFormat = "HH:mm"
        //newDateFormatter.dateFormat = "h:mm a"
        newDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        newDateFormatter.dateFormat = "h:mm a"
        newDateFormatter.amSymbol = "AM"
        newDateFormatter.pmSymbol = "PM"
        return newDateFormatter.string(from: dateObj) //dateObj.getElapsedInterval(short: short)
    }
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
    
}
extension Date {
    func changeDays(by days: Int) -> Date{
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    var timeStamp: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    func getElapsedInterval(short:Bool? = false) -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        if (short ?? false){
            if let year = interval.year, year > 0 {
                return "\(year)y"
            } else if let month = interval.month, month > 0 {
                return "\(month)m"
            } else if let day = interval.day, day > 0 {
                return "\(day)d"
            }else if let hour = interval.hour, hour > 0 {
                return "\(hour)h"
            }else if let mins = interval.minute, mins > 0 {
                return "\(mins)mn"
            }else {
                return "now"
            }
        }
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago".localiz() :
            "\(year)" + " " + "years ago".localiz()
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago".localiz() :
            "\(month)" + " " + "months ago".localiz()
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago".localiz() :
            "\(day)" + " " + "days ago".localiz()
        }else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago".localiz() :
            "\(hour)" + " " + "hrs ago".localiz()
        }else if let mins = interval.minute, mins > 0 {
            return mins == 1 ? "\(mins)" + " " + "min ago".localiz() :
            "\(mins)" + " " + "mins ago".localiz()
        }
        else {
            return "now".localiz()
        }
        
    }
}
