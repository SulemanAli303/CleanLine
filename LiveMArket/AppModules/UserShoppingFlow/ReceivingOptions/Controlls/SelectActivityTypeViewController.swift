//
//  LMLoginTypeSelectionViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import UIKit

class SelectActivityTypeViewController: BaseViewController {
    
    @IBOutlet weak var selectActivityTypeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData = ["FURNITURE", "PHARMACIES", "CATERING", "CLOTHING", "JEWELLERY"]
    var row1 = ["TOYS","RESTURANTS","CARS","PHARMACIES","SUPERMARKETS"]
    var row4 = ["HOTELS","APARTMENTS","PLAYGROUNDS","WEDDING HALLS","SPORTS CLUB"]
    var row5 = ["PAINT","PLUMBER","CAR MAINTENANCE","ELECTRICAL"]
    var ROWType :Int?
    
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
    var RowType : Int?
    override func viewDidLoad() {
        type = .backWithoutTitle
        super.viewDidLoad()
        configureLanguage()
        setInterface()
    }
    
    //MARK: - Methods
    
    func configureLanguage(){
        selectActivityTypeLabel.text = "SELECT ACTIVITY TYPE".localiz()
        nextButton.setTitle("Next".localiz(), for: .normal)
    }
    
    func setInterface() {
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
       // self.navigationController?.navigationBar.isHidden = true
        self.fetchActivityType()
        
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
    //MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
        if (self.accountType != nil && self.accountType!.count > 0) {
            SessionManager.setActivityType(userType: String(self.accountType?[selectedRow].id ?? 0))
            WholeSellerAuthCoordinator.goToWSCreateAnAccount(controller: self)
        } else {
            Utilities.showWarningAlert(message: "Please select account type first".localiz()) {
                
            }
        }
        
        
//        if RowType  == 4
//        {
//            ShopCoordinator.goToSelectBusinessType(controller: self,VCtype: 4)
//        }else if RowType == 5
//        {
//            ShopCoordinator.goToSelectActivityTyoe(controller: self,rowType: 2)
//            //ShopCoordinator.goToSelectBusinessType(controller: self, VCtype: 5)
//        }
//        else
//        {
//            WholeSellerAuthCoordinator.goToWSCreateAnAccount(controller: self)
//        }
    }
    
    func fetchActivityType () {
        let parameters:[String:String] = [
            "":""
        ]
        AuthenticationAPIManager.getActivityTypeAPI(parameters: parameters) { result in
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

extension SelectActivityTypeViewController : UIPickerViewDelegate,UIPickerViewDataSource {
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
        pickerView.reloadAllComponents()
    }
    
}

