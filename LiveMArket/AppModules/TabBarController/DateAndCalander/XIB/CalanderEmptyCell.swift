//
//  CalanderEmptyCell.swift

//
//  Created by apple on 31/10/2022.
//

import UIKit

class CalanderEmptyCell: TableCell {
    
    var cellData: CalanderEmptyCellData {get {return data as! CalanderEmptyCellData}}
    
    override func setupUI() {
        super.setupUI()
    }

    override func setupTheme() {
        super.setupTheme()
    }
}

class CalanderEmptyCellData: TableCellData {
    
    var viewModel: DateAndCalanderVM {get {return model as! DateAndCalanderVM}}
    init() {
        super.init(nibId: "CalanderEmptyCell")
    }
}
