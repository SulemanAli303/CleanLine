//
//  ResturantListViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 19/01/2023.
//

import UIKit
import FittedSheets
import SDWebImage
import SwiftGifOrigin

class ResturantListViewController: UIViewController {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var delegateServiceView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    //@IBOutlet weak var searchViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchStringTextField: UITextField!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var productCollection: UICollectionView!
    @IBOutlet weak var topCollection: UICollectionView!
    @IBOutlet weak var scroller: UIScrollView!
    
    var module : Int = 0
    var isSelected = -1
    var topOptionsArray = [TopOptions]()
    var postCollectionArray : [PostCollection] = []
    var userTypeString:String = ""
    var userTypeID:String = ""
    private var initialPageCount = 20
    var isStoreButtonClicked:Bool = false
    var searchText:String = ""
    var  selectedIndividualID:String = ""
    
    var pageCount = 1
    var hasFetchedAll = false
    var offset = 0

    var selectedColors = ["#9A8ED4","#8EB2D4","#F1B8A0","#8EB2D4"]
    var unselectedColors = ["#E7E2FD","#E2EFFD","#FFE7DA","#E2EFFD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchStringTextField.placeholder = "Search here..".localiz()
        // scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("openOptionsDiscover"), object: nil)
        
        
//        topOptionsArray.append(TopOptions(name: "Reservations",selectedImg: "Group 236455",unselectedImg: "Group 236454"))
//        topOptionsArray.append(TopOptions(name: "Services",selectedImg: "service",unselectedImg: "serviceSelected"))
//        topOptionsArray.append(TopOptions(name: "Shopping",selectedImg: "shop",unselectedImg: "shop 1"))
//        topOptionsArray.append(TopOptions(name: "Subsciptions",selectedImg: "gym",unselectedImg: "gym 1"))
        setProductCell()
        
        isStoreButtonClicked = true
        storeImage.image = UIImage(named: "storeSelected")
        userImage.image = UIImage(named: "userUnselected")
        userTypeString = "shop"
        userTypeID = "1"
    }
    func setProductCell() {
        productCollection.delegate = self
        productCollection.dataSource = self
        productCollection.register(UINib.init(nibName: "ResturantCell", bundle: nil), forCellWithReuseIdentifier: "ResturantCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.productCollection.collectionViewLayout = layout
        
        
        topCollection.delegate = self
        topCollection.dataSource = self
        topCollection.register(UINib.init(nibName: "topOptionsCell", bundle: nil), forCellWithReuseIdentifier: "topOptionsCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        self.topCollection.collectionViewLayout = layout2
        self.topCollection.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllAccountType()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.selectedIndex = 1
        module = UserDefaults.standard.integer(forKey: "flow")
        //self.hideViews(value: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            if Constants.shared.searchHashTagText != ""{
                self.searchText = Constants.shared.searchHashTagText
                self.searchStringTextField.text = self.searchText
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.resetPage()
                    self.searchPublicPosts(page: 1, searchKey: self.searchText)
                }
                
            }else{
                self.closeButton.isHidden = true
                self.searchText = ""
                self.searchStringTextField.text = self.searchText
                self.resetPage()
                self.searchPublicPosts(page: 1, searchKey: searchText)
            }
        }
        
