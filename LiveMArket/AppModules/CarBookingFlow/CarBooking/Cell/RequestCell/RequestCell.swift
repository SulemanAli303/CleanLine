//
//  ChaletsListCell.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit

class RequestCell: UITableViewCell {
    var base: UIViewController!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var confirmedView: UIView!
    @IBOutlet weak var StatusView: UIView!
    @IBOutlet weak var Statuslbl: UILabel!
    

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var statusImg: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var type = ""
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusImg.isHidden = true
        StatusView.backgroundColor = UIColor(hexString: "#00B24D")
        indicator.isHidden = true
        Statuslbl.text = " Delivered     ".localiz()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func btnBookNow(_ sender: Any) {
        if self.type == "Chalets"{
            Coordinator.goToBookNoww(controller: base, room_ID: "")
        }else {
            Coordinator.goToBookNoww(controller: base, room_ID: "")
        }
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        if self.type == "Chalets"{
            Coordinator.goToChaletsNewReservationRequest(controller: base,VCtype: "1")
        }else if self.type == "Gym"{
            Coordinator.goToGymNewReservationRequest(controller: base,VCtype: "1")
        }else {
            Coordinator.goToHotelNewReservationRequest(controller: base,VCtype: "1")
        }
       
        
    }
}
