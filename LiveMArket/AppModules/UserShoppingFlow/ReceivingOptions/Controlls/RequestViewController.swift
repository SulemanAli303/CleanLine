//
//  LMLoginTypeSelectionViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import UIKit
import SDWebImage


class RequestViewController: UIViewController {
    
    
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var selectedRow = 0
    var isFromFood:Bool = false
    
   // var pickerData = ["PICK UP", "NORMAL CAR","MEDIUM TRUCK","BIG TRUCK"]
   // var imageData = [UIImage(named: "noun-pickup-4270958"),UIImage(named: "car1"),UIImage(named: "car2"),UIImage(named: "car3")]
    //var SelectedimageData = [UIImage(named: "noun-pickup-1"),UIImage(named: "noun-truck-4270970"),UIImage(named: "noun-truck-4270970"),UIImage(named: "noun-truck-4270970")]
    
        var pickerData : [DelegateList]? {
            didSet {
                pickerView.reloadAllComponents()
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        setInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        getReceivingOption()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    func configureLanguage(){
        requestLabel.text = "REQUEST A DELEGATE".localiz()
        backButton.setTitle("Back".localiz(), for: .normal)
        continueButton.setTitle("Continue".localiz(), for: .normal)
    }
    func setInterface() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .clear
        pickerView.selectRow(3, inComponent: 0, animated: false)
        pickerView.subviews.first?.subviews.last?.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true

    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    @IBAction func nextBtn(_ sender: Any) {
        if isFromFood{
            let  VC = AppStoryboard.FoodStore.instance.instantiateViewController(withIdentifier: "FoodCartViewController") as! FoodCartViewController
            VC.isAssigned = true
            VC.selectedDelegete = pickerData?[selectedRow]
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            let  VC = AppStoryboard.UserCart.instance.instantiateViewController(withIdentifier: "UserCartVC") as! UserCartVC
            VC.isAssigned = true
            VC.selectedDelegete = pickerData?[selectedRow]
            Constants.shared.appliedCoupon = ""
            self.navigationController?.pushViewController(VC, animated: true)
        }
       // ShopCoordinator.goToCart(controller: self,isSelected: true)
        
    }
    @IBAction func BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RequestViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData?[row].deligateName ?? ""
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        pickerView.subviews.forEach { UIView in
            UIView.backgroundColor = .clear
        }
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 100))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        let myLabel = UILabel(frame: CGRect(x: 0, y: 60, width:pickerView.bounds.width - 30, height: 40))
        
        if pickerView.selectedRow(inComponent: component) == row {
            
            myLabel.attributedText = NSAttributedString(string: pickerData?[row].deligateName ?? "", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-SemiBold", size: 17.0)!, NSAttributedString.Key.foregroundColor: Color.yellow.color()])
            myImageView.sd_setImage(with: URL(string: pickerData?[row].deligateIcon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            myImageView.setImageColor(color: Color.darkOrange.color())
        }else
        {
            myLabel.attributedText = NSAttributedString(string: pickerData?[row].deligateName ?? "", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-SemiBold", size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            myImageView.sd_setImage(with: URL(string: pickerData?[row].deligateIcon ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            
        }
        myImageView.contentMode = .scaleAspectFit
        myImageView.center = myView.center
        myLabel.textAlignment = .center
        
        myView.addSubview(myImageView)
        myView.addSubview(myLabel)
        
        pickerView.backgroundColor = .white
        view?.backgroundColor = .white
        
        return myView
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        selectedRow = row
    }
    
}


extension RequestViewController {
    func getReceivingOption() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        StoreAPIManager.deligatesAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.pickerData = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {

                }
            }
        }
    }
}
