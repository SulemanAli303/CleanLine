//
//  popularHome.swift
//  HealthyWealthy
//
//  Created by Zain on 06/10/2022.
//

import UIKit

protocol AddtoCartCellDelegate: AnyObject {
    func getCartCall()
    func getShopDetails()
}

class AddtoCartCell: UICollectionViewCell {
    var baseVc :UIViewController?
    var viewProduct :UIView?
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var units: UILabel!
    @IBOutlet weak var Price: UILabel!
    weak var delegate : AddtoCartCellDelegate?
    
    var productList: ProductList? {
        didSet {
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData() {
        name.text = productList?.productName ?? ""
        units.text = "\(productList?.inventory.stockQuantity ?? "") \("Pieces".localiz())"
        Price.text =   "\("SAR".localiz()) \(productList?.inventory.salePrice ?? "")"
        if productList?.inventory.image.count ?? 0 > 0{
            img.sd_setImage(with: URL(string: productList?.inventory.image[0] ?? "" ), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
        }
        if productList?.isLiked == "1" {
            self.addToFavoriteButton.setImage(UIImage(named: "filled-wish"), for: .normal)
        }else {
            self.addToFavoriteButton.setImage(UIImage(named: "add-wish"), for: .normal)
        }
    }
    @IBAction func BtnAddtoCart(_ sender: Any) {
//        if !SessionManager.isLoggedIn() {
//            Coordinator.presentLogin(viewController: baseVc)
//        }else {
            AddToCart()
      //  }
    }
    @IBAction func BtnFav(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: baseVc)
        }else {
            AddTOFav()
        }
    }
    func AddToCart() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productList?.id ?? "",
            "product_variant_id"  : productList?.inventory.productAttributeID ?? "",
            "store_id" : productList?.storeID ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "quantity" : "1",
            "update_quantity" : "1"
        ]
        StoreAPIManager.addTOCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                let frame = CGRect(x:  self.frame.origin.x, y: self.viewProduct?.frame.origin.y ?? 0 + self.frame.origin.y , width: self.img.frame.size.width, height: self.img.frame.size.height)
                Utilities.addToCartAnimation(vc:  self.baseVc, frame: frame, image: self.img.image)
                self.delegate?.getCartCall()
            default:
                if result.status == "4" {
                    Utilities.showQuestionAlert(message: result.message ?? ""){
                        self.clearCart()
                    }
                }else {
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
    func AddTOFav() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productList?.id ?? "",
            "product_attribute_id"  : productList?.inventory.productAttributeID ?? "",
        ]
        print(parameters)
        StoreAPIManager.productFavAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.getShopDetails()
            default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
    
    func clearCart() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        StoreAPIManager.clearCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.AddToCart()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
