//
//  LMLoginTypeSelectionViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import UIKit

class SelectBusinessTypeViewController: BaseViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerData = ["COMPANY REGISTRATION","INDIVIDUAL REGESTRATION"]
    
    var accountType : [AccountType]? {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = .white
            pickerView.selectRow(0, inComponent: 0, animated: false)
            pickerView.subviews.first?.subviews.last?.backgroundColor = UIColor.white
        }
    }
    
    var selectedRow = 0
    var ROWType :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        configureLanguage()
        setInterface()
    }
    //MARK: - Methods
    
    func configureLanguage(){
        topLabel.text = "Select Business Type".localiz()
        nextButton.setTitle("Next".localiz(), for: .normal)
    }
    
    func setInterface() {
        
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
       // self.navigationController?.navigationBar.isHidden = true
        self.fetchBusinessType()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    
    @IBAction func NextAction(_ sender: Any) {
        SessionManager.setBusinessType(userType: String(accountType?[selectedRow].id ?? 0))
        ShopCoordinator.goToSelectActivityTyoe(controller: self,rowType: 5)
        
//        if (selectedRow == 1 || selectedRow == 0) && ROWType == 5
//        {
//            WholeSellerAuthCoordinator.goToServiceProviderAccount(controller: self,VCtype: selectedRow,RowType: ROWType)
//
//        }else
//        {
//            WholeSellerAuthCoordinator.goToRRCompanyAccount(controller: self, VCtype: selectedRow,RowType: ROWType)
//        }
        
    }
    
    func fetchBusinessType () {
        let parameters:[String:String] = [
            "":""
        ]
        AuthenticationAPIManager.getBusinessTypeAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.accountType = result.oData?.list ?? []
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
   
}

extension SelectBusinessTypeViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accountType?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accountType?[row].name ?? ""
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 66
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        pickerView.subviews.forEach { UIView in
            UIView.backgroundColor = .clear
        }
        var pickerLabel = UILabel()
        pickerLabel.frame = CGRect(x: 0, y: 0, width: (pickerView .rowSize(forComponent: 0).width), height: (pickerView .rowSize(forComponent: 0).height))
        if pickerView.selectedRow(inComponent: component) == row {
            pickerLabel.attributedText = NSAttributedString(string: accountType?[row].name ?? "", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor: Color.yellow.color()])
            
        } else {
            pickerLabel.attributedText = NSAttributedString(string: accountType?[row].name ?? "", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 14.0)!, NSAttributedString.Key.foregroundColor:UIColor.black])
        }
        pickerLabel.textAlignment = .center
        pickerLabel.numberOfLines = 2
        pickerLabel.backgroundColor = .white
        pickerView.backgroundColor = .white
        view?.backgroundColor = .white
        
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = "data"
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        return myTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        pickerView.reloadAllComponents()
    }
    
}


