//
//  ResturantListViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 19/01/2023.
//

import UIKit
import FittedSheets
import SDWebImage
import CoreImage

class CategoryDetailsList: UIViewController {
    
    
    @IBOutlet weak var headingLabel: UILabel!
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
    
    private var initialPageCount = 20
    var isStoreButtonClicked:Bool = false
    var searchText:String = ""
    var userTypeString:String = ""
    var accountTypeID:String = ""
    var activityTypeID:Int = 0
    var heading:String = ""
    var selectedColor:String = ""
    var unselectedColor:String = ""
    var individualID:String = ""
    
    var pageCount = 1
    var hasFetchedAll = false
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = heading.localiz()
        searchStringTextField.placeholder = "Search what you need...".localiz()
        // scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("openOptionsDiscover"), object: nil)
//        topOptionsArray.append(TopOptions(name: "Hotel",selectedImg: "hotel",unselectedImg: "hotelSelected"))
//        topOptionsArray.append(TopOptions(name: "Chalet",selectedImg: "chelate",unselectedImg: "chelate12"))
//        topOptionsArray.append(TopOptions(name: "Ground",selectedImg: "stadium 1",unselectedImg: "stadium"))
//        topOptionsArray.append(TopOptions(name: "Pools",selectedImg: "Your Icons",unselectedImg: "Your Icons 1"))
        setProductCell()
        if accountTypeID == "3"{
            self.topCollection.isHidden = true
        }else{
            self.topCollection.isHidden = false
        }
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
    var activityData:[ActicityData]?{
        didSet{
            self.topCollection.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
        self.getAllActivityType()
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
      
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        
    }
    
   
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filter(_ sender: UIButton) {
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "FilterView") as! FilterView
        VC.userType = userTypeString
        VC.selectedAccountID = "\(accountTypeID)"
        VC.selectedActivityID = "\(activityTypeID)"
        VC.searchText = searchText
        VC.individualID = individualID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    
}
extension CategoryDetailsList: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollection {
            guard self.postCollectionArray.count != 0  else {
                collectionView.setEmptyView_new(title: "", message: "No data Found!".localiz(), image: UIImage(named: "filterPlaceHolder"))
                
                return 0
            }
            collectionView.backgroundView = nil
            return postCollectionArray.count
        }else {
            return activityData?.count ?? 0
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
            cell.profileNameLabel.text = activityData?[indexPath.row].name ?? ""
            if self.isSelected == indexPath.row {
                cell.profileNameLabel.textColor = UIColor(hex: "F6B400")
                cell.postImageView.backgroundColor = UIColor(hex: selectedColor)
                cell.img.sd_setImage(with: URL(string: activityData?[indexPath.row].activity_type_image ?? "")){ image, error, cache, url in
                    if error == nil {
                        cell.img.image = image
                        // Set the tint color
                        let tintColor = UIColor.white // Change this to your desired tint color
                        // Apply the template rendering mode with tint color
                        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                        cell.img.tintColor = tintColor
                        cell.img.image = tintedImage
                    }else {
                        cell.img.image = UIImage(named:"placeholder_profile" )
                    }
                }
            }else {
                cell.profileNameLabel.textColor = UIColor(hex: "313131")
                cell.postImageView.backgroundColor = UIColor(hex: unselectedColor)
                ///cell.img.image = UIImage(named: activityData?[indexPath.row].activity_type_image ?? "")
                cell.img.sd_setImage(with: URL(string: activityData?[indexPath.row].activity_type_image ?? "")){ image, error, cache, url in
                    
                    if error == nil {
                        cell.img.image = image
                        // Set the tint color
                        let tintColor = UIColor.init(hexString: "#F6B400") // Change this to your desired tint color
                        // Apply the template rendering mode with tint color
                        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                        cell.img.tintColor = tintColor
                        cell.img.image = tintedImage
                    }else {
                        cell.img.image = UIImage(named:"placeholder_profile" )
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
            let screenWidth = screenSize.width - 5
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
            
            if self.isSelected == indexPath.row{
                self.activityTypeID = 0
                self.isSelected = -1
            }else{
                self.activityTypeID = self.activityData?[indexPath.row].id ?? 0
                self.isSelected = indexPath.row
            }
            self.topCollection.reloadData()
            DispatchQueue.main.async {
                self.resetPage()
                self.searchPublicPosts(page: 1, searchKey: self.searchText)
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
extension CategoryDetailsList: FloatingVCDelegate {
    func goToLive() {
        Coordinator.goToLive(controller: self)
    }
    func goToVideo() {
        Coordinator.goToTakeVideo(controller: self)
    }
    func goToImage() {
        Coordinator.goToTakePicture(controller: self)
    }
    
    func imageColorChange(image:UIImage) -> UIImage{
        
        if let ciImage = CIImage(image: image) {
            let context = CIContext(options: nil)
            
            // Create a color filter to change white to yellow
            if let colorFilter = CIFilter(name: "CIColorControls") {
                colorFilter.setValue(ciImage, forKey: kCIInputImageKey)
                
                // Adjust the color values to achieve yellow color
                colorFilter.setValue(CIColor(red: 1.0, green: 1.0, blue: 0.0), forKey: kCIInputColorKey) // Yellow color
                
                // Get the output CIImage
                if let outputCIImage = colorFilter.outputImage {
                    // Render the output CIImage to a UIImage
                    if let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
                        let outputImage = UIImage(cgImage: outputCGImage)
                        // Now you have the white image changed to yellow
                        return outputImage
                    }
                }
            }
        }
        return UIImage()
    }
}
extension CategoryDetailsList {
    
    //API Call
    
    func getAllActivityType() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [:]
      
        StoreAPIManager.activityTypeAPI(parameters: parameters,id: accountTypeID,individual_id: individualID) { result in
            switch result.status {
            case "1":
                self.activityData = result.oData ?? []
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
                         "keyword":searchKey,
                         "fUserType":userTypeString,
                         "account_type_id":accountTypeID,
                         "activity_type_id":activityTypeID] as [String : Any]
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
extension CategoryDetailsList: UITextFieldDelegate {
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
extension CategoryDetailsList: PopupProtocol{
    func openPopup() {
        if SessionManager.isLoggedIn() {
           // self.checkUserProductExistOrNotAPI()
        }else{
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
    }
}
