//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit

class BookNowViewController: BaseViewController {
    
    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    
    
    
    var storeID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        
        setProductCell()
        
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func liveAction () {
        Coordinator.goToLive(controller: self)
    }
    @IBAction func menuPressed(_ sender: UIButton) {
         
        PlayGroundCoordinator.goToBookNowDetail(controller: self, store_ID: storeID)
    }
    func setProductCell() {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.register(UINib.init(nibName: "BookNowCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BookNowCollectionCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.productCollection.collectionViewLayout = layout
        
    }
    
}
extension BookNowViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookNowCollectionCell", for: indexPath) as? BookNowCollectionCell else
        { return UICollectionViewCell()
        }
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



