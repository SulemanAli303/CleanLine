//
//  NewOrderViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 21/01/2023.
//

import UIKit

class FavouriteListViewController: BaseViewController {
    
    @IBOutlet weak var productCollection: UICollectionView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var myOrdersButton: UIButton!
    @IBOutlet weak var receivedOrdersButton: UIButton!
    @IBOutlet weak var chaletButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    var productList: [ProductList]? {
        didSet {
            self.productCollection.reloadData()
        }
    }
    var StoreList: [StoreFavList]? {
        didSet {
            self.productCollection.reloadData()
        }
    }
    var foodProducts: [FavList]? {
        didSet {
            self.productCollection.reloadData()
        }
    }
    
    var chaletList: [ChaletsList]? {
        didSet {
            self.productCollection.reloadData()
        }
    }
    
    var VCtype = ""
    var isClicked:Int = 0
    var isFromThankUPage:Bool = false
    var isFromDriver:Bool = false
    var isFromResturant:Bool = false
    var myOrdersList:[CharletBookingList] = []
    var receivedOrdersList:[CharletBookingList] = []
    @IBOutlet var allButtons: [UIButton]!
    var foodItemsList:[CharletBookingList] = []
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    var userData: User?
    
    var myOrdersData:CharletBookingListData?{
        didSet{
            let count = Int(myOrdersData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            self.myOrdersList.append(contentsOf: myOrdersData?.list ?? [CharletBookingList]())
            
        }
    }
    var myReceivedOrdersData:CharletBookingListData?{
        didSet{
            let count = Int(myReceivedOrdersData?.list?.count ?? 0)
            if count < (self.pageLimit) {
                self.hasFetchedAll = true
            }
            self.receivedOrdersList.append(contentsOf: myReceivedOrdersData?.list ?? [CharletBookingList]())
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = SessionManager.getUserData()
        type = .backWithTop
        viewControllerTitle = "Favourites"
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        
        self.setProductCell()
        self.resetAllButton()
    }
    
    func setProductCell() {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.register(UINib.init(nibName: "ProductFavCell", bundle: nil), forCellWithReuseIdentifier: "ProductFavCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.productCollection.collectionViewLayout = layout
        self.productCollection.layoutIfNeeded()
    }
    
    @objc func setupNotificationObserver()
    {
        
        self.resetPage()
        DispatchQueue.main.async {
            if self.isClicked == 0{
                self.getFavProductAPI()
            }else if self.isClicked == 1{
                self.getFavFoodProductAPI()
            }else{
                self.getFavStoreAPI()
            }
        }
        
        if isFromDriver{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
        }else{
            topView.isHidden = false
            topViewHeightConstraint.constant = 180
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.resetPage()
        DispatchQueue.main.async {
            if self.isClicked == 0{
                    //                    self.resetPage()
                    //                    self.getFavProductAPI()
                    //                    self.myOrdersButton.backgroundColor = .white
                    //                    self.receivedOrdersButton.backgroundColor = .clear
                    //                    self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
                    //                    self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)
                self.myOrdwersAction(UIButton())
            }else if self.isClicked == 1{
                //self.getFavFoodProductAPI()
                self.foodButnActions(UIButton())
            }else if self.isClicked == 3{
                self.chaletButnActions(self.chaletButton)
            }else{
                Constants.shared.isCommingFromOrderPopup = false
                self.receivedOrdwersAction(UIButton())
            }
        }
        
        if isFromDriver{
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
        }else{
            topView.isHidden = false
            topViewHeightConstraint.constant = 180
        }

        if Constants.shared.isCommingFromOrderPopup {
            Constants.shared.isCommingFromOrderPopup = false
            self.receivedOrdwersAction(UIButton())
        }
    }
    
    func resetPage() {
        pageCount = 1
        myOrdersList.removeAll()
        receivedOrdersList.removeAll()
        foodItemsList.removeAll()
        chaletList?.removeAll()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    @IBAction func foodButnActions(_ sender: UIButton) {
        self.resetPage()
        self.isClicked = 1
        self.foodButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
        self.myOrdersButton.setTitleColor(UIColor.white, for: .normal)
        self.receivedOrdersButton.setTitleColor(UIColor.white, for: .normal)
        self.getFavFoodProductAPI()
        self.foodButton.backgroundColor = .white
        self.receivedOrdersButton.backgroundColor = .clear
        self.myOrdersButton.backgroundColor = .clear
    }
    
    
    @IBAction func myOrdwersAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.isClicked = 0
            self.resetPage()
            self.resetAllButton()
            self.getFavProductAPI()
            self.myOrdersButton.setTitleColor(UIColor(hexString: "#C96031"), for: .normal)
            self.myOrdersButton.backgroundColor = .white
        }
    }
    @IBAction func receivedOrdwersAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.isClicked = 2
            self.resetPage()
            self.resetAllButton()
            self.getFavStoreAPI()
            self.receivedOrdersButton.setTitleColor(UIColor(hexString: "#F1B943"), for: .normal)
            self.receivedOrdersButton.backgroundColor = .white
        }
    }
    
    @IBAction func chaletButnActions(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.isClicked = 3
            self.resetPage()
            self.resetAllButton()
            self.getFavChaletAPI()
            self.chaletButton.setTitleColor(UIColor(hexString: "#F1B943"), for: .normal)
            self.chaletButton.backgroundColor = .white
        }
        
    }
    
