//
//  DateAndCalanderVM.swift

//
//  Created by apple on 21/10/2022.
//
import Foundation
import UIKit

protocol DateAndCalanderVMDelegate: AnyObject {
    func updateView(_ date: String)
}

class DateAndCalanderVM: TableViewModel {
    
    var showWeekView: Bool =  true
    var selectedDate: Date?
    var selectedTime: String?
    weak var vmdelegate: DateAndCalanderVMDelegate?
    override init() {
        super.init()
        prepareData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.prepareData()
        }
    }
 
    
    override func prepareData() {
        super.prepareData()
        
        let section = TableSectionData(model: self)
        section.addCell(cellData: CalanderCellData())
        section.addCell(cellData: ButtonViewCellData())
        
        tableData.append(section)
        delegate?.onUnderlyingDataChanged()
    }
    
    func changeCal() {
        showWeekView = !showWeekView
        self.prepareData()
    }
    
//    func checkValidation() -> Bool{
//        if selectedDate == nil{
//            Utilities.showWarningAlert(message: "Please select Service Date")
//            return false
//        }
//
//        if selectedTime == nil{
//            Utilities.showWarningAlert(message: "Please select Service Time")
//            return false
//        }
//
//        if selectedTime?.trimmingCharacters(in: .whitespaces) == "" {
//            Utilities.showWarningAlert(message: "Please select Service Time")
//            return false
//        }
//
//        return true
//    }
    
//    func continueButtonAction(){
//        if(checkValidation()){
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let serviceDate = formatter.string(from: selectedDate ?? Date())
//            let date = "\(serviceDate) \(selectedTime ?? ""):00"
//            self.vmdelegate?.updateView(date)
//        }
//    }
}