        let tabbar = tabBarController as? TabbarController
        tabbar?.popupDelegate = self
        tabbar?.showTabBar()
        self.resetPage()
        
    }
    func resetPage() {
        pageCount = 1
        offset = 0
        self.hasFetchedAll = false
        postCollectionArray.removeAll()
        productCollection.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        //Constants.shared.searchHashTagText = ""
        //        searchText = ""
        //        searchStringTextField.text = ""
    }
    
    var accountData:[AccountData]?{
        didSet{
            if accountData?.contains(where: {$0.id == 6}) == true {
                guard let index = accountData?.firstIndex(where: {$0.id == 6}) else { return  }
                accountData?.remove(at: index)
            }
            if accountData?.contains(where: {$0.id == 3}) == true {
                guard let index = accountData?.firstIndex(where: {$0.id == 3}) else { return  }
                accountData?.remove(at: index)
            }
            
            if SessionManager.getUserData()?.user_type_id == "6"{
                if SessionManager.getUserData()?.is_notifiable == "1" {
                    let deliverDict = ["id":100,"name":"DELIVERY REQUEST","image":"DelegateGif","capitalized_name":"Delivery Request"] as [String : Any]
                    print(deliverDict)
                    do {
                        let json = try JSONSerialization.data(withJSONObject: deliverDict as Any)
                        let response = try JSONDecoder().decode(AccountData.self, from: json)
                        print(response)
                        accountData?.append(response)
                    } catch let err {
                        print(err)
                    }
                } else {
                    let delegateDict = ["id":0,"name":"DELEGATE SERVICE","image":"DelegateGif","capitalized_name":"Delegate Service"] as [String : Any]
                    print(delegateDict)
                    do {
                        let json = try JSONSerialization.data(withJSONObject: delegateDict as Any)
                        let response = try JSONDecoder().decode(AccountData.self, from: json)
                        print(response)
                        accountData?.append(response)
                    } catch let err {
                        print(err)
                    }
                }
            }else{
                let delegateDict = ["id":0,"name":"DELEGATE SERVICE","image":"DelegateGif","capitalized_name":"Delegate Service"] as [String : Any]
                print(delegateDict)
                do {
                    let json = try JSONSerialization.data(withJSONObject: delegateDict as Any)
                    let response = try JSONDecoder().decode(AccountData.self, from: json)
                    print(response)
                    accountData?.append(response)
                } catch let err {
                    print(err)
                }
            }
            
            //guard let data = AccountData.init(from: delegateDict)
            //accountData?.append(data)
            self.topCollection.reloadData()
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        OpenPopUp()
    }
    func OpenPopUp(){
        
        let tabbar = tabBarController as? TabbarController
        tabbar?.selectedIndex = 0
        
        DispatchQueue.main.async {
            Constants.shared.isPopupShow = false
            NotificationCenter.default.post(name: Notification.Name("openOptionsHome"), object: nil)
        }
        /*
         let  controller =  AppStoryboard.Floating.instance.instantiateViewController(withIdentifier: "FloatingVC") as! FloatingVC
         controller.delegate = self
         let sheet = SheetViewController(
         controller: controller,
         sizes: [.fullscreen],
         options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
         let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
         (self.navigationController?.navigationBar.frame.height ?? 0.0)
         sheet.minimumSpaceAbovePullBar = 0
         sheet.dismissOnOverlayTap = false
         sheet.dismissOnPull = false
         sheet.contentBackgroundColor = .clear
         self.present(sheet, animated: true, completion: nil)
         */
    }
    @IBAction func NotificationAction(_ sender: UIButton) {
        Coordinator.goToNotifications(controller: self)
    }
    
    @IBAction func userButtonAction(_ sender: UIButton) {
        isStoreButtonClicked = false
        selectedIndividualID = "2"
        storeImage.image = UIImage(named: "storeUnselected")
        userImage.image = UIImage(named: "userSelected")
        userTypeString = "user"
        userTypeID = "2"
        if Constants.shared.searchHashTagText == ""{
            searchText = ""
            searchStringTextField.text = ""
        }else{
            searchText = Constants.shared.searchHashTagText
            searchStringTextField.text = Constants.shared.searchHashTagText
        }
        self.getAllAccountType()
        resetPage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.searchPublicPosts(page: 1, searchKey: self.searchText)
        }
        
//        DispatchQueue.main.async {
//            Coordinator.goToOptionsCategory(controller: self, fUserType: self.userTypeString,accountTypeID: "3", searchText: self.searchText,headString: "Individual",selectedColor: self.selectedColors.last,unselectedColor: self.unselectedColors.last)
//        }
        
    }
    
