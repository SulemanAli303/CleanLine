//
//  FilterView.swift
//  LiveMArket
//
//  Created by Zain on 18/08/2023.
//

import UIKit
import AlignedCollectionViewFlowLayout
import CoreLocation
import MultiSlider
import DatePickerDialog
import DropDown

class FilterView: UIViewController {
    
    @IBOutlet weak var maxcurrencyLabel: UILabel!
    @IBOutlet weak var minicurrencyLabel: UILabel!
    @IBOutlet weak var searchTextFeild: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var checkInCheckOutView: UIView!
    @IBOutlet weak var aminitiesView: UIView!
    @IBOutlet weak var cityBgView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var priceSlider: MultiSlider!
    @IBOutlet weak var priceHighLabel: UILabel!
    @IBOutlet weak var priceLowLabel: UILabel!
    @IBOutlet weak var checkOutTextField: UITextField!
    @IBOutlet weak var checkInTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var PriceImg: UIImageView!
    @IBOutlet weak var RatingImg: UIImageView!
    @IBOutlet weak var amenityImg: UIImageView!
    @IBOutlet weak var sortImg: UIImageView!
    @IBOutlet weak var sortDetails: UIView!
    @IBOutlet weak var PriceDetails: UIView!
    @IBOutlet weak var topCollection: UICollectionView!
    @IBOutlet weak var CategotycollectionView: IntrinsicCollectionView!
    @IBOutlet weak var amenitiesCollection: IntrinsicCollectionView!
    @IBOutlet weak var RatingCollection: IntrinsicCollectionView!
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    
    var topOptionsArray = [TopOptions]()
    var amenitiesArray = [amenitiesOption]()
    var catArray = [String]()
    var selectedCategortArray:[Int] = []
    var SelectedAccountType:[Int] = []
    var isSelectedRating = -1
   
    var aminity_list : [Aminity_list] = []
    var ratingArray = ["5","4","3","2","1"]
    var userType:String = ""
    
    var selectedLat = ""
    var selectedlong = ""
    var selectedActivityID:String = ""
    var selectedAccountID:String = ""
    var cityID:String = ""
    var selectedAminities:[String] = []
    var selectedStarRating:String = ""
    var priceMinValue:Int = 0
    var priceMaxValue:Int = 0
    var selectedRating:String = ""
    var minivalue:Double = 0
    var maxvalue:Double = 0
    var searchText:String = ""
    var selectedColors = ["#9A8ED4","#8EB2D4","#F1B8A0","#8ED4BA"]
    var unselectedColors = ["#E7E2FD","#E2EFFD","#FFE7DA","#E2FDF3"]
    var individualID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLanguage()
//        catArray.append("Hotel")
//        catArray.append("Chalet")
//        catArray.append("Ground")
//        catArray.append("Pools")
        
//        amenitiesArray.append(amenitiesOption(name: "Parking",img: "Car"))
//        amenitiesArray.append(amenitiesOption(name: "Bath",img: "Group 236463"))
//        amenitiesArray.append(amenitiesOption(name: "Bar",img: "Group 236466"))
//        amenitiesArray.append(amenitiesOption(name: "Wifi",img: "Group 236462"))
//        amenitiesArray.append(amenitiesOption(name: "Gym",img: "Group 236461"))
        
//        topOptionsArray.append(TopOptions(name: "Reservations",selectedImg: "Group 236455",unselectedImg: "Group 236454"))
//        topOptionsArray.append(TopOptions(name: "Services",selectedImg: "service",unselectedImg: "serviceSelected"))
//        topOptionsArray.append(TopOptions(name: "Shopping",selectedImg: "shop",unselectedImg: "shop 1"))
//        topOptionsArray.append(TopOptions(name: "Subsciptions",selectedImg: "gym",unselectedImg: "gym 1"))
        SelectedAccountType.removeAll()
        selectedCategortArray.removeAll()
        SelectedAccountType.append(Int(selectedAccountID ) ?? 0)
        selectedCategortArray.append(Int(selectedActivityID) ?? 0)
        setProductCell()
        
        
        aminitiesView.isHidden = true
        checkInCheckOutView.isHidden = true
        if selectedCategortArray.count > 0{
            CategotycollectionView.isHidden = false
        }else{
            CategotycollectionView.isHidden = true
        }
        
