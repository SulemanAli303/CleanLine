//
//  UserGymList.swift
//  LiveMArket
//
//  Created by Zain on 30/01/2023.
//

import UIKit
import STRatingControl


class UserGymList: BaseViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingView: STRatingControl!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    
    var store_ID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        
        setProductCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        getStoreDetailsAPI()
    }
    var storeData : Store_details? {
        didSet {
            print(storeData)
            viewControllerTitle = storeData?.name ?? ""
            nameLabel.text = storeData?.name ?? ""
            locationLabel.text = storeData?.user_location?.location_name ?? ""
            rateLabel.text = storeData?.rating ?? ""
            bannerImageView.sd_setImage(with: URL(string: storeData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            profileImageView.sd_setImage(with: URL(string: storeData?.user_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            ratingView.rating = Int(storeData?.rating ?? "0") ?? 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func liveAction () {
        Coordinator.goToLive(controller: self)
    }
    @IBAction func menuPressed(_ sender: UIButton) {
        //Coordinator.goToGymSelectPackage(controller: self,store_id: self.storeData?.id ?? "")
        Coordinator.goToGymPackegesList(controller: self,id: storeData?.id ?? "")
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
       // self.tabBarController?.selectedIndex = 3
        Coordinator.goToChatDetails(delegate: self,user_id: storeData?.id ?? "",user_name: storeData?.name,userImgae: storeData?.user_image ?? "", firebaseUserKey: storeData?.firebase_user_key ?? "")
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.profileImageView.bounds
        gradientLayer.cornerRadius = self.profileImageView.bounds.width/2
        
        self.profileImageView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    //MARK: - API Calls
    
    func getStoreDetailsAPI() {
        let parameters:[String:String] = [
            "store_id" : store_ID
        ]
        print(parameters)
        FoodAPIManager.storeDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.storeData = result.oData?.store_details
                //self.categories = result.oData?.categories
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension UserGymList: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else
        { return UICollectionViewCell()
        }
        cell.productImage.image = UIImage(named: "Rectangle 2233")
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
    }
    
    
}
