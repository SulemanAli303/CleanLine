//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit
import SDWebImage
import Cosmos
import ContextMenuSwift

class ShopProfileViewController: BaseViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var stackViewBottamConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookingATableView: UIView!
    @IBOutlet weak var liveIconImageView: UIImageView!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuButtonLabel: UILabel!
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var bookNowStackView: UIStackView!
    
    @IBOutlet weak var productCollection: UICollectionView!
    var storeID:String = ""
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var rateStarView: CosmosView!{
        didSet {
            rateStarView.settings.fillMode = .half
            rateStarView.settings.starMargin = 5
            rateStarView.settings.starSize = 20
            rateStarView.settings.minTouchRating = 0
        }
    }
    
    private var initialPageCount = 100
    var selectedPostID:String = ""
    var userData:User?
    var postCollectionArray : [PostCollection] = []
    var userTypeID:String = ""
    var activityID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = SessionManager.getUserData()
        setProductCell()
        setupLongGestureRecognizerOnCollection()
        bannerImageView.contentMode = .scaleAspectFill
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        type = .transperantBack
        getStoreDetailsAPI()
        setGradientBackground()
        navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    
    var storeData : StoreData? {
        didSet{
            
        }
    }
    
    var SellerData : SellerData? {
        didSet {
            
            print(SellerData?.user_image ?? "")
            viewControllerTitle = SellerData?.name ?? ""
            nameLbl.text = SellerData?.name ?? ""
            locLbl.text = SellerData?.user_location?.location_name ?? ""
            star.text = "\(SellerData?.rating ?? "")/\("5")"
            myImage.sd_setImage(with: URL(string: SellerData?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            bannerImageView.sd_setImage(with: URL(string: SellerData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            rateStarView.rating = Double(SellerData?.rating ?? "0") ?? 0
            userTypeID = SellerData?.user_type_id ?? ""
            activityID = SellerData?.activity_type_id ?? ""
            self.view.layoutIfNeeded()
            self.setMenuButtonIconsAndName()
            if SellerData?.isLive == "1"{
                liveIconImageView.isHidden = false
            }else{
                liveIconImageView.isHidden = true
            }
            
            if SellerData?.is_table_booking_available == "1"{
                self.bookingATableView.isHidden = false
            }else{
                self.bookingATableView.isHidden = true
            }
            self.getAllUserPosts()
        }
    }
//    @objc func showBlurbMessage(tapGesture: UITapGestureRecognizer) {
//        let location = (self.nameLbl.text?.count ?? 0)
//        if tapGesture.didTapAttributedTextInLabel(label: self.nameLbl, inRange: NSRange(location: location - 2, length: 1)) {
//
////            let alert = UIAlertController.createOkAlert(WithTitle: "", message: assessment.blurbDescription, okTitle: "Close")
////            self.present(alert, animated: true, completion: nil)
//        }
//    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.myView.bounds
        gradientLayer.cornerRadius = self.myView.bounds.width/2
        
        self.myView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        productCollection?.addGestureRecognizer(longPressedGesture)
        
    }
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let p = gestureRecognizer.location(in: productCollection)
        
        if let indexPath = productCollection?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
            if self.postCollectionArray[indexPath.row].postedUserId ?? "" == userData?.id ?? ""{
                guard let cell = productCollection.cellForItem(at: indexPath) else { return  }
                //let share = ContextMenuItemWithImage(title: "Share", image: #imageLiteral(resourceName: "Group 236131"))
                //let edit = "Edit"
                self.selectedPostID = self.postCollectionArray[indexPath.row].postId ?? ""
                let delete = "Delete".localiz()
                CM.MenuConstants.horizontalDirection = .right
                CM.items = [delete]
                CM.showMenu(viewTargeted:cell, delegate: self)
            }
        }
    }
    
    @IBAction func goToDinning(_ sender: UIButton) {
        
        if SessionManager.isLoggedIn() {
            if let sellerData = SellerData{
                Coordinator.goToTableDateAndTime(controller: self,data: sellerData)
            }
        }else {
            Coordinator.setRoot(controller: self)
        }
        
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if userTypeID == "1"{//COMMERCIAL CENTERS(SHOPS)
            if activityID == "12"{//Restaurant
                ShopCoordinator.goToFoodShopProfileDetail(controller: self,resturantID: storeID)
            }else{
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: storeID)
            }
            
        }else if userTypeID == "2"{//RESERVATIONS
            
            if activityID == "6"{//Chalets
                Coordinator.goToCharletsListVC(controller: self, venderID: storeID)
            }else if activityID == "16"{//Gym
                Coordinator.goToGymPackegesList(controller: self,id: storeID)
            }else if activityID == "4"{//Hotels
                Coordinator.goToRoomLIst(controller: self,store_id: storeID)
            }else if activityID == "24"{//Wedding Halls
                
            }else if activityID == "17"{//Playground
                PlayGroundCoordinator.goToBookNowDetail(controller: self, store_ID: storeID )
            }else{
                
            }
        }else if userTypeID == "3"{//INDIVIDUALS
            if activityID == "7"{//Car Repaire
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: storeID)
            }else if activityID == "12"{//Food store
                ShopCoordinator.goToFoodShopProfileDetail(controller: self,resturantID: storeID)
            }else if activityID == "6"{//Chalets
                Coordinator.goToCharletsListVC(controller: self, venderID: storeID)
            }else if activityID == "16"{//Gym
                Coordinator.goToGymPackegesList(controller: self,id: storeID)
            }else if activityID == "4"{//Hotels
                Coordinator.goToRoomLIst(controller: self,store_id: storeID)
            }else if activityID == "24"{//Wedding Halls
                
            }else if activityID == "17"{//Playground
                PlayGroundCoordinator.goToBookNowDetail(controller: self, store_ID: storeID )
            }else {//individuals
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: storeID)
                //SellerOrderCoordinator.goToIndividualSellerOrderDetail(controller: self)
            }
            
        }else if userTypeID == "4"{//SERVICES PROVIDERS
            Coordinator.goToAddServices(controller: self,serviceId: storeID)
        }else if userTypeID == "5"{
            if activityID == "5"{//Appartments
                
            }else if activityID == "2"{//Wedding Halls
                
            }else if activityID == "1"{//Sports Clubs
                
            }else{
                
            }
        }else if userTypeID == "6"{//DELIVERY REPRESENTATIVE
            if activityID == "8"{//Restaurants
                
            }else{
                
            }
        }else{
            
        }
        // }
    }
    
    func setMenuButtonIconsAndName(){
        
        self.bookNowStackView.isHidden = true
        self.menuStackView.isHidden = true
        
        if userTypeID == "1"{//COMMERCIAL CENTERS(SHOPS)
            if activityID == "11"{//Clothing
                self.menuStackView.isHidden = false
                self.menuButton.setImage(UIImage(named: "productICon"), for: .normal)
                self.menuButtonLabel.text = "Products".localiz()
            }else if activityID == "12"{//Restaurant
                self.menuStackView.isHidden = false
            }else if activityID == "13"{//Medicine
                self.bookNowStackView.isHidden = false
            }else if activityID == "14"{//Fruit Vegetable
                self.bookNowStackView.isHidden = false
                self.bookNowButton.setTitle("Menu".localiz(), for: .normal)
            }else if activityID == "9"{//Super Market
                self.menuStackView.isHidden = false
            }else if activityID == "23"{//CAFE
                self.menuStackView.isHidden = false
            }else if activityID == "10"{//Shoping
                self.menuStackView.isHidden = false
                self.menuButton.setImage(UIImage(named: "storeIcon"), for: .normal)
                self.menuButtonLabel.text = "Products".localiz()
            }else{
                self.menuStackView.isHidden = false
            }
            
        }else if userTypeID == "2"{//RESERVATIONS
            
            if activityID == "6"{//Chalets
                self.bookNowStackView.isHidden = false
            }else if activityID == "16"{//Gym
                self.bookNowStackView.isHidden = false
                self.bookNowButton.titleLabel?.textAlignment = .center
                self.bookNowButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14.0)
                self.bookNowButton.setTitle("Book Now".localiz(), for: .normal)
            }else if activityID == "4"{//Hotels
                self.menuStackView.isHidden = false
                self.menuButton.setImage(UIImage(named: "hotelIcon_Orange"), for: .normal)
                self.menuButtonLabel.text = "Room List".localiz()
            }else if activityID == "24"{//Wedding Halls
                self.bookNowStackView.isHidden = false
            }else if activityID == "17"{//Playground
                self.bookNowStackView.isHidden = false
            }else{
                
            }
        }else if userTypeID == "3"{//INDIVIDUALS
            if activityID == "7"{//Car Repaire
                
            }else if activityID == "12"{//Food store
                self.menuStackView.isHidden = false
            }else if activityID == "6"{//Chalets
                self.bookNowStackView.isHidden = false
            }else if activityID == "16"{//Gym
                self.bookNowStackView.isHidden = false
                self.bookNowButton.titleLabel?.textAlignment = .center
                self.bookNowButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14.0)
                self.bookNowButton.setTitle("Active Subscription".localiz(), for: .normal)
            }else if activityID == "4"{//Hotels
                self.menuStackView.isHidden = false
                self.menuButton.setImage(UIImage(named: "hotelIcon_Orange"), for: .normal)
                self.menuButtonLabel.text = "Room List".localiz()
            }else if activityID == "24"{//Wedding Halls
                self.bookNowStackView.isHidden = false
            }else if activityID == "17"{//Playground
                self.bookNowStackView.isHidden = false
            }else if activityID == "5"{//Appartments
                self.bookNowStackView.isHidden = false
            }else if activityID == "2"{//Wedding Halls
                self.bookNowStackView.isHidden = false
            }else if activityID == "1"{//Sports Clubs
                self.bookNowStackView.isHidden = false
            }else if activityID == "11"{//Clothing
                self.menuStackView.isHidden = false
                self.menuButton.setImage(UIImage(named: "productICon"), for: .normal)
                self.menuButtonLabel.text = "Products".localiz()
            }else if activityID == "13"{//Medicine
                self.bookNowStackView.isHidden = false
            }else if activityID == "14"{//Fruit Vegetable
                self.bookNowStackView.isHidden = false
                self.bookNowButton.setTitle("Menu", for: .normal)
            }else if activityID == "9"{//Super Market
                self.menuStackView.isHidden = false
            }else if activityID == "23"{//CAFE
                self.menuStackView.isHidden = false
            }else if activityID == "10"{//Shoping
                self.menuStackView.isHidden = false
                self.menuButton.setImage(UIImage(named: "storeIcon"), for: .normal)
                self.menuButtonLabel.text = "Products".localiz()
            }else{//individuals
                self.menuStackView.isHidden = false
                self.menuButton.setImage(UIImage(named: "productICon"), for: .normal)
                self.menuButtonLabel.text = "Products".localiz()
            }
            
        }else if userTypeID == "4"{//SERVICES PROVIDERS
            self.bookNowStackView.isHidden = false
        }else if userTypeID == "5"{
            if activityID == "5"{//Appartments
                self.bookNowStackView.isHidden = false
            }else if activityID == "2"{//Wedding Halls
                self.bookNowStackView.isHidden = false
            }else if activityID == "1"{//Sports Clubs
                self.bookNowStackView.isHidden = false
            }else{
                
            }
        }else if userTypeID == "6"{//DELIVERY REPRESENTATIVE
            if activityID == "8"{//Restaurants
                
            }else{
                self.menuStackView.isHidden = false
                self.menuButton.setImage(UIImage(named: "DeliveryRepresentiveIcon"), for: .normal)
                self.menuButtonLabel.text = "Details".localiz()
            }
        }else{
            
        }
    }
    
    func setProductCell() {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.register(UINib.init(nibName: "SellerOrderCell", bundle: nil), forCellWithReuseIdentifier: "SellerOrderCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.productCollection.collectionViewLayout = layout
        
    }
    
    @objc func openShare(linkString:String)  {
        let message = "Live Market"
        if let link = URL(string: linkString) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true)
        }
        
    }
    
    
    
    @IBAction func share(_ sender: UIButton) {
        if SessionManager.isLoggedIn() {
            //self.openShare(linkString: SellerData?.profile_url ?? "")
            if let obj = SellerData {
                self.createShareURL(id: obj.id ?? "", type: "profile", title: obj.name ?? "", image: obj.banner_image ?? "")
            }
            
        }else {
            Coordinator.setRoot(controller: self)
        }
    }
    @IBAction func openChatViewAction(_ sender: UIButton) {
        var lowerValue = ""
        var uppwerValue = ""
        if let firstUser = Int(SessionManager.getUserData()?.id ?? "0"), let secondUser = Int(SellerData?.id ?? "0") {
            if firstUser > secondUser {
                lowerValue = "\(secondUser)"
                uppwerValue = "\(firstUser)"
            } else {
                uppwerValue  = "\(secondUser)"
                lowerValue = "\(firstUser)"
            }
            let chatRoomId = "\(lowerValue)_\(uppwerValue)"
            Coordinator.goToChatDetails(delegate: self,user_id: SellerData?.id ?? "",user_name: SellerData?.name,userImgae: SellerData?.user_image ?? "", firebaseUserKey: SellerData?.firebase_user_key ?? "",roomId:chatRoomId)

        } else {
            Utilities.showSuccessAlert(message: "Invalid User Details".localiz())
        }

    }
    @IBAction func reviewPageNavigation(_ sender: UIButton) {
        //        self.tabBarController?.selectedIndex = 3
//        if storeData?.chat_open == "1"{
//            Coordinator.goToChatDetails(delegate: self,user_id: SellerData?.id ?? "",user_name: SellerData?.name,userImgae: SellerData?.user_image ?? "", firebaseUserKey: SellerData?.firebase_user_key ?? "")
//        }else{
//            Utilities.showWarningAlert(message: storeData?.chat_message ?? "") {
//
//            }
//        }
        
       // Coordinator.goToChatDetails(delegate: self,user_id: SellerData?.id ?? "",user_name: SellerData?.name,userImgae: SellerData?.user_image ?? "", firebaseUserKey: SellerData?.firebase_user_key ?? "")
        SellerOrderCoordinator.goToMyReviews(controller: self,store_id: SellerData?.id ?? "",isFromProfile: false)

//        if SessionManager.isLoggedIn() {
//            Coordinator.goToCommentsList(controller: self,postID: "",orderCount: 0,userID: SellerData?.id ?? "", onDone:{ })
//        }
    }
    
    @IBAction func reviewBtnAction(_ sender: UIButton) {
        SellerOrderCoordinator.goToMyReviews(controller: self,store_id: SellerData?.id ?? "",isFromProfile: false)
    }
    
    @IBAction func locationLabelAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Map".localiz(), message: "", preferredStyle: .alert)
        let appleAction = UIAlertAction(title: "Apple Map".localiz(), style: .default) { [self] (action) in
            let latt = SellerData?.user_location?.lattitude ?? ""
            let lngg = SellerData?.user_location?.longitude ?? ""
            self.navigateAppleMap(lat: latt, longi: lngg)
        }
        alertController.addAction(appleAction)
        let googleAction = UIAlertAction(title: "Google Map".localiz(), style: .default) { [self] (action) in
            let latt = SellerData?.user_location?.lattitude ?? ""
            let lngg = SellerData?.user_location?.longitude ?? ""
            self.navigateGoogleMap(lat: latt, longi: lngg)
        }
        alertController.addAction(googleAction)
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { (action) in
            print("Cancel tapped")
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
extension ShopProfileViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postCollectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerOrderCell", for: indexPath) as? SellerOrderCell else
        { return UICollectionViewCell()
        }
        cell.postData = self.postCollectionArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: screenWidth/3, height:145)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let  VC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
        VC.videoIndexPath = indexPath
        VC.postCollectionDummyArray = self.postCollectionArray
        VC.isFromProfile = true
        VC.isFromOtherProfile = true
        VC.delegate = self
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
}

