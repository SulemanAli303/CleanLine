//
//  TimeSlotCell.swift

//
//  Created by apple on 21/10/2022.
//
import UIKit



class ButtonViewCell: TableCell {
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    override func setupUI() {
        super.setupUI()
      
 
    }
    
    override func setupTheme() {
        super.setupTheme()
    }
}

class ButtonViewCellData: TableCellData {
    
    var selectedIndex: Int? = nil

    
    var viewModel: DateAndCalanderVM {get {return model as! DateAndCalanderVM}}
    init() {
        super.init(nibId: "ButtonViewCell")
    }
}
