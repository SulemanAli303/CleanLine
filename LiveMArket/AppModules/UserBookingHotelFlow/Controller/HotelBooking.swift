
//
//  UserGymList.swift
//  LiveMArket
//
//  Created by Zain on 30/01/2023.
//

import UIKit

class HotelBooking: BaseViewController {
    
    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    
    var storeID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBackWithTwo
        viewControllerTitle = "Crown Palace"
        setProductCell()
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func liveAction () {
        Coordinator.goToLive(controller: self)
    }
    @IBAction func menuPressed(_ sender: UIButton) {
        ShopCoordinator.goToFoodShopProfileDetail(controller: self, resturantID: "")
       // Coordinator.goToSelectRoom(controller: self)
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
    }
}
extension HotelBooking: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else
        { return UICollectionViewCell()
        }
        cell.productImage.image = UIImage(named: "hotel_bg")
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
