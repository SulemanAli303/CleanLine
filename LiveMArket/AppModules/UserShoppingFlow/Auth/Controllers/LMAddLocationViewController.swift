//
//  LMAddLocationViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 03/01/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import DropDown


class LMAddLocationViewController: BaseViewController {
    
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var stbtn: UIButton!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: CreateAccountProgress! {
        didSet {
            progressView.backgroundColor  = .clear
        }
    }
    @IBOutlet weak var mapContainerView: GMSMapView!
    private var mapView: GMSMapView!
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var searchLocationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var countryList : [CountryObj] = []
    var selectedCountryObj : CountryObj?
    
    var cityList : [CityObj] = []
    var selectedCityObj : CityObj?
    
    var cityDropDown = DropDown()
    var countryDropDown = DropDown()
    var cityBounds : GMSCoordinateBounds?
    
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation? {
        didSet {
            if let coordinate = currentLocation?.coordinate {
                let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
                self.mapContainerView?.animate(to: camera)
                mapContainerView.delegate = self
            }
        }
    }
    var locationCoordinates: CLLocation? {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithoutTitle
        setInterface()
        getCountriesList()
        configueLanguage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - Methode
    func setInterface() {
        if UIDevice.current.hasNotch {
            topViewHeight.constant = 140
        } else {
            topViewHeight.constant = 100
        }
        progressView.selectedTab = 2
        addMapView()
    }
    
    func configueLanguage(){
        searchLocationLabel.text = "SEARCH LOCATION".localiz()
        countryTextField.placeholder = "Country".localiz()
        cityTextField.placeholder = "City".localiz()
        
        backButton.setTitle("Back".localiz(), for: .normal)
        continueButton.setTitle("Continue".localiz(), for: .normal)
    }
    
    //MARK: - Methods
    func addMapView() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        mapContainerView.layer.cornerRadius = 12
        mapContainerView.layer.masksToBounds = true
        mapContainerView.isMyLocationEnabled = true
        mapContainerView.delegate = self
    }
    //MARK: - Actions
    @IBAction func nextAction(_ sender: Any) {
        
        let pointToCheck = CLLocationCoordinate2D(latitude: locationCoordinates?.coordinate.latitude ?? 0.0, longitude: locationCoordinates?.coordinate.longitude ?? 0.0)
        
        if locationCoordinates == nil {
            Utilities.showQuestionAlert(message: "Please select location".localiz())
        }else {
            if let bounds = cityBounds {
                if bounds.contains(pointToCheck) {
                    let parameters:[String:String] = [
                        "lattitude" : String(locationCoordinates?.coordinate.latitude ?? 0.0),
                        "longitude" : String(locationCoordinates?.coordinate.longitude ?? 0.0),
                        "location_name" : self.txtAddress.text ?? "",
                        //"user_id" : String(SessionManager.getUserData()?.id ?? 0),
                        "user_id" : String(SessionManager.getUserData()?.id ?? ""),
                        "city_id":self.selectedCityObj?.id ?? "",
                        "country_id":"\(self.selectedCountryObj?.id ?? 0)",
                        "temp_user_id" : String(SessionManager.getUserData()?.id ?? ""),

                    ]
                    AuthenticationAPIManager.addLocationAPIV2(parameters: parameters) { result in
                        switch result.status {
                        case "1":
                            //  Utilities.showSuccessAlert(message: result.message ?? "") {
                            Coordinator.goToRegisterSuccessPage(controller: self)
                            // }
                        default:
                            Utilities.showWarningAlert(message: result.message ?? "") {
                                
                            }
                        }
                    }
                }else{
//                    Utilities.showQuestionAlert(message: "Your location is outside the \(self.selectedCityObj?.name ?? "") city. Please choose location with this city.")
                    Utilities.showQuestionAlert(message: "\( "Your location is outside the".localiz() ) \(self.selectedCityObj?.name ?? "") \( "city. Please choose location with this city.".localiz() )")
                }
            }else{
//                Utilities.showQuestionAlert(message: "Your location is outside the \(self.selectedCityObj?.name ?? "") city. Please choose location with this city.")
                Utilities.showQuestionAlert(message: "\( "Your location is outside the".localiz() ) \(self.selectedCityObj?.name ?? "") \( "city. Please choose location with this city.".localiz() )")
            }
            
        }
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func currntLoc(_ sender: Any) {
        self.locationManager.startUpdatingLocation()
    }
    @IBAction func satliet(_ sender: Any) {
        if self.mapContainerView.mapType == .satellite {
            self.mapContainerView.mapType = .normal
            self.stbtn.setImage(UIImage(named: "satlite"), for: .normal)
        }else if self.mapContainerView.mapType == .normal  {
            self.mapContainerView.mapType = .satellite
            self.stbtn.setImage(UIImage(named: "simple"), for: .normal)
        }
        
    }
    @IBAction func searhBtn(_ sender: Any) {
        
        var countryCode = ""
        if let country = self.selectedCountryObj {
            countryCode = country.oDatumPrefix ?? ""
        }
        
        var cityName = ""
        if let city = self.selectedCityObj {
            cityName = city.name ?? ""
        }
        
        //Utilities.presentPlacePicker(vc: self,countryCode: countryCode,cityName: cityName,cityBounds: self.cityBounds)
        
        let placePickerVC = UIStoryboard(name: "PlacePicker", bundle: nil).instantiateViewController(withIdentifier: "ODAddressPickerViewController") as! ODAddressPickerViewController

        placePickerVC.delegate = self
        placePickerVC.titleString = "Select Location".localiz()
        placePickerVC.countryCode = countryCode
        placePickerVC.cityName = cityName
        placePickerVC.cityBounds = self.cityBounds
        let navVC = UINavigationController.init(rootViewController: placePickerVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
        
    }
    
    @IBAction func countryBtnAction(_ sender: Any) {
        
        var items : [String] = []
        for index in 0..<(countryList.count){
            items.append(countryList[index].name ?? "")
        }
        
        if items.count > 0{
            countryDropDown.dataSource = items
            // The view to which the drop down will appear on
            countryDropDown.anchorView = countryView// UIView
            countryDropDown.direction = .any
            countryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               // self..text = item
                self.countryTextField.text = item
                //self.cityID = self.cityData?.list?[index].id ?? ""
                self.selectedCountryObj = self.countryList[index]
                self.selectedCityObj = nil
                self.cityList.removeAll()
                self.cityTextField.text = ""
                self.getCitiesList()
            }
            
            countryDropDown.semanticContentAttribute = .forceLeftToRight
            countryDropDown.dismissMode = .onTap
            countryDropDown.show()
        }else{
            
        }
        
    }
    
    @IBAction func cityBtnAction(_ sender: Any) {
        
        var items : [String] = []
        for index in 0..<(cityList.count){
            items.append(cityList[index].name ?? "")
        }
        
        if items.count > 0{
            cityDropDown.dataSource = items
            // The view to which the drop down will appear on
            cityDropDown.anchorView = cityView// UIView
            cityDropDown.direction = .any
            cityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               // self..text = item
                self.cityTextField.text = item
                //self.cityID = self.cityData?.list?[index].id ?? ""
                self.selectedCityObj = self.cityList[index]
                self.setCameraPosition()

            }
            
            cityDropDown.semanticContentAttribute = .forceLeftToRight
            cityDropDown.dismissMode = .onTap
            cityDropDown.show()
        }else{
            
        }
    }
    
}
extension LMAddLocationViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let center = CLLocation (latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude)
        locationCoordinates = center
        let center2 = CLLocation (latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0)
        self.getAddress(loc:center)
      
    }
    func getAddress(loc:CLLocation) {
        var input = GInput()
        let destination = GLocation.init(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        input.destinationCoordinate = destination
        GoogleApi.shared.callApi(.reverseGeo , input: input) { (response) in
            if let places = response.data as? [GApiResponse.ReverseGio], response.isValidFor(.reverseGeo) {
                DispatchQueue.main.async {
                    self.txtAddress.text = places.first?.formattedAddress ?? ""
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
}
extension LMAddLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationCoordinates = currentLocation
        self.locationManager.stopUpdatingLocation()
        let center = CLLocation (latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0)
        self.getAddress(loc:center)
    }
}
extension LMAddLocationViewController: PlacePickerDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String) {
        self.txtAddress.text = address
        let center = CLLocation (latitude: coordinate.latitude, longitude: coordinate.longitude)
        locationCoordinates = center
        self.currentLocation = center
    }
}
extension LMAddLocationViewController {
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }

                        self.txtAddress.text = addressString
                        print(addressString)
                  }
            })

        }
}

