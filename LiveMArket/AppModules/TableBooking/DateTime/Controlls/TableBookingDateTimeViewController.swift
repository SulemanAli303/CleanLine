//
//  DateTimeViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 30/01/2023.
//

import UIKit
import CHIPageControl

//struct timeslotsValue
//{
//    var timeslots : String
//}

class TableBookingDateTimeViewController: BaseViewController {
    
    @IBOutlet weak var selectSlotLabel: UILabel!
    @IBOutlet weak var notAvailableLabel: UILabel!
    @IBOutlet weak var personsLabel: UILabel!
    @IBOutlet weak var whereDoYouLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var imagePageControl: CHIPageControlJaloro! {
        didSet{
            imagePageControl.tintColor = .white
            imagePageControl.currentPageTintColor = UIColor(named: "DarkOrange")
            imagePageControl.radius = 2
        }
    }
    @IBOutlet weak var mediaSlider: MediaSlideshow!
    
    @IBOutlet weak var selcetedDateLabel: UILabel!
    @IBOutlet weak var slots: UICollectionView!
    @IBOutlet weak var topCollection: IntrinsicCollectionView!
    @IBOutlet weak var timeCollection: UICollectionView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    var shopData:SellerData?

    var isSelected = -1
    var selectedPostion = -1
    var maxSeats = 0
    
    
    //var timeslotsArray :[timeslotsValue] = []
    var selectedSlot : Slot_list?
    //var date = Date()
    //var datesArray = [Date]()
    var ground_ID:String = ""
    var store_ID:String = ""
    var monthDatesArray : [GroundBookingDate] = []
    var slotsArray : [Slot_list] = []
    var selectedDateArray:[Int] = []
    var selectedSlotArray:[Int] = []
    var unavailableSlotArray:[String] = []
    var selectedSlotID:String = ""
    var selectedDate:String = ""
    var page = 1
    var count = 0
    var currentTime:String = ""
    
