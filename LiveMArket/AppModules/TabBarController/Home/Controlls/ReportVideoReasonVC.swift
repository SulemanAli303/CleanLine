//
//  ReportVideoReasonVC.swift
//  LiveMArket
//
//  Created by Shoaib Hassan's Macbook Pro M2 on 23/02/2024.
//

import UIKit

class ReportVideoReasonVC: BaseViewController {

    @IBOutlet weak var pTableView: UITableView!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var postID = ""
    let dataArr = ["Nudity or sexual activity","Hate Speech or symbols","Scam or fraud","Violence or dangerous organisations","Sale of illegal or regulated goods","Bullying or harassmeent","Pretending to be someoe else"]
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        self.pTableView.register(UINib.init(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
    }
    
    func configureLanguage(){
        reportLabel.text = "REPORT THIS POST".localiz()
        descriptionLabel.text = "You can report this video to live market, if you think that is against our community guidlines.We won't notify the account that you submitted this report.".localiz()
        cancelButton.setTitle("Cancel".localiz(), for: .normal)
    }
    @IBAction func cancelPressed(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)
    }
}

extension ReportVideoReasonVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = self.pTableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        cell.pTitleLbl.text = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vcObject = self.storyboard?.instantiateViewController(withIdentifier: "ReportVideoFeedbackVC") as! ReportVideoFeedbackVC
        vcObject.selectedReason = dataArr[indexPath.row]
        vcObject.postID = self.postID
        self.navigationController?.pushViewController(vcObject, animated: true)
    }
}
