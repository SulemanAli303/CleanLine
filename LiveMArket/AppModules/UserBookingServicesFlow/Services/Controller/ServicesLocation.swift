//
//  ServicesLocation.swift
//  LiveMArket
//
//  Created by Zain on 30/01/2023.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


protocol ServicesLocationDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String)
}
class ServicesLocation: BaseViewController {
    
    var delegate: ServicesLocationDelegate?
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var mapContainerView: GMSMapView!
    var cameraLatitude = 52.5659
    var cameraLongitude = -1.1897
    var pickupCoorinate : CLLocation?
    var dropCoorinate : CLLocation?
    var locationManager = CLLocationManager()
    var isLocationPicked: Bool = false
    var mapMovedGesture: Bool = false
    var bookingLatitude : String?
    var bookingLongitude : String?
    var zoom:Float = 20.0

    var currentLocation: CLLocation? {
        didSet {
            if let coordinate = currentLocation?.coordinate {
                let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom, bearing: .zero, viewingAngle: 0)
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
        type = .backWithTop
        viewControllerTitle = "Select Location"
        self.addMapView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
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
        //mapContainerView.delegate = self
    
    }
    @IBAction func sendLocation(_ sender: UIButton) {
        if let coordinate = locationCoordinates {
            let pickedCoordinate =  coordinate.coordinate
            delegate?.placePicked(coordinate: pickedCoordinate, address: self.txtAddress.text ?? "")
        }
        self.navigationController?.popViewController(animated: true)
        //Coordinator.goToServiceRequestDetails(controller: self, step: "4")
    }
    @IBAction func searhBtn(_ sender: Any) {
        Utilities.presentPlacePicker(vc: self)
    }
    func animateMapTo(_ location: CLLocation) {
        DispatchQueue.main.async { [self] in
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoom)
            mapContainerView.animate(to: camera)
        }
    }
   
}

extension ServicesLocation: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        let center = CLLocation (latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude)
        zoom = position.zoom
        if isLocationPicked {
            return
        }
        if mapMovedGesture == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                let location = CLLocation(latitude: self.locationCoordinates?.coordinate.latitude ?? 0.000000, longitude: self.locationCoordinates?.coordinate.longitude ?? 0.000000)
                animateMapTo(location)
                self.getAddress(loc: location)
                mapMovedGesture = false
            }
        } else {
            locationCoordinates = center
            currentLocation = center
            self.getAddress(loc:center)
        }
       
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

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            mapMovedGesture = true
            isLocationPicked = false
        }
    }
}
extension ServicesLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.isLocationPicked = true
        if (self.pickupCoorinate != nil) {
            currentLocation = pickupCoorinate
            locationCoordinates = currentLocation
            self.locationManager.stopUpdatingLocation()
            if let loc = currentLocation {
                self.getAddress(loc: loc)
            }
        }else if (self.dropCoorinate != nil){
            currentLocation = dropCoorinate
            locationCoordinates = currentLocation
            self.locationManager.stopUpdatingLocation()
            if let loc = currentLocation {
                self.getAddress(loc: loc)
            }
        }else{
            currentLocation = locations.last
            locationCoordinates = currentLocation
            
            self.locationManager.stopUpdatingLocation()
            if let loc = currentLocation {
                self.getAddress(loc: loc)
            }
        }
        
        
    }
}
extension ServicesLocation: PlacePickerDelegate {
    func placePicked(coordinate: CLLocationCoordinate2D, address: String) {
        self.isLocationPicked = true
        self.txtAddress.text = address
        let center = CLLocation (latitude: coordinate.latitude, longitude: coordinate.longitude)
        locationCoordinates = center
        self.currentLocation = center
    }
}
