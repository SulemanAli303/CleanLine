//
//  popularHome.swift
//  HealthyWealthy
//
//  Created by Zain on 06/10/2022.
//

import UIKit

protocol ProductFavCellDelegate: AnyObject {
    func getCartCall()
    func getShopDetails()
    func getProductDetails()
    func getFoodDetails()
}

class ProductFavCell: UICollectionViewCell {
    var baseVc :UIViewController?
    var viewProduct :UIView?
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var units: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var loc: UILabel!
    @IBOutlet weak var PriceView: UIView!
    @IBOutlet weak var locationNameView: UIView!
    weak var delegate : ProductFavCellDelegate?
    
    var productList: ProductList? {
        didSet {
        }
    }
    var storeList: StoreFavList? {
        didSet {
        }
    }
    
    var foodList: FavList? {
        didSet {
        }
    }
    
    var chaletObj: ChaletsList? {
        didSet {
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addToCartBtn.setTitle("Add To Cart".localiz(), for: .normal)
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
    
    func setFoodData() {
        name.text = foodList?.product?.first?.product_name ?? ""
        //units.text = "\(foodList?.inventory.stockQuantity ?? "") Pieces"
        Price.text =   "\("SAR".localiz()) \(foodList?.product?.first?.sale_price ?? "")"
        img.sd_setImage(with: URL(string: foodList?.product?.first?.processed_default_image ?? "" ), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
        if foodList?.is_liked == "1" {
            self.addToFavoriteButton.setImage(UIImage(named: "filled-wish"), for: .normal)
        }else {
            self.addToFavoriteButton.setImage(UIImage(named: "add-wish"), for: .normal)
        }
    }
    
    func setChaletData() {
        name.text = chaletObj?.name ?? ""
        Price.text =   "\("SAR".localiz()) \(chaletObj?.price ?? "")"
        img.sd_setImage(with: URL(string: chaletObj?.primary_image ?? "" ), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
        self.addToFavoriteButton.setImage(UIImage(named: "filled-wish"), for: .normal)
    }
    
    func setData_store() {
        name.text = storeList?.name ?? ""
        loc.text = "\(storeList?.locationName ?? "" )"
        
        //if productList?.inventory.image.count ?? 0 > 0{
            img.sd_setImage(with: URL(string: storeList?.userImage ?? "" ), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
        //}
        if storeList?.isLiked == "1" {
            self.addToFavoriteButton.setImage(UIImage(named: "filled-wish"), for: .normal)
        }else {
            self.addToFavoriteButton.setImage(UIImage(named: "add-wish"), for: .normal)
        }
    }
    @IBAction func BtnAddtoCart(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: baseVc)
        }else {
            if productList != nil {
                AddToCart()
            }else if storeList != nil {
                AddTOFavStore()
            }
        }
    }
    @IBAction func BtnFav(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: baseVc)
        }else {
            if productList != nil {
                AddTOFav()
            }else if storeList != nil {
                AddTOFavStore()
            }else if foodList != nil{
                AddFoodFav(likeStatus: foodList?.is_liked ?? "")
            }
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
        print(parameters)
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
                self.delegate?.getProductDetails()
            default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
            }
        }
    }
    
    func AddFoodFav(likeStatus:String) {
        var like:String = ""
        if likeStatus == "1"{
            like = "0"
        }else{
            like = "1"
        }
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : foodList?.product_id ?? "",
            "like"  : like
        ]
        print(parameters)
        FoodAPIManager.productFavouriteAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.getFoodDetails()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {

                }
            }
        }
    }
    
    func AddTOFavStore() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "store_id" : self.storeList?.id ?? "",
        ]
        StoreAPIManager.storeFavAPI(parameters: parameters) { result in
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
