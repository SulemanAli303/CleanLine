//
//  ProductCollectionViewCell.swift
//  LiveMArket
//
//  Created by Greeniitc on 19/04/23.
//

import UIKit
import SDWebImage

protocol AddtoFavoriteCellDelegate: AnyObject {
    func getProductDetailsCall()
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var cellBgView: UIView!
    
    weak var delegate : AddtoFavoriteCellDelegate?
    var baseVc :UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var shopData:Shop_products?{
        didSet{
            if let data = shopData{
                nameLabel.text = data.product_name ?? ""
                productImageView.sd_setImage(with: URL(string: data.inventory?.image.first ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
                
                ///Favourite
                if data.is_liked == "1"{
                    favoriteButton.setImage(UIImage(named: "filled-wish"), for: .normal)
                }else{
                    favoriteButton.setImage(UIImage(named: "add-wish"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func BtnFav(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: baseVc)
        }else {
            AddTOFav()
        }
    }
    
    func AddTOFav() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : shopData?.id ?? "",
            "product_attribute_id"  : shopData?.inventory?.productAttributeID ?? "",
        ]
        print(parameters)
        StoreAPIManager.productFavAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.getProductDetailsCall()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
}
