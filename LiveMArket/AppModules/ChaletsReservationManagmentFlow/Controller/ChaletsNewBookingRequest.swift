//
//  HotelNewBookingRequest.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit

class ChaletsNewBookingRequest: BaseViewController {
    @IBOutlet weak var StatusView: UIView!
    @IBOutlet weak var StatusImg: UIView!
    @IBOutlet weak var Statuslbl: UILabel!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var ConfimedView: UIView!
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
        if (step == "1"){
            self.acceptView.isHidden = false
        }
        if (step == "2"){
            self.ConfimedView.isHidden = false
            self.StatusView.backgroundColor = UIColor(hex: "F57070")
            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            self.Statuslbl.text = "Payment Received".localiz()
        }
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        
        self.step = "2"
        self.setData()
        
    }
}
