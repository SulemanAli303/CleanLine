//
//  ReportVideoFeedbackVC.swift
//  LiveMArket
//
//  Created by Shoaib Hassan's Macbook Pro M2 on 23/02/2024.
//

import UIKit

class ReportVideoFeedbackVC: BaseViewController {

    @IBOutlet weak var reportPostLabel: UILabel!
    @IBOutlet weak var yourCommentLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pDetailsTextView: UITextView!
    var selectedReason = ""
    var postID = ""
    @IBOutlet weak var pReasonLbl: UILabel!
    
    let placeHolder = "TYPE YOUR COMMENT HERE...".localiz()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        pReasonLbl.text = selectedReason
        // Do any additional setup after loading the view.
    }

    func configureLanguage(){
        reportPostLabel.text = "REPORT THIS POST".localiz()
        yourCommentLabel.text = "Enter Your comments below".localiz()
        pDetailsTextView.placeholder = "TYPE YOUR COMMENT HERE...".localiz()
        backButton.setTitle("Submit".localiz(), for: .normal)
        submitButton.setTitle("Back".localiz(), for: .normal)
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitPressed(_ sender: Any) {
       
        var submittedDesc = pDetailsTextView.text ?? ""
        if submittedDesc == placeHolder {
            submittedDesc = ""
        }
        
        let params = ["access_token":SessionManager.getAccessToken(),
                      "post_id":self.postID,
                      "reason":submittedDesc,
                      "problem_id":selectedReason
        ] as? [String:String]
        AddPostAPIManager.reportPostAPI(parameters: params!) { result in
            print(result)
        
            Utilities.showWarningAlert(message: result.message ?? "Post reported succesfully".localiz())
            {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}

extension ReportVideoFeedbackVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) 
    {
        if textView.text == placeHolder{
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = placeHolder
        }
    }
    
}