extension LMAddLocationViewController {
    
    func getCountriesList(){
        
        AuthenticationAPIManager.getCountriesListAPI(parameters: [:]) { result in
            switch result.status {
            case "1":
                self.countryList = result.oData ?? []
                if(self.countryList.count > 0){
                    self.selectedCountryObj = self.countryList[0]
                    self.countryTextField.text = self.countryList[0].name
                    self.getCitiesList()
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
        
    }
    
    func getCitiesList(){
        
        if let countryObj = self.selectedCountryObj {
            
            let parameters:[String:String] = [
                "limit" : "10000",
                "page" : "1",
                "country_id" : "\(countryObj.id ?? 0)",
            ]
            
            AuthenticationAPIManager.getCitiesListAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.cityList = result.oData?.list ?? []
                    if(self.cityList.count > 0){
                        self.cityTextField.text = self.cityList[0].name
                        self.selectedCityObj = self.cityList[0]
                        self.setCameraPosition()
                    }
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
        
        
    }
    
    func setCameraPosition() {
        
        if let city = self.selectedCityObj {
            
            
            let locationString = city.name
            let apiKey = Config.googleApiKey
            
            guard let encodedLocation = locationString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return
            }
            
            let urlString = "https://maps.googleapis.com/maps/api/geocode/json?key=\(apiKey)&address=\(encodedLocation)"
            
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            if let results = json?["results"] as? [[String: Any]] , results.count > 0 {
                                if let geometry = results[0]["geometry"] as? [String: Any],
                                   let viewport = geometry["viewport"] as? [String: Any],
                                   let northeast = viewport["northeast"] as? [String: Double],
                                   let southwest = viewport["southwest"] as? [String: Double] {
                                    
                                    let bounds = GMSCoordinateBounds(
                                        coordinate: CLLocationCoordinate2D(latitude: southwest["lat"]!, longitude: southwest["lng"]!),
                                        coordinate: CLLocationCoordinate2D(latitude: northeast["lat"]!, longitude: northeast["lng"]!)
                                    )
                                    
                                    // Update the camera position and bounds
                                    DispatchQueue.main.async {
                                        self.cityBounds = bounds
                                        let camera = GMSCameraUpdate.fit(bounds)
                                        self.mapContainerView.moveCamera(camera)
                                    }
                                }
                                
                                if let geometry = results[0]["geometry"] as? [String: Any],
                                   let viewport = geometry["location"] as? [String: Any],
                                   let lat = viewport["lat"] as? [String: Double],
                                   let lng = viewport["lng"] as? [String: Double] {
                                    
                                }
                                
                            }
                            
                            
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                }.resume()
            }
        }
        
    }
    
    
}
