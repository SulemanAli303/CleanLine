//
//  FoodCartHoursPicker.swift
//  LiveMArket
//
//  Created by Shoaib Hassan's Macbook Pro M2 on 02/03/2024.
//

import UIKit

class FoodCartHoursPicker: UIViewController {
    
    let hoursArr = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    let amArr = ["AM","PM"]
    var existingValueString = ""
    var onDonePress : ((String) -> ())?
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if existingValueString.count > 0
        {
            let components = existingValueString.components(separatedBy: ":")
            if components.count > 1
            {
                let first = components.first
                if hoursArr.contains(first!)
                {
                    pickerView.selectRow(hoursArr.firstIndex(of: first!)!, inComponent: 0, animated: true)
                }
                let last = components.last
                let amString = last?.components(separatedBy: " ").last
                if amArr.contains(amString!)
                {
                    pickerView.selectRow(amArr.firstIndex(of: amString!)!, inComponent: 2, animated: true)
                }
            }
        }
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.hideView()
    }
    @IBAction func donePressed(_ sender: Any) {
        
        let timeVal = hoursArr[pickerView.selectedRow(inComponent: 0)]
        let amValue = amArr[pickerView.selectedRow(inComponent: 2)]
        let value = timeVal + ":00 " + amValue
        self.onDonePress?(value)
        self.hideView()
    }
    
    func hideView()
    {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

extension FoodCartHoursPicker : UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0
        {
            return hoursArr.count
        }
        else if component == 1
        {
            return 1
        }
        else {
            return amArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0
        {
            return hoursArr[row]
        }
        else if component == 1
        {
            return "00"
        }
        else
        {
            return amArr[row]
        }
    }
}
