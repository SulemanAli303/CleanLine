//
//  ProductDetailsViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 18/04/23.
//

import UIKit

import SDWebImage
import Cosmos
import ImageSlideshow
import FittedSheets

class ProductDetailsViewController: BaseViewController {
    
    @IBOutlet weak var foodDes: UILabel!
    @IBOutlet weak var vegImg: UIImageView!
    @IBOutlet weak var YouMaylike: UIView!
    @IBOutlet weak var sizeChartButton: UIButton!
    @IBOutlet weak var topBlackgradientView: UIImageView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var addToCartStackView: UIStackView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var colorVarientView: UIView!
    @IBOutlet weak var sizeVarientView: UIView!
    @IBOutlet weak var varientStackView: UIStackView!
    @IBOutlet weak var colorVarientLabel: UILabel!
    @IBOutlet weak var sizeVarientLabel: UILabel!
    @IBOutlet weak var productCollectionViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var addCountStackView: UIStackView!
    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var CategotycollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var sizesCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UIView!
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var subNameLbl: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var rateStarView: CosmosView!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var AddToCartCounter: UIView!
    
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterLbl: UILabel!
    
    @IBOutlet weak var sliderView: ImageSlideshow!
    @IBOutlet weak var addCartButton: UIButton!
    
    var localSource : [AlamofireSource] = []
    var productID:String = ""
    var step = ""
    var varientAttributeDict:[String:String] = [:]
    var itemCount:Int = 1
    var defaultAttributevalue:String = ""
    var isFood = false
    var addOns:[String:String] = [:]
    
