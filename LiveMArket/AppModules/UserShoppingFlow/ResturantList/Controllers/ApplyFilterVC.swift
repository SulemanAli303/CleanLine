//
//  ApplyFilterVC.swift
//  LiveMArket
//
//  Created by Zain on 19/08/2023.
//

import UIKit


    class ApplyFilterVC: UIViewController {
        
        var Lat = ""
        var long = ""
        var activityID:String = ""
        var accountID:String = ""
        var cityID:String = ""
        var aminities:[String] = []
        var minValue:Int = 0
        var maxValue:Int = 0
        var rating:String = ""
        var checkInDate:String = ""
        var checkOutDate:String = ""
        
        @IBOutlet weak var resutCountLabel: UILabel!
        @IBOutlet weak var searchStringTextField: UITextField!
        @IBOutlet weak var productCollection: UICollectionView!
        @IBOutlet weak var scroller: UIScrollView!
        @IBOutlet weak var clearAllButton: UIButton!
        @IBOutlet weak var modifyButton: UIButton!
        
        var module : Int = 0
        var isSelected = -1
        var topOptionsArray = [TopOptions]()
        var postCollectionArray : [PostCollection] = []
        var userTypeString:String = ""
        private var initialPageCount = 20
        var isStoreButtonClicked:Bool = false
        var searchText:String = ""
        
        var pageCount = 1
        var hasFetchedAll = false
        var offset = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            searchStringTextField.placeholder = "Search here..".localiz()
            clearAllButton.setTitle("Clear All", for: .normal)
            modifyButton.setTitle("Modify Filter  ", for: .normal)
            // scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            //NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("openOptionsDiscover"), object: nil)
            
           // isStoreButtonClicked = true
//            storeImage.image = UIImage(named: "storeSelected")
//            userImage.image = UIImage(named: "userUnselected")
           // userTypeString = "shop"
    //        topOptionsArray.append(TopOptions(name: "Reservations",selectedImg: "Group 236455",unselectedImg: "Group 236454"))
    //        topOptionsArray.append(TopOptions(name: "Services",selectedImg: "service",unselectedImg: "serviceSelected"))
    //        topOptionsArray.append(TopOptions(name: "Shopping",selectedImg: "shop",unselectedImg: "shop 1"))
    //        topOptionsArray.append(TopOptions(name: "Subsciptions",selectedImg: "gym",unselectedImg: "gym 1"))
            setProductCell()
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
            
            
//            topCollection.delegate = self
//            topCollection.dataSource = self
//            topCollection.register(UINib.init(nibName: "topOptionsCell", bundle: nil), forCellWithReuseIdentifier: "topOptionsCell")
//            let layout2 = UICollectionViewFlowLayout()
//            layout2.scrollDirection = .horizontal
//            layout2.minimumInteritemSpacing = 0
//            layout2.minimumLineSpacing = 0
//            self.topCollection.collectionViewLayout = layout2
//            self.topCollection.reloadData()
            
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.selectedIndex = 1
            module = UserDefaults.standard.integer(forKey: "flow")
            if Constants.shared.searchHashTagText != ""{
                self.searchText = Constants.shared.searchHashTagText
                searchStringTextField.text = self.searchText
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.resetPage()
                    self.searchPublicPosts(page: 1, searchKey: self.searchText)
                }
                
            }else{
                self.resetPage()
                searchPublicPosts(page: 1, searchKey: searchText)
            }
            let tabbar = tabBarController as? TabbarController
            tabbar?.popupDelegate = self
            tabbar?.showTabBar()
            self.resetPage()
            //self.getAllAccountType()
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
        
//        var accountData:[AccountData]?{
//            didSet{
//                self.topCollection.reloadData()
//            }
//        }
        
