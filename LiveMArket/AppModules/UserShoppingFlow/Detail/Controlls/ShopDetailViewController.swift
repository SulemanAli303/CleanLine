//
//  ShopProfileViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit
import SDWebImage
import Cosmos
import ImageSlideshow

class ShopDetailViewController: BaseViewController {
    
    @IBOutlet weak var productCollection: IntrinsicCollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var CategotycollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UIView!
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var subNameLbl: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var rateStarView: CosmosView!{
        didSet{
            rateStarView.settings.fillMode = .half
        }
    }
    
    var storeID = ""
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var favImg: UIImageView!
    
    var localSource : [AlamofireSource] = []
    
    var step = ""
    var page = 1
    var isLoadMore = true
    var isFecthing = true
    @IBOutlet weak var scollerTopConst: NSLayoutConstraint!
    
    
    var SellerData : SellerData? {
        didSet {
            print(SellerData?.user_image ?? "")
            scroller.isHidden = false
            scroller.delegate = self
            viewControllerTitle = SellerData?.name ?? ""
            nameLbl.text = SellerData?.name ?? ""
            about.text = SellerData?.about_me ?? ""
            locLbl.text = SellerData?.user_location?.location_name ?? ""
            star.text = "\(SellerData?.rating ?? "") \("Star Ratings".localiz())"
            myImage.sd_setImage(with: URL(string: SellerData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            
            rateStarView.rating = Double(SellerData?.rating ?? "0") ?? 0
            ///Favorite code
            if SellerData?.is_liked == "1"{
                favImg.image = UIImage(named: "liked")
            }else{
                favImg.image = UIImage(named: "unliked")
            }
            self.getProductAPI()
            self.view.layoutIfNeeded()
        }
    }
    var categories: [Category]? {
        didSet {
            self.setCategories()
            if categories?.count ?? 0 > 0{
                //  self.getProductAPI()
            }else{
                // self.setProductCell()
            }
            
        }
    }
    var productList: [ProductList]? {
        didSet {
            // self.setProductCell()
        }
    }
    var cart: CartData? {
        didSet {
            if (Int(self.cart?.cartCount ?? "") ?? 0) > 0 {
                self.cartView.layer.add(cartHearBeatAnimationGroup, forKey: "pulse")
                self.counterView.isHidden = false
                self.counterLbl.isHidden = false
                self.counterLbl.text = self.cart?.cartCount ?? ""
            }else {
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
        scroller.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 20, right: 0)
     //   scroller.isHidden = true
        self.setProductCell()
        
        var const = 64
        if hasTopNotch{
            const += Int(self.getNotchHeight)
        }
        scollerTopConst.constant = CGFloat(const)
        
        //        myImage.layer.cornerRadius = 165
        //        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStoreDetailsAPI()
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        self.productCollection.reloadData()
        self.productCollection.layoutIfNeeded()
    }
    func setCategories () {
        CategotycollectionView.delegate = self
        CategotycollectionView.dataSource = self
        CategotycollectionView.register(UINib.init(nibName: "CategoryNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryNameCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 0
        self.CategotycollectionView.collectionViewLayout = layout
        self.CategotycollectionView.reloadData()
        self.CategotycollectionView.layoutIfNeeded()
    }
    @IBAction func btnGoToCart(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: self)
        }else {
            if (Int(self.cart?.cartCount ?? "") ?? 0) > 0 {
                ShopCoordinator.goToCart(controller: self, isSelected: false)
            }else {
                Utilities.showSuccessAlert(message: "No cart item found".localiz())
            }
        }
    }
    @IBAction func btnFav(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: self)
        }else {
            self.AddTOFav()
        }
    }
    @IBAction func reviewBtnAction(_ sender: UIButton) {
        SellerOrderCoordinator.goToMyReviews(controller: self,store_id: SellerData?.id ?? "",isFromProfile: false)
    }
    @IBAction func locationLabelAction(_ sender: UIButton) {
            let alertController = UIAlertController(title: "Select Map".localiz(), message: "", preferredStyle: .alert)
            let appleAction = UIAlertAction(title: "Apple Map".localiz(), style: .default) { [self] (action) in
                let latt = SellerData?.user_location?.lattitude ?? ""
                let lngg = SellerData?.user_location?.longitude ?? ""
                self.navigateAppleMap(lat: latt, longi: lngg)
            }
            alertController.addAction(appleAction)
            let googleAction = UIAlertAction(title: "Google Map".localiz(), style: .default) { [self] (action) in
                let latt = SellerData?.user_location?.lattitude ?? ""
                let lngg = SellerData?.user_location?.longitude ?? ""
                self.navigateGoogleMap(lat: latt, longi: lngg)
            }
            alertController.addAction(googleAction)
            let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { (action) in
                print("Cancel tapped")
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func fullViewOfImageAction(_ sender: UIButton) {
        let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
        VC.imageURLArray = [SellerData?.banner_image ?? ""]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
}
extension ShopDetailViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == CategotycollectionView
        {
            return categories?.count ?? 0
            
        }else if collectionView == productCollection
        {
            //(productList?.count ?? 0) == 0 || (productList?.count ?? 0) == nil ? (productCollection.setEmptyView(title: "", message: "No Record Found", image: UIImage(named: "noStoreData"), msgLblTextColor: .black)) : (collectionView.restore())
            guard (productList?.count ?? 0) != 0  else {
                collectionView.setEmptyView(title: "", message: "No Record Found".localiz(), image: UIImage(named: "noStoreData"))
                
                return 0
            }
            collectionView.backgroundView = nil
            return productList?.count ?? 0
        }else{
            return 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == CategotycollectionView
        {
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryNameCollectionViewCell", for: indexPath) as? CategoryNameCollectionViewCell else { return UICollectionViewCell() }
            switch indexPath.row {
            case selectedIndex:
                topCategoriesCell.bagImg.isHidden = false
                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#FFFFFF")
                topCategoriesCell.countLbl.textColor = UIColor.init(hex: "#FF6B30")
                topCategoriesCell.namelbl.alpha = 1.0
            default:
                topCategoriesCell.bagImg.isHidden = true
                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#686868")
                topCategoriesCell.countLbl.textColor = UIColor.init(hex: "#686868")
                topCategoriesCell.namelbl.alpha = 1.0
            }
            topCategoriesCell.namelbl.text = "\(self.categories?[indexPath.row].name ?? "")"
            topCategoriesCell.countLbl.text = "\(self.categories?[indexPath.row].product_count ?? "")"
            topCategoriesCell.layoutSubviews()
            topCategoriesCell.layoutIfNeeded()
            
            return topCategoriesCell
        }else if collectionView == productCollection
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddtoCartCell", for: indexPath) as? AddtoCartCell else
            { return UICollectionViewCell()
                
            }
            cell.baseVc = self
            cell.delegate = self
            cell.viewProduct = self.productCollectionView
            cell.addToCartBtn.tag = indexPath.row
            cell.productList = productList?[indexPath.row]
            cell.setData()
            return cell
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == CategotycollectionView {
            self.selectedIndex = indexPath.row
            if (self.selectedIndex) <= (self.categories?.count ?? 0) {
                self.selectedIndex = indexPath.row
                self.isLoadMore = true
                page = 1
                self.getProductAPI()
            }
            self.CategotycollectionView.reloadData()
        }else if collectionView == productCollection  {
            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            VC.productID = productList?[indexPath.item].id ?? ""
            VC.defaultAttributevalue = productList?[indexPath.item].defaultAttributeID ?? ""
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == productCollection {
            
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.scroller.contentOffset.y < 0){
            //reach top
        }
        
        else   if (self.scroller.contentOffset.y >= 0 && self.scroller.contentOffset.y < (self.scroller.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
        else if(self.scroller.contentOffset.y >= (self.scroller.contentSize.height - self.scroller.bounds.size.height)) {
            if (self.isLoadMore == true && self.isFecthing == false) {
                self.isFecthing = true
                page += 1
                self.getProductAPI()
                
            }
        }
    }
    
}
extension ShopDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CategotycollectionView {
            
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryNameCollectionViewCell", for: indexPath) as? CategoryNameCollectionViewCell else { return CGSize.zero}
            
            topCategoriesCell.namelbl.text = "\(self.categories?[indexPath.row].name ?? "")"
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
extension ShopDetailViewController {
    func getStoreDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "seller_user_id" : storeID
        ]
        StoreAPIManager.storeDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.SellerData = result.oData?.sellerData
                self.categories = result.oData?.categories
                self.getCartAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getProductAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "seller_user_id" : storeID,
            "page"  :String(page),
            "limit" : "10",
            "store_id" :storeID,
            "category_id" : self.categories?[selectedIndex].id ?? "",
            "lang" : "ar"
        ]
        print(parameters)
        StoreAPIManager.productListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                
                self.isLoadMore = true
                if self.page == 1 {
                    self.productList?.removeAll()
                    self.productList =  result.oData?.list
                    if (self.productList?.count ?? 0) < 10 {
                        self.isLoadMore = false
                    }
                }else {
                    self.productList?.append(contentsOf: result.oData?.list ?? [])
                    if ((result.oData?.list?.count ?? 0) < 10){
                        self.isLoadMore = true
                    }
                }
                if (result.oData?.list?.count ?? 0) == 0 {
                    self.isLoadMore = false
                }
                self.productCollection.reloadData()
                self.productCollection.layoutIfNeeded()
                self.isFecthing = false
                // self.productList = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func getCartAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "device_cart_id" : SessionManager.getCartId() ?? "",
            
        ]
        StoreAPIManager.getCartAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.cart = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func AddTOFav() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "store_id" : storeID,
        ]
        StoreAPIManager.storeFavAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getStoreDetailsAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension ShopDetailViewController:AddtoCartCellDelegate {
    func getCartCall() {
        self.getCartAPI()
    }
    
    func getShopDetails() {
        self.getStoreDetailsAPI()
    }
}