//    @IBAction func searchButtonAction(_ sender: UIButton) {
//
//        // Duration of the animation
//        let animationDuration: TimeInterval = 1.0 // 0.5 seconds
//        //self.searchViewWidthConstraint.constant = 45
//        UIView.animate(withDuration: animationDuration) {
//            self.hideViews(value: true)
//            // Inside this block, you change the width of your view
//           // self.searchViewWidthConstraint.constant = Screen.width - 40
//        }
//    }
    
    @IBAction func delegateServiceAction(_ sender: UIButton) {
        
        if SessionManager.isLoggedIn() {
            //Coordinator.goToServiceUserList(controller: self)
            Coordinator.goToChooseDelegate(controller: self)
        }else {
            let tabbar = self.tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
    }
    @IBAction func storeButtonAction(_ sender: UIButton) {
        isStoreButtonClicked = true
        selectedIndividualID = ""
        storeImage.image = UIImage(named: "storeSelected")
        userImage.image = UIImage(named: "userUnselected")
        userTypeString = "shop"
        userTypeID = "1"
        if Constants.shared.searchHashTagText == ""{
            searchText = ""
            searchStringTextField.text = ""
        }else{
            searchText = Constants.shared.searchHashTagText
            searchStringTextField.text = Constants.shared.searchHashTagText
        }
        self.getAllAccountType()
        resetPage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.searchPublicPosts(page: 1, searchKey: self.searchText)
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        
        guard self.searchStringTextField.text != "" else {
            return
        }
        Constants.shared.searchHashTagText = ""
        self.closeButton.isHidden = true
        self.searchText = ""
        self.searchStringTextField.text = ""
        self.resetPage()
        self.searchPublicPosts(page: 1, searchKey: "")
    }
    
    //MARK:- API Call
    func checkUserProductExistOrNotAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "user_id" : SessionManager.getUserData()?.id ?? ""
        ]
        CMSAPIManager.checkUserProductExistAPI(parameters: parameters) { [weak self] result in
            switch result.status {
            case "1":
                let  controller =  AppStoryboard.Floating.instance.instantiateViewController(withIdentifier: "FloatingVC") as! FloatingVC
                controller.delegate = self
                let sheet = SheetViewController(
                    controller: controller,
                    sizes: [.fullscreen],
                    options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
                sheet.minimumSpaceAbovePullBar = 0
                sheet.dismissOnOverlayTap = false
                sheet.dismissOnPull = false
                sheet.contentBackgroundColor = .clear
                
                self?.present(sheet, animated: true, completion: nil)
            default:
                DispatchQueue.main.async {
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    
}
extension ResturantListViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    //filterPlaceHolder
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollection {
            
            guard self.postCollectionArray.count != 0  else {
                collectionView.setEmptyView_new(title: "", message: "No data Found!", image: UIImage(named: "filterPlaceHolder"))
                return 0
            }
            collectionView.backgroundView = nil
            return postCollectionArray.count
        }else {
            
            return accountData?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResturantCell", for: indexPath) as? ResturantCell else
            { return UICollectionViewCell()
            }
            cell.data = self.postCollectionArray[indexPath.row]
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topOptionsCell", for: indexPath) as? topOptionsCell else
            { return UICollectionViewCell()
            }
            
            cell.profileNameLabel.text = accountData?[indexPath.row].capitalized_name ?? ""
           
            
            /*
            if self.isSelected == indexPath.row {
                cell.profileNameLabel.textColor = UIColor(hex: "F6B400")
                cell.postImageView.backgroundColor = UIColor(hex: "F6B400")
                cell.img.sd_setImage(with: URL(string: accountData?[indexPath.row].image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile")){ image, error, cache, url in
                    cell.img.image = image
                    // Set the tint color
                    let tintColor = UIColor.white // Change this to your desired tint color
                    // Apply the template rendering mode with tint color
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    cell.img.tintColor = tintColor
                    cell.img.image = tintedImage
                }
            }else {
                cell.profileNameLabel.textColor = UIColor(hex: "313131")
                cell.postImageView.backgroundColor = UIColor(hex: "FFF3E4")
                //cell.img.image = UIImage(named: accountData?[indexPath.row].image ?? "")
                cell.img.sd_setImage(with: URL(string: accountData?[indexPath.row].image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile")){ image, error, cache, url in
                    cell.img.image = image
                    // Set the tint color
                    let tintColor = UIColor.init(hexString: "#F6B400")  // Change this to your desired tint color
                    // Apply the template rendering mode with tint color
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    cell.img.tintColor = tintColor
                    cell.img.image = tintedImage
                }
            }*/
            
            cell.profileNameLabel.textColor = UIColor(hex: "313131")
            cell.postImageView.backgroundColor = UIColor(hex: unselectedColors[indexPath.row])
            cell.img.sd_setImage(with: URL(string: accountData?[indexPath.row].image ?? "")){ image, error, cache, url in
                if error == nil {
                    cell.img.image = image
                    // Set the tint color
                    let tintColor = UIColor.init(hexString: "#F6B400") // Change this to your desired tint color
                    // Apply the template rendering mode with tint color
                    let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                    cell.img.tintColor = tintColor
                    cell.img.image = tintedImage
                }else {
                    if self.accountData?[indexPath.row].name == "DELEGATE SERVICE" || self.accountData?[indexPath.row].name == "DELIVERY REQUEST"{
                        cell.img.image = UIImage.gif(name: "DelegateGif")
                    }else{
                        cell.img.image = UIImage(named: "")
                    }
                    
                }

            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollection {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            return CGSize(width: screenWidth/2, height:180)
        }else {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width - 10
            return CGSize(width: (screenWidth/4), height:150)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == productCollection {
            let  VC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
            VC.postCollectionDummyArray = self.postCollectionArray
            VC.videoIndexPath = indexPath
            VC.isFromProfile = true
            //VC.delegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }else {
            if self.accountData?[indexPath.row].name == "DELEGATE SERVICE" || self.accountData?[indexPath.row].name == "DELIVERY REQUEST"{
                if SessionManager.getUserData()?.user_type_id == "6"{
                    if SessionManager.getUserData()?.is_notifiable == "1" {
                        if SessionManager.isLoggedIn() {
                            SellerOrderCoordinator.goToDeliveryRequests(controller: self)
                        }else {
                            let tabbar = self.tabBarController as? TabbarController
                            tabbar?.hideTabBar()
                            Coordinator.setRoot(controller: self)
                        }
                    }else {
                        self.delegateServiceAction(UIButton())
                    }
                }else{
                    self.delegateServiceAction(UIButton())
                }
            }else{
                Coordinator.goToOptionsCategory(controller: self, fUserType: self.userTypeString,accountTypeID: "\(self.accountData?[indexPath.row].id ?? 0)", searchText: searchText,headString: self.accountData?[indexPath.row].capitalized_name ?? "",selectedColor: selectedColors[indexPath.row],unselectedColor: unselectedColors[indexPath.row],individual_id: selectedIndividualID)
                self.isSelected = indexPath.row
                self.topCollection.reloadData()
            }
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == productCollection {
            guard indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 else { return }
            if  hasFetchedAll { return }
            pageCount += 1
            offset += 20
            searchPublicPosts(page: pageCount, searchKey: searchText)
        }else {
            
        }
    }
}
extension ResturantListViewController: FloatingVCDelegate {
    func goToLive() {
        Coordinator.goToLive(controller: self)
    }
    func goToVideo() {
        Coordinator.goToTakeVideo(controller: self)
    }
    func goToImage() {
        Coordinator.goToTakePicture(controller: self)
    }
}
extension ResturantListViewController {
    //API Call
    
    func getAllAccountType() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [:]
        StoreAPIManager.accountTypeAPI(parameters: parameters,id: userTypeID) { result in
            switch result.status {
            case "1":
                self.accountData = result.oData ?? []
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    //MARK: - Socket Calls
    
    func searchPublicPosts(page:Int,searchKey:String){
        let parameter = ["userId": SessionManager.getUserData()?.id ?? "0",
                         "limitPerPage": initialPageCount ,
                         "offset":  offset,
                         "fUserType":userTypeString,
                         "keyword":searchKey] as [String : Any]
        print(parameter)
        DispatchQueue.main.async {
            Utilities.showIndicatorView()
        }
        let socket = SocketIOManager.sharedInstance
        socket.searchPublicPosts(request: parameter) {[weak self] dataArray in
            DispatchQueue.main.async {
                Utilities.hideIndicatorView()
            }
            guard self != nil else {return}
            guard let dict = dataArray[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                if let decodedArray:FeedPost_Base = try? decoder.decode(FeedPost_Base.self, from: json){
                    print(decodedArray.postCollection ?? [])
                    let count = Int(decodedArray.postCollection?.count ?? 0 )
                    if count < (self?.initialPageCount ?? 0) {
                        self?.hasFetchedAll = true
                    }
                    if page == 1{
                        self?.postCollectionArray = decodedArray.postCollection ?? []
                    }else{
                        self?.postCollectionArray.append(contentsOf: decodedArray.postCollection ?? [])
                    }
                    self?.productCollection.reloadData()
                }else{
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
extension ResturantListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            searchText = updatedText
            Constants.shared.searchHashTagText = updatedText
            if updatedText == ""{
                self.closeButton.isHidden = true
            }else{
                self.closeButton.isHidden = false
            }
            self.resetPage()
            self.searchPublicPosts(page: 1, searchKey: updatedText)
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension ResturantListViewController: PopupProtocol{
    func openPopup() {
        if SessionManager.isLoggedIn() {
            self.checkUserProductExistOrNotAPI()
        }else{
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
    }
}
