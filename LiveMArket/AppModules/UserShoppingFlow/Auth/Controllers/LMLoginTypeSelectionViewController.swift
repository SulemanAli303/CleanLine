//
//  LMLoginTypeSelectionViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import UIKit

class LMLoginTypeSelectionViewController: BaseViewController {
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
   
    @IBOutlet weak var selectLoginTypeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var accountType : [AccountType]? {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = .white
            pickerView.selectRow(3, inComponent: 0, animated: false)
            pickerView.subviews.first?.subviews.last?.backgroundColor = UIColor.white
        }
    }
    
//    var pickerData = [ "INDIVIDUALS","WHOLESSALLER","COMMERCIAL CENTERS (SHOPS)","DELIVERY REPRESENTATIVE","RESERVATIONS","SERVICE PROVIDER"]
//    
//    var pickerDataID = [ "1","WHOLESSALLER","COMMERCIAL CENTERS (SHOPS)","DELIVERY REPRESENTATIVE","RESERVATIONS","SERVICE PROVIDER"]
    
    var selectedRow = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        setInterface()
    }
    //MARK: - Methods
    func setInterface() {
        configueLanguage()
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
     //   self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        self.fetchAAccountType()
        
    }
    
    func configueLanguage(){
        selectLoginTypeLabel.text = "Select Account Type".localiz()
        nextButton.setTitle("Next".localiz(), for: .normal)
        backButton.setTitle("Back".localiz(), for: .normal)
    }
    //MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
        SessionManager.setUserType(userType:String(accountType?[selectedRow].id ?? 0))
        SessionManager.setActivityType(userType: "")
        SessionManager.setBusinessType(userType: "")
        
        
        if (accountType?[selectedRow].id ?? 0) == 3
        {
            /// INDIVIDUALS
            SessionManager.setBusinessType(userType: "2")
            SessionManager.setActivityType(userType: "7")
            Coordinator.goToCreateAccountPage(controller: self)
            UserDefaults.standard.set(0, forKey: "flow")
        }else if (accountType?[selectedRow].id ?? 0) == 5
        {
            /// WHOLESSALLER
            SessionManager.setBusinessType(userType: "1")
            ShopCoordinator.goToSelectActivityTyoe(controller: self,rowType: 1)
            UserDefaults.standard.set(1, forKey: "flow")
            
        }else if (accountType?[selectedRow].id ?? 0) == 1
        {
            /// COMMERCIAL CENTERS (SHOPS)
            SessionManager.setBusinessType(userType: "1")
            ShopCoordinator.goToSelectActivityTyoe(controller: self,rowType: 2)
            UserDefaults.standard.set(2, forKey: "flow")
            
        }else if (accountType?[selectedRow].id ?? 0) == 6
        {
            //DELIVERY
            WholeSellerAuthCoordinator.goToDRCreateAccount(controller: self)
            UserDefaults.standard.set(3, forKey: "flow")
            
        }else if (accountType?[selectedRow].id ?? 0) == 2
        {
            /// RESERVATIONS
            ShopCoordinator.goToSelectBusinessType(controller: self, VCtype: 5)
            //ShopCoordinator.goToSelectActivityTyoe(controller: self,rowType: 5)
            UserDefaults.standard.set(4, forKey: "flow")
            
        }
        else if (accountType?[selectedRow].id ?? 0) == 4
        {
            /// SERVICE PROVIDER"
//            ShopCoordinator.goToSelectBusinessType(controller: self, VCtype: 5)
//           //ShopCoordinator.goToSelectActivityTyoe(controller: self,rowType: 5)
//            UserDefaults.standard.set(5, forKey: "flow")
            SessionManager.setBusinessType(userType: "1")
            ShopCoordinator.goToSelectActivityTyoe(controller: self,rowType: 5)
            
        }
    }
    @IBAction func skipAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchAAccountType () {
        let parameters:[String:String] = [
            "":""
        ]
        AuthenticationAPIManager.getAccountTypeAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.accountType = result.oData ?? []
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension LMLoginTypeSelectionViewController : UIPickerViewDelegate,UIPickerViewDataSource {
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
