//
//  FoodStoreDetailsViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 05/05/23.
//


    import UIKit
    import SDWebImage
    import Cosmos
    import ImageSlideshow

    class FoodStoreDetailsViewController: BaseViewController {
        
        
        @IBOutlet weak var titleNameLbl: UILabel!
        @IBOutlet weak var priceLbl: UILabel!
        @IBOutlet weak var sliderView: ImageSlideshow!
        
        @IBOutlet weak var popupBgView: UIView!
        @IBOutlet weak var productCollection: UICollectionView!
        @IBOutlet weak var scroller: UIScrollView!
        @IBOutlet weak var CategotycollectionView: UICollectionView!
        @IBOutlet weak var productCollectionView: UIView!
        
        @IBOutlet weak var myView: UIView!
        @IBOutlet weak var myImage: UIImageView!
        
        @IBOutlet weak var cartView: UIView!
        @IBOutlet weak var counterView: UIView!
        @IBOutlet weak var counterLbl: UILabel!
        @IBOutlet weak var favImg: UIImageView!
        
        var resturant_ID :String = ""
        
        var localSource : [AlamofireSource] = []
        
        var page = 1
        var isLoadMore = true
        var isFecthing = true
        var step = ""
        var storeData : Store_details? {
            didSet {
                self.scroller.isHidden = false
                print(storeData?.user_image ?? "")
                viewControllerTitle = storeData?.name ?? ""
                myImage.sd_setImage(with: URL(string: storeData?.banner_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
//                rateStarView.rating = Double(storeData?.rating ?? "0") ?? 0
                
                ///Favorite code
                if storeData?.is_liked == "1"{
                    favImg.image = UIImage(named: "liked")
                }else{
                    favImg.image = UIImage(named: "unliked")
                }
                self.getProductAPI()
                self.view.layoutIfNeeded()
            }
        }
        var categories: [FoodCategories]? {
            didSet {
                self.setCategories()
                
            }
        }
        var productData: ResturantMenuData? {
            didSet {
                
            }
        }
        var productList: [Menus]? {
            didSet {
               
            }
        }
        var foodData:FoodProductData?{
            didSet{
                print("sdsdsd")
                titleNameLbl.text = foodData?.product_details?.product_name ?? ""
                priceLbl.text = "\(foodData?.currency_code ?? "") \(foodData?.product_details?.sale_price ?? "")"
               // myImage.sd_setImage(with: URL(string: foodData?.product_details?.default_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
                self.configerSlider(imageArray: foodData?.product_details?.product_images ?? [])
                self.popupBgView.isHidden = false
            }
        }
        var cart: FoodCartData? {
            didSet {
                if (Int(self.cart?.cart_count ?? "") ?? 0) > 0 {
                    self.cartView.layer.add(cartHearBeatAnimationGroup, forKey: "pulse")
                    self.counterView.isHidden = false
                    self.counterLbl.isHidden = false
                    self.counterLbl.text = self.cart?.cart_count ?? ""
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
            self.scroller.isHidden = true
    //        myImage.layer.cornerRadius = 165
    //        myImage.layer.maskedCorners = [.layerMaxXMaxYCorner]
            self.setProductCell()
          
            
        }
        override func notificationBtnAction () {
            Coordinator.goToNotifications(controller: self)
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.getStoreDetailsAPI()
            getCartAPI()
            
        }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
        }
        func setProductCell() {
            productCollection.delegate = self
            productCollection.dataSource = self
            productCollection.register(UINib.init(nibName: "ProductListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductListCollectionViewCell")
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
        @IBAction func btnGoToCart(_ sender: Any) {
            if !SessionManager.isLoggedIn() {
                Coordinator.presentLogin(viewController: self)
            }else {
                if (Int(self.cart?.cart_count ?? "") ?? 0) > 0 {
                    ShopCoordinator.goToFoodCart(controller: self, isSelected: false,storeID: storeData?.id ?? "")
                }else {
                    Utilities.showSuccessAlert(message: "No cart item found".localiz())
                }
            }
        }
        @IBAction func closeAction(_ sender: UIButton) {
            self.popupBgView.isHidden = true
        }
        @IBAction func btnFav(_ sender: Any) {
            if !SessionManager.isLoggedIn() {
                Coordinator.presentLogin(viewController: self)
            }else {
                self.AddTOFav()
            }
        }
        
        @IBAction func fullViewOfImageAction(_ sender: UIButton) {
            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
            VC.imageURLArray = [storeData?.banner_image ?? ""]
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        @IBAction func reviewBtnAction(_ sender: UIButton) {
            SellerOrderCoordinator.goToMyReviews(controller: self,store_id: foodData?.product_details?.store_id ?? "",isFromProfile: false)
        }
        @IBAction func locationLabelAction(_ sender: UIButton) {
            let alertController = UIAlertController(title: "Select Map".localiz(), message: "", preferredStyle: .alert)
                let appleAction = UIAlertAction(title: "Apple Map".localiz(), style: .default) { [self] (action) in
                    let latt = storeData?.user_location?.lattitude ?? ""
                    let lngg = storeData?.user_location?.longitude ?? ""
                    self.navigateAppleMap(lat: latt, longi: lngg)
                }
                alertController.addAction(appleAction)
                let googleAction = UIAlertAction(title: "Google Map".localiz(), style: .default) { [self] (action) in
                    let latt = storeData?.user_location?.lattitude ?? ""
                    let lngg = storeData?.user_location?.longitude ?? ""
                    self.navigateGoogleMap(lat: latt, longi: lngg)
                }
                alertController.addAction(googleAction)
                let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { (action) in
                    print("Cancel tapped")
                }
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }

    }
    extension FoodStoreDetailsViewController: UICollectionViewDataSource , UICollectionViewDelegate{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == CategotycollectionView
            {
                return categories?.count ?? 0
                
            }else if collectionView == productCollection
            {
                (productList?.count ?? 0) == 0 ? (productCollection.setEmptyView(title: "", message: "No Record Found", image: nil, msgLblTextColor: .black)) : (collectionView.restore())
                return productList?.count ?? 0
            }
            
            return 0
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
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as? ProductListCollectionViewCell else
                { return UICollectionViewCell()
                    
                }
                cell.baseVc = self
                cell.delegate = self
                cell.viewProduct = self.productCollectionView
                cell.addToCartBtn.tag = indexPath.row
                cell.productList = productList?[indexPath.row]
                cell.currencyType = productData?.currency_code ?? ""
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
                    self.getProductAPI()
                }
                self.CategotycollectionView.reloadData()
            }else if collectionView == productCollection  {
//                let  VC = AppStoryboard.FoodStore.instance.instantiateViewController(withIdentifier: "FoodDetailsViewController") as! FoodDetailsViewController
//                VC.productID = productList?[indexPath.item].id ?? ""
//                self.present(VC, animated: true, completion: nil)
                
                let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
                VC.productID = productList?[indexPath.item].id ?? ""
                VC.isFood = true
                self.navigationController?.pushViewController(VC, animated: true)
            //    self.getFoodProductDetailsAPI(productID: self.productList?[indexPath.row].id ?? "")
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
    extension FoodStoreDetailsViewController: UICollectionViewDelegateFlowLayout {
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
    extension FoodStoreDetailsViewController {
        func getStoreDetailsAPI() {
            let parameters:[String:String] = [
                "store_id" : resturant_ID
            ]
            print(parameters)
            FoodAPIManager.storeDetailsAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.storeData = result.oData?.store_details
                    self.categories = result.oData?.categories
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
        
        func getProductAPI() {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "store_id" : resturant_ID,
                "category_id" : self.categories?[selectedIndex].id ?? "",
                "page"  :String(page),
                "limit" : "10",
            ]
            FoodAPIManager.productListAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.productData = result.oData
                    self.isLoadMore = true
                    if self.page == 1 {
                        self.productList?.removeAll()
                        self.productList =   result.oData?.menus ?? []
                        if (self.productList?.count ?? 0) < 10 {
                            self.isLoadMore = false
                        }
                    }else {
                        self.productList?.append(contentsOf:  result.oData?.menus ?? [] )
                        if ((result.oData?.menus?.count ?? 0) < 10){
                            self.isLoadMore = true
                        }
                    }
                    if (result.oData?.menus?.count ?? 0) == 0 {
                        self.isLoadMore = false
                    }
                    self.productCollection.reloadData()
                    self.productCollection.layoutIfNeeded()
                    self.isFecthing = false
                   // self.productList = result.oData?.menus ?? []
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
        func getFoodProductDetailsAPI(productID:String) {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "product_id" :productID
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
        func getCartAPI() {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "device_cart_id" : SessionManager.getCartId() ?? ""
            ]
            self.counterView.isHidden = true
            self.counterLbl.isHidden = true
            FoodAPIManager.listCartNewItemsAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.cart = result.oData
                default:
//                    Utilities.showWarningAlert(message: result.message ?? "") {
//                    }
                    self.cart?.cart_items?.removeAll()
                    self.cart?.cart_count = "0"
                    print(result.message ?? "")
                }
            }
        }
        func AddTOFav() {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "store_id" : resturant_ID,
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
    extension FoodStoreDetailsViewController:AddToCartCellDelegate {
        func getCartCall() {
            self.getCartAPI()
        }
        
        func getStoreDetails() {
            self.getStoreDetailsAPI()
        }
    }
