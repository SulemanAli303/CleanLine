//
//  AddGymPackages.swift
//  LiveMArket
//
//  Created by Zain on 30/01/2023.
//

import UIKit

class ActiveSubscriptionViewController: BaseViewController {
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthView_3: UIView!
    @IBOutlet weak var monthView_6: UIView!
    
    //var imageArray = [UIImage(named: "visaPayment"),UIImage(named: "madaPayment"),UIImage(named: "PayPal"),UIImage(named: "ApplePayment"),UIImage(named: "Stc_Payment"),UIImage(named: "tamaraPayment")]
    var selectedIndex = 0
    var imageArray = [UIImage(named: "visaPayment"), UIImage(named: "ApplePayment"), UIImage(named: "Stc_Payment")]
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBackWithTwo
        viewControllerTitle = "Gold's Gym"
        reset()
       // scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        setPayCollectionCell()
    }
    override func liveAction () {
        Coordinator.goToLive(controller: self)
    }
    func setPayCollectionCell() {
        payCollection.delegate = self
        payCollection.dataSource = self
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.payCollection.collectionViewLayout = layout
        payCollection.reloadData()
        self.payCollection.layoutIfNeeded()
       
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    @IBAction func PlaceAction(_ sender: UIButton) {
        Coordinator.goToGymThanks(controller: self, id: "", subscriptionid: "")
    }
    @IBAction func MonthAction(_ sender: UIButton) {
        reset()
        monthView.backgroundColor = UIColor(hex: "FDCC76")
        Coordinator.goToServicProviderThank(controller: self, step: "1")
    }
    @IBAction func Month_3Action(_ sender: UIButton) {
        reset()
        monthView_3.backgroundColor = UIColor(hex: "FDCC76")
    }
    @IBAction func Month_6Action(_ sender: UIButton) {
        reset()
        monthView_6.backgroundColor = UIColor(hex: "FDCC76")
    }
    func reset() {
        monthView.backgroundColor = .clear
        monthView_3.backgroundColor = .clear
        monthView_6.backgroundColor = .clear
    }
}
extension ActiveSubscriptionViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imageArray.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodsCell", for: indexPath) as? PaymentMethodsCell else
            { return UICollectionViewCell()
            }
            
            cell.image.image = imageArray[indexPath.row]
            
            if indexPath.row == self.selectedIndex {
                cell.checkBoxBtn.setImage(UIImage(named: "Group 236139"), for: .normal)
            } else {
                cell.checkBoxBtn.setImage(UIImage(named: "Ellipse 1449"), for: .normal)
            }
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-70
            return CGSize(width: screenWidth/2.08, height:70)
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
        self.selectedIndex = indexPath.row
        self.payCollection.reloadData()
    }
}

