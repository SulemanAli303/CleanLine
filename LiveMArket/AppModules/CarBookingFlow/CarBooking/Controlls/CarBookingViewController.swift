//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit

class CarBookingViewController: BaseViewController {

    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var counterLbl: UILabel!

    var storeID:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        viewControllerTitle = "Danial Alexandar"
        
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        setProductCell()
        counterLbl.layer.cornerRadius = 10
        counterLbl.layer.masksToBounds = true
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let tabbar = tabBarController as? TabbarController
//        tabbar?.hideTabBar()
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        let tabbar = tabBarController as? TabbarController
//        tabbar?.showTabBar()
//    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        
        Coordinator.goToCarBookingProfile(controller: self, VCtype: "car")
        
    }
    @IBAction func OrderPressed(_ sender: UIButton) {
        
        Coordinator.goToHotelNewBooking(controller: self)

    }
    @IBAction func NewOrderPressed(_ sender: UIButton) {
        
        Coordinator.goToDeliveryRequest(controller: self, step: "")

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
}
extension CarBookingViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerOrderCell", for: indexPath) as? SellerOrderCell else
            { return UICollectionViewCell()
            }
        cell.productImage.image = UIImage(named: "Rectangle 2229")
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

