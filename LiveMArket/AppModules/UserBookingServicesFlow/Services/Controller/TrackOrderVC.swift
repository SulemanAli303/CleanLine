//
//  TrackOrderVC.swift
//  LiveMArket
//
//  Created by Zain on 20/05/2023.
//

import UIKit
import GoogleMaps
import GoogleMapsCore
import Firebase
import FirebaseDatabase
import CoreLocation
import MetalKit
class TrackOrderVC: BaseViewController {
    

    @IBOutlet weak var recenterButton: UIControl!
    @IBOutlet weak var lblDeliveryTIme: UILabel!
    @IBOutlet weak var lblTrackStatus: UILabel!
    @IBOutlet weak var mapTrackStatus: UILabel!
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
            mapView.settings.zoomGestures = true
            mapView.delegate = self
        }
    }
    @IBOutlet weak var mapTouch: UIImageView!
    @IBOutlet weak var callbtn: UIButton!
    
    var order_ID = ""
    var TrackType = ""
    var oldPolyLines = [GMSPolyline]()
    var driverMarker :GMSMarker?
    private let manager = CLLocationManager()
    var driverLoc : CLLocationCoordinate2D?
    var storeLoc : CLLocationCoordinate2D?
    var markers:[GMSMarker]?
    var dbRef : DatabaseReference?
    var hasDrawnRoute = false
    var hasMapSet = false
    var bearing: Double = 0.0
    var zoomLevel: Float = 20.0
    var isCameraChange = false
    var isCameraCentered = true

   var getDriverRequestDetail = false
    
    var myOrderData:MyOrderDetailsData?{
        didSet{
            
            if let status = myOrderData?.status, status == "6"
            {
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.markers = [GMSMarker]()
                self.fetchDriverLocation()
                self.configureLocationManager()
            }
        }
    }
    var myDriverOrder:DriverOrderDetailsData?{
        didSet{
            
            self.markers = [GMSMarker]()
            self.fetchDriverLocation()
            self.configureLocationManager()
        }
        
    }
    var servicesDetails : DelegateDetailsServicesData? {
        didSet {
            
            if let status = servicesDetails?.data?.serviceStatus, status == "5"
            {
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.markers = [GMSMarker]()
                self.fetchDriverLocation()
                self.configureLocationManager()
            }
        }
    }
    var serviceData : ServiceData? {
        didSet {
            if serviceData?.status == "5"{
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.markers = [GMSMarker]()
                self.fetchDriverLocation()
                self.configureLocationManager()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
       
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDriverLocationFromLocationManager), name: Notification.Name("updateDriverLocation"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func setupNotificationObserver() {
        if TrackType == "1"{
            self.receivedOrdesDetailsAPI()
        }else if TrackType == "2" {
            self.myOrdesDetailsAPI()
        }else if TrackType == "3" {
            self.driverOrdesDetailsAPI()
        }else if TrackType == "4" {
            self.driverOrdesDetailsAPI()
        }else if TrackType == "5" {
            if self.getDriverRequestDetail{
                self.getDriverServiceDetails()
            }
            else{
                self.getServiceDetails()
            }
            
        }else if TrackType == "6" {
            if getDriverRequestDetail {
                getServiceDetailsDriver()
            } else {
                self.getServiceDetails1()
            }
        }
    }
    
    @objc func updateDriverLocationFromLocationManager(notification: NSNotification)
    {
        if TrackType == "6" {
            let dict = notification.object as! NSDictionary
            self.bearing = dict["bearing"] as? Double ?? 0.0
            print("updateDriverLocationFromLocationManager")
            if self.getDriverRequestDetail
            {
                formulateCoordinatesIncaseOfEmptyFirebaseKey()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        if TrackType == "1"{
            callbtn.setTitle(" Call Driver".localiz(), for: .normal)
            viewControllerTitle = "Track Order".localiz()
            self.receivedOrdesDetailsAPI()
        }else if TrackType == "2" {
            callbtn.setTitle(" Call Driver", for: .normal)
            viewControllerTitle = "Track Order"
            self.myOrdesDetailsAPI()
        }else if TrackType == "3" {
            callbtn.setTitle(" Call Customer".localiz(), for: .normal)
            mapTouch.image = UIImage(named: "Group 236301")
            viewControllerTitle = "View Map".localiz()
            self.driverOrdesDetailsAPI()
        }else if TrackType == "4" {
            callbtn.setTitle(" Call Customer".localiz(), for: .normal)
            mapTouch.image = UIImage(named: "Group 236301")
            viewControllerTitle = "View Map".localiz()
            self.driverOrdesDetailsAPI()
        }else if TrackType == "5" {//
            callbtn.setTitle(" Call Driver".localiz(), for: .normal)
            viewControllerTitle = "Track Order".localiz()
            if self.getDriverRequestDetail{
                self.getDriverServiceDetails()
            }
            else{
                self.getServiceDetails()
            }
        } else if TrackType == "6" {//
            callbtn.setTitle(" Call Service Provider".localiz(), for: .normal)
            callbtn.titleLabel?.font = UIFont(name: AppFonts.regular.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12)
            viewControllerTitle = "Track Order".localiz()
            if getDriverRequestDetail {
                getServiceDetailsDriver()
            } else {
                self.getServiceDetails1()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        var driverFID = ""
        driverFID = myOrderData?.driver?.firebase_user_key ?? ""
        if self.TrackType == "3" ||  self.TrackType == "4" {
            driverFID = myDriverOrder?.driver?.firebase_user_key ?? ""
        }
        //        dbRef?.child(driverFID).removeAllObservers()
        //        dbRef?.removeAllObservers()
        //        dbRef = nil
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "updateDriverLocation"), object: nil)
    }
    @IBAction func openExternalMap(_ sender: Any) {
        if self.TrackType == "3" ||  self.TrackType == "4" {
            if myDriverOrder?.status == "4" {
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.openURL(URL(string:
                                                        "comgooglemaps://?center=\(Double(self.myDriverOrder?.store?.location_data?.lattitude ?? "0.00") ?? 0.00),\((Double(self.myDriverOrder?.store?.location_data?.longitude ?? "0.00") ?? 0.00))&zoom=14&views=traffic")!)
                } else {
                    if let urlDestination = URL.init(string: "http:maps.google.com/?daddr=\(Double(self.myDriverOrder?.store?.location_data?.lattitude ?? "0.00") ?? 0.00),\(Double(self.myDriverOrder?.store?.location_data?.longitude ?? "0.00") ?? 0.00)") {
                        UIApplication.shared.open(urlDestination)
                    }
                }
            }else {
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.openURL(URL(string:
                                                        "comgooglemaps://?center=\(Double(self.driverLoc?.latitude ?? 0.0)),\(Double(self.driverLoc?.longitude ?? 0.0))&zoom=14&views=traffic")!)
                } else {
                    if let urlDestination = URL.init(string: "http:maps.google.com/?daddr=\(Double(self.driverLoc?.latitude ?? 0.0) ),\(Double(self.driverLoc?.longitude ?? 0.0) )") {
                        UIApplication.shared.open(urlDestination)
                    }
                }
            }
        }
    }
    @IBAction func openLoc(_ sender: Any) {
        if TrackType == "1" || TrackType == "2"{
            let url: NSURL = URL(string: "TEL://+\(self.myOrderData?.driver?.dial_code ?? "")\(self.myOrderData?.driver?.phone ?? "")")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }else if TrackType == "3" || TrackType == "2"{
            let url: NSURL = URL(string: "TEL://+\(self.myDriverOrder?.customer?.dial_code ?? "")\(self.myDriverOrder?.customer?.phone ?? "")")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }else if TrackType == "4"{
            let url: NSURL = URL(string: "TEL://+\(self.myDriverOrder?.customer?.dial_code ?? "")\(self.myDriverOrder?.customer?.phone ?? "")")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }else if TrackType == "5"{
            let url: NSURL = URL(string: "TEL://+\(self.servicesDetails?.data?.driver?.dialCode ?? "")\(self.servicesDetails?.data?.driver?.phone ?? "")")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }else if TrackType == "6"{
            let url: NSURL = URL(string: "TEL://+\(self.serviceData?.store?.dial_code ?? "")\(self.serviceData?.store?.phone ?? "")")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }

    @IBAction func didRecenterTaped(_ sender: UIView) {
        if let loc = self.driverMarker?.position {
            zoomLevel = 20.0
            let camera = GMSCameraPosition.camera(withTarget: loc, zoom: zoomLevel)
            self.mapView.animate(to: camera)
            isCameraCentered = true
            recenterButton.isHidden = true
        }
    }
}

extension TrackOrderVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if !isCameraCentered {
            self.zoomLevel = position.zoom
        }
        print(#function)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print(#function,gesture)
        isCameraCentered = !gesture
        recenterButton.isHidden = !gesture
        if gesture {
            driverMarker!.rotation = mapView.camera.bearing
        }
    }
}

extension TrackOrderVC {
    
    private func configureLocationManager(){
        if #available(iOS 9.0, *) {
            manager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        let userData = SessionManager.getUserData()
        if userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_DELIVERY_REPRESENTATIVE.rawValue {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            manager.startMonitoringVisits()
        }
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.requestAlwaysAuthorization()
    }
    
    func showPath(polyStr :String) {

        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = UIColor.black


        if self.oldPolyLines.count > 0 {
            for polyline in self.oldPolyLines {
                polyline.map = nil
            }
        }
        self.oldPolyLines.append(polyline)
        polyline.map = mapView // Your map view

//        if let pathGM = path,let storeLoc = destination  {
//
//            let lastLoc = pathGM.coordinate(at: pathGM.count() - 1)
//            if lastLoc.latitude != -180 && lastLoc.longitude != -180 {
//                let dottedPath = GMSMutablePath()
//                dottedPath.add(lastLoc)
//                dottedPath.add(storeLoc)
//
//                    // Create a new polyline for the dotted line
//                let dottedPolyline = GMSPolyline(path: dottedPath)
//                dottedPolyline.strokeWidth = 5.0
//                dottedPolyline.strokeColor = UIColor.black
//                let span = GMSStyleSpan(style: GMSStrokeStyle.solidColor(.clear), segments: 1)
//                dottedPolyline.spans = [span]
//
//
//                let path2 = GMSPath(path:dottedPath)
//
//                dottedPolyline.path = path2
//
//                    // Add the dotted line to the map
//                dottedPolyline.map = mapView
//            }
//        }
    }
    
    
    func fetchUserFirebase(firebaseKey : String ,finished:@escaping (_ result: FirebaseDriver?) -> Void) {
        
        Database.database().reference().child("Driver_location").child(firebaseKey).observe(.value) { snapshot in
            
            if let value = snapshot.value as? [String:Any]
            {
                //                Utilities.showWarningAlert(message:"Location updated \(snapshot.value)") {
                //
                //                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: value)
                    let user = try JSONDecoder().decode(FirebaseDriver.self, from: json)
                    finished(user)
                } catch {
                    finished(nil)
                }
            }else {
                finished(nil)
            }
        }
        
    }
    func fetchDriverLocation() {
        var key = ""
        if self.TrackType == "1" {
            key = self.myOrderData?.driver?.firebase_user_key ?? ""
        }else if self.TrackType == "2"{
            key = self.myOrderData?.driver?.firebase_user_key ?? ""
        }else if self.TrackType == "3"{
            key = self.myDriverOrder?.driver?.firebase_user_key ?? ""
        }else if self.TrackType == "4"{
            key = self.myDriverOrder?.driver?.firebase_user_key ?? ""
        }else if self.TrackType == "5"{
            key = self.servicesDetails?.data?.driver?.firebaseUserKey ?? ""
        }else if self.TrackType == "6"{
            key = self.serviceData?.store?.firebase_user_key ?? ""  //self.servicesDetails?.data?.driver?.firebaseUserKey ?? ""
        }
        
        if key.isEmpty{
            formulateCoordinatesIncaseOfEmptyFirebaseKey()
            return
        }
        
        self.fetchUserFirebase(firebaseKey: key) {result in
            if let user = result {
                self.driverLoc = user.coordinate
                
                var sourceCoordinate:CLLocationCoordinate2D  = CLLocationCoordinate2D()




                var destinationCoordinate:CLLocationCoordinate2D  = CLLocationCoordinate2D()
                
                if self.TrackType == "1" && (self.myOrderData?.status == "4" || self.myOrderData?.status == "5") {
                    sourceCoordinate.latitude = Double(user.latitude ?? 0.0)
                    sourceCoordinate.longitude = Double(user.longitude ?? 0.0)
                    destinationCoordinate.latitude = Double(self.myOrderData?.store?.location_data?.lattitude ?? "0.00") ?? 0.00
                    destinationCoordinate.longitude = Double(self.myOrderData?.store?.location_data?.longitude ?? "0.00") ?? 0.00
                }else if self.TrackType == "5" {
                    sourceCoordinate.latitude = Double(user.latitude ?? 0.0)
                    sourceCoordinate.longitude = Double(user.longitude ?? 0.0)
                    if self.servicesDetails?.data?.serviceStatus == "2"{
                        sourceCoordinate.latitude = Double(SessionManager.getLat()) ?? 0.00
                        sourceCoordinate.longitude = Double(SessionManager.getLng()) ?? 0.00
                    }
                    if self.servicesDetails?.data?.serviceStatus == "1" || self.servicesDetails?.data?.serviceStatus == "2" || self.servicesDetails?.data?.serviceStatus == "3"
                    {
                        destinationCoordinate.latitude = Double(self.servicesDetails?.data?.pickupLattitude ?? "0.00") ?? 0.00
                        destinationCoordinate.longitude = Double(self.servicesDetails?.data?.pickupLongitude ?? "0.00") ?? 0.00
                    }
                    else{
                        destinationCoordinate.latitude = Double(self.servicesDetails?.data?.dropoffLattitude ?? "0.00") ?? 0.00
                        destinationCoordinate.longitude = Double(self.servicesDetails?.data?.dropoffLongitude ?? "0.00") ?? 0.00
                    }
                   
                }else if self.TrackType == "6" {
                    sourceCoordinate.latitude = Double(user.latitude ?? 0.0)
                    sourceCoordinate.longitude = Double(user.longitude ?? 0.0)
                    destinationCoordinate.latitude = Double(self.serviceData?.latitude ?? "0.00") ?? 0.00
                    destinationCoordinate.longitude = Double(self.serviceData?.longitude ?? "0.00") ?? 0.00
                }else if self.TrackType == "1" {
                    sourceCoordinate.latitude = Double(user.latitude ?? 0.0)
                    sourceCoordinate.longitude = Double(user.longitude ?? 0.0)
                    destinationCoordinate.latitude = Double(self.myOrderData?.address?.latitude ?? "0.00") ?? 0.00
                    destinationCoordinate.longitude = Double(self.myOrderData?.address?.longitude ?? "0.00") ?? 0.00
                }else if self.TrackType == "2" {
                    sourceCoordinate.latitude = Double(user.latitude ?? 0.0)
                    sourceCoordinate.longitude = Double(user.longitude ?? 0.0)
                    destinationCoordinate.latitude = Double(self.myOrderData?.address?.latitude ?? "0.00") ?? 0.00
                    destinationCoordinate.longitude = Double(self.myOrderData?.address?.longitude ?? "0.00") ?? 0.00
                }else if self.TrackType == "3" ||  self.TrackType == "4"  {
                    if self.myDriverOrder?.status == "4"{
                        sourceCoordinate.latitude = Double(user.latitude ?? 0.0)
                        sourceCoordinate.longitude = Double(user.longitude ?? 0.0)
                        destinationCoordinate.latitude = Double(self.myDriverOrder?.store?.location_data?.lattitude ?? "0.00") ?? 0.00
                        destinationCoordinate.longitude = Double(self.myDriverOrder?.store?.location_data?.longitude ?? "0.00") ?? 0.00
                    }else {
                        sourceCoordinate.latitude = Double(user.latitude ?? 0.0)
                        sourceCoordinate.longitude = Double(user.longitude ?? 0.0)
                        destinationCoordinate.latitude = Double(self.myDriverOrder?.address?.latitude ?? "0.00") ?? 0.00
                        destinationCoordinate.longitude = Double(self.myDriverOrder?.address?.longitude ?? "0.00") ?? 0.00
                    }
                }
                
                if self.hasMapSet
                {
                    
                }
                else
                {
                    self.setupMap(from: sourceCoordinate, to: destinationCoordinate)
                    
                }
                let userData = SessionManager.getUserData()
                if userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_DELIVERY_REPRESENTATIVE.rawValue {
                    sourceCoordinate.latitude = Double(SessionManager.getLat()) ?? 0.00
                    sourceCoordinate.longitude = Double(SessionManager.getLng()) ?? 0.00
                } else {
                    sourceCoordinate.latitude = user.latitude ?? 0.00
                    sourceCoordinate.longitude = user.longitude ?? 0.00
                }
                self.storeLoc = destinationCoordinate
                if self.hasDrawnRoute == false {

                    self.getPolylineRoute(from: sourceCoordinate, to: destinationCoordinate)
                    // self.hasDrawnRoute = true
                }
                
                // self.countdown(totalSeconds: Int(driver.eta ?? "0") ?? 0)
                self.updateDriver(driver: user)
            }else {
                
            }
        }
    }
    // }
    
    func formulateCoordinatesIncaseOfEmptyFirebaseKey() {
        var sourceCoordinate:CLLocationCoordinate2D  = CLLocationCoordinate2D()
        var destinationCoordinate:CLLocationCoordinate2D  = CLLocationCoordinate2D()
        
        sourceCoordinate.latitude = Double(SessionManager.getLat()) ?? 0.00
        sourceCoordinate.longitude = Double(SessionManager.getLng()) ?? 0.00
        destinationCoordinate.latitude = Double(self.serviceData?.latitude ?? "0.00") ?? 0.00
        destinationCoordinate.longitude = Double(self.serviceData?.longitude ?? "0.00") ?? 0.00
        
        if !hasMapSet {
            self.setupMap(from: sourceCoordinate, to: destinationCoordinate)
        }
        self.getPolylineRoute(from: sourceCoordinate, to: destinationCoordinate)
        let coordinate = CLLocationCoordinate2D(latitude: sourceCoordinate.latitude , longitude: sourceCoordinate.longitude)
        self.updateDriverLocation(driverLocation: coordinate)
        let userData = SessionManager.getUserData()
    }
    
    func setupMap(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        hasMapSet = true
        
        let currentLocation = manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708)
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: zoomLevel)
        mapView.animate(to: camera)
        let destinationMarker = GMSMarker()
        destinationMarker.position = destination
        
        if (self.TrackType == "3" || self.TrackType == "4") && (self.myDriverOrder?.status == "4") {
            let markerView = UIImageView(image: UIImage(named: "sellerPin"))
            destinationMarker.iconView = markerView
        }else if (self.TrackType == "3" || self.TrackType == "4") {
            let markerView = UIImageView(image: UIImage(named: "userPin"))
            destinationMarker.iconView = markerView
        }else if self.TrackType == "1" && (self.myOrderData?.status == "4" || self.myOrderData?.status == "5") {
            let markerView = UIImageView(image: UIImage(named: "sellerPin"))
            destinationMarker.iconView = markerView
        }else {
            let markerView = UIImageView(image: UIImage(named: "userPin"))
            destinationMarker.iconView = markerView
        }
        destinationMarker.map = mapView
        markers?.append(destinationMarker)
        
    }
    
    
    func focusMapToShowAllMarkers() {
        let firstLocation = markers!.first!.position
        
        var bounds =  GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)
        
        for marker in markers! {
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(15))
        self.mapView.animate(with: update)
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let origin = "\(source.latitude),\(source.longitude)"
        let destinationLocation = "\(destination.latitude),\(destination.longitude)"
     
        
        let array = [source,destination]
        
        var wayPoints = ""
        for point in array {
            wayPoints = wayPoints.count == 0 ? "\(point.latitude),\(point.longitude)" : "\(wayPoints)%7C\(point.latitude),\(point.longitude)"
            
        }
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destinationLocation)&sensor=false&mode=driving&key=\(Config.googleApiKey)")!
        
        let task = session.dataTask(with: url, completionHandler: {[weak self]
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                //                self.activityIndicator.stopAnimating()
            }
            else {
                do {

                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            return
                        }
                        
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            //print("Time \(overview_polyline)")
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            
                            let ArrLegs = overview_polyline?["legs"] as? NSArray
                            let legs = ArrLegs?.firstObject as? NSDictionary
                            var duration = legs?["duration"] as? NSDictionary
                            
                            let points = dictPolyline?.object(forKey: "points") as? String
                            
                            
                            
                            DispatchQueue.main.async {
                                if points != nil {
                                    self?.showPath(polyStr: points ?? "")
                                }
                                self?.calculateDistacnce(from: source, to: destination)
                            }
                            if let newRoute = routes.firstObject as? Dictionary<String, AnyObject>,let dictArray = newRoute["legs"] as? Array<Any>,let dict = dictArray.last as? Dictionary<String, AnyObject>,let steps = dict["steps"] as? Array<Any>, let stepsDict = steps.last as? Dictionary<String, AnyObject>,let startLocation = stepsDict["end_location"] {
                                let lat = (startLocation["lat"] ?? "0") as! NSNumber
                                let lng = (startLocation["lng"] ?? "0") as! NSNumber
                                print("lat : \(lat) lng : \(lng)")
                                let dotCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating:lat), longitude: CLLocationDegrees(truncating:lng))
                                DispatchQueue.main.async {
                                    self?.drawWalkingDistance(dotCoordinate:dotCoordinate)
                                }
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }

    func drawWalkingDistance(dotCoordinate : CLLocationCoordinate2D) {
        guard storeLoc != nil else {return}
        let dotPath :GMSMutablePath = GMSMutablePath()
        dotPath.add(CLLocationCoordinate2DMake(storeLoc!.latitude, storeLoc!.longitude))
        dotPath.add(CLLocationCoordinate2DMake(dotCoordinate.latitude, dotCoordinate.longitude))
        let dottedPolyline  = GMSPolyline(path: dotPath)

        dottedPolyline.geodesic = true
        

        let styles: [GMSStrokeStyle] = [GMSStrokeStyle.solidColor(UIColor.red),GMSStrokeStyle.solidColor(UIColor.clear)]

        let points = mapView.projection.points(forMeters: 1, at: mapView.camera.target)
        let scale = 1.0 / points
        let lengths: [NSNumber] = [NSNumber(value: Float(0.5 * scale)), NSNumber(value: Float(1 * scale))]
        dottedPolyline.strokeWidth =  5.0
        dottedPolyline.spans = GMSStyleSpans(dottedPolyline.path!, styles , lengths ,GMSLengthKind.rhumb)
        dottedPolyline.map = self.mapView

        self.oldPolyLines.append(dottedPolyline)
    }

    func calculateDistacnce(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let origin = "\(source.latitude),\(source.longitude)"
        let destinationLocation = "\(destination.latitude),\(destination.longitude)"

        
        let array = [source,destination]
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destinationLocation)&sensor=false&units=metric&mode=driving&key=\(Config.googleApiKey)")!
        
        let task = session.dataTask(with: url, completionHandler: {[weak self]
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                //                self.activityIndicator.stopAnimating()
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                                //                                self.activityIndicator.stopAnimating()
                            }
                            return
                        }
                        
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            
                            let ArrLegs = overview_polyline?["legs"] as? NSArray
                            let legs = ArrLegs?.firstObject as? NSDictionary
                            var duration = legs?["duration"] as? NSDictionary
                            var dist = legs?["distance"] as? NSDictionary
                            DispatchQueue.main.async {
                                
                                
                                
                                
                                if self?.TrackType == "3" || self?.TrackType == "4"{
                                    if self?.myDriverOrder?.status == "4" {
                                        self?.lblTrackStatus.text = "(\("\((dist?["text"] as? String) ?? "")")) \("On the way".localiz())"
                                        self?.mapTrackStatus.text = "Your order ready for collection".localiz()
                                    }else {
                                        self?.lblTrackStatus.text = "(\("\((dist?["text"] as? String) ?? "")")) \(self?.myDriverOrder?.status_text ?? "")"
                                        self?.mapTrackStatus.text = "\("Your order is".localiz()) \(self?.myDriverOrder?.status_text ?? "")"
                                    }
                                }else if self?.TrackType == "1" ||  self?.TrackType == "2"{
                                    if self?.myOrderData?.status == "4" {
                                        self?.lblTrackStatus.text = "(\("\((dist?["text"] as? String) ?? "")")) \("On the way".localiz())"
                                        self?.mapTrackStatus.text = "Your order ready for collection".localiz()
                                    }else {
                                        self?.lblTrackStatus.text = "(\("\((dist?["text"] as? String) ?? "")")) \(self?.myOrderData?.status_text ?? "")"
                                        self?.mapTrackStatus.text = "\("Your order is".localiz()) \(self?.myOrderData?.status_text ?? "")"
                                    }
                                }else if self?.TrackType == "5"{
                                    if self?.servicesDetails?.data?.serviceStatus == "4" {
                                        self?.lblTrackStatus.text = "(\("\((dist?["text"] as? String) ?? "")")) \("On the way".localiz())"
                                    }else {
                                        self?.mapTrackStatus.text = "\("Your order is".localiz()) \(self?.myOrderData?.status_text ?? "")"
                                    }
                                }else if self?.TrackType == "6"{
                                    if self?.serviceData?.status == "4" {
                                        self?.lblTrackStatus.text = "(\("\((dist?["text"] as? String) ?? "")")) \("On the way".localiz())"
                                    }else {
                                        self?.mapTrackStatus.text = "\("Your order is".localiz()) \(self?.myOrderData?.status_text ?? "")"
                                    }
                                }
                                
                                
                                self?.lblDeliveryTIme.text = "\((duration?["text"] as? String) ?? "")"
                                //  self?.showPath(polyStr: points!)
                                
                            }
                        } else {
                            DispatchQueue.main.async {
                                
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        //                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        })
        task.resume()
    }
    
    func countdown(totalSeconds:Int) {
        var hours: Int
        var minutes: Int
        var seconds: Int
        seconds = totalSeconds - 1
        hours = totalSeconds / 3600
        minutes = (totalSeconds % 3600) / 60
        seconds = (totalSeconds % 3600) % 60
        if hours == 0
        {
            self.lblDeliveryTIme.text = String(format: "%02d min", minutes)
        }
        else
        {
            self.lblDeliveryTIme.text = String(format: "%02d hr %02d min", hours, minutes)
        }
        
    }
    
    func updateDriver(driver: FirebaseDriver) {
        if self.driverMarker == nil {
            self.driverMarker = GMSMarker()
            self.driverMarker!.map = self.mapView
            driverMarker!.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            var markerView = UIImageView(image: UIImage(named: "motorCycle"))
            
            
            if TrackType == "1" || TrackType == "2"{
                if myOrderData?.request_deligate == "1" {
                    markerView = UIImageView(image: UIImage(named: "MediumTruck"))
                }else if myOrderData?.request_deligate == "3"{
                    markerView = UIImageView(image: UIImage(named: "BigTruck"))
                }else if myOrderData?.request_deligate == "4"{
                    markerView = UIImageView(image: UIImage(named: "NormalCar"))
                }else if myOrderData?.request_deligate == "5"{
                    markerView = UIImageView(image: UIImage(named: "motorCycle"))
                }else if myOrderData?.request_deligate == "6"{
                    markerView = UIImageView(image: UIImage(named: "Pickup"))
                }else {
                    markerView = UIImageView(image: UIImage(named: "motorCycle"))
                }
            }else if TrackType == "3" || TrackType == "4" {
                if myDriverOrder?.request_deligate == "1" {
                    markerView = UIImageView(image: UIImage(named: "MediumTruck"))
                }else if myDriverOrder?.request_deligate == "3"{
                    markerView = UIImageView(image: UIImage(named: "BigTruck"))
                }else if myDriverOrder?.request_deligate == "4"{
                    markerView = UIImageView(image: UIImage(named: "NormalCar"))
                }else if myDriverOrder?.request_deligate == "5"{
                    markerView = UIImageView(image: UIImage(named: "motorCycle"))
                }else if myDriverOrder?.request_deligate == "6"{
                    markerView = UIImageView(image: UIImage(named: "Pickup"))
                }else {
                    markerView = UIImageView(image: UIImage(named: "motorCycle"))
                }
            }
            
            
            
            

            //  self.driverMarker?.icon = UIImage(named: "map-truck")
            self.driverMarker?.iconView =  UIImageView(image:UIImage(named: "Group 235298"))
            self.driverMarker?.position = driver.coordinate!

            self.markers?.append(self.driverMarker!)
            let camera = GMSCameraPosition.camera(withTarget: driver.coordinate!, zoom: zoomLevel)
            self.mapView.animate(to: camera)
            //self.focusMapToShowAllMarkers()
        } else {

                let newCoordinates = driver.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                CATransaction.begin()
                CATransaction.setValue(Int(1.0), forKey: kCATransactionAnimationDuration)
                print("driver Bearing are",driver.bearing ?? 0)

                   // self.driverMarker?.rotation = driver.bearing ?? 0.0
                self.driverMarker?.position = newCoordinates
            let camera = GMSCameraPosition.camera(withTarget: newCoordinates, zoom: zoomLevel,bearing: driver.bearing ?? 0.0, viewingAngle: 45)

                self.mapView.animate(to: camera)

                CATransaction.commit()

        }
    }
    
    func updateDriverLocation(driverLocation: CLLocationCoordinate2D) {
                
        if self.driverMarker == nil {
            self.driverMarker = GMSMarker()
            self.driverMarker!.map = self.mapView
            let markerView = UIImageView(image: UIImage(named: "Group 235298"))
            self.driverMarker!.iconView =  markerView
            self.driverMarker!.position = driverLocation
            self.markers?.append(self.driverMarker!)
            self.driverMarker?.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            let camera = GMSCameraPosition.camera(withTarget: driverLocation, zoom: zoomLevel)
            self.mapView.animate(to: camera)
        } else {
            CATransaction.begin()
            CATransaction.setValue(Int(1.0), forKey: kCATransactionAnimationDuration)
           // self.mapView.animate(toBearing: driverLocation.bearing ?? 0.0)
                // self.driverMarker?.rotation = driver.bearing ?? 0.0
            self.driverMarker?.position = driverLocation
            let camera = GMSCameraPosition.camera(withTarget: driverLocation, zoom: zoomLevel)
            self.mapView.animate(to: camera)
            CATransaction.commit()
        }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
    //MARK: Seller order CLLocationManagerDelegate
extension TrackOrderVC:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let loc =  locations.last {
//            CATransaction.begin()
//            CATransaction.setValue(Int(1.0), forKey: kCATransactionAnimationDuration)
//            let userData = SessionManager.getUserData()
//            if userData?.user_type_id != UserAccountType.ACCOUNT_TYPE_DELIVERY_REPRESENTATIVE.rawValue && userData?.user_type_id != UserAccountType.ACCOUNT_TYPE_SERVICE_PROVIDERS.rawValue {
//                self.driverMarker?.rotation = loc.course
//                self.driverMarker?.position = loc.coordinate
//            }
//            CATransaction.commit()
//            if isCameraCentered {
//                let camera = GMSCameraPosition.camera(withTarget: loc.coordinate, zoom: zoomLevel)
//                self.mapView.animate(to: camera)
//            }
//        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        let userData = SessionManager.getUserData()
//        if userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_DELIVERY_REPRESENTATIVE.rawValue || userData?.user_type_id == UserAccountType.ACCOUNT_TYPE_SERVICE_PROVIDERS.rawValue {
//            self.mapView.animate(toBearing: newHeading.headingAccuracy)
//        }
    }
}

extension TrackOrderVC {
    func getServiceDetails1() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_request_id" : self.order_ID
        ]
        ServiceAPIManager.requestServiceAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.serviceData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getServiceDetailsDriver() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_request_id" : self.order_ID
        ]
        ServiceAPIManager.providerServiceAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.serviceData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
