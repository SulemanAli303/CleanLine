//
//  HotelNewBookingRequest.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit

class HotelReserveRequest: BaseViewController {
    @IBOutlet weak var StatusView: UIView!
    @IBOutlet weak var StatusImg: UIView!
    @IBOutlet weak var Statuslbl: UILabel!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var ConfimedView: UIView!
    @IBOutlet weak var ProviderView: UIView!
    @IBOutlet weak var VerificationView: UIStackView!
    @IBOutlet weak var CompelteView: UIStackView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var bookingLbl: UILabel!
    
    
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var sec: UILabel!
    var step = ""
    var timer:Timer?

    @IBOutlet weak var timerView: UIStackView!
    let futureDate: Date = {
        var future = DateComponents(
            year: 2023,
            month: 2,
            day: 30,
            hour: 0,
            minute: 0,
            second: 0
        )
        return Calendar.current.date(from: future)!
    }()
    var countdown: DateComponents {
        return Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: futureDate)
    }
    
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
            runCountdown()
            self.StatusView.backgroundColor = UIColor(hex: "F57070")
            self.StatusImg.backgroundColor = UIColor(hex: "F57070")
            self.Statuslbl.text = " Reserved   ".localiz()
           
        }
        if (step == "2"){
            self.bookingLbl.isHidden = true
            self.timerView.isHidden = true
            self.VerificationView.isHidden = true
            self.CompelteView.isHidden = false
            self.StatusView.backgroundColor = UIColor(hex: "00B24D")
            self.StatusImg.backgroundColor = UIColor(hex: "00B24D")
            self.StatusImg.isHidden = true
            self.Statuslbl.text = " Completed  ".localiz()
            self.indicator.isHidden = true
        }
    }
    @IBAction func acceptAction(_ sender: UIButton) {
        
        self.step = "2"
        self.setData()
        
    }
    func runCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    deinit {
        timer?.invalidate()
    }

    @objc func updateTime() {
        let countdown = self.countdown //only compute once per call
        let days = countdown.day!
        let hours = countdown.hour!
        let minutes = countdown.minute!
        let seconds = countdown.second!
        print(String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds))
        hour.text! = "\(String(format: "%02d",hours))"
        minute.text! = "\(String(format: "%02d",minutes))"
        sec.text! = "\(String(format: "%02d",seconds))"
    }
    @IBAction func EnterGroundBTN(_ sender: UIButton) {
        self.step = "2"
        self.setData()
    }
}