    var postionArray : [Postionlist]? {
        didSet {
            self.topCollection.reloadData()
            self.topCollection.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        setData()
        type = .transperantBack
        //setImageSlider()
        self.getTblPostionAPI()
        bookingDatesDetailsAPI()
        countLbl.text = "1"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Set the desired time format
        currentTime = dateFormatter.string(from: Date())
        print(currentTime)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   playGroundDetailsAPI()
        
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    
    override func liveAction () {
        Coordinator.goToLive(controller: self)
    }
    func configureLanguage(){
        selectSlotLabel.text = "Select your slot".localiz()
        notAvailableLabel.text = "Not Available".localiz()
        availableLabel.text = "Available".localiz()
        personsLabel.text = "Persons".localiz()
        whereDoYouLabel.text = "Where do you prefer?".localiz()
        backButton.setTitle("Back".localiz(), for: .normal)
        nextButton.setTitle("Next".localiz(), for: .normal)
    }
    @IBAction func minusPressed(_ sender: UIButton) {
        
        if count > 0
        {
            count = count - 1
            countLbl.text = String(count)
        }
        
    }
    
    @IBAction func plusPressed(_ sender: UIButton) {
        
        //if count < self.maxSeats{
            count = count + 1
            countLbl.text = String(count)
//        }
//        else
//        {
//            Utilities.showWarningAlert(message: "Maximum seats allowed are \(self.maxSeats)")
//        }
        
        
    }
    
    func setData() {
        slots.delegate = self
        slots.dataSource = self
        slots.register(UINib.init(nibName: "OptionsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OptionsCollectionCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 0
        self.slots.collectionViewLayout = layout
        self.slots.reloadData()
        self.slots.layoutIfNeeded()
        
        
        timeCollection.delegate = self
        timeCollection.dataSource = self
        timeCollection.register(UINib.init(nibName: "DateCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DateCollectionCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0.0
        layout2.minimumLineSpacing = 0.0
        self.timeCollection.collectionViewLayout = layout2
        self.timeCollection.reloadData()
        
        
        topCollection.delegate = self
        topCollection.dataSource = self
        topCollection.register(UINib.init(nibName: "TablePostionCell", bundle: nil), forCellWithReuseIdentifier: "TablePostionCell")
        let layout4 = UICollectionViewFlowLayout()
        layout4.scrollDirection = .vertical
        layout4.minimumInteritemSpacing = 0
        layout4.minimumLineSpacing = 0
        self.topCollection.collectionViewLayout = layout4
        self.topCollection.reloadData()
        self.topCollection.layoutIfNeeded()
        
        bannerImageView.sd_setImage(with: URL(string: shopData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
        viewControllerTitle = shopData?.name ?? ""
        
    }
    
    
    var dateData:GroundBookingDate_Base?{
        didSet{
            if(self.page == 1){
                monthDatesArray = dateData?.data ?? []
                dateLbl.text = monthDatesArray.first?.month_year ?? ""
                selectedDateArray.append(0)
                //slotsArray = monthDatesArray.first?.slots ?? []
                selectedDate = self.formatDate(date: monthDatesArray.first?.full_date ?? "")
                self.selcetedDateLabel.text = monthDatesArray.first?.full_date ?? ""
                slots.reloadData()
                timeCollection.reloadData()
                self.getTimeSlotAPI()
            }else{
                let items = dateData?.data ?? []
                if(items.count > 0){
                    monthDatesArray.append(contentsOf: dateData?.data ?? [])
                    dateLbl.text = items.first?.month_year ?? ""
                    slots.reloadData()
                    timeCollection.reloadData()
                    let index = 10 * (page - 1)
                    let indexPath = IndexPath(item: index, section: 0)
                    self.timeCollection.scrollToItem(at: indexPath, at: [.left], animated: true)
                    self.getTimeSlotAPI()
                }
                
            }

        }
    }
    
    var timeSlot:SlotData?{
        didSet{
            print(timeSlot)
            slotsArray = timeSlot?.slot_list ?? []
            self.unavailableSlotArray.removeAll()
            if selectedDate == Date().toSting{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                for i in 0..<slotsArray.count {
                    
                    let value: String = self.reduceOneHourFromTimeSlot(inputTimeString: slotsArray[i].slot_from ?? "")
                    
                    if let time1 = dateFormatter.date(from: value), let time2 = dateFormatter.date(from: currentTime) {
                        // Compare the two Date objects
                        
                        if time1 > time2 {
                            print("Time 1 is greater than Time 2.")
                            if slotsArray[i].is_available != "1"
                            {
                                self.unavailableSlotArray.append(slotsArray[i].slot_text ?? "")
                            }
                        } else if time1 < time2 {
                            print("Time 1 is less than Time 2.")
                            self.unavailableSlotArray.append(slotsArray[i].slot_text ?? "")
                        } else {
                            print("Time 1 and Time 2 are equal.")
                            if slotsArray[i].is_available != "1"
                            {
                                self.unavailableSlotArray.append(slotsArray[i].slot_text ?? "")
                            }
                            
                        }
                    } else {
                        print("Invalid time string format")
                    }
                }
            }
            else{
               
                for i in 0..<slotsArray.count {
                    if slotsArray[i].is_available != "1"
                    {
                        self.unavailableSlotArray.append(slotsArray[i].slot_text ?? "")
                    }
                }
            }
            print(unavailableSlotArray)
            self.slots.reloadData()
        }
    }
    func reduceOneHourFromTimeSlot(inputTimeString:String) -> String{

        // Create a DateFormatter with the "HH:mm" format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        // Your input time string
        //let inputTimeString = "14:30" // Replace this with your input time

        // Parse the input time string into a Date
        if let date = dateFormatter.date(from: inputTimeString) {
            // Subtract one hour from the date
            let calendar = Calendar.current
            if let newDate = calendar.date(byAdding: .hour, value: -1, to: date) {
                // Format the newDate back to "HH:mm" format
                let newTimeString = dateFormatter.string(from: newDate)
                print(newTimeString) // This will print the time with one hour subtracted
                return newTimeString
            } else {
                print("Error: Could not subtract one hour from the date.")
                return ""
            }
        } else {
            print("Error: Invalid time format.")
            return ""
        }
        return ""
    }
    
    @objc func didTapSlider() {
        let fullScreenController = mediaSlider.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: UIActivityIndicatorView.Style.medium, color: nil)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func PreviousMoth(_ sender: UIButton) {
//        date = date.getPreviousMonth() ?? Date()
//        self.dateLbl.text = date.monthName()
//        datesArray = getDaysSimple(for: date)
//        self.timeCollection.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        timeCollection.scrollToItem(at: indexPath, at: .right, animated: true)
        
    }
    @IBAction func nextMounth(_ sender: UIButton) {
//        date = date.getNextMonth() ?? Date()
//        self.dateLbl.text = date.monthName()
//        datesArray = getDaysSimple(for: date)
//        self.timeCollection.reloadData()
        self.page = page + 1
     //   bookingDatesDetailsAPI()
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        guard selectedDate != "" else {
            Utilities.showWarningAlert(message: "Please select your date.".localiz()) {
            }
            return
        }
        guard selectedSlot != nil else {
            Utilities.showWarningAlert(message: "Please select your slot.".localiz()) {
            }
            return
        }
        guard selectedPostion != -1 else {
            Utilities.showWarningAlert(message: "Please tell where do you prefer?".localiz()) {
            }
            return
        }
        guard countLbl.text != "" && countLbl.text != "0" && countLbl.text != "-1" else {
            Utilities.showWarningAlert(message: "Please add your person count.".localiz()) {
            }
            return
        }
        Coordinator.goToTablePlaceOrder(controller: self,shopDetails: shopData,personCount: countLbl.text ?? "",date: selectedDate,selectedSlot: selectedSlot,selectedPostion: self.postionArray?[self.selectedPostion])
    }
    
    func getDaysSimple(for month: Date) -> [Date] {
        
        //get the current Calendar for our calculations
        let cal = Calendar.current
        //get the days in the month as a range, e.g. 1..<32 for March
        let monthRange = cal.range(of: .day, in: .month, for: month)!
        //get first day of the month
        let comps = cal.dateComponents([.year, .month], from: month)
        //start with the first day
        //building a date from just a year and a month gets us day 1
        var date = cal.date(from: comps)!
        
        //somewhere to store our output
        var dates: [Date] = []
        //loop thru the days of the month
        for _ in monthRange {
            //add to our output array...
            dates.append(date)
            //and increment the day
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }
    func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd MMMM yyyy"
        let showDate = inputFormatter.date(from: date) ?? Date()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = inputFormatter.string(from: showDate)
        print(resultString)
        return resultString
    }
    
}
extension TableBookingDateTimeViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == topCollection){
            return postionArray?.count ?? 0
        }else if (collectionView == timeCollection){
            return monthDatesArray.count
        }else {
            guard self.slotsArray.count != 0  else {
                collectionView.setEmptyView_new(title: "", message: "No slot Found!", image: UIImage(named: ""))
                return 0
            }
            collectionView.backgroundView = nil
            return self.slotsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == topCollection){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TablePostionCell", for: indexPath) as? TablePostionCell else { return UICollectionViewCell() }
         
            cell.namelbl.text = postionArray?[indexPath.row].positionName ?? ""
            
            if selectedPostion == indexPath.row {
                cell.baseView.layer.borderColor = UIColor(hexString: "#FCB813").cgColor
                cell.namelbl.textColor = UIColor(hexString: "#FFFFFF")
                cell.baseView.backgroundColor = UIColor(hexString: "#FCB813")
            }else {
                cell.baseView.layer.borderColor = UIColor(hexString: "#E2E2E2").cgColor
                cell.namelbl.textColor = UIColor(hexString: "#363636")
                cell.baseView.backgroundColor = UIColor(hexString: "#FFFFFF")
            }
            return cell
        }
        else if (collectionView == timeCollection){
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionCell", for: indexPath) as? DateCollectionCell else { return UICollectionViewCell() }
            cell.dateData = monthDatesArray[indexPath.row]
            if selectedDateArray.contains(indexPath.row){
                cell.baseView.backgroundColor = UIColor(hexString: "#FBCD77")
            }else{
                cell.baseView.backgroundColor = UIColor(hexString: "#F6B446")
                
            }
            
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCollectionCell", for: indexPath) as? OptionsCollectionCell else { return UICollectionViewCell() }
            cell.dateString = selectedDate
            cell.timeSlotsData = slotsArray[indexPath.row]
            if selectedSlotArray.contains(indexPath.row){
                cell.baseView.backgroundColor = UIColor.white
                cell.namelbl.textColor = Color.darkOrange.color()
            }else{
//                cell.baseView.backgroundColor = UIColor(hex: "#F1A748")
                cell.namelbl.textColor = UIColor.white
                
                if self.unavailableSlotArray.contains({self.slotsArray[indexPath.row].slot_text ?? ""}()){
                    cell.baseView.backgroundColor = UIColor(hex: "#F1A748")
                    cell.isUserInteractionEnabled = false
                }else{
                    cell.baseView.backgroundColor = UIColor(hex: "#D85A1F")
                    cell.isUserInteractionEnabled = true
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == timeCollection{
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-40
            return CGSize(width: screenWidth/6, height:62)
        } else if collectionView == topCollection{
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-40
            return CGSize(width: screenWidth/3, height:40)
        }else {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-40
            return CGSize(width: screenWidth/3, height:40)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if (collectionView != timeCollection){
            return 5.0
        }else {
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isSelected = indexPath.row
        
        if collectionView == topCollection{
            self.selectedPostion = indexPath.row
            self.topCollection.reloadData()
            self.topCollection.layoutIfNeeded()
        }
        else if collectionView == timeCollection{
            selectedDateArray.removeAll()
            selectedSlotArray.removeAll()
            self.selcetedDateLabel.text = monthDatesArray[indexPath.row].full_date ?? ""
            //slotsArray = monthDatesArray[indexPath.row].slots ?? []
            selectedDateArray.append(indexPath.row)
            selectedDate = self.formatDate(date: monthDatesArray[indexPath.row].full_date ?? "")
            timeCollection.reloadData()
            self.getTimeSlotAPI()
        }else{
            
            selectedSlotArray.removeAll()
            selectedSlotArray.append(indexPath.row)
            selectedSlot = slotsArray[indexPath.row]
            count = 1
            countLbl.text = String(count)
            self.maxSeats = Int(slotsArray[indexPath.row].max_no_of_seats_can_be_selected ) ?? 0
            //selectedSlotID = "\(slotsArray[indexPath.row].id ?? 0)"
        }
        slots.reloadData()
        
//        self.slots.reloadData()
    }
}
extension TableBookingDateTimeViewController {
    func bookingDatesDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "ground_id" : ground_ID,
            "limit":"10",
            "page":"\(page)"
        ]
        StoreAPIManager.bookindDatesDetailsAPI(parameters: parameters) { result in

            self.dateData = result
        }
    }
    func playGroundDetailsAPI() {
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? "",
//            "ground_id" : ground_ID
//        ]
//        StoreAPIManager.playGroundDetailsAPI(parameters: parameters) { result in
//            switch result.status {
//            case "1":
//
//               // self.groundData = result.oData
//                //self.categories = result.oData?.categories
//            default:
//                Utilities.showWarningAlert(message: result.message ?? "") {
//
//                }
//            }
//        }
    }
    func getTimeSlotAPI() {
        let parameters:[String:String] = [
            "store_id" : shopData?.id ?? "",
            "date" : selectedDate
        ]
        StoreAPIManager.getTimeSlotAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.timeSlot = result.oData
                self.maxSeats = Int(self.timeSlot?.max_no_of_seats_can_be_selected ?? "0") ?? 0
                let aData = TableBookingBillingData.shared
                aData.tax = self.timeSlot?.tax ?? ""
                aData.currency_code = self.timeSlot?.currency_code ?? ""
                aData.grand_total = self.timeSlot?.grand_total ?? ""
                aData.service_charge = self.timeSlot?.service_charge ?? ""
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {

                }
            }
        }
    }
    func saveBookingDatesAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "ground_id":ground_ID,
            "slot_id":selectedSlotID,
            "date":selectedDate
        ]
        print(parameters)
        StoreAPIManager.playGroundSaveBookingAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                //self.groundData = result.oData
                PlayGroundCoordinator.goToCompleteBooking(controller: self)
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension TableBookingDateTimeViewController: MediaSlideshowDelegate {
    func mediaSlideshow(_ mediaSlideshow: MediaSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        self.imagePageControl.set(progress: page, animated: true)
    }
}
extension TableBookingDateTimeViewController {
    func getTblPostionAPI() {
        let parameters:[String:String] = [
            "": ""
        ]
        StoreAPIManager.getTblPostionAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.postionArray = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                  
                }
            }
        }
    }
}
