//
//  FoodItemsCartTableViewCell.swift
//  LiveMArket
//
//  Created by Greeniitc on 06/05/23.
//


import UIKit
import SDWebImage

protocol FoodCartProductDelegate: AnyObject {
    func getCartCall()
}

class FoodItemsCartTableViewCell: UITableViewCell {
    var baseVc :UIViewController?
    weak var delegate : FoodCartProductDelegate?
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var orderQuantityLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet var addOnsStackView: UIStackView!
    @IBOutlet var quantityIncreaseDecreaseStackView: UIStackView!

    @IBOutlet var addOnLabel: PaddingLabel!
    enum CellType{
        case cart
        case orderDetail
        case driverOrderDetail
    }
    
    var productList: Cart_items? {
        didSet {
        }
    }
    
    var orderDetail: Products?
    var cellType: CellType?
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
        if cellType == .orderDetail || cellType == .driverOrderDetail{
            self.productName.text = orderDetail?.product_name
            productImg.sd_setImage(with: URL(string: orderDetail?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "product"))
            self.price.text = "SAR \(orderDetail?.price ?? "")"
            let quantityText = cellType == .driverOrderDetail ? "Products".localiz() : "Quantity".localiz()
            orderQuantityLabel.text = ("\(orderDetail?.quantity ?? "") \(quantityText)")
        }else {
            self.productName.text = productList?.product?.product_name ?? ""
            self.price.text = "\("SAR".localiz()) \(productList?.product?.sale_price ?? "")"
            self.quantity.text = "\(productList?.quantity ?? "")"
            productImg.sd_setImage(with: URL(string: productList?.product?.product_images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "product"))
        }
        quantityIncreaseDecreaseStackView.isHidden = (cellType == .orderDetail || cellType == .driverOrderDetail)
        orderQuantityLabel.isHidden = cellType == .cart 
        configAddOnsItems()
        
    }
    
    func configAddOnsItems(){
        addOnsStackView.removeAllArrangedSubviews()
        if cellType == .orderDetail || cellType == .driverOrderDetail {
            addOnsStackView.isHidden = orderDetail?.product_combo.count == 0
            addOnsLabel()
            for combo in orderDetail?.product_combo ?? [] {
                let paddingLabel = PaddingLabel()
                paddingLabel.text =  "\(combo.comboQuantity) X 1 \(combo.productItem.productName ?? "") (\("SAR".localiz()) \(combo.comboUnitPrice))"
                paddingLabel.font = AppFonts.regular.size(12)
                paddingLabel.textColor = .black
                paddingLabel.leftInset = 20
                addOnsStackView.addArrangedSubview(paddingLabel)
            }
            
        }else{
            addOnsStackView.isHidden = productList?.cart_combos?.count == 0
            addOnsLabel()
            for combo in productList?.cart_combos ?? [] {
                let paddingLabel = PaddingLabel()
                paddingLabel.text =  "\(combo.combo_quantity ?? "") X 1 \(combo.combo_item?.food_item?.product_name ?? "") (\(combo.combo_item?.currency_code ?? "SAR".localiz()) \(combo.combo_item?.extra_price ?? ""))"
                paddingLabel.font = AppFonts.regular.size(12)
                paddingLabel.textColor = .black
                paddingLabel.leftInset = 20
                addOnsStackView.addArrangedSubview(paddingLabel)
            }
        }
    }
    
    func addOnsLabel(){
        let paddingLabel = PaddingLabel()
        paddingLabel.text =  "Add Ons:".localiz()
        paddingLabel.font = AppFonts.bold.size(14)
        paddingLabel.textColor = .black
        paddingLabel.leftInset = 20
        addOnsStackView.addArrangedSubview(paddingLabel)
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
        var parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productList?.product_id ?? "",
            "store_id" : productList?.store_id ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "quantity" : "1",
            "update_quantity" : "1"
        ]
        if let addOns = UserDefaults.standard.value(forKey: "add_ons") as? [String : String] {
            parameters = parameters.merging(addOns) { (current, _) in current }
        }
        print(parameters)
        FoodAPIManager.addToCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.getCartCall()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
    
    func ReduceToCart() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "cart_id" : productList?.id ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        print(parameters)
        
        FoodAPIManager.reduceCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.delegate?.getCartCall()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}


extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
