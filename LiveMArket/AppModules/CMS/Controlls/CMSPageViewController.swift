//
//  CMSPageViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 13/07/23.
//

import UIKit

class CMSPageViewController: BaseViewController {

    @IBOutlet weak var descTxt: UITextView!
    var cmsData:CMS_Data? {
        didSet {
            descTxt.text = cmsData?.desc_en?.html2String
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Terms & Conditions".localiz()
        fetchCMSData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    func fetchCMSData() {
        let params = ["page_id": "2"]
        CMSAPIManager.getCMSPageAPI(parameters: params) { result in
            switch result.status {
            case "1":
                self.cmsData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "")
            }
        }
    }
}