    var product_Details: ProductDetailsData?{
        didSet{
            print(product_Details?.product_name ?? "")
            self.configerSlider(imageArray: product_Details?.product_images ?? [])
            viewControllerTitle = product_Details?.product_name ?? ""
            subNameLbl.text = (product_Details?.currency_code ?? "") + " " + (product_Details?.sale_price ?? "")
            nameLbl.text = product_Details?.product_name ?? ""
            locLbl.text = product_Details?.product_desc ?? ""
            star.text = "\(product_Details?.rating ?? "") \("Star Ratings".localiz())"
            myImage.sd_setImage(with: URL(string: product_Details?.product_images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            rateStarView.rating = Double(product_Details?.rating ?? "0") ?? 0
            ///Favorite code
            if product_Details?.is_liked == "1"{
                favoriteImageView.image = UIImage(named: "liked")
            }else{
                favoriteImageView.image = UIImage(named: "unliked")
            }
            
            ///Size chart code
            if product_Details?.size_chart == ""{
                sizeChartButton.isHidden = true
            }else{
                sizeChartButton.isHidden = false
            }
            self.getCartAPI()
        }
    }
    
    var shopProducts:[Shop_products]?{
        didSet{
            print(shopProducts ?? [])
            self.productCollection.reloadData()
            if self.shopProducts?.count ?? 0 > 0{
                self.productCollectionViewHeightConstarint.constant = CGFloat(((self.shopProducts?.count ?? 0)/2) * 280)
            }
        }
    }
    var productVarient: [Product_variations]?{
        didSet{
            print(productVarient ?? [])
            if productVarient?.count ?? 0 > 0{
                self.varientStackView.isHidden = false
                if productVarient?.count == 1{
                    
                    if productVarient?.first?.attribute_name ?? "" == "size"{
                        self.colorVarientView.isHidden = true
                        self.sizeVarientView.isHidden = false
                        self.sizeVarientLabel.text = productVarient?.first?.attribute_name ?? ""
                    }else{
                        self.sizeVarientView.isHidden = true
                        self.colorVarientView.isHidden = false
                        self.colorVarientLabel.text = productVarient?.first?.attribute_name ?? ""
                    }
                }else {
                    self.sizeVarientLabel.text = productVarient?.first?.attribute_name ?? ""
                    self.colorVarientLabel.text = productVarient?.last?.attribute_name ?? ""
                    
                }
            }else{
                self.varientStackView.isHidden = true
            }
            self.sizesCollectionView.reloadData()
            self.colorCollectionView.reloadData()
            
        }
    }
    
    var productList: [ProductList]? {
        didSet {
            self.setProductCell()
        }
    }
    var foodData:FoodProductData?{
        didSet{
            print("sdsdsd")
            viewControllerTitle = foodData?.product_details?.product_name ?? ""
            nameLbl.text = foodData?.product_details?.product_name ?? ""
            subNameLbl.text = "\(foodData?.currency_code ?? "") \(foodData?.product_details?.sale_price ?? "")"
            locLbl.text = "\(foodData?.product_details?.pieces ?? "") Pieces"
            foodDes.text = foodData?.product_details?.description ?? ""
            myImage.sd_setImage(with: URL(string: foodData?.product_details?.default_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            //myImage.sd_setImage(with: URL(string: foodData?.product_details?.product_images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            self.configerSlider(imageArray: foodData?.product_details?.product_images ?? [])
            
            if foodData?.product_details?.isLiked == "1"{
                favoriteImageView.image = UIImage(named: "liked")
            }else{
                favoriteImageView.image = UIImage(named: "unliked")
            }
            self.vegImg.isHidden = false
            if foodData?.product_details?.is_veg == "1"{
                self.vegImg.image = UIImage(named: "veg")
            }else{
                self.vegImg.image = UIImage(named: "non-veg")
            }
            
            
            self.getCartAPI()
        }
    }
    
    var Foodcart: FoodCartData? {
        didSet {
            
            if (Int(self.Foodcart?.cart_count ?? "") ?? 0) > 0 {
                self.cartView.layer.add(cartHearBeatAnimationGroup, forKey: "pulse")
                self.counterView.isHidden = false
                self.counterLbl.isHidden = false
                self.counterLbl.text = self.Foodcart?.cart_count ?? ""
                
                var isfound = false
                for item in self.cart?.cartItems ?? [] {
                    if item.productID  == self.foodData?.product_details?.id {
                        //self.addToCartStackView.isHidden = true
                        isfound = true
                        // self.itemCountLabel.text = "\(item.quantity)"
                        // self.itemCount = Int(item.quantity ) ?? 1
                        break
                    }
                }
                if isfound {
                    //self.AddToCartCounter.isHidden = false
                    // self.addToCartStackView.isHidden = true
                    if self.shopProducts?.count ?? 0 > 0{
                        self.productCollectionViewHeightConstarint.constant = CGFloat(((self.shopProducts?.count ?? 0)/2) * 280)
                    }
                }else {
                    // self.AddToCartCounter.isHidden = true
                }
            }else {
                //self.AddToCartCounter.isHidden = true
                self.counterView.isHidden = true
                self.counterLbl.isHidden = true
            }
        }
    }
    var cart: CartData? {
        didSet {
            
            if (Int(self.cart?.cartCount ?? "") ?? 0) > 0 {
                self.cartView.layer.add(cartHearBeatAnimationGroup, forKey: "pulse")
                self.counterView.isHidden = false
                self.counterLbl.isHidden = false
                self.counterLbl.text = self.cart?.cartCount ?? ""
                
                var isfound = false
                for item in self.cart?.cartItems ?? [] {
                    if item.productID  == self.product_Details?.product_id {
                        //self.addToCartStackView.isHidden = true
                        isfound = true
                        // self.itemCountLabel.text = "\(item.quantity)"
                        // self.itemCount = Int(item.quantity ) ?? 1
                        break
                    }
                }
                if isfound {
                    //self.AddToCartCounter.isHidden = false
                    // self.addToCartStackView.isHidden = true
                    if self.shopProducts?.count ?? 0 > 0{
                        self.productCollectionViewHeightConstarint.constant = CGFloat(((self.shopProducts?.count ?? 0)/2) * 280)
                    }
                }else {
                    // self.AddToCartCounter.isHidden = true
                }
            }else {
                //self.AddToCartCounter.isHidden = true
                self.counterView.isHidden = true
                self.counterLbl.isHidden = true
            }
            
        }
    }
    
    let cartHearBeatAnimationGroup: CAAnimationGroup = {
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8
        
        let group = CAAnimationGroup()
        group.duration = 2.7
        group.repeatCount = 1
        group.animations = [pulse1]
        return group
        
    }()
    var optionsArray = [String]()
    var selectedIndex:Int = 0
    var selectedCategory  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
        sizeChartButton.setTitle("Size Chart".localiz(), for: .normal)
        addCartButton.setTitle("Add to Cart".localiz(), for: .normal)
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        //        myImage.layer.cornerRadius = 165
        //        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        //        sliderView.layer.cornerRadius = 165
        //        sliderView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        addCountStackView.layer.cornerRadius = 10
        
        self.setSizeCell()
        self.setColorCell()
        
        self.setProductCell()
        
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemCountLabel.text = "\(itemCount)"
        if isFood == false {
            self.vegImg.isHidden = true
            self.getProductDetailsAPI()
        }else {
            self.vegImg.isHidden = true
            self.YouMaylike.isHidden = true
            self.varientStackView.isHidden = true
            self.getFoodProductDetailsAPI()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    func setProductCell() {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.register(UINib.init(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.productCollection.collectionViewLayout = layout
        
    }
    
    func setColorCell() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.register(UINib.init(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 23
        self.colorCollectionView.collectionViewLayout = layout
        
    }
    
    func setSizeCell() {
        sizesCollectionView.delegate = self
        sizesCollectionView.dataSource = self
        sizesCollectionView.register(UINib.init(nibName: "SizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        self.sizesCollectionView.collectionViewLayout = layout
        
    }
    /// Image Slider
    /// - Parameter imageArray: image array
    func configerSlider(imageArray:[String]) {
        localSource.removeAll()
        for imageUrl in imageArray {
            if let url = URL(string: imageUrl){
                localSource.append(contentsOf: [AlamofireSource(url: url, placeholder: UIImage(named: ""))])
            }
        }
        sliderView.slideshowInterval = 3.0
        sliderView.zoomEnabled = false
        // sliderView.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 5))
        sliderView.contentScaleMode = UIViewContentMode.scaleAspectFill
        //sliderView.activityIndicator = DefaultActivityIndicator()
        sliderView.setImageInputs(localSource)
    }
    
    /// Dictionary to String
    /// - Returns: converted string
    func dictionaryToString() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: varientAttributeDict, options:[])
            return String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
        } catch let error {
            print(error.localizedDescription)
            return ""
        }
    }
    @IBAction func minusButton(_ sender: Any) {
        /*
         if !SessionManager.isLoggedIn() {
         Coordinator.presentLogin(viewController: self)
         }else {
         ReduceToCart()
         }*/
        
        if self.itemCount == 1{
            
        }else{
            self.itemCount = self.itemCount - 1
            self.itemCountLabel.text = "\(self.itemCount)"
        }
        
    }
    @IBAction func plusButton(_ sender: Any) {
        /*
         if !SessionManager.isLoggedIn() {
         Coordinator.presentLogin(viewController: self)
         }else {
         self.PlusCart()
         }*/
        
        self.itemCount = self.itemCount + 1
        self.itemCountLabel.text = "\(self.itemCount)"
    }
    
    @IBAction func addToCart(_ sender: Any) {
        //        if !SessionManager.isLoggedIn() {
        //            Coordinator.presentLogin(viewController: self)
        //        }else {

        if self.isFood {
            if self.foodData?.product_details?.product_combo.isEmpty  ?? false {
                addToCartAPI(addOns: [:])
            } else {
                showCompletedPopupWithHomeButtonOnly()
            }
        } else {
            self.addToCartAPI(addOns: [:])
        }
        //  }
        
    }
    
    func showCompletedPopupWithHomeButtonOnly(){

        let  controller =  AppStoryboard.AddOnSB.instance.instantiateViewController(withIdentifier: "AddOnViewController") as! AddOnViewController
            //controller.delegate = viewcontroller as! any SuccessProtocol
        controller.product_combo = self.foodData?.product_details?.product_combo ?? []
        controller.currencyCode = self.foodData?.currency_code ?? ""
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
            self.addToCartAPI(addOns: addOns)
            controller.dismiss(animated: true)
        }
        self.present(sheet, animated: true, completion: nil)
    }

    @IBAction func sizeChartAction(_ sender: Any) {
        
        let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        VC.urlString = product_Details?.size_chart ?? ""
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func btnGoToCart(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: self)
        }else {
            if self.isFood {
                if (Int(self.Foodcart?.cart_count ?? "") ?? 0) > 0 {
                    ShopCoordinator.goToFoodCart(controller: self, isSelected: false,storeID: product_Details?.store_id ?? "")
                }else {
                    
                }
            }else {
                if (Int(self.cart?.cartCount ?? "") ?? 0) > 0 {
                    ShopCoordinator.goToCart(controller: self, isSelected: false)
                }else {
                    
                }
            }
        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: self)
        }else {
            self.productFavoriteAPI()
        }
    }
    
    @IBAction func fullViewOfImageAction(_ sender: UIButton) {
        if isFood {
            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
            VC.imageURLArray = self.foodData?.product_details?.product_images ?? []
            self.present(VC, animated: true)
        }else {
            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
            VC.imageURLArray = product_Details?.product_images ?? []
            self.present(VC, animated: true)
        }
    }
    
}
extension ProductDetailsViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollection
        {
            (shopProducts?.count ?? 0) == 0 ? (productCollection.setEmptyView(title: "", message: "No Record Found".localiz(), image: nil, msgLblTextColor: .black)) : (collectionView.restore())
            return shopProducts?.count ?? 0
        }else if collectionView == sizesCollectionView
        {
            
            return productVarient?.first?.attribute_values?.count ?? 0
        }else if collectionView == colorCollectionView
        {
            
            return productVarient?.last?.attribute_values?.count ?? 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == productCollection
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else
            { return UICollectionViewCell()
                
            }
            cell.baseVc = self
            cell.delegate = self
            cell.favoriteButton.tag = indexPath.row
            cell.shopData = self.shopProducts?[indexPath.row]
            cell.priceLabel.text = (product_Details?.currency_code ?? "") + " " + (self.shopProducts?[indexPath.row].inventory?.salePrice ?? "")
            return cell
        }else if collectionView == colorCollectionView
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as? ColorCollectionViewCell else
            { return UICollectionViewCell()}
            cell.nameLabel.text = self.productVarient?.last?.attribute_values?[indexPath.row].attribute_value_name
            cell.colorView.backgroundColor = UIColor(hexString: self.productVarient?.last?.attribute_values?[indexPath.row].attribute_value_color ?? "")
            if self.productVarient?.last?.attribute_values?[indexPath.row].is_selected ?? "" == "1"{
                cell.colorView.borderWidth = 1
                cell.colorView.borderColor =  Color.darkOrange.color()
                varientAttributeDict["\(self.productVarient?.last?.attribute_id ?? "")"] = self.productVarient?.last?.attribute_values?[indexPath.row].attribute_value_id ?? ""
                cell.nameLabel.textColor = Color.darkOrange.color()
            }else{
                cell.colorView.borderWidth = 1
                cell.colorView.borderColor = .black
                cell.nameLabel.textColor = .black
            }
            return cell
        }else if collectionView == sizesCollectionView
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell else
            { return UICollectionViewCell()
                
            }
            cell.nameLabel.text = self.productVarient?.first?.attribute_values?[indexPath.row].attribute_value_name ?? ""
            if self.productVarient?.first?.attribute_values?[indexPath.row].is_selected ?? "" == "1"{
                cell.nameLabel.borderWidth = 1
                cell.nameLabel.borderColor = Color.darkOrange.color()
                cell.nameLabel.textColor = Color.darkOrange.color()
                varientAttributeDict["\(self.productVarient?.first?.attribute_id ?? "")"] = self.productVarient?.first?.attribute_values?[indexPath.row].attribute_value_id ?? ""
            }else{
                cell.nameLabel.borderWidth = 1
                cell.nameLabel.borderColor = .black
                cell.nameLabel.textColor = .black
            }
            cell.nameLabel.layer.cornerRadius = 5
            return cell
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sizesCollectionView{
            defaultAttributevalue = ""
            print(varientAttributeDict)
            varientAttributeDict["\(self.productVarient?.first?.attribute_id ?? "")"] = self.productVarient?.first?.attribute_values?[indexPath.row].attribute_value_id ?? ""
            print(varientAttributeDict)
            getProductDetailsAPI()
        }else if collectionView == colorCollectionView{
            defaultAttributevalue = ""
            varientAttributeDict["\(self.productVarient?.last?.attribute_id ?? "")"] = self.productVarient?.last?.attribute_values?[indexPath.row].attribute_value_id ?? ""
            print(varientAttributeDict)
            getProductDetailsAPI()
        }else if collectionView == productCollection{
            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            VC.productID = shopProducts?[indexPath.item].id ?? ""
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
}
extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == productCollection
        {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-20
            return CGSize(width: screenWidth/2, height:230)
        }else if collectionView == sizesCollectionView
        {
            return CGSize(width: 65, height:40)
        }else if collectionView == colorCollectionView
        {
            return CGSize(width: 44, height:65)
        }
        
        return CGSize(width: 0, height: 0)
    }
}



extension UIView {
    func roundCornersNew(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension ProductDetailsViewController {
    func getProductDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productID,
            "sattr":dictionaryToString(),
            "product_variant_id":defaultAttributevalue
        ]
        print(parameters)
        StoreAPIManager.shopProductDetailsAPI(parameters: parameters) { result in
            switch result.status{
            case "1" :
                self.product_Details = result.oData
                self.shopProducts    = result.oData?.shop_products
                self.productVarient  = result.oData?.product_variations
            default:
                Utilities.showWarningAlert(message: result.message ?? ""){
                    
                }
            }
        }
    }
    