    func resetAllButton(){
        
        for single in allButtons {
            single.setTitleColor(UIColor.white, for: .normal)
            single.backgroundColor = .clear
        }
        
    }
    
    //MARK: - API Calls
    
    func myOrdesListAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "page":pageCount.description,
            "limit":pageLimit.description
        ]
        print(parameters)
        if isFromResturant{
            CharletAPIManager.charletBookingListAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            CharletAPIManager.charletBookingListAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
    func myReceivedOrdersAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" : localTimeZoneIdentifier,
            "page":pageCount.description,
            "limit":pageLimit.description
        ]
        print(parameters)
        
        if isFromResturant{
            CharletAPIManager.charletManagmentBookingListAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myReceivedOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            CharletAPIManager.charletManagmentBookingListAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myReceivedOrdersData = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
}



extension FavouriteListViewController {
    func getFavProductAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "page"  : "1",
            "limit" : "100"
        ]
        StoreAPIManager.productFavListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.productList = result.oData?.list
            default:
                self.productList?.removeAll()
                self.productCollection.reloadData()
            }
        }
    }
    
    func getFavStoreAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "page"  : "1",
            "limit" : "100"
        ]
        StoreAPIManager.storeFavListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.StoreList = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getFavFoodProductAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "page"  : "1",
            "limit" : "100"
        ]
        FoodAPIManager.foodFavoriteAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.foodProducts = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getFavChaletAPI(){
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "page"  : "1",
            "limit" : "10000"
        ]
        StoreAPIManager.chaletFavListAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.chaletList = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    @objc func removeChaletFav(_ sender : UIButton){
        let obj = self.chaletList?[sender.tag]
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "like" : "0",
            "id" : "\(obj?.id ?? "0")"
        ]
        CharletAPIManager.charletListProductLikeAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getFavChaletAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension FavouriteListViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isClicked == 0 {
            (productList?.count ?? 0) == 0 ? (productCollection.setEmptyView_new(title: "", message: "No Record Found", image: UIImage(named: "undraw_personal_file_re_5joy 1"), msgLblTextColor: .black)) : (collectionView.restore())
            return productList?.count ?? 0
        }else if isClicked == 1  {
            (foodProducts?.count ?? 0) == 0 ? (productCollection.setEmptyView_new(title: "", message: "No Record Found", image: UIImage(named: "undraw_personal_file_re_5joy 1"), msgLblTextColor: .black)) : (collectionView.restore())
            return foodProducts?.count ?? 0
        }else if isClicked == 3  {
            (chaletList?.count) == 0 ? (productCollection.setEmptyView_new(title: "", message: "No Record Found", image: UIImage(named: "undraw_personal_file_re_5joy 1"), msgLblTextColor: .black)) : (collectionView.restore())
            return chaletList?.count ?? 0
            
        }else{
            (StoreList?.count ?? 0) == 0 ? (productCollection.setEmptyView_new(title: "", message: "No Record Found", image: UIImage(named: "undraw_personal_file_re_5joy 1"), msgLblTextColor: .black)) : (collectionView.restore())
            return StoreList?.count ?? 0
        }
        
        return productList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isClicked == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductFavCell", for: indexPath) as? ProductFavCell else
            { return UICollectionViewCell()
                
            }
            cell.locationNameView.isHidden = true
            cell.baseVc = self
            cell.addToCartView.isHidden = true
            cell.delegate = self
            cell.addToCartBtn.tag = indexPath.row
            cell.storeList = nil
            cell.productList = productList?[indexPath.row]
            cell.setData()
            return cell
        }else if isClicked == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductFavCell", for: indexPath) as? ProductFavCell else
            { return UICollectionViewCell()
                
            }
            cell.locationNameView.isHidden = true
            cell.baseVc = self
            cell.addToCartView.isHidden = true
            cell.delegate = self
            cell.addToCartBtn.tag = indexPath.row
            cell.storeList = nil
            cell.productList = nil
            cell.foodList = foodProducts?[indexPath.row]
            cell.setFoodData()
            return cell
        }else if isClicked == 3 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductFavCell", for: indexPath) as? ProductFavCell else
            { return UICollectionViewCell()
                
            }
            cell.locationNameView.isHidden = true
            cell.baseVc = self
            cell.addToCartView.isHidden = true
            cell.delegate = self
            cell.addToCartBtn.tag = indexPath.row
            cell.storeList = nil
            cell.productList = nil
            cell.PriceView.isHidden = true
            cell.locationNameView.isHidden = true
            cell.chaletObj = chaletList?[indexPath.row]
            cell.setChaletData()
            
            cell.addToFavoriteButton.tag = indexPath.row
            cell.addToFavoriteButton.addTarget(self, action: #selector(removeChaletFav(_:)), for: .touchUpInside)
            
            return cell
            
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductFavCell", for: indexPath) as? ProductFavCell else
            { return UICollectionViewCell()
                
            }
            cell.locationNameView.isHidden = false
            cell.PriceView.isHidden = true
            cell.baseVc = self
            cell.addToCartView.isHidden = true
            cell.delegate = self
            cell.productList = nil
            cell.addToCartBtn.tag = indexPath.row
            cell.storeList = StoreList?[indexPath.row]
            cell.setData_store()
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isClicked == 0 {
            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            VC.productID = productList?[indexPath.item].id ?? ""
            self.navigationController?.pushViewController(VC, animated: true)
        }else if isClicked == 1 {
            let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            VC.productID = foodProducts?[indexPath.item].product_id ?? ""
            VC.isFood = true
            self.navigationController?.pushViewController(VC, animated: true)
        }else if isClicked == 3 {
        
            if SessionManager.getUserData()?.user_type_id ?? "" == "2" {
                Coordinator.goToChaletsLIstDetails(controller: self,chaledId:  chaletList?[indexPath.row].id)
            }else{
                Coordinator.goToCharletsRoom(controller: self,chaletID: chaletList?[indexPath.row].id ?? "")
            }
            
        }else {
            ShopCoordinator.goToShopProfileDetail(controller: self, storeID: StoreList?[indexPath.row].id ?? "")
        }
        
    }
}
extension FavouriteListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isClicked == 0 {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-20
            return CGSize(width: screenWidth/2, height:180)
        }else if isClicked == 1 {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-20
            return CGSize(width: screenWidth/2, height:180)
        }else if isClicked == 3 {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-20
            return CGSize(width: screenWidth/2, height:180)
        
        }else {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width-20
            return CGSize(width: screenWidth/2, height:200)
        }
        
        return CGSize(width: 0, height: 0)
    }
}
extension FavouriteListViewController:ProductFavCellDelegate {
    func getShopDetails() {
        self.getFavStoreAPI()
    }
    func getCartCall() {
    }
    func getProductDetails() {
        self.getFavProductAPI()
    }
    func getFoodDetails() {
        self.getFavFoodProductAPI()
    }
    
}
