//
//  CategoryNameCollectionViewCell.swift
//  Opium
//
//  Created by Albin Jose on 15/12/21.
//

import UIKit

class TablePostionCell: UICollectionViewCell, Registerable {

    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var img: UIImageView!
    
    var slotsData: Slots?{
        didSet{
            namelbl.text = slotsData?.slot_value ?? ""
            
        }
    }
    var timeSlotsData: Slot_list?{
        didSet{
            namelbl.text = timeSlotsData?.slot_text ?? ""
            
        }
    }
   
    var category: String? {
        didSet {
            updateUI()
        }
    }
    
    var isSelectCategory: Bool = false {
        didSet {
            if(isSelectCategory){
              //  self.baseView.layer.borderColor = UIColor.init(hex: "#BEBBEE").cgColor
                self.baseView.backgroundColor = UIColor.init(hex: "#D3DBFF")
                self.namelbl.textColor = UIColor.init(hex: "#0B26AD")
            }else {
               // self.baseView.layer.borderColor = UIColor.init(hex: "#D8D8D8").cgColor
                self.namelbl.textColor = UIColor.init(hex: "#202020")
                self.baseView.backgroundColor = UIColor.init(hex: "#FFFFFF")
            }
        }
    }
    
    fileprivate func updateUI() {
        guard let category = category else {
            return
        }
        namelbl.text = category
    }
}
