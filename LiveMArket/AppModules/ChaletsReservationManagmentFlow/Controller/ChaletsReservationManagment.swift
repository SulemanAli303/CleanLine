//
//  HotelReservationManagment.swift
//  LiveMArket
//
//  Created by Zain on 06/02/2023.
//
import UIKit

class ChaletsReservationManagment: BaseViewController {

    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var counterLbl: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        viewControllerTitle = "Jeddaha Wakan Villas"
        
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        setProductCell()
        counterLbl.layer.cornerRadius = 10
        counterLbl.layer.masksToBounds = true
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }

    
    @IBAction func menuPressed(_ sender: UIButton) {
        
        Coordinator.goToChaletsLIstDetails(controller: self)
        
    }
    @IBAction func OrderPressed(_ sender: UIButton) {
        Coordinator.goToChaletsReservedBooking(controller: self)
        
    }
    @IBAction func NewOrderPressed(_ sender: UIButton) {
      
        Coordinator.goToChaletsNewBooking(controller: self)
      
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
extension ChaletsReservationManagment: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
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