        if SelectedAccountType.count > 0{
            self.getAllActivityType(activityID: "\(self.SelectedAccountType.first ?? 0)")
        }
        
        if selectedAccountID == "3"{
            topCollection.isHidden = true
            CategotycollectionView.isHidden = true
            aminitiesView.isHidden = true
            checkInCheckOutView.isHidden = true
            locationView.isHidden = true
            ratingView.isHidden = true
            getFilterData()
            
        }else{
            getAllAccountType()
        }
        topCollection.reloadData()
        CategotycollectionView.reloadData()
    }
    
    func configLanguage(){
        filterLabel.text = "Filter".localiz()
        clearAllButton.setTitle("Clear all".localiz(), for: .normal)
        searchTextFeild.placeholder = "Search what you need...".localiz()
        locationTextField.placeholder = "Location".localiz()
        checkInTextField.placeholder = "Check in".localiz()
        checkOutTextField.placeholder = "Check out".localiz()
        cityTextField.placeholder = "City".localiz()
        
        applyButton.setTitle("Apply Fliter".localiz(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let tabbar = tabBarController as? TabbarController
        if Constants.shared.searchHashTagText != ""{
            searchTextFeild.text = Constants.shared.searchHashTagText
            
        }else{
            searchTextFeild.text = searchText
        }
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        priceMinValue = Int(slider.value.min() ?? 0.0)
        priceMaxValue = Int(slider.value.max() ?? 0.0)
        print(" mini = \(priceMinValue) max= \(priceMaxValue)" )
    }
    var accountData:[AccountData]?{
        didSet{
            if accountData?.contains(where: {$0.id == 6}) == true{
                guard let index = accountData?.firstIndex(where: {$0.id == 6}) else { return  }
                accountData?.remove(at: index)
            }
            //check individual account type and remove it// Adnan - 12-03-24
            if accountData?.contains(where: {$0.id == 3}) == true{
                guard let index = accountData?.firstIndex(where: {$0.id == 3}) else { return  }
                accountData?.remove(at: index)
            }
            self.topCollection.reloadData()
        }
    }
    var activityData:[ActicityData]?{
        didSet{
            if activityData?.count ?? 0 > 0{
                self.CategotycollectionView.isHidden = false
            }else{
                self.CategotycollectionView.isHidden = true
            }
            self.CategotycollectionView.reloadData()
        }
    }
    var filterData:FilterData?{
        didSet{
//            priceLowLabel.text = filterData?.price?.from ?? ""
//            priceHighLabel.text = filterData?.price?.to ?? ""
            minicurrencyLabel.text = filterData?.currency_code ?? ""
            maxcurrencyLabel.text = filterData?.currency_code ?? ""
            
            minivalue = Double(filterData?.price?.from ?? "") ?? 0
            maxvalue = Double(filterData?.price?.to ?? "") ?? 0
            priceSlider.minimumValue = CGFloat(minivalue)
            priceSlider.maximumValue = CGFloat(maxvalue)
            aminity_list = filterData?.aminity_list ?? []
            amenitiesCollection.reloadData()
            
            priceSlider.orientation = .horizontal
            priceSlider.minimumValue = minivalue
            priceSlider.maximumValue = maxvalue
            priceSlider.outerTrackColor = .lightGray
            priceSlider.value = [minivalue, maxvalue]
            priceSlider.valueLabelPosition = .top
            priceSlider.tintColor = Color.darkOrange.color()
            priceSlider.trackWidth = 5
            priceSlider.showsThumbImageShadow = false
           // priceSlider.valueLabelAlternatePosition = true

            priceSlider.keepsDistanceBetweenThumbs = false
            priceSlider.valueLabelFormatter.positiveSuffix = ""
            priceSlider.valueLabelColor = Color.darkOrange.color()
            priceSlider.valueLabelFont = UIFont(name: "Roboto-Regular", size: 10)


            priceSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        }
    }
    
//    var cityData:CityData?{
//        didSet{
//            cityNamesArray.removeAll()
//            for index in 0..<(cityData?.list?.count ?? 0){
//                cityNamesArray.append(cityData?.list?[index].name ?? "")
//            }
//            
//            if cityNamesArray.count > 0{
//                cityDropDown.dataSource = cityNamesArray
//                // The view to which the drop down will appear on
//                cityDropDown.anchorView = cityBgView// UIView
//                cityDropDown.direction = .any
//                cityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//                   // self..text = item
//                    self.cityTextField.text = item
//                    self.cityID = self.cityData?.list?[index].id ?? ""
//                }
//                
//                cityDropDown.semanticContentAttribute = .forceLeftToRight
//                cityDropDown.dismissMode = .onTap
//                cityDropDown.show()
//            }else{
//                
//            }
//            
//        }
//    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Apply(_ sender: UIButton) {
        //Coordinator.goToApplyFilter(controller: self)
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "ApplyFilterVC") as! ApplyFilterVC
        VC.long = selectedlong
        VC.Lat = selectedLat
        VC.minValue = priceMinValue
        VC.maxValue = priceMaxValue
        VC.accountID = "\(SelectedAccountType.first ?? 0)"
        VC.activityID = "\(selectedCategortArray.first ?? 0)"
        VC.rating = selectedRating
        VC.cityID = cityID
        VC.aminities = selectedAminities
        VC.userTypeString = userType
        VC.checkInDate = self.checkInTextField.text ?? ""
        VC.checkOutDate = self.checkOutTextField.text ?? ""
        VC.searchText = searchTextFeild.text ?? ""
        VC.userTypeString = userType 
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func setProductCell() {
        topCollection.delegate = self
        topCollection.dataSource = self
        topCollection.register(UINib.init(nibName: "topOptionsCell", bundle: nil), forCellWithReuseIdentifier: "topOptionsCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        self.topCollection.collectionViewLayout = layout2
        self.topCollection.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.CategotycollectionView.collectionViewLayout = layout
        self.CategotycollectionView.reloadData()
        self.CategotycollectionView.layoutIfNeeded()
        
        CategotycollectionView.isScrollEnabled = true
        CategotycollectionView.delegate = self
        CategotycollectionView.dataSource = self
        CategotycollectionView.register(UINib.init(nibName: "FilterCategoryName", bundle: nil), forCellWithReuseIdentifier: "FilterCategoryName")
        
        amenitiesCollection.delegate = self
        amenitiesCollection.dataSource = self
        amenitiesCollection.register(UINib.init(nibName: "AmenitiesOptionCell", bundle: nil), forCellWithReuseIdentifier: "AmenitiesOptionCell")
        
        

        
        let layout3 = UICollectionViewFlowLayout()
        layout3.scrollDirection = .vertical
        layout3.minimumInteritemSpacing = 0
        layout3.minimumLineSpacing = 0
        self.amenitiesCollection.collectionViewLayout = layout3
        self.amenitiesCollection.reloadData()
        self.amenitiesCollection.layoutIfNeeded()
        
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        alignedFlowLayout.scrollDirection = .vertical
        alignedFlowLayout.minimumInteritemSpacing = 0
        alignedFlowLayout.minimumLineSpacing = 0
        RatingCollection.delegate = self
        RatingCollection.dataSource = self
        RatingCollection.register(UINib.init(nibName: "RatingCells", bundle: nil), forCellWithReuseIdentifier: "RatingCells")
        self.RatingCollection.collectionViewLayout = alignedFlowLayout
        self.RatingCollection.reloadData()
        self.RatingCollection.layoutIfNeeded()
        
    }
    @IBAction func sortClick(_ sender: UIButton) {
        self.sortDetails.isHidden = !self.sortDetails.isHidden
        if sortDetails.isHidden {
            self.sortImg.image = UIImage(named: "Path 321565")
        }else {
            self.sortImg.image = UIImage(named: "Path 321567")
        }
    }
    @IBAction func amenityClick(_ sender: UIButton) {
        self.amenitiesCollection.isHidden = !self.amenitiesCollection.isHidden
        if amenitiesCollection.isHidden {
            self.amenityImg.image = UIImage(named: "Path 321565")
        }else {
            self.amenityImg.image = UIImage(named: "Path 321567")
        }
    }
    @IBAction func RatingClick(_ sender: UIButton) {
        self.RatingCollection.isHidden = !self.RatingCollection.isHidden
        if RatingCollection.isHidden {
            self.RatingImg.image = UIImage(named: "Path 321565")
        }else {
            self.RatingImg.image = UIImage(named: "Path 321567")
        }
    }
    @IBAction func PriceClick(_ sender: UIButton) {
        self.PriceDetails.isHidden = !self.PriceDetails.isHidden
        if PriceDetails.isHidden {
            self.PriceImg.image = UIImage(named: "Path 321565")
        }else {
            self.PriceImg.image = UIImage(named: "Path 321567")
        }
    }
    @IBAction func checkOutClick(_ sender: UIButton) {
        DatePickerDialog().show("Select Date".localiz(), doneButtonTitle: "Done".localiz(), cancelButtonTitle: "Cancel".localiz(),minimumDate: Date(), datePickerMode: .date) { date in
            if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    self.checkOutTextField.text = formatter.string(from: dt)
                   // self.timeField.text = ""
            }
        }
    }
    @IBAction func checkInClick(_ sender: UIButton) {
        DatePickerDialog().show("Select Date".localiz(), doneButtonTitle: "Done".localiz(), cancelButtonTitle: "Cancel".localiz(),minimumDate: Date(), datePickerMode: .date) { date in
            if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    self.checkInTextField.text = formatter.string(from: dt)
                    //self.timeField.text = ""
            }
        }
    }
    @IBAction func locationClick(_ sender: UIButton) {
        let VC = AppStoryboard.UserServicesBooking.instance.instantiateViewController(withIdentifier: "ServicesLocation") as! ServicesLocation
        VC.delegate = self
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func cityClick(_ sender: UIButton) {
        //self.getAllCity()
        
        let  VC = AppStoryboard.ResturantList.instance.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
        VC.delegate = self
        self.navigationController?.pushViewController(VC, animated: true)

    }
    @IBAction func clearAllAction(_ sender: UIButton) {
        clearAllValues()
    }
    
    func clearAllValues(){
        selectedLat = ""
        selectedlong = ""
        selectedActivityID = ""
        selectedAccountID = ""
        cityID = ""
        selectedAminities.removeAll()
        selectedStarRating = ""
        priceMinValue = 0
        priceMaxValue = 0
        selectedRating = ""
        
        checkInTextField.text = ""
        checkOutTextField.text = ""
        cityTextField.text = ""
        locationTextField.text = ""
        priceSlider.minimumValue = CGFloat(minivalue)
        priceSlider.maximumValue = CGFloat(maxvalue)
        
        SelectedAccountType.removeAll()
        selectedCategortArray.removeAll()
         isSelectedRating = -1
        
        topCollection.reloadData()
        CategotycollectionView.reloadData()
        RatingCollection.reloadData()
        amenitiesCollection.reloadData()
    }
}

