//
//  CharletRoomDetails.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit
import STRatingControl

class BookNowVC: BaseViewController {
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var facilityCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var roomNumber: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var roomID:String = ""
    var facilityArray:[Facilities] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        viewControllerTitle = "Select Room".localiz()
        myImage.layer.cornerRadius = 165
        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionViewSetUp()
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let tabbar = tabBarController as? TabbarController
//        tabbar?.showTabBar()
        self.getRoomDetailsAPI()
    }
    
    func collectionViewSetUp(){
        facilityCollectionView.delegate = self
        facilityCollectionView.dataSource = self
        
        facilityCollectionView.register(UINib.init(nibName: "FacilityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FacilityCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = CGSize(width: 70, height: 60)
        self.facilityCollectionView.collectionViewLayout = layout
        self.facilityCollectionView.reloadData()
        self.facilityCollectionView.layoutIfNeeded()
    }
    
    var roomData:Rooms?{
        didSet{
            myImage.sd_setImage(with: URL(string: roomData?.primary_image ?? ""), placeholderImage:UIImage(named: "placeholder_profile"))
            facilityArray = roomData?.facilities ?? []
            priceLabel.text = roomData?.price ?? ""
            self.facilityCollectionView.reloadData()
            descriptionLabel.text = roomData?.description ?? ""
            roomNumber.text = roomData?.name ?? ""
        }
    }
    @IBAction func favoriteAction(_ sender: UIButton) {
    }
    
    @IBAction func bookNow(_ sender: UIButton) {
        Coordinator.goToBookDateAndTime(controller: self, room_ID: roomID)
    }
}

extension BookNowVC {
    func getRoomDetailsAPI() {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "room_id" : roomID
        ]
        StoreAPIManager.hotelRoomDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.roomData = result.oData?.room
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension BookNowVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.facilityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCollectionViewCell", for: indexPath) as? FacilityCollectionViewCell else { return UICollectionViewCell() }
        cell.iconImageView.sd_setImage(with: URL(string: facilityArray[indexPath.row].icon ?? ""), placeholderImage:UIImage(named: "placeholder_profile"))
        cell.nameLabel.text = facilityArray[indexPath.row].name ?? ""
        return cell
    }
}