extension ShopProfileViewController {
    func getStoreDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "seller_user_id" : storeID
        ]
        StoreAPIManager.storeDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.storeData = result.oData
                self.SellerData = result.oData?.sellerData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    func getAllUserPosts(){
        let parameter = ["userId": SellerData?.id ?? "",
                         "limitPerPage": initialPageCount] as [String : Any]
        print(parameter)
        self.postCollectionArray.removeAll()
        Utilities.showIndicatorView()
        let socket = SocketIOManager.sharedInstance
        socket.getUserPosts(request: parameter) {[weak self] dataArray in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                Utilities.hideIndicatorView()
            }
            
            guard self != nil else {return}
            //weakSelf.loading = false
            guard let dict = dataArray[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                
                if let decodedArray:FeedPost_Base = try? decoder.decode(FeedPost_Base.self, from: json){
                    print(decodedArray.postCollection ?? [])
                    self?.postCollectionArray = decodedArray.postCollection ?? []
                    self?.productCollection.reloadData()
                    
                }else{
                    
                }
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    func removePostAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "post_id" : self.selectedPostID
        ]
        print(parameters)
        StoreAPIManager.removePostAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getAllUserPosts()
                // self.SellerData = result.oData?.sellerData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension ShopProfileViewController : ContextMenuDelegate {
    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
        print("contextMenuDidSelect", item.title)
        if item.title == "Delete"{
            self.removePostAPI()
        }else{
            
        }
        return true
    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {
        print("contextMenuDidDeselect")
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("contextMenuDidAppear")
    }
    
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("contextMenuDidDisappear")
    }
    
}
extension ShopProfileViewController:PostListProtocol{
    func moveDiscoverController(hashTag: String) {
        Constants.shared.searchHashTagText = hashTag
        ShopCoordinator.goToResturantList(controller: self)
    }
}
