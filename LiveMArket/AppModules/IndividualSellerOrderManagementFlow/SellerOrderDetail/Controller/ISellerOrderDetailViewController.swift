//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit

class ISellerOrderDetailViewController: BaseViewController {
    
    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var CategotycollectionView: UICollectionView!
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    
    
    var optionsArray = [String]()
    var selectedIndex:Int = 0
    var selectedCategory  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        viewControllerTitle = "Olivia Stanford".localiz()
        
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        myImage.layer.cornerRadius = 165
        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        optionsArray.append("All (15)")
        optionsArray.append("Mobile (5)")
        optionsArray.append("Fashion (3)")
        
        setCategories()
        setProductCell()
        
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    func setProductCell() {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.register(UINib.init(nibName: "ISellerOrderDetailAddToCart", bundle: nil), forCellWithReuseIdentifier: "ISellerOrderDetailAddToCart")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.productCollection.collectionViewLayout = layout
        
    }
    func setCategories () {
        CategotycollectionView.delegate = self
        CategotycollectionView.dataSource = self
        CategotycollectionView.register(UINib.init(nibName: "SellerCategoryNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SellerCategoryNameCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.CategotycollectionView.collectionViewLayout = layout
        self.CategotycollectionView.reloadData()
        self.CategotycollectionView.layoutIfNeeded()
    }
}
extension ISellerOrderDetailViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CategotycollectionView
        {
            return optionsArray.count
            
        }else if collectionView == productCollection
        {
            return 12
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == CategotycollectionView
        {
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerCategoryNameCollectionViewCell", for: indexPath) as? SellerCategoryNameCollectionViewCell else { return UICollectionViewCell() }
            switch indexPath.row {
            case selectedIndex:
                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#333333")
                topCategoriesCell.namelbl.alpha = 1.0
            default:
                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#333333")
                topCategoriesCell.namelbl.alpha = 0.42
            }
            topCategoriesCell.namelbl.text = self.optionsArray[indexPath.row]
            topCategoriesCell.layoutSubviews()
            topCategoriesCell.layoutIfNeeded()
            
            return topCategoriesCell
        }else if collectionView == productCollection
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ISellerOrderDetailAddToCart", for: indexPath) as? ISellerOrderDetailAddToCart else
            { return UICollectionViewCell()
            
            }
            cell.addToCartBtn.addTarget(self, action: #selector(accept(_:)), for: .touchUpInside)

           
            return cell
        }
        
        return UICollectionViewCell()
    }
    @objc func accept(_ sender: Any?)
     {
         SellerOrderCoordinator.goToSellerBookingDetail(controller: self, orderId: "", isSeller: true, isThankYouPage:false)
     }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == CategotycollectionView {
            self.selectedIndex = indexPath.row
            if (self.selectedIndex) <= self.optionsArray.count {
                if (self.selectedIndex == 0){
                    self.selectedCategory = -1
                }else {
                    //  self.selectedCategory = self.PharmacyCategoryArray?[indexPath.row  - 1].id ?? 0
                }
                self.selectedIndex = indexPath.row
            }
            self.CategotycollectionView.reloadData()
        }
    }
}
extension ISellerOrderDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CategotycollectionView {
            
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerCategoryNameCollectionViewCell", for: indexPath) as? SellerCategoryNameCollectionViewCell else { return CGSize.zero}
            
            topCategoriesCell.namelbl.text = self.optionsArray[indexPath.row]
            topCategoriesCell.setNeedsLayout()
            topCategoriesCell.layoutIfNeeded()
            let size: CGSize = topCategoriesCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: size.width, height: 40)
        }else if collectionView == productCollection
        {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-20
            return CGSize(width: screenWidth/2, height:220)
        }
        
        return CGSize(width: 0, height: 0)
    }
}