//        @objc func methodOfReceivedNotification(notification: Notification) {
//            OpenPopUp()
//        }
//        func OpenPopUp(){
//
//            let tabbar = tabBarController as? TabbarController
//            tabbar?.selectedIndex = 0
//
//            DispatchQueue.main.async {
//                Constants.shared.isPopupShow = false
//                NotificationCenter.default.post(name: Notification.Name("openOptionsHome"), object: nil)
//            }
//            /*
//             let  controller =  AppStoryboard.Floating.instance.instantiateViewController(withIdentifier: "FloatingVC") as! FloatingVC
//             controller.delegate = self
//             let sheet = SheetViewController(
//             controller: controller,
//             sizes: [.fullscreen],
//             options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
//             let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
//             (self.navigationController?.navigationBar.frame.height ?? 0.0)
//             sheet.minimumSpaceAbovePullBar = 0
//             sheet.dismissOnOverlayTap = false
//             sheet.dismissOnPull = false
//             sheet.contentBackgroundColor = .clear
//             self.present(sheet, animated: true, completion: nil)
//             */
//        }
        
        @IBAction func clearAllButtonAction(_ sender: UIButton) {
            Constants.shared.searchHashTagText = ""
            for controller in self.navigationController!.viewControllers as Array{
                if controller.isKind(of: ResturantListViewController.self){
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
        @IBAction func modifiedButtonAction(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
        }
        @IBAction func backButtonAction(_ sender: UIButton) {
            for controller in self.navigationController!.viewControllers as Array{
                if controller.isKind(of: ResturantListViewController.self){
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
        @IBAction func NotificationAction(_ sender: UIButton) {
            Coordinator.goToNotifications(controller: self)
        }
        
//        @IBAction func userButtonAction(_ sender: UIButton) {
//            isStoreButtonClicked = false
//            storeImage.image = UIImage(named: "storeUnselected")
//            userImage.image = UIImage(named: "userSelected")
//            userTypeString = "user"
//            if Constants.shared.searchHashTagText == ""{
//                searchText = ""
//                searchStringTextField.text = ""
//            }else{
//                searchText = Constants.shared.searchHashTagText
//                searchStringTextField.text = Constants.shared.searchHashTagText
//            }
//            resetPage()
//            self.searchPublicPosts(page: 1, searchKey: searchText)
//        }
        
//        @IBAction func storeButtonAction(_ sender: UIButton) {
//            isStoreButtonClicked = true
//            storeImage.image = UIImage(named: "storeSelected")
//            userImage.image = UIImage(named: "userUnselected")
//            userTypeString = "shop"
//            if Constants.shared.searchHashTagText == ""{
//                searchText = ""
//                searchStringTextField.text = ""
//            }else{
//                searchText = Constants.shared.searchHashTagText
//                searchStringTextField.text = Constants.shared.searchHashTagText
//            }
//            resetPage()
//            self.searchPublicPosts(page: 1, searchKey: searchText)
//        }
    }
    extension ApplyFilterVC: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            guard self.postCollectionArray.count != 0  else {
                collectionView.setEmptyView_new(title: "", message: "No data Found!".localiz(), image: UIImage(named: "filterPlaceHolder"))
                
                return 0
            }
            collectionView.backgroundView = nil
            return postCollectionArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResturantCell", for: indexPath) as? ResturantCell else
            { return UICollectionViewCell()
            }
            cell.data = self.postCollectionArray[indexPath.row]
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            return CGSize(width: screenWidth/2, height:180)
            
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
            
            
            let  VC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
            VC.postCollectionDummyArray = self.postCollectionArray
            VC.videoIndexPath = indexPath
            VC.isFromProfile = true
            //VC.delegate = self
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            guard indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 else { return }
            if  hasFetchedAll { return }
            pageCount += 1
            offset += 20
            searchPublicPosts(page: pageCount, searchKey: searchText)
        }
    }
    extension ApplyFilterVC: FloatingVCDelegate {
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
    extension ApplyFilterVC {
        //API Call
        
//        func getAllAccountType() {
//            var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
//            let parameters:[String:String] = [:]
//            StoreAPIManager.accountTypeAPI(parameters: parameters) { result in
//                switch result.status {
//                case "1":
//                    self.accountData = result.oData ?? []
//                default:
//                    Utilities.showWarningAlert(message: result.message ?? "") {
//
//                    }
//                }
//            }
//        }
        //MARK: - Socket Calls
        
        func searchPublicPosts(page:Int,searchKey:String){
            let parameter = ["userId": SessionManager.getUserData()?.id ?? "0",
                             "limitPerPage": initialPageCount ,
                             "offset":  offset,
                             "fUserType":userTypeString,
                             "keyword":searchKey,
                             "account_type_id":accountID,
                             "activity_type_id":activityID,
                             "check_in":checkInDate,
                             "check_out":checkOutDate,
                             "sel_lattitude":Lat,
                             "sel_longitude":long,
                             "price_range_from":"\(Int(minValue))",
                             "price_range_to":"\(Int(maxValue))",
                             "city_id":cityID,
                             "rating":rating] as [String : Any]
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
                        self?.resutCountLabel.text = "\(decodedArray.totalPostCount ?? "0") \("Results showing".localiz())"
                        self?.productCollection.reloadData()
                    }else{
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    extension ApplyFilterVC: UITextFieldDelegate {
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            if let text = textField.text,
               let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                searchText = updatedText
                Constants.shared.searchHashTagText = updatedText
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
    extension ApplyFilterVC: PopupProtocol{
        func openPopup() {
            if SessionManager.isLoggedIn() {
                //self.checkUserProductExistOrNotAPI()
            }else{
                let tabbar = tabBarController as? TabbarController
                tabbar?.hideTabBar()
                Coordinator.setRoot(controller: self)
            }
        }
    }
