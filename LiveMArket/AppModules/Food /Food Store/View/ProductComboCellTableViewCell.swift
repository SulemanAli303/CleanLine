//
//  ProductComboCellTableViewCell.swift
//  LiveMArket
//
//  Created by Suleman Ali on 04/05/2024.
//

import UIKit

class  ProductComboCellTableViewCell: UITableViewCell {


    @IBOutlet weak var checkboxButton: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var qtyStackView: UIStackView!

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    
    var itemCount = 1
    var currencyCode:String = "SAR".localiz()
    var item:ComboItem! {
        didSet {
            itemNameLabel.text = "\(item.foodItem?.productName ?? "") \(((item.extraPrice?.isEmpty ?? false) || item.extraPrice == "0" ) ? "" : "(\(item.extraPrice ?? "") \(currencyCode))")"
            self.isSelected = item.isDefault == "1"
            checkboxButton.image =  UIImage(named: isSelected ? "Group 236139" : "Ellipse 1449")

            qtyStackView.isHidden = !(item.allowQuantityUpdate == "1")
        }
    }

    var selectedItem:ComboItemsSelectedElement! {
        didSet {
            itemNameLabel.text = "\(selectedItem.comboQuantity) X \(selectedItem.productItem.productName) \((selectedItem.comboUnitPrice.isEmpty || selectedItem.comboUnitPrice == "0" ) ? "" : "(\(selectedItem.comboUnitPrice) \(currencyCode))")"
            checkboxButton.isHidden =  true
            qtyStackView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkboxButton.image =  UIImage(named: selected ? "Group 236139" : "Ellipse 1449")
    }


    @IBAction func minusButton(_ sender: Any) {
        if self.itemCount == 1{

        }else{
            self.itemCount = self.itemCount - 1
            self.itemCountLabel.text = "\(self.itemCount)"
        }

    }
    @IBAction func plusButtonTapped(_ sender: Any) {
        self.itemCount = self.itemCount + 1
        self.itemCountLabel.text = "\(self.itemCount)"
    }

}