    func productFavoriteAPI() {
        if self.isFood {
            var like:String = ""
            if self.foodData?.product_details?.isLiked == "1"{
                like = "0"
            }else{
                like = "1"
            }
            
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "product_id" : self.foodData?.product_details?.id ?? "",
                "like"  : like
            ]
            print(parameters)
            FoodAPIManager.productFavouriteAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.getFoodProductDetailsAPI()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "product_id" : productID,
                "product_attribute_id"  : product_Details?.product_variant_id ?? ""
            ]
            print(parameters)
            StoreAPIManager.productFavAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.getProductDetailsAPI()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
    func addToCartAPI(addOns:[String:String]) {
        if self.isFood {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "product_id" : self.foodData?.product_details?.id ?? "",
                "store_id" : self.foodData?.product_details?.store_id ?? "",
                "device_cart_id" : SessionManager.getCartId() ?? "",
                "quantity" : "\(self.itemCount)",
            ]
            let result1 = parameters.merging(addOns) { (current, _) in current }
            print(parameters)
            FoodAPIManager.addToCartAPI(parameters: result1) { result in
                switch result.status {
                case "1":
                    let frame = CGRect(x:  self.myImage.frame.origin.x, y: self.myImage.frame.origin.y , width: self.myImage.frame.size.width, height: self.myImage.frame.size.height)
                    Utilities.addToCartAnimation(vc:  self, frame: frame, image: self.myImage.image)
                    self.getCartAPI()
                    self.itemCount = 1
                default:
                    if result.status == "4" {
                        Utilities.showQuestionAlert(message: result.message ?? ""){
                            if self.isFood{
                                self.clearCartFood()
                            }
                            else{
                                self.clearCart()
                            }
                        }
                    }else {
                        Utilities.showWarningAlert(message: result.message ?? "") {
                            
                        }
                    }
                }
            }
            
        }else {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "product_id" : productID,
                "product_variant_id"  : product_Details?.product_variant_id ?? "",
                "store_id" : product_Details?.store_id ?? "",
                "device_cart_id" : SessionManager.getCartId() ?? "",
                "quantity" :  "\(self.itemCount)",
                "update_quantity" : "1"
            ]
            print(parameters)
            StoreAPIManager.addTOCartAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    let frame = CGRect(x:  self.myImage.frame.origin.x, y: self.myImage.frame.origin.y , width: self.myImage.frame.size.width, height: self.myImage.frame.size.height)
                    Utilities.addToCartAnimation(vc:  self, frame: frame, image: self.myImage.image)
                    self.getCartAPI()
                    self.itemCount = 1
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
    }
    func clearCart() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        StoreAPIManager.clearCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                UserDefaults.standard.set(self.addOns, forKey: "add_ons")
                self.addToCartAPI(addOns: self.addOns)
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func clearCartFood() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? ""
        ]
        StoreAPIManager.clearCartFoodAPI(parameters: parameters) { result in
            switch result.status {
            case "1":

                    DispatchQueue.main.async {
                        if self.foodData?.product_details?.product_combo.isEmpty  ?? false {
                            UserDefaults.standard.set(self.addOns, forKey: "add_ons")
                            self.addToCartAPI(addOns: self.addOns)
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
    
    func PlusCart() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productID,
            "product_variant_id"  : product_Details?.product_variant_id ?? "",
            "store_id" : product_Details?.store_id ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "quantity" : "1",
            "update_quantity" : "1"
        ]
        StoreAPIManager.addTOCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getCartAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func ReduceToCart() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productID,
            "product_variant_id"  : product_Details?.product_variant_id ?? "",
            "store_id" : product_Details?.store_id ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            "quantity" : "1",
        ]
        StoreAPIManager.reduceCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getCartAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func getCartAPI() {
        if self.isFood {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "device_cart_id" : SessionManager.getCartId() ?? ""
            ]
            FoodAPIManager.listCartNewItemsAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.Foodcart = result.oData
                default:
                    // self.cart?.cart_items?.removeAll()
                    // self.tbl.reloadData()
//                    Utilities.showWarningAlert(message: result.message ?? "") {
//                    }
                    break;
                }
            }
        }
        else {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "device_cart_id" : SessionManager.getCartId() ?? "",
                
            ]
            StoreAPIManager.getCartAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.cart = result.oData
                default:
//                    Utilities.showWarningAlert(message: result.message ?? "") {
//
//                    }
                    break
                }
            }
        }
    }
}
extension ProductDetailsViewController:AddtoCartCellDelegate {
    func getShopDetails() {
        self.getProductDetailsAPI()
    }
    
    func getCartCall() {
        self.getCartAPI()
    }
    
}
extension ProductDetailsViewController:AddtoFavoriteCellDelegate {
    func getProductDetailsCall() {
        self.getProductDetailsAPI()
    }
}
extension ProductDetailsViewController {
    
    func getFoodProductDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productID
        ]
        print(parameters)
        FoodAPIManager.foodDetailsAPI(parameters: parameters) { result in
            switch result.status{
            case "1" :
                self.foodData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? ""){
                    
                }
            }
        }
    }
}
