//
//  RoomListVC.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//

import UIKit
import STRatingControl

class RoomListVC: BaseViewController {
    @IBOutlet weak var scroller: UIScrollView!
    //@IBOutlet weak var slideshow: MediaSlideshow!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var rateStarView: STRatingControl!
    @IBOutlet weak var aboutLabel: UILabel!
    
    @IBOutlet weak var abooutView: UIView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favImg: UIImageView!
    
    var storeID:String = ""
    var roomsList : [Rooms] = []
    let videoSource = AVSource(
        url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!,
        onAppear: .play)
    let localSource = [BundleImageSource(imageString: "12"), BundleImageSource(imageString: "13"), BundleImageSource(imageString: "14"), BundleImageSource(imageString: "15")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        viewControllerTitle = ""
        myImage.layer.cornerRadius = 165
        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        abooutView.isHidden = true
        addressView.isHidden = true
        setData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let tabbar = tabBarController as? TabbarController{
            tabbar.showTabBar()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        type = .transperantBack
        super.viewWillAppear(animated)
        self.getHotelDetailsAPI()
//        let tabbar = tabBarController as? TabbarController
//        tabbar?.hideTabBar()
       // self.sliderShowSetup()
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    func setData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ReserveRoomCell", bundle: nil), forCellReuseIdentifier: "ReserveRoomCell")
        tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
//    func sliderShowSetup(){
//        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
//        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
//
//        slideshow.pageIndicator = UIPageControl.withSlideshowColors()
//
//
//        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
//        slideshow.activityIndicator = DefaultActivityIndicator()
//        slideshow.delegate = self
//
//
//        slideshow.setMediaSources([videoSource] + localSource)
//
////        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap()))
////        slideshow.addGestureRecognizer(recognizer)
//    }
    
//    @objc func didTap() {
//        let fullScreenController = slideshow.presentFullScreenController(from: self)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
//    }
    
    var roomData:RoomListData?{
        didSet{
            if let data = roomData{
                viewControllerTitle = data.hotel?.name ?? ""
                nameLbl.text = data.hotel?.name ?? ""
                locLbl.text = data.hotel?.user_location?.location_name ?? ""
                star.text = "\(data.hotel?.rating ?? "")/\("5")"
                myImage.sd_setImage(with: URL(string: data.hotel?.banner_image ?? ""), placeholderImage:UIImage(named: "placeholder_banner"))
                //bannerImageView.sd_setImage(with: URL(string: SellerData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
                rateStarView.rating = Int(data.hotel?.rating ?? "0") ?? 0
                self.roomsList = data.rooms ?? []
                self.tableView.reloadData()
                if let isLiked = data.hotel?.is_liked , isLiked == "1" {
                    self.favImg.image = UIImage(named: "liked")
                }else{
                    self.favImg.image = UIImage(named: "unliked")
                }
            }
        }
    }
    
    @IBAction func btnFav(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: self)
        }else {
            self.AddTOFav()
        }
    }
    @IBAction func fullViewOfImageAction(_ sender: UIButton) {
        let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
        VC.imageURLArray = [roomData?.hotel?.banner_image ?? ""]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    

}

// MARK: - TableviewDelegate
extension RoomListVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReserveRoomCell", for: indexPath) as! ReserveRoomCell
        cell.isBookingActive = roomData?.hotel?.hide_profile == "0"
        cell.base  = self
        cell.selectionStyle = .none
        cell.currency = roomData?.currency_code ?? ""
        cell.roomData = self.roomsList[indexPath.row]
        
        cell.facilityCollectionView.reloadData()
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Coordinator.goToBookNoww(controller: self, room_ID: self.roomsList[indexPath.row].id ?? "")
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
extension RoomListVC {
    func getHotelDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "hotel_id" : storeID
        ]
        StoreAPIManager.hotelRoomListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.roomData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func AddTOFav() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "store_id" : storeID,
        ]
        StoreAPIManager.storeFavAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getHotelDetailsAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
//    func getAllUserPosts(){
//        let parameter = ["userId": SellerData?.id ?? "",
//                         "limitPerPage": initialPageCount] as [String : Any]
//        print(parameter)
//        self.postCollectionArray.removeAll()
//        Utilities.showIndicatorView()
//        let socket = SocketIOManager.sharedInstance
//        socket.getUserPosts(request: parameter) {[weak self] dataArray in
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                Utilities.hideIndicatorView()
//            }
//
//            guard self != nil else {return}
//            //weakSelf.loading = false
//            guard let dict = dataArray[0] as? [String:Any] else {return}
//            do {
//                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
//                let decoder = JSONDecoder()
//
//                if let decodedArray:FeedPost_Base = try? decoder.decode(FeedPost_Base.self, from: json){
//                    print(decodedArray.postCollection ?? [])
//                    self?.postCollectionArray = decodedArray.postCollection ?? []
//                    self?.productCollection.reloadData()
//
//                }else{
//
//                }
//            } catch {
//                print(error.localizedDescription)
//
//            }
//        }
//    }
    
    
//    func removePostAPI() {
//        let parameters:[String:String] = [
//            "access_token" : SessionManager.getAccessToken() ?? "",
//            "post_id" : self.selectedPostID
//        ]
//        print(parameters)
//        StoreAPIManager.removePostAPI(parameters: parameters) { result in
//            switch result.status {
//            case "1":
//                self.getAllUserPosts()
//                // self.SellerData = result.oData?.sellerData
//                //self.categories = result.oData?.categories
//            default:
//                Utilities.showWarningAlert(message: result.message ?? "") {
//
//                }
//            }
//        }
//    }
}
extension RoomListVC:RoomListProtocol{
    func bookNowAction(room_id:String) {
        Coordinator.goToBookDateAndTime(controller: self, room_ID: room_id)
    }
    
}
extension RoomListVC: MediaSlideshowDelegate {
    func mediaSlideshow(_ mediaSlideshow: MediaSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
