
//
//  Created by apple on 21/10/2022.
//
import UIKit
import FSCalendar

protocol CalanderCellDelegate: AnyObject {
    func setDate(firstDate :Date?,   lastDate :Date?)
}
class CalanderCell: UITableViewCell, FSCalendarDelegateAppearance, FSCalendarDataSource, FSCalendarDelegate {
    var avalible  : [String]? {
        didSet {
        }
    }
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var theCaldenderateDelegate: CalanderCellDelegate? = nil
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var theCalender: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    var isShowWeekDay: Bool = true
    var didToggleCalenderView: (() -> Void) = {}
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    var priceType = "per_day"
    var notAvailableDates : [String]?
    override func awakeFromNib() {
        super.awakeFromNib()
        //  fsCalender()
    }

    fileprivate lazy var dayFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()

    func fsCalender() {
        theCalender.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        theCalender.appearance.titleFont = UIFont(name: "Poppins-SemiBold", size: 18)
        theCalender.appearance.weekdayFont = UIFont(name: "Poppins-SemiBold", size: 18)
        theCalender.rowHeight = 50
        if isShowWeekDay {
            self.theCalender.scope = .week
            calendarHeightConstraint.constant = 90
        } else {
            calendarHeightConstraint.constant = 300
            
            self.theCalender.scope = .month
        }
        
        theCalender.delegate = self
        theCalender.reloadData()
        theCalender.layoutIfNeeded()
        self.layoutIfNeeded()
        self.setupHeaderDate(date: Date())
        
    }
    
    @IBAction func toggleClicked(sender: AnyObject) {
        isShowWeekDay.toggle()
        if isShowWeekDay {
            self.theCalender.scope = .week
            calendarHeightConstraint.constant = 90
        } else {
            calendarHeightConstraint.constant = 300
            self.theCalender.scope = .month
        }
        theCalender.reloadData()
        theCalender.layoutIfNeeded()
        self.layoutIfNeeded()
        didToggleCalenderView()
    }
    
    func setupHeaderDate(date:Date){
        
        let month = Calendar.current.component(.month, from: date)
        let monthName = DateFormatter().monthSymbols[month - 1].capitalized
        let year = Calendar.current.component(.year, from: date)
        self.monthLabel.text = "\(monthName) \(year)"
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        self.setupHeaderDate(date: currentPageDate)
        
    }
    
