//
//  LMLoginTypeSelectionViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import UIKit


protocol ReceivingViewDelegate: AnyObject {
    func goBack(pickData : DelegateList?)
    func selectedPickupbyPerson(pickText: String?, id:String?)
}

class ReceivingViewController: UIViewController {

    @IBOutlet weak var receivingOptionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate : ReceivingViewDelegate?
    @IBOutlet weak var pickerView: UIPickerView!
    var selectedRow = 0
    var isFromFoodCart:Bool = false
    
    var pickerData = ["PICK UP IN PERSON", "REQUEST A DELEGATE"]
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        setInterface()
    }
    //MARK: - Methods
    
    func configureLanguage(){
        receivingOptionLabel.text = "Receiving Options".localiz()
        nextButton.setTitle("Next".localiz(), for: .normal)
    }
    func setInterface() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .clear
        //pickerView.selectRow(3, inComponent: 0, animated: false)
        pickerView.subviews.first?.subviews.last?.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
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
        
        
      //  ShopCoordinator.goToRequestDelegate(controller: self)
        if pickerData[selectedRow] == "PICK UP IN PERSON"{
            delegate?.selectedPickupbyPerson(pickText: "PICK UP IN PERSON", id: "2")
            self.navigationController?.popViewController(animated: true)
        }else{
            
            delegate?.selectedPickupbyPerson(pickText: "REQUEST A DELEGATE", id: "5")
            self.navigationController?.popViewController(animated: true)

//            let  VC = AppStoryboard.ReceivingOption.instance.instantiateViewController(withIdentifier: "RequestViewController") as! RequestViewController
//            VC.isFromFood = isFromFoodCart
//            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

extension ReceivingViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
        }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
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
            pickerLabel.attributedText = NSAttributedString(string: pickerData[row] , attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-SemiBold", size: 17.0)!, NSAttributedString.Key.foregroundColor: Color.yellow.color()])

        } else {
            pickerLabel.attributedText = NSAttributedString(string: pickerData[row] , attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-SemiBold", size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        }
        pickerLabel.textAlignment = .center
        pickerLabel.numberOfLines = 2
        pickerLabel.backgroundColor = .white
        pickerView.backgroundColor = .white
        view?.backgroundColor = .white
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        selectedRow = row
    }

}
