//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit
import Cosmos

class UserServicesBooking: BaseViewController {
    
    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var rateStarView: CosmosView!{
        didSet{
            rateStarView.settings.fillMode = .half
        }
    }
    
    var store_id:String = ""
    
    
    var SellerData : SellerData? {
        didSet {
            viewControllerTitle = SellerData?.name ?? ""
            nameLbl.text = SellerData?.name ?? ""
            locLbl.text = SellerData?.user_location?.location_name ?? ""
            star.text = "\(SellerData?.rating ?? "")/0"
            myImage.sd_setImage(with: URL(string: SellerData?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            bannerImg.sd_setImage(with: URL(string: SellerData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "Path 321176"))
            rateStarView.rating = Double(SellerData?.rating ?? "0") ?? 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        self.getStoreDetailsAPI()
        bookNowButton.setTitle("BOOK NOW", for: .normal)
        setProductCell()
        
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        
        Coordinator.goToAddServices(controller: self,serviceId: self.SellerData?.id)
    }
    func setProductCell() {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.productCollection.collectionViewLayout = layout
        
    }
    @IBAction func share(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("OpenSahre"), object: nil)
    }
    @IBAction func chat(_ sender: UIButton) {
        Coordinator.goToChatDetails(delegate: self,user_id: SellerData?.id ?? "",firebaseUserKey: SellerData?.firebase_user_key ?? "")
       // self.tabBarController?.selectedIndex = 3
    }
}
extension UserServicesBooking: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else
        { return UICollectionViewCell()
        }
        cell.productImage.image = UIImage(named: "Rectangle 2226")
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
        
        Coordinator.updateRootVCToTab()
        // ShopCoordinator.goToReceivingOptions(controller: self)
        
    }
}

extension UserServicesBooking {
    func getStoreDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "seller_user_id" : store_id
        ]
        StoreAPIManager.storeDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.SellerData = result.oData?.sellerData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