    //    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    //        self.cellData.viewModel.selectedDate = date
    //
    //    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        self.moveCurrentPage(moveUp: false)
    }
    @IBAction func nextButtonAction(_ sender: Any) {
        self.moveCurrentPage(moveUp: true)
        
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        if(self.isShowWeekDay){
            dateComponents.weekOfYear = moveUp ? 1 : -1
        }else{
            dateComponents.month = moveUp ? 1 : -1
        }
        
        
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.theCalender.setCurrentPage(self.currentPage!, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            print("datesRange contains: \(datesRange!)")
            theCaldenderateDelegate?.setDate(firstDate: firstDate, lastDate: lastDate)
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                
                DispatchQueue.main.async {
                    for d in calendar.selectedDates {
                        calendar.deselect(d)
                    }
                    self.firstDate = date
                    calendar.reloadData()
                    calendar.layoutIfNeeded()
                    calendar.layoutSubviews()
                    calendar.select(self.firstDate)
                    self.datesRange = [self.firstDate!]
                    self.theCaldenderateDelegate?.setDate(firstDate: self.firstDate, lastDate: self.lastDate)
                    print("datesRange containsssss: \(self.datesRange!)")
                }
                
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            var rangeDatesString = [String]()
            for d in range{
                rangeDatesString.append(dateFormatter1.string(from: d))
            }
            var shouldContinue = true
            if rangeDatesString.count > 0
            {
                if let disableDates = notAvailableDates
                {
                    for str in rangeDatesString
                    {
                        if disableDates.contains(str){
                            shouldContinue = false
                            break
                        }
                    }
                }
            }
            if !shouldContinue{
                for d in calendar.selectedDates 
                {
                    calendar.deselect(d)
                }
                lastDate = nil
                firstDate = nil
                return
            }
            
            lastDate = range.last
            datesRange = range
            
            var isFound = true
            for (indexx,d) in range.enumerated() {
                calendar.select(d)
                if (indexx == (range.count - 1)){
                    for (indexxx,d2) in range.enumerated() {
                        let dateString : String = dateFormatter1.string(from:d2)
                        if (self.avalible?.count ?? 0) > 0 {
                            for (index, element) in self.avalible!.enumerated() {
                                if element == dateString {
                                    isFound = false
                                    break
                                }else {
                                    if (index == (self.avalible!.count - 1)){
                                        isFound = true
                                    }
                                }
                            }
                        }else {
                            isFound = true
                        }
                        if (indexxx == (range.count - 1)){
                            if isFound == true {
                                
                            }else {
                                for d in calendar.selectedDates {
                                    calendar.deselect(d)
                                }
                                lastDate = nil
                                firstDate = nil
                                datesRange = []
                            }
                        }
                    }
                }
            }
            
            
            
            theCaldenderateDelegate?.setDate(firstDate: firstDate, lastDate: lastDate)
            print("datesRange contains: \(datesRange!)")
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
            theCaldenderateDelegate?.setDate(firstDate: firstDate, lastDate: lastDate)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }

//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//
//        cell.titleLabel.attributedText = NSAttributedString(string: "",attributes: [NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue])
//
//        cell.titleLabel.attributedText = nil
//        cell.titleLabel.attributedText = nil
//        cell.titleLabel.attributedText = nil
//        cell.titleLabel.attributedText = nil
//        cell.titleLabel.text = nil
//
//        let dateString : String = dateFormatter1.string(from:date)
//        var isStrikeThroug = false
//
//
//        if (self.avalible?.count ?? 0) > 0 {
//            for (index, element) in self.avalible!.enumerated() {
//                if element == dateString {
//                    isStrikeThroug = true
//                }
//            }
//        }
//        else if let disableDates = notAvailableDates {
//            if disableDates.contains(dateString){
//                isStrikeThroug = true
//            }
//        }
//        if date.timeIntervalSinceNow.sign == .minus  {
//            isStrikeThroug = true
//        }
//        let attributes =   NSMutableAttributedString(string: dayFormatter1.string(from: date))
//
//        if isStrikeThroug {
//            attributes.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributes.length))
//        }
//        cell.titleLabel.attributedText = attributes
//    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateString : String = dateFormatter1.string(from:date)
        if (self.avalible?.count ?? 0) > 0 {
            for (index, element) in self.avalible!.enumerated() {
                if element == dateString {
                    return .lightGray
                    
                }else {
                    if (index == (self.avalible!.count - 1)){
                        if date < Date() {
                            return .lightGray
                        }
                        return .white
                    }
                }
            }
        }else {
            if date < Date() {
                return .lightGray
            }
            if let disableDates = notAvailableDates{
                if disableDates.contains(dateString){
                    return .lightGray
                }
            }
            return .white
        }
        if date < Date() {
            return .lightGray
        }
        return .white
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let dateString : String = dateFormatter1.string(from:date)
        if (self.avalible?.count ?? 0) > 0 {
            for (index, element) in self.avalible!.enumerated() {
                if element == dateString {
                    return false
                    //return true
                }else {
                    if (index == (self.avalible!.count - 1)){
                        return true
                    }
                }
            }
        }else {
            
            if let disableDates = notAvailableDates{
                if disableDates.contains(dateString){
                    return false
                }
            }
            else if date < Date() {
                return false
            }
            
            return true
        }
        return true
    }
    
}

class CalanderCellData: TableCellData {
    
    var viewModel: DateAndCalanderVM {get {return model as! DateAndCalanderVM}}
    init() {
        super.init(nibId: "CalanderCell")
    }
}
