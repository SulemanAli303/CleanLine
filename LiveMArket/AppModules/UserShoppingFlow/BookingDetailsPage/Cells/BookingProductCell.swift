//
//  BookingProductCell.swift
//  LiveMArket
//
//  Created by Zain on 18/01/2023.
//

import UIKit
import SDWebImage

protocol BookingProductDelegate: AnyObject {
    func getCartCall()
}

class BookingProductCell: UITableViewCell {
    var baseVc :UIViewController?
    weak var delegate : BookingProductDelegate?
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var sizeColorView: UIView!
    @IBOutlet weak var sizeVarientContainer: UIView!
    @IBOutlet weak var sizeValueLabel: UILabel!
    
    @IBOutlet weak var colorVarientContainer: UIView!
    @IBOutlet weak var colorValueView: UIView!
    @IBOutlet weak var colorValueLabel: UILabel!
    
    var productList: CartItem? {
        didSet {
        }
    }
    
    @IBOutlet weak var countView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    
    func setdate() {
        self.productName.text = productList?.productName ?? ""
        self.stock.text = "\(productList?.stockQuantity ?? "") \("Quantity".localiz())"
        self.price.text = "\("SAR".localiz()) \(productList?.salePrice ?? "")"
        self.quantity.text = "\(productList?.quantity ?? "")"
        
//        productImg.sd_setImage(with: URL(string: productList?.defaultImage ?? ""), placeholderImage: #imageLiteral(resourceName: "product"))
//        // Add Color/Size Variations info/ Adnan-27-03-24
//        if productList?.product_variations?.count ?? 0 == 2 {
//            //Get Size Attribute
//            let productSizeVariation = productList?.product_variations?.first
//            if let productSizeVariation {
//                sizeValueLabel.text = productSizeVariation.product_variation_attribute_value?.attribute_values ?? ""
//            }
//            
//            //Get Color Attribute
//            let productColorVariation = productList?.product_variations?.last
//            if let productColorVariation {
//                colorValueLabel.text = productColorVariation.product_variation_attribute_value?.attribute_values ?? ""
//                colorValueView.backgroundColor = UIColor.init(hex: productColorVariation.product_variation_attribute_value?.attribute_color ?? "")
//            }
//        } else if productList?.product_variations?.count ?? 0 == 1 {
//            let productVariation = productList?.product_variations?.first
//            if let productVariation {
//                // Check either it's size
//                if productVariation.attribute_id == "2" {
//                    sizeValueLabel.text = productVariation.product_variation_attribute_value?.attribute_values ?? ""
//                } else {
//                    //hide color variation
//                    sizeVarientContainer.isHidden = true
//                }
//                
//                // OR Color
//                if productVariation.attribute_id == "1" {
//                    colorValueLabel.text = productVariation.product_variation_attribute_value?.attribute_values ?? ""
//                    colorValueView.backgroundColor = UIColor.init(hex: productVariation.product_variation_attribute_value?.attribute_color ?? "")
//                } else {
//                    //hide size variation
//                    colorVarientContainer.isHidden = true
//                }
//            } else {
//                sizeColorView.isHidden = true
//            }
//        } else {
//            sizeColorView.isHidden = true
//        }
        
        
    }
    @IBAction func BtnAddtoCart(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: baseVc)
        }else {
            AddToCart()
        }
    }
    @IBAction func BtnReducetoCart(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: baseVc)
        }else {
            ReduceToCart()
        }
    }
    func AddToCart() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productList?.productID ?? "",
            "product_variant_id"  : productList?.productAttributeID ?? "",
            "store_id" : productList?.storeID ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "quantity" : "1",
            "update_quantity" : "1"
        ]
        StoreAPIManager.addTOCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.getCartCall()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.delegate?.getCartCall()
                }
            }
        }
    }
    
    func ReduceToCart() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productList?.productID ?? "",
            "product_variant_id"  : productList?.productAttributeID ?? "",
            "store_id" : productList?.storeID ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "quantity" : "1"
        ]
        StoreAPIManager.reduceCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.getCartCall()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.delegate?.getCartCall()
                }
            }
        }
    }
}
