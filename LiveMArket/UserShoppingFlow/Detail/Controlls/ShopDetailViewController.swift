//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit

class ShopDetailViewController: BaseViewController {
    
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
        viewControllerTitle = "Stuffed Zucchini"
        
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        myImage.clipsToBounds = true
        myImage.layer.cornerRadius = 170
        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        optionsArray.append("Starter (15)")
        optionsArray.append("Soup (5)")
        optionsArray.append("Tandoori (3)")
        
        setCategories()
        setProductCell()
        
    }
    func setProductCell() {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.register(UINib.init(nibName: "AddtoCartCell", bundle: nil), forCellWithReuseIdentifier: "AddtoCartCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.productCollection.collectionViewLayout = layout
        
    }
    func setCategories () {
        CategotycollectionView.delegate = self
        CategotycollectionView.dataSource = self
        CategotycollectionView.register(UINib.init(nibName: "CategoryNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryNameCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.CategotycollectionView.collectionViewLayout = layout
        self.CategotycollectionView.reloadData()
        self.CategotycollectionView.layoutIfNeeded()
    }
}
extension ShopDetailViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    
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
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryNameCollectionViewCell", for: indexPath) as? CategoryNameCollectionViewCell else { return UICollectionViewCell() }
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddtoCartCell", for: indexPath) as? AddtoCartCell else
            { return UICollectionViewCell()
            }
            return cell
        }
        
        return UICollectionViewCell()
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
extension ShopDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CategotycollectionView {
            
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryNameCollectionViewCell", for: indexPath) as? CategoryNameCollectionViewCell else { return CGSize.zero}
            
            topCategoriesCell.namelbl.text = self.optionsArray[indexPath.row]
            topCategoriesCell.setNeedsLayout()
            topCategoriesCell.layoutIfNeeded()
            let size: CGSize = topCategoriesCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: size.width, height: 40)
        }else if collectionView == productCollection
        {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-20
            return CGSize(width: screenWidth/2, height:214)
        }
        
        return CGSize(width: 0, height: 0)
    }
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
