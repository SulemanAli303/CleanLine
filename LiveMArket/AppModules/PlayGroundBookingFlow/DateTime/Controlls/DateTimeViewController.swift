//
//  DateTimeViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 30/01/2023.
//

import UIKit
import CHIPageControl

struct timeslotsValue
{
    var timeslots : String
}

class DateTimeViewController: BaseViewController {
    
    @IBOutlet weak var imagePageControl: CHIPageControlJaloro! {
        didSet{
            imagePageControl.tintColor = .white
            imagePageControl.currentPageTintColor = UIColor(named: "DarkOrange")
            imagePageControl.radius = 2
        }
    }
    @IBOutlet weak var mediaSlider: MediaSlideshow!
    
    @IBOutlet weak var selcetedDateLabel: UILabel!
    @IBOutlet weak var slots: IntrinsicCollectionView!
    @IBOutlet weak var timeCollection: UICollectionView!
    @IBOutlet weak var dateLbl: UILabel!
    var isSelected = -1
    
    //var timeslotsArray :[timeslotsValue] = []
    var selectedSlot : String?
    //var date = Date()
    //var datesArray = [Date]()
    var ground_ID:String = ""
    var store_ID:String = ""
    var monthDatesArray : [GroundBookingDate] = []
    var slotsArray : [Slots] = []
    var selectedDateArray:[Int] = []
    var selectedSlotArray:[Int] = []
    var selectedSlotIds:[Int] = []
    var selectedSlotID:String = ""
    var selectedDate:String = ""
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        type = .transperantBack
        bookingDatesDetailsAPI()
        playGroundDetailsAPI()
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func liveAction () {
        Coordinator.goToLive(controller: self)
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
        
    }
    
    
    var dateData:GroundBookingDate_Base?{
        didSet{
            if(self.page == 1){
                monthDatesArray = dateData?.data ?? []
                dateLbl.text = monthDatesArray.first?.month_year ?? ""
                selectedDateArray.append(0)
                slotsArray = monthDatesArray.first?.slots ?? []
                selectedDate = self.formatDate(date: monthDatesArray.first?.full_date ?? "")
                self.selcetedDateLabel.text = monthDatesArray.first?.full_date ?? ""
                slots.reloadData()
                timeCollection.reloadData()
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
                }
            }
            
        }
    }
    var groundData : GroundDetailsData? {
        didSet {
            viewControllerTitle = groundData?.ground?.name ?? ""
            //bannerImagView.sd_setImage(with: URL(string: groundData?.ground?.primary_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            setImageSlider()
        }
    }
    
    
    func setImageSlider() {
        
        imagePageControl.numberOfPages = groundData?.ground?.content?.count ?? 0
        var localSource : [SDWebImageSource] = []
        var videoSource : [AVSource] = []
        
        if let gallery = self.groundData?.ground?.content , gallery.count > 0 {
            for single in gallery {
                if let encodedURLString = single.content?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    if(single.contentType == "video"){
                        videoSource.append(AVSource(url: URL(string: encodedURLString)!, onAppear: .play))
                    }else{
                        localSource.append(SDWebImageSource(url: URL(string: encodedURLString)!,placeholder: UIImage(named: "propic-placeholder")))
                    }
                }
                
            }
        }else{
            if let encodedURLString = groundData?.ground?.primary_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                localSource.append(SDWebImageSource(url: URL(string: encodedURLString)!,placeholder: UIImage(named: "propic-placeholder")))
            }
                
            
        }
        
        
        mediaSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        mediaSlider.contentScaleMode = UIViewContentMode.scaleAspectFill
        mediaSlider.pageIndicator?.view.isHidden = true

        mediaSlider.pageIndicator = UIPageControl.withSlideshowColors()

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        mediaSlider.activityIndicator = DefaultActivityIndicator()
        mediaSlider.delegate = self

        mediaSlider.setMediaSources(localSource + videoSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSlider))
        mediaSlider.addGestureRecognizer(recognizer)
        
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
        bookingDatesDetailsAPI()
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
       // PlayGroundCoordinator.goToCompleteBooking(controller: self)
        guard selectedDate != "" else {
            Utilities.showWarningAlert(message: "Please select your date.".localiz()) {
                
            }
            return
        }
        guard selectedSlotIds.count != 0 else {
            Utilities.showWarningAlert(message: "Please select your slot.".localiz()) {
                
            }
            return
        }
        saveBookingDatesAPI()
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
extension DateTimeViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == timeCollection){
            return monthDatesArray.count
        }else {
            return self.slotsArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == timeCollection){
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionCell", for: indexPath) as? DateCollectionCell else { return UICollectionViewCell() }
            cell.dateData = monthDatesArray[indexPath.row]
            if selectedDateArray.contains(indexPath.row){
                cell.baseView.backgroundColor = UIColor(hexString: "#FBCD77")
            }else{
                cell.baseView.backgroundColor = UIColor(hexString: "#F6B446")
                
            }
            
//            let item = datesArray[indexPath.row]
//            var formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let showDate = formatter.string(from: item)
//            let day = showDate.components(separatedBy: "-")
//            cell.itemDate.text = day[2]
//            formatter.dateFormat = "EEE"
//            cell.itemDay.text = formatter.string(from: item)
            
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCollectionCell", for: indexPath) as? OptionsCollectionCell else { return UICollectionViewCell() }
            cell.slotsData = slotsArray[indexPath.row]
            if selectedSlotArray.contains(indexPath.row){
                cell.baseView.backgroundColor = UIColor.white
                cell.namelbl.textColor = Color.darkOrange.color()
            } else {
//                cell.baseView.backgroundColor = UIColor(hex: "#F1A748")
                cell.namelbl.textColor = UIColor.white
                if slotsArray[indexPath.row].is_available == true {
                    cell.baseView.backgroundColor = UIColor(hex: "#D85A1F")
                    cell.isUserInteractionEnabled = true
                }else{
                    cell.baseView.backgroundColor = UIColor(hex: "#F1A748")
                    cell.isUserInteractionEnabled = false
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
        if collectionView == timeCollection{
            selectedDateArray.removeAll()
            selectedSlotArray.removeAll()
            selectedSlotIds.removeAll()
            self.selcetedDateLabel.text = monthDatesArray[indexPath.row].full_date ?? ""
            slotsArray = monthDatesArray[indexPath.row].slots ?? []
            selectedDateArray.append(indexPath.row)
            selectedDate = self.formatDate(date: monthDatesArray[indexPath.row].full_date ?? "")
            timeCollection.reloadData()
        } else {
            //selectedSlotArray.removeAll()
            if (selectedSlotArray.contains(indexPath.row)) {
                selectedSlotArray.removeAll(where: { $0 == indexPath.row})
                selectedSlotIds.removeAll(where: {
                    $0 == slotsArray[indexPath.row].id ?? 0
                })
                //already selected
            } else {
                selectedSlotArray.append(indexPath.row)
                selectedSlotIds.append(slotsArray[indexPath.row].id ?? 0)
            }
            //selectedSlotID = "\(slotsArray[indexPath.row].id ?? 0)"
        }
        slots.reloadData()
//        selectedSlot = timeslotsArray[indexPath.row].timeslots
//        self.slots.reloadData()
    }
}
extension Date {
    func monthName() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("LLLL yyyy")
            return df.string(from: self)
    }
}
extension Date {
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}
extension DateTimeViewController {
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
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "ground_id" : ground_ID
        ]
        StoreAPIManager.playGroundDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.groundData = result.oData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func saveBookingDatesAPI() {
        if SessionManager.isLoggedIn() {

            let selectedSlotIds = self.selectedSlotIds.map{String($0)}.joined(separator: ",")
            print(selectedSlotIds)
            selectedSlotID = "\(self.selectedSlotIds[0])"

            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "device_cart_id" : SessionManager.getCartId() ?? "",
                "ground_id":ground_ID,
                "slot_id": selectedSlotID,
                "date":selectedDate,
                "slot_ids":selectedSlotIds
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
        } else {
            Coordinator.presentLogin(viewController: self)
        }
    }
}

extension DateTimeViewController: MediaSlideshowDelegate {
    func mediaSlideshow(_ mediaSlideshow: MediaSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        self.imagePageControl.set(progress: page, animated: true)
    }
}
