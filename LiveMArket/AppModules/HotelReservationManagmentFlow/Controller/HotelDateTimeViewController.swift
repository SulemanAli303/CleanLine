//
//  HotelDateTimeViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 08/08/23.
//


    import Foundation
    import UIKit
    import FSPagerView
    import PageControls
    import SDWebImage
import CHIPageControl

    protocol HotelDateAndCalanderVCDelegate: AnyObject {
        func selecetdServiceDate(_ date: String)
    }

    class HotelDateTimeViewController: BaseViewController, TableCellDelegate {
        
        @IBOutlet weak var imagePageControl: CHIPageControlJaloro! {
            didSet{
                imagePageControl.tintColor = .white
                imagePageControl.currentPageTintColor = UIColor(named: "DarkOrange")
                imagePageControl.radius = 2
            }
        }
        @IBOutlet weak var mediaSlider: MediaSlideshow!
        
        var roomID:String = ""
        
        func cellWasTapped(cell: TableCell, tag: String) {
            
        }
        fileprivate lazy var dateFormatterMain: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        @IBOutlet weak var theTableView: UITableView! {
            didSet {
            }
        }
        
        var adultsCount:String = "1"
        var childAboveCount:String = "0"
        var childBelowCount:String = "0"
        var roomCount:String = "1"
        
        var roomData:Rooms?{
            didSet{
                viewControllerTitle = roomData?.name ?? ""
                self.setImageSlider()
            }
        }
        
        private var firstDate: Date?
        private var lastDate: Date?
        var chaletID = ""
//        var chaletProduct : ChaletsDetailData? {
//            didSet {
//                topImg.sd_setImage(with: URL(string: chaletProduct?.product?.cover_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
//                viewControllerTitle = chaletProduct?.product?.name ?? ""
//            }
//        }
        var avalible  : [String]? {
            didSet {
                theTableView.delegate = self
                theTableView.dataSource = self
                theTableView.reloadData()
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            theTableView.isHidden = true
            type = .transperantBack
            registerXibs()
//            self.getChaletDetailsAPI()
//            self.getChaletAvaliableAPI()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            type = .transperantBack
            super.viewWillAppear(animated)
            getRoomDetailsAPI()
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            // navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        func registerXibs() {
            
            theTableView.register(UINib.init(nibName: "CalanderCell", bundle: nil), forCellReuseIdentifier: "CalanderCell")
            theTableView.register(UINib.init(nibName: "NextButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "NextButtonTableViewCell")
            theTableView.register(UINib.init(nibName: "AdultsAddTableViewCell", bundle: nil), forCellReuseIdentifier: "AdultsAddTableViewCell")
            
        }
        
        
        
        @IBAction func backPressed(_ sender: Any) {
            print("back")
            navigateBack()
        }
        
        func navigateBack(){
            if let _ = navigationController?.popViewController(animated: true) {
            } else {
                dismiss(animated: true, completion: nil)
                
            }
        }
        
        @IBAction func cartPressed(_ sender: Any) {
            print("cartPressed")
            //Coordinator.goToCheckOut(delegate: self)
        }
        
        func setImageSlider(){
            imagePageControl.numberOfPages = roomData?.content?.count ?? 0
            var localSource : [SDWebImageSource] = []
            var videoSource : [AVSource] = []
            
            if let gallery = roomData?.content {
                for single in gallery {
                    if let encodedURLString = single.content?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        if(single.contentType == "video"){
                            videoSource.append(AVSource(url: URL(string: encodedURLString)!, onAppear: .play))
                        }else{
                            localSource.append(SDWebImageSource(url: URL(string: encodedURLString)!,placeholder: UIImage(named: "placeholder_banner")))
                        }
                    }
                    
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

        
    }

    extension HotelDateTimeViewController:DateAndCalanderVMDelegate{
        
        func updateView(_ date: String) {
            navigateBack()
        }
    }


    // MARK: - UITableView Delegate & DataSource
    extension HotelDateTimeViewController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let sections = indexPath.section
            switch sections {
            case 0:
                guard let cell: CalanderCell = tableView.dequeueReusableCell(withIdentifier: "CalanderCell", for: indexPath) as? CalanderCell else { return UITableViewCell() }
                cell.avalible = avalible
                cell.isShowWeekDay = false
                cell.theCaldenderateDelegate = self
                cell.fsCalender()
                cell.didToggleCalenderView = { [weak self] in
                    guard let self = self else { return }
                    self.theTableView.beginUpdates()
                    self.theTableView.endUpdates()
                }
                cell.selectionStyle = .none
                return cell
            case 1:
                guard let cell: AdultsAddTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdultsAddTableViewCell", for: indexPath) as? AdultsAddTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
//                cell.btnBack.addTarget(self, action: #selector(btnNextFun(sender:)), for: .touchUpInside)
//                cell.btnNext.addTarget(self, action: #selector(btnBackFun(sender:)), for: .touchUpInside)
                cell.personCountDelegate = self
                return cell
                
            case 2:
                guard let cell: NextButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NextButtonTableViewCell", for: indexPath) as? NextButtonTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
//                cell.btnBack.addTarget(self, action: #selector(btnNextFun(sender:)), for: .touchUpInside)
                cell.btnNext.addTarget(self, action: #selector(btnNextFun(sender:)), for: .touchUpInside)
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        @objc func btnNextFun(sender: UIButton){
            if self.firstDate == nil {
                Utilities.showWarningAlert(message: "Please select date") {
                    
                }
            }else  if self.lastDate == nil {
                self.lastDate = Calendar.current.date(byAdding: .day, value: 1, to: self.firstDate ?? Date())!
                var start : String = dateFormatterMain.string(from:self.firstDate ?? Date())
                var end : String = dateFormatterMain.string(from:self.lastDate ?? Date())
                if SessionManager.isLoggedIn() {
                    self.saveBookingDatesAPI(firstDate: start, lastDate: end)
                }else {
                    Coordinator.presentLogin(viewController: self)
                }
            }else {
                self.lastDate = Calendar.current.date(byAdding: .day, value: 1, to: self.lastDate ?? Date())!
                var start : String = dateFormatterMain.string(from:self.firstDate ?? Date())
                var end : String = dateFormatterMain.string(from:self.lastDate ?? Date())
                if SessionManager.isLoggedIn() {
                   // Coordinator.goToChaletCart(controller: self,chaletID: self.chaletID,start_date_time: start,end_date_time: end)
                    self.saveBookingDatesAPI(firstDate: start, lastDate: end)
                }else {
                    Coordinator.presentLogin(viewController: self)
                }
            }
        }
     
        
    }
    extension HotelDateTimeViewController: CalanderCellDelegate {
        func setDate(firstDate: Date?, lastDate: Date?) {
            self.firstDate = firstDate
            self.lastDate = lastDate
        }
    }
extension HotelDateTimeViewController {
    func getRoomDetailsAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "room_id" : roomID
        ]
        StoreAPIManager.hotelBookingDateAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.roomData = result.oData?.room
                self.avalible = result.oData?.bookings ?? []
                self.theTableView.isHidden = false
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func saveBookingDatesAPI(firstDate:String, lastDate:String) {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "room_id":roomID,
            "start_date":firstDate,
            "end_date":lastDate,
            "adults":adultsCount,
            "children_above_two":childAboveCount,
            "children_below_two":childBelowCount,
            "room_count":roomCount
        ]
        print(#function,#line,parameters)
        StoreAPIManager.saveBookingDateAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                Coordinator.goToCompleteBooking(controller: self)
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension HotelDateTimeViewController: AdultsProtocol {
    func roomCount(count: String) {
        roomCount = count
    }
    
    func adultsCount(count: String) {
        adultsCount = count
    }
    
    func childAboveCount(count: String) {
        childAboveCount = count
    }
    
    func childsBelowCount(count: String) {
        childBelowCount = count
    }
    
    
}


extension HotelDateTimeViewController: MediaSlideshowDelegate {
    func mediaSlideshow(_ mediaSlideshow: MediaSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        self.imagePageControl.set(progress: page, animated: true)
    }
}
