//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit
import SDWebImage
import Cosmos
import STRatingControl
import ContextMenuSwift

class ISellerOrderViewController: BaseViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var counterLbl: UILabel!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var rateStarView: STRatingControl!
    
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var storeID:String = ""
    var postCollectionArray : [PostCollection] = []
    private var initialPageCount = 100
    var selectedPostID:String = ""
    var userData:User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = SessionManager.getUserData()
        type = .transperantBack
        viewControllerTitle = ""
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        setProductCell()

        setupLongGestureRecognizerOnCollection()
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        let tabbar = tabBarController as? TabbarController
        //        tabbar?.hideTabBar()
        getStoreDetailsAPI()
        setGradientBackground()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        let tabbar = tabBarController as? TabbarController
        //        tabbar?.showTabBar()
    }
    override func backButtonAction() {
        if self.navigationController == nil{
            Coordinator.updateRootVCToTab()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
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
                let delete = "Delete"
                CM.MenuConstants.horizontalDirection = .right
                CM.items = [delete]
                CM.showMenu(viewTargeted:cell, delegate: self)
            }
        }
    }
    
    //MARK: - @IBAction
    @IBAction func chatButtonAction(_ sender: UIButton) {
        Coordinator.goToChatDetails(delegate: self,user_id: SellerData?.id ?? "",firebaseUserKey: SellerData?.firebase_user_key ?? "")
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        
        if SessionManager.isLoggedIn() {
            //self.openShare(linkString: SellerData?.profile_url ?? "")
            if let obj = SellerData {
                self.createShareURL(id: obj.id ?? "", type: "profile", title: obj.name ?? "", image: obj.banner_image ?? "")
            }
        }else {
            Coordinator.setRoot(controller: self)
        }
    }
    
    @IBAction func followingBtnDidTapped(_ sender: Any) {
        let  VC = AppStoryboard.ISellerOrder.instance.instantiateViewController(withIdentifier: "FollowingsViewController") as! FollowingsViewController
        VC.postUserID = storeID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func followerBtnDidTapped(_ sender: Any) {
        let  VC = AppStoryboard.ISellerOrder.instance.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
        VC.postUserID = storeID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    @IBAction func menuPressed(_ sender: UIButton) {
        
        SellerOrderCoordinator.goToIndividualSellerOrderDetail(controller: self)
    }
    @IBAction func OrderPressed(_ sender: UIButton) {
        
    }
    @IBAction func NewOrderPressed(_ sender: UIButton) {
        Coordinator.goToChatDetails(delegate: self,user_id: SellerData?.id ?? "",firebaseUserKey: SellerData?.firebase_user_key ?? "")
    //    SellerOrderCoordinator.goToNewOrder(controller: self,status: "")
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
        let message = "Live Market".localiz()
        if let link = URL(string: linkString) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true)
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
            rateStarView.rating = Int(Double(SellerData?.rating ?? "0") ?? 0)
            postCountLabel.text = SellerData?.post_count ?? "0"
            followersCountLabel.text = SellerData?.followers_count ?? "0"
            followingCountLabel.text = SellerData?.following_count ?? "0"
            self.getAllUserPosts()
            self.view.layoutIfNeeded()
        }
    }
    
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
}
extension ISellerOrderViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
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
        VC.postCollectionDummyArray = self.postCollectionArray
        VC.videoIndexPath = indexPath
        VC.isFromProfile = true
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
}

extension ISellerOrderViewController {
    func getStoreDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "seller_user_id" : storeID
        ]
        StoreAPIManager.storeDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.SellerData = result.oData?.sellerData
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
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


extension ISellerOrderViewController{
    
    func getAllUserPosts(completion:((Bool)->())? = nil){
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
                    completion?(true)
                }else{
                    completion?(false)
                }
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
    }
}
extension ISellerOrderViewController : ContextMenuDelegate {
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
