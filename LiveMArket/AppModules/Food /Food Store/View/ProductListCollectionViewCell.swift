//
//  ProductListCollectionViewCell.swift
//  LiveMArket
//
//  Created by Greeniitc on 05/05/23.
//

import UIKit
import FittedSheets



protocol AddToCartCellDelegate: AnyObject {
    func getCartCall()
    func getStoreDetails()
}

class ProductListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var unitView: UIView!
    var baseVc :UIViewController?
    var viewProduct :UIView?
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var units: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var addtofavoriteButton: UIButton!
   
    weak var delegate : AddToCartCellDelegate?

    var addOns:[String:String] = [:]


    override func awakeFromNib() {
        super.awakeFromNib()
        addToCartBtn.setTitle("Add To Cart".localiz(), for: .normal)
    }
    
    var productList: Menus? {
        didSet {
        }
    }
    var currencyType: String? {
        didSet {
        }
    }
    
    
    func setData() {
        name.text = productList?.product_name ?? ""
        if productList?.pieces ?? "" == "0"{
            unitView.isHidden = true
        }else{
            unitView.isHidden = false
            units.text = "\(productList?.pieces ?? "") \("Pieces".localiz())"
        }
        
        Price.text =   "\(currencyType ?? "") \(productList?.sale_price ?? "")"
        if productList?.product_images?.count ?? 0 > 0{
            img.sd_setImage(with: URL(string: productList?.product_images?[0] ?? "" ), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
        }
        
        if productList?.isLiked == "1" {
            self.addtofavoriteButton.setImage(UIImage(named: "filled-wish"), for: .normal)
        }else {
            self.addtofavoriteButton.setImage(UIImage(named: "add-wish"), for: .normal)
        }
    }
    @IBAction func BtnAddtoCart(_ sender: Any) {
//        if !SessionManager.isLoggedIn() {
//            Coordinator.presentLogin(viewController: baseVc)
//        }else {
        if self.productList?.product_combo?.isEmpty  ?? false{
            AddToCart(addOns: [:])
        } else {
            showCompletedPopupWithHomeButtonOnly()
        }
      //  }
    }
    @IBAction func BtnFav(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: baseVc)
        }else {
            AddTOFav(likeStatus: productList?.isLiked ?? "0")
        }
    }

    func AddToCart(addOns:[String:String]) {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productList?.id ?? "",
            "store_id" : productList?.store_id ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "quantity" : "1",
            "update_quantity" : "1"
        ]

        let result1 = parameters.merging(addOns) { (current, _) in current }

        print(result1)
        FoodAPIManager.addToCartAPI(parameters: result1) { result in
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
    
    func AddTOFav(likeStatus:String) {
        var like:String = ""
        if likeStatus == "1"{
            like = "0"
        }else{
            like = "1"
        }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productList?.id ?? "",
            "like"  : like
        ]
        print(parameters)
        FoodAPIManager.productFavouriteAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.getStoreDetails()
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
        StoreAPIManager.clearCartFoodAPI(parameters: parameters) { result in
            switch result.status {
            case "1":

                    DispatchQueue.main.async {
                        if self.productList?.product_combo?.isEmpty  ?? false{
                            UserDefaults.standard.set(self.addOns, forKey: "add_ons")
                            self.AddToCart(addOns: self.addOns)

                        } else {
                            self.showCompletedPopupWithHomeButtonOnly()
                        }
                    }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }

    func showCompletedPopupWithHomeButtonOnly(){

            let  controller =  AppStoryboard.AddOnSB.instance.instantiateViewController(withIdentifier: "AddOnViewController") as! AddOnViewController
                //controller.delegate = viewcontroller as! any SuccessProtocol
            controller.product_combo = self.productList?.product_combo ?? []
            controller.currencyCode = currencyType ?? ""
            let sheet = SheetViewController(
                controller: controller,
                sizes: [.fullscreen],
                options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
            sheet.minimumSpaceAbovePullBar = 0
            sheet.dismissOnOverlayTap = false
            sheet.dismissOnPull = false
            sheet.contentBackgroundColor = UIColor.black.withAlphaComponent(0.5)
            controller.didTapOnContinueButton = { addOns in
                self.addOns = addOns
                self.AddToCart(addOns: addOns)
                controller.dismiss(animated: true)
            }
            baseVc?.present(sheet, animated: true, completion: nil)
    }


}