extension FilterView{
    func getAllAccountType() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [:]
        var idValue:String = ""
        if userType == "user"{
            idValue = "2"
        }else{
            idValue = "1"
        }
        
        StoreAPIManager.accountTypeAPI(parameters: parameters, id: idValue) { result in
            self.getFilterData()
            switch result.status {
                
            case "1":
                self.accountData = result.oData ?? []
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getAllActivityType(activityID:String) {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [:]
      
        StoreAPIManager.activityTypeAPI(parameters: parameters,id: activityID, individual_id: individualID) { result in
            switch result.status {
            case "1":
                self.activityData = result.oData ?? []
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func getFilterData() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token":SessionManager.getAccessToken() ?? ""
        ]
      
        StoreAPIManager.getFilterDataAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.filterData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension FilterView: ServicesLocationDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String) {
        self.locationTextField.text = address
        let center = CLLocation (latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.selectedlong = String(center.coordinate.longitude)
        self.selectedLat = String(center.coordinate.latitude)
    }
}
extension FilterView: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollection {
            return accountData?.count ?? 0
        }else if collectionView == CategotycollectionView {
            return self.activityData?.count ?? 0
        }else if collectionView == amenitiesCollection {
            return aminity_list.count
        }else if collectionView == RatingCollection {
            return 5
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CategotycollectionView
        {
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCategoryName", for: indexPath) as? FilterCategoryName else { return UICollectionViewCell() }
            
            if selectedCategortArray.contains(self.activityData?[indexPath.row].id ?? 0){
                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#F6B400")
                topCategoriesCell.namelbl.alpha = 1.0
                topCategoriesCell.outView.layer.borderColor = UIColor.init(hex: "#F6B400").cgColor
            }else{
                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#313131")
                topCategoriesCell.namelbl.alpha = 1.0
                topCategoriesCell.outView.layer.borderColor = UIColor.init(hex: "#E2E2E2").cgColor
            }
            
            topCategoriesCell.namelbl.text = self.activityData?[indexPath.row].name ?? ""
            topCategoriesCell.layoutSubviews()
            topCategoriesCell.layoutIfNeeded()
            
            return topCategoriesCell
        }else if collectionView == amenitiesCollection {
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenitiesOptionCell", for: indexPath) as? AmenitiesOptionCell else { return UICollectionViewCell() }
//            switch indexPath.row {
//            case isSelectedCategory:
//                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#F6B400")
//                topCategoriesCell.namelbl.alpha = 1.0
//                topCategoriesCell.outView.layer.borderColor = UIColor.init(hex: "#F6B400").cgColor
//            default:
//
//            }
            
            if selectedAminities.contains(self.aminity_list[indexPath.row].id ?? ""){
                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#F6B400")
                topCategoriesCell.namelbl.alpha = 1.0
                topCategoriesCell.outView.layer.borderColor = UIColor.init(hex: "#F6B400").cgColor
            }else{
                topCategoriesCell.namelbl.textColor = UIColor.init(hex: "#313131")
                topCategoriesCell.namelbl.alpha = 1.0
                topCategoriesCell.outView.layer.borderColor = UIColor.init(hex: "#E2E2E2").cgColor
            }
            topCategoriesCell.configure(with: self.aminity_list[indexPath.row].name ?? "")
            topCategoriesCell.leftImg.sd_setImage(with: URL(string: self.aminity_list[indexPath.row].icon ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_profile"))
            topCategoriesCell.layoutSubviews()
            topCategoriesCell.layoutIfNeeded()
            
            return topCategoriesCell
        }else if collectionView == RatingCollection {
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingCells", for: indexPath) as? RatingCells else { return UICollectionViewCell() }
            switch indexPath.row {
            case isSelectedRating:
                topCategoriesCell.outView.layer.borderColor = UIColor.init(hex: "#F6B400").cgColor
            default:
              
                topCategoriesCell.outView.layer.borderColor = UIColor.init(hex: "#E2E2E2").cgColor
            }
            topCategoriesCell.rating.rating = Double(ratingArray[indexPath.row] ?? "1") ?? 0
            topCategoriesCell.layoutSubviews()
            topCategoriesCell.layoutIfNeeded()
            
            return topCategoriesCell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topOptionsCell", for: indexPath) as? topOptionsCell else
            { return UICollectionViewCell()
            }
            cell.profileNameLabel.text = accountData?[indexPath.row].capitalized_name ?? ""
            if SelectedAccountType.contains(accountData?[indexPath.row].id ?? 0){
                cell.profileNameLabel.textColor = UIColor(hex: "F6B400")
                cell.postImageView.backgroundColor = UIColor(hex: selectedColors[indexPath.row])
                cell.img.sd_setImage(with: URL(string: accountData?[indexPath.row].image ?? "")){ image, error, cache, url in
                    if error == nil {
                        cell.img.image = image
                        // Set the tint color
                        let tintColor = UIColor.white // Change this to your desired tint color
                        // Apply the template rendering mode with tint color
                        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                        cell.img.tintColor = tintColor
                        cell.img.image = tintedImage
                    }else {
                        cell.img.image = UIImage(named: "placeholder_profile")
                    }
                }
            }else{
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
                        cell.img.image = UIImage(named: "placeholder_profile")
                    }
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == CategotycollectionView {
            
            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCategoryName", for: indexPath) as? FilterCategoryName else { return CGSize.zero}
            topCategoriesCell.namelbl.text = self.activityData?[indexPath.row].name ?? ""
            topCategoriesCell.setNeedsLayout()
            topCategoriesCell.layoutIfNeeded()
            let size: CGSize = topCategoriesCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: size.width, height: 40)
        }else if collectionView == amenitiesCollection {
            
//            guard let topCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenitiesOptionCell", for: indexPath) as? AmenitiesOptionCell else { return CGSize.zero}
//            topCategoriesCell.namelbl.text = self.aminity_list[indexPath.row].name ?? ""
//            topCategoriesCell.setNeedsLayout()
//            topCategoriesCell.layoutIfNeeded()
//            let size: CGSize = topCategoriesCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//            return CGSize(width: size.width, height: 40)
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            return CGSize(width: (150), height:40)

        }else if collectionView == RatingCollection {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            return CGSize(width: (150), height:40)
        }else {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            return CGSize(width: (screenWidth/4), height:150)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == amenitiesCollection {
            return 10
        }else if collectionView == RatingCollection {
            return 10
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == amenitiesCollection {
            return 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == topCollection {
            self.clearAllValues()
            DispatchQueue.main.async {
                self.selectedCategortArray.removeAll()
                self.SelectedAccountType.removeAll()
                self.SelectedAccountType.append(self.accountData?[indexPath.row].id ?? 0)
                self.topCollection.reloadData()
                self.selectedAccountID = "\(self.accountData?[indexPath.row].id ?? 0)"
                self.getAllActivityType(activityID: "\(self.accountData?[indexPath.row].id ?? 0)")
                self.CategotycollectionView.reloadData()
                if self.selectedAccountID == "2"{
                    self.aminitiesView.isHidden = false
                    self.checkInCheckOutView.isHidden = false
                }else{
                    self.aminitiesView.isHidden = true
                    self.checkInCheckOutView.isHidden = true
                }
            }
            
            
        }else  if collectionView == CategotycollectionView {
            self.selectedCategortArray.removeAll()
            self.selectedCategortArray.append(self.activityData?[indexPath.row].id ?? 0)
            self.CategotycollectionView.reloadData()
        }else if collectionView == RatingCollection {
            self.isSelectedRating = indexPath.row
            self.selectedRating = ratingArray[indexPath.row]
            self.RatingCollection.reloadData()
        }else if collectionView == amenitiesCollection{
            if selectedAminities.contains(self.aminity_list[indexPath.row].id ?? ""){
                guard let index = selectedAminities.firstIndex(of: self.aminity_list[indexPath.row].id ?? "") else { return  }
                selectedAminities.remove(at: index)
            }else{
                selectedAminities.append(self.aminity_list[indexPath.row].id ?? "")
            }
            self.amenitiesCollection.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension FilterView:CityUpdateProtocol{
    func updateCityName(cityData: CityList) {
        self.cityTextField.text = cityData.name ?? ""
        self.cityID = cityData.id ?? ""
    }
}
extension FilterView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            searchText = updatedText
            Constants.shared.searchHashTagText = updatedText
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