//MARK: Seller order Details
extension TrackOrderVC {
    
    func getServiceDetails() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_id" : self.order_ID
        ]
        DelegateServiceAPIManager.getMyRequestDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.servicesDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func getDriverServiceDetails() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "timezone" :  TimeZone.current.identifier,
            "service_id" : self.order_ID,
            "lattitude" : SessionManager.getLat(),
            "longitude" : SessionManager.getLng()
            
        ]
        DelegateServiceAPIManager.getDriverRequestDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.servicesDetails = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func receivedOrdesDetailsAPI() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : order_ID,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        StoreAPIManager.receivedOrdersDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myOrderData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func myOrdesDetailsAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : order_ID,
            "timezone" : localTimeZoneIdentifier
        ]
        print(parameters)
        StoreAPIManager.myOrdersDetailsAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.myOrderData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func driverOrdesDetailsAPI() {
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "order_id" : order_ID,
            "timezone" : localTimeZoneIdentifier,
            "lattitude": SessionManager.getLat(),
            "longitude":SessionManager.getLng()
        ]
        print(parameters)
        
        if self.TrackType == "3"{
            StoreAPIManager.driverFoodOrdersDetailsAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myDriverOrder = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }else{
            StoreAPIManager.driverOrdersDetailsAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.myDriverOrder = result.oData
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
        
    }
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree
        }
        else {
            return 360 + degree
        }
    }
}
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
