//
//  HotelNewBookingRequest.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit

class GymNewBookingRequest: BaseViewController {
    @IBOutlet weak var StatusView: UIView!
    @IBOutlet weak var StatusImg: UIView!
    @IBOutlet weak var Statuslbl: UILabel!
    @IBOutlet weak var StatusIndication: UIActivityIndicatorView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var ConfimedView: UIView!
    @IBOutlet weak var completeView: UIView!
    var step = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "#LM-154948596038"
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        setData()
        // Do any additional setup after loading the view.
    }
    func setData() {
        ConfimedView.isHidden = true
        acceptView.isHidden = true
        completeView.isHidden = true
        if (step == "1"){
            self.acceptView.isHidden = false
        }
        if (step == "2"){
        
            self.completeView.isHidden = false
            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            self.StatusImg.isHidden = true
            self.Statuslbl.text = " Completed  ".localiz()
            self.StatusIndication.isHidden = true
        }
       
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        
        Coordinator.goToGymNewReservationRequestAccept(controller: self)
        
    }
    
}
