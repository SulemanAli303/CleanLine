//
//  ChaletsListCell.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit
import SDWebImage

class ChaletsListCell: UITableViewCell {
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bookNowView: UIView!
    @IBOutlet weak var collectionFacilitiesView: UICollectionView!
    var productData :  ChaletsList? {
        didSet {
            
        }
    }
    var currencyTxt = ""
    var base: UIViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func btnBookNow(_ sender: Any) {
        //Coordinator.goToCharletsRoom(controller: base,chaletID: self.productData?.id ?? "")
        Coordinator.goToChaletSetDate(controller: base,chaletId: self.productData?.id ?? "")
        
    }
    func setData() {
        productImg.sd_setImage(with: URL(string: productData?.primary_image ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        name.text = productData?.name ?? ""
        des.text = productData?.description ?? ""
        des.numberOfLines = 4
        currency.text = currencyTxt
        let priceVal = " \((Double(productData?.price ?? "")) ?? 0.0) / "
        let convertedString = productData?.price_type?.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
        
        let attributedString = NSMutableAttributedString(string: priceVal, attributes: [
            .font: UIFont(name: "Roboto-Bold", size: 22.0)!
        ])
        
        attributedString.append(NSAttributedString(string: convertedString, attributes: [
            .font: UIFont(name: "Roboto-Bold", size: 14.0)!,
            .baselineOffset: 0  // Adjust the offset to align the small text
        ]))
        
        price.attributedText = attributedString
        
        setFacilites()
    }
    func setFacilites() {
        collectionFacilitiesView.delegate = self
        collectionFacilitiesView.dataSource = self
        collectionFacilitiesView.register(UINib.init(nibName: "EventFaclitiesCell", bundle: nil), forCellWithReuseIdentifier: "EventFaclitiesCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        self.collectionFacilitiesView.collectionViewLayout = layout2
        collectionFacilitiesView.reloadData()
    }
    
}
extension ChaletsListCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productData?.facilities?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventFaclitiesCell", for: indexPath) as? EventFaclitiesCell else { return UICollectionViewCell() }
        
        cell.name.text! = self.productData?.facilities?[indexPath.row].name ?? ""
        cell.img.sd_setImage(with: URL(string: "\( self.productData?.facilities?[indexPath.row].icon ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
                label.text = self.productData?.facilities?[indexPath.row].name ?? ""
                label.sizeToFit()
        return CGSize(width: 72, height:85)
        
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
        
    }
}
