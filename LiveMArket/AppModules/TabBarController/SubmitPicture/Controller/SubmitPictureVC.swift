//
//  SubmitPictureVC.swift
//  LiveMArket
//
//  Created by Zain on 25/01/2023.
//

import UIKit
import KMPlaceholderTextView
import AVFoundation
import CoreLocation

class SubmitPictureVC: BaseViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var uploadPercentageLabel: UILabel!
    @IBOutlet weak var post_title: KMPlaceholderTextView!
    @IBOutlet weak var collectionViewImage: UICollectionView!
    
    var locationManager = CLLocationManager()
    var currentAddressSting:String = ""
    var isFromPicture:Bool = false
    var isFromLive:Bool = false
    var hashtagsArray: [String] = []
    var channelID : String?
    
    var imageAnimator: ImageAnimator1?
    @IBOutlet weak var progressBar: UIProgressView!

        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        submitButton.setTitle("ADD POST".localiz(), for: .normal)
        setData()
        setGradientBackground()
        post_title.delegate = self
    }
    func setData() {
        collectionViewImage.delegate = self
        collectionViewImage.dataSource = self
        collectionViewImage.register(UINib.init(nibName: "ShowPicCell", bundle: nil), forCellWithReuseIdentifier: "ShowPicCell")
        collectionViewImage.register(UINib.init(nibName: "AddMoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddMoreCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionViewImage.collectionViewLayout = layout
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromPicture {
            viewControllerTitle = "Picture".localiz()
        }else{
            viewControllerTitle = "Video".localiz()
        }
        self.setUpLocation()
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadDidProgress(_:)), name: Notification.Name("UploadProgress"), object: nil)
        submitButton.isEnabled = true
        self.collectionViewImage.reloadData()
    }

    func writeImage() {
        DispatchQueue.main.async {
            Utilities.showIndicatorView()
        }
        var setting = RenderSettings1()
        setting.size = CGSize(width: 720, height: 1280)
        setting.saveToLibrary = false
        setting.fps = 30
        setting.imageloop = 60
        imageAnimator = ImageAnimator1(renderSettings: setting)
        imageAnimator?.images = Constants.shared.uploadImageArray
        print("render time begin")
        let start = Date().timeIntervalSince1970
        imageAnimator?.render {
            let end = Date().timeIntervalSince1970
            print("render time \(end - start)")
            print("render complete \(setting.outputURL)")
            Constants.shared.uploadVideoArray.removeAll()
            Constants.shared.uploadVideoArray.append(setting.outputURL)
            self.uploadVideoAPI()
            DispatchQueue.main.async {
                Utilities.hideIndicatorView()
            }
        }
    }
    
    //MARK: - Location
    
    var locationCoordinates: CLLocation? {
        didSet {
        }
    }
    
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    var currentLocation: CLLocation? {
        didSet {
            self.getAddress(loc: currentLocation)
            if let coordinate = currentLocation?.coordinate {
                //let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15, bearing: .zero, viewingAngle: 0)
                // self.mapContainerView?.animate(to: camera)
                //mapContainerView.delegate = self
            }
        }
    }
    
    func getAddress(loc:CLLocation?) {
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: loc?.coordinate.latitude ?? 25.2048, longitude:loc?.coordinate.longitude ?? 55.2708)) { (places, error) in
            if error == nil{
                if let place = places?.first{
                    print(place)
                    //let place = placemarks[0]
                    var addressString : String = ""
                    if place.thoroughfare != nil {
                        addressString = addressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        addressString = addressString + place.subThoroughfare! + ", "
                    }
                    if place.locality != nil {
                        addressString = addressString + place.locality! + ", "
                    }
                    if place.postalCode != nil {
                        addressString = addressString + place.postalCode! + ", "
                    }
                    if place.subAdministrativeArea != nil {
                        addressString = addressString + place.subAdministrativeArea! + ", "
                    }
                    if place.country != nil {
                        addressString = addressString + place.country!
                    }
                    
                    print( addressString)
                    self.currentAddressSting = addressString
                }
            }
        }
    }
    @IBAction func Submit(_ sender: Any) {
        

        // Coordinator.updateRootVCToTab()
        submitButton.isEnabled = false
        if isFromPicture{
            //writeImage()
            uploadImagesAPI()
        }else{
            
            if isFromLive{
                uploadLiveVideo()
            }else{
                uploadVideoAPI()
            }
            
        }
    }
    override func backButtonAction() {
        var idex = 0
        for controller in self.navigationController!.viewControllers as Array{
            if controller.isKind(of: TakePictureVC.self){
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }else if controller.isKind(of: TakeVideoVC.self){
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }else{
                if idex == ((self.navigationController!.viewControllers as Array).count - 1) {
                    self.navigationController?.popViewController(animated: true)
                }
                idex = idex + 1
            }
        }
        
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    //MARK: API Call
    func uploadImagesAPI() {
        
        guard Constants.shared.uploadImageArray.count > 0  else {
            Utilities.showWarningAlert(message:  "Please add your post images.".localiz()) {
                
            }
            return
        }
        guard Constants.shared.uploadImageArray.count <= 5  else {
            self.submitButton.isEnabled = true
            Utilities.showWarningAlert(message:  "Please select maximum five post images.".localiz()) {
            }
            return
        }
        
        let separator = ","
        let result = hashtagsArray.map { String($0) }.joined(separator: separator)
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "caption":post_title.text ?? "",
            "file_type":"1",
            "location":self.currentAddressSting,
            "lattitude":"\(currentLocation?.coordinate.latitude ?? 0)",
            "longitude":"\(currentLocation?.coordinate.longitude ?? 0)",
            "hash_tag_list":result.replacingOccurrences(of: "#", with: "")
        ]
        print(parameters)
        /// First showed image // Proirity set
        var firstImageArray:[UIImage] = []
        firstImageArray.append(Constants.shared.uploadImageArray.first ?? UIImage())
        var remainingimageArray:[UIImage] = []
        for index in 1..<Constants.shared.uploadImageArray.count {
            remainingimageArray.append(Constants.shared.uploadImageArray[index])
        }

        AddPostAPIManager.addPostImageApi(image: remainingimageArray, firstImage: firstImageArray, parameters: parameters) { result in
            switch result.status {
            case "1":
                Constants.shared.uploadImageArray.removeAll()
                self.submitButton.isEnabled = true
                NotificationCenter.default.post(name: NSNotification.Name("PostUpload"), object: nil)
                Utilities.showWarningAlert(message: result.message ?? "")
                {
                    Coordinator.updateRootVCToTab()
                }
//                for controller in self.navigationController!.viewControllers as Array{
//                    if controller.isKind(of: HomeViewController.self) || controller.isKind(of: ProfileViewController.self) || controller.isKind(of: ChatVC.self) || controller.isKind(of: ResturantListViewController.self){
//                        self.navigationController?.popToViewController(controller, animated: true)
//                    }
//                }
            default:
                self.submitButton.isEnabled = true
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func uploadVideoAPI() {
        /*
        let userInfo = ["caption":post_title.text ?? "","file_type":"2","location":self.currentAddressSting,"lattitude":"\(currentLocation?.coordinate.latitude ?? 0)","longitude":"\(currentLocation?.coordinate.longitude ?? 0)"]
        NotificationCenter.default.post(name: NSNotification.Name("PostUpload"), object: nil, userInfo:userInfo)
        Coordinator.updateRootVCToTab()*/
        
        
        guard Constants.shared.uploadVideoArray.count > 0  else {
            Utilities.showWarningAlert(message:  "Please add your post videos.".localiz()) {
                
            }
            return
        }

        let separator = ","
        let result = hashtagsArray.map { String($0) }.joined(separator: separator)
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "caption":post_title.text ?? "",
            "file_type":"2",
            "location":self.currentAddressSting,
            "lattitude":"\(currentLocation?.coordinate.latitude ?? 0)",
            "longitude":"\(currentLocation?.coordinate.longitude ?? 0)",
            "hash_tag_list":result.replacingOccurrences(of: "#", with: "")
        ]
        print(parameters)
        /// First showed video // Proirity set
        var firstVideoArray:[URL] = []
        firstVideoArray.append(Constants.shared.uploadVideoArray.first!)
        
        var remainingVideoArray:[URL] = []
        if Constants.shared.uploadVideoArray.count > 2{
            for index in 0..<Constants.shared.uploadVideoArray.count {
                if index != 0{
                    remainingVideoArray.append(Constants.shared.uploadVideoArray[index])
                }
            }
        }
       // APIClient.delegate = self
        AddPostAPIManager.addPostVideoApi(video: remainingVideoArray, firstVideo: firstVideoArray, parameters: parameters) { result  in
            
            switch result.status {
                
                
            case "1":
                
              
                Constants.shared.uploadImageArray.removeAll()
                //Coordinator.updateRootVCToTab()
                self.submitButton.isEnabled = true
                NotificationCenter.default.post(name: NSNotification.Name("PostUpload"), object: nil)
                Utilities.showWarningAlert(message: result.message ?? "")
                {
                    Coordinator.updateRootVCToTab()
                }
//                for controller in self.navigationController!.viewControllers as Array{
//                    if controller.isKind(of: HomeViewController.self) || controller.isKind(of: ProfileViewController.self) || controller.isKind(of: ChatVC.self) || controller.isKind(of: ResturantListViewController.self){
//                        self.navigationController?.popToViewController(controller, animated: true)
//                    }
//                }
//                Constants.shared.uploading = true
                //
                
            default:
                self.submitButton.isEnabled = true
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.submitButton.isEnabled = true
                }
            }
        }
    }
    
    func uploadLiveVideo(){
        
        guard Constants.shared.uploadVideoArray.count > 0  else {
            Utilities.showWarningAlert(message:  "Please add your post videos.".localiz()) {
                
            }
            return
        }
        let separator = ","
        let result = hashtagsArray.map { String($0) }.joined(separator: separator)
        var parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "caption":post_title.text ?? "",
            "file_type":"2",
            "location":self.currentAddressSting,
            "lattitude":"\(currentLocation?.coordinate.latitude ?? 0)",
            "longitude":"\(currentLocation?.coordinate.longitude ?? 0)",
            "main_file_url":"\(Constants.shared.uploadVideoArray.first!)",
            "hash_tag_list":result.replacingOccurrences(of: "#", with: "")
        ]
        print(parameters)
        if let channelID = self.channelID , channelID != "" {
            parameters["channel_id"] = channelID
        }
        
        AddPostAPIManager.addPostLiveVideoApi(parameters: parameters) { result in
            switch result.status {
                
                
            case "1":
                Constants.shared.uploadImageArray.removeAll()
                self.submitButton.isEnabled = true
                NotificationCenter.default.post(name: NSNotification.Name("PostUpload"), object: nil)
                Utilities.showWarningAlert(message: result.message ?? "")
                {
                    Coordinator.updateRootVCToTab()
                }
//                for controller in self.navigationController!.viewControllers as Array{
//                    if controller.isKind(of: HomeViewController.self) || controller.isKind(of: ProfileViewController.self) || controller.isKind(of: ChatVC.self) || controller.isKind(of: ResturantListViewController.self){
//                        self.navigationController?.popToViewController(controller, animated: true)
//                    }
//                }
               
            default:
                self.submitButton.isEnabled = true
            
                Utilities.showWarningAlert(message: result.message ?? "") {
                    self.submitButton.isEnabled = true
                }
            }
        }
    }
    
    func checkHashTagAPI(hashTagSting:String){
        
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "tag":hashTagSting.replacingOccurrences(of: "#", with: "")
        ]
        print(parameters)
        
        AddPostAPIManager.checkHashTagApi(parameters: parameters) { result in
            switch result.status {
                
            case "1":
              print(result.message ?? "")
            default:
                self.post_title.resignFirstResponder()
                self.removeAlreadyUsedHashTag(hashTag: hashTagSting)
                Utilities.showWarningAlert(message: result.message ?? "") {
                }
            }
        }
    }
    
    func removeAlreadyUsedHashTag(hashTag:String){
        let originalString = self.post_title.text
        let wordToRemove = hashTag + " a"
        // Remove the word from the original string with case-insensitivity
        let modifiedString = originalString?.replacingOccurrences(of: wordToRemove, with: "", options: .caseInsensitive) ?? ""
        let attributedText = highlightHashtags(in: modifiedString)
        self.post_title.attributedText = attributedText
    }
    
    
    @objc private func uploadDidProgress(_ notification: Notification) {
           if let progress = notification.object as? CGFloat {
               print("#############\(progress)")
               self.progressBar.progress = Float(progress)
               let progressPercentage = "\((Float(progress) * 100))"
               let prefix = progressPercentage.prefix(while: { $0 != "." })
               uploadPercentageLabel.text = "\(prefix.description)%"
           }
       }
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func extractHashtags(from text: String) -> [String] {
        let pattern = "#\\w+" // Regular expression pattern to match hashtags
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        // Create an array to store the extracted #tag words
        var hashtags: [String] = []
        hashtagsArray.removeAll()
        // Extract #tag words from the matches
        for match in matches {
            let range = Range(match.range, in: text)!
            let hashtag = text[range]
            hashtags.append(String(hashtag))
        }
        hashtagsArray = hashtags
        return hashtags
    }
    
    func highlightHashtags(in text: String) -> NSAttributedString {
        let pattern = "#\\w+" // Regular expression pattern to match hashtags
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // Create a mutable attributed string with the original text
        let captionText = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedText = NSMutableAttributedString(string: text,attributes: captionText)
        
        // Find all matches in the text
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        // Apply highlighting to the matches
        let defaultFont = UIFont.systemFont(ofSize: 16)
        for match in matches {
            
            let defaultFont = UIFont.systemFont(ofSize: 16)
            let defaultColor = Color.darkOrange.color()
            let fullRange = Range(match.range, in: text)!
            attributedText.addAttribute(.font, value: defaultFont, range: NSRange(fullRange, in: text))
            attributedText.addAttribute(.foregroundColor, value: defaultColor, range: NSRange(fullRange, in: text))
        }
        
        return attributedText
    }
}
extension SubmitPictureVC: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if Constants.shared.uploadImageArray.count > 4{
            return 1
        }else{
            if isFromPicture{
                return 2
            }else{
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if isFromPicture{
                return Constants.shared.uploadImageArray.count
            }else{
                return Constants.shared.uploadVideoArray.count
            }
        }else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowPicCell", for: indexPath) as? ShowPicCell else { return UICollectionViewCell() }
            
            if isFromPicture{
                cell.img.image = Constants.shared.uploadImageArray[indexPath.row]
                cell.actionBlock = {
                    if !Constants.shared.uploadImageArray.isEmpty {
                        Constants.shared.uploadImageArray.remove(at: indexPath.row)
                        self.collectionViewImage.reloadData()
                    }
                    if Constants.shared.uploadImageArray.count == 0{
                        self.navigationController?.popViewController(animated: true)
                    }

                }
            } else{
                self.getThumbnailImageFromVideoUrl(url: Constants.shared.uploadVideoArray[indexPath.row], completion: { image in
                     cell.img.image = image
                })
                cell.actionBlock = {

                    if !Constants.shared.uploadVideoArray.isEmpty {
                        Constants.shared.uploadVideoArray.remove(at: indexPath.row)
                        self.collectionViewImage.reloadData()
                    }
                    if Constants.shared.uploadVideoArray.count == 0{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreCollectionViewCell", for: indexPath) as? AddMoreCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 103, height:130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            if isFromPicture && !Constants.shared.uploadImageArray.isEmpty {
                let  VC = AppStoryboard.TakePicture.instance.instantiateViewController(withIdentifier: "PhotoViewViewController") as! PhotoViewViewController
                VC.image = Constants.shared.uploadImageArray[indexPath.row]
                self.present(VC, animated: true, completion: nil)
            }else{
                
            }
        }else{
            isFromPicture = true
            Coordinator.goToTakePicture(controller: self)
        }
        
    }
}
extension SubmitPictureVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationCoordinates = currentLocation
        self.locationManager.stopUpdatingLocation()
    }
}

extension SubmitPictureVC:uploadProgressProtocol{
    func uploadProgressAction(progress: CGFloat) {
        print(progress)
    }
    
    
}
extension SubmitPictureVC:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        // Get the text from the UITextView
        guard let text = textView.text else {
            return
        }
        
        // Highlight #tag words and update the attributed text
        let attributedText = highlightHashtags(in: text)
        textView.attributedText = attributedText
        
        let tags = extractHashtags(from: text)
 
        if tags.count > 0{
            
            let lastText = text.last?.description ?? ""
            let tagText = tags.last ?? ""
            let compainText = tagText + lastText
            if let lastTagRange = text.range(of: compainText , options: .backwards) {
                // Check if the last character in the range is a space
                let lastCharacterIndex = text.index(before: lastTagRange.upperBound)
                if lastCharacterIndex >= text.startIndex, text[lastCharacterIndex] == " " {
                    print("Last character of #tag is a space")
                    checkHashTagAPI(hashTagSting: tags.last ?? "")
                } else {
                    print("Last character of #tag is not a space")
                }
            }
        }
    }
}
