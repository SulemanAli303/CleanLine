//
//  CategoryNameCollectionViewCell.swift
//  Opium
//
//  Created by Albin Jose on 15/12/21.
//

import UIKit

class OptionsCollectionCell: UICollectionViewCell, Registerable {

    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var img: UIImageView!
    var currentTime:String = ""
    var selectedDateString:String = ""
    
    override func awakeFromNib() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Set the desired time format
        currentTime = dateFormatter.string(from: Date())
        print(currentTime)
    }
    var dateString: String?{
        didSet{
        }
    }
    
    var slotsData: Slots?{
        didSet{
            namelbl.text = slotsData?.slot_value ?? ""
            
        }
    }
    
    var timeSlotValue: String? {
        didSet {
            namelbl.text = timeSlotValue
        }
    }
    
    var timeSlotsData: Slot_list?{
        didSet{
            namelbl.text = timeSlotsData?.slot_text ?? ""
            
//            if dateString == Date().toSting{
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "HH:mm"
//                
//                if let time1 = dateFormatter.date(from: timeSlotsData?.slot_to ?? ""), let time2 = dateFormatter.date(from: currentTime) {
//                    // Compare the two Date objects
//                    if time1 > time2 {
//                        print("Time 1 is greater than Time 2.")
//                        self.baseView.backgroundColor = UIColor(hex: "#D85A1F")
//                        self.isUserInteractionEnabled = true
//                    } else if time1 < time2 {
//                        print("Time 1 is less than Time 2.")
//                        self.baseView.backgroundColor = UIColor(hex: "#F1A748")
//                        self.isUserInteractionEnabled = false
//                    } else {
//                        print("Time 1 and Time 2 are equal.")
//                        self.baseView.backgroundColor = UIColor(hex: "#F1A748")
//                        self.isUserInteractionEnabled = false
//                    }
//                } else {
//                    print("Invalid time string format")
//                    self.baseView.backgroundColor = UIColor(hex: "#F1A748")
//                    self.isUserInteractionEnabled = false
//                }
//            }
        }
    }
   
    var category: String? {
        didSet {
            updateUI()
        }
    }
    
    var isSelectCategory: Bool = false {
        didSet {
            if(isSelectCategory){
              //  self.baseView.layer.borderColor = UIColor.init(hex: "#BEBBEE").cgColor
                self.baseView.backgroundColor = UIColor.init(hex: "#D3DBFF")
                self.namelbl.textColor = UIColor.init(hex: "#0B26AD")
            }else {
               // self.baseView.layer.borderColor = UIColor.init(hex: "#D8D8D8").cgColor
                self.namelbl.textColor = UIColor.init(hex: "#202020")
                self.baseView.backgroundColor = UIColor.init(hex: "#FFFFFF")
            }
        }
    }
    
    fileprivate func updateUI() {
        guard let category = category else {
            return
        }
        namelbl.text = category
    }
}
