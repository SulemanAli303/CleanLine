//
//  CharletRoomDetails.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit
import FSPagerView
import CHIPageControl
import Lightbox
import ImageSlideshow

class CharletRoomDetails: BaseViewController {
    @IBOutlet weak var imagePageControl: CHIPageControlJaloro! {
        didSet{
            imagePageControl.tintColor = .white
            imagePageControl.currentPageTintColor = UIColor(named: "DarkOrange")
            imagePageControl.radius = 2
        }
    }
    @IBOutlet weak var imageSlider: FSPagerView!{
        didSet {
            self.imageSlider.delegate = self
            self.imageSlider.dataSource = self
            self.imageSlider.automaticSlidingInterval = 3.0
            self.imageSlider.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.imageSlider.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var mediaSlider: MediaSlideshow!
    
    @IBOutlet weak var collectionFacilitiesView: UICollectionView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var favImg: UIImageView!
    var chaletID = ""
    var chaletProduct : ChaletsDetailData? {
        didSet {
            self.scroller.isHidden = false
            myImage.sd_setImage(with: URL(string: chaletProduct?.product?.cover_image ?? ""), placeholderImage: UIImage(named: "placeholder_banner"))
            name.text = chaletProduct?.product?.name ?? ""
            currency.text = chaletProduct?.product?.currency_code ?? ""
            //price.text = " \((Double(chaletProduct?.product?.price ?? "") ?? 0.0))/Per Day"
            
            let priceVal = " \((Double(chaletProduct?.product?.price ?? "")) ?? 0.0) / "
            let convertedString = chaletProduct?.product?.price_type?.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
            
            let attributedString = NSMutableAttributedString(string: priceVal, attributes: [
                .font: UIFont(name: "Roboto-Bold", size: 22.0)!
            ])
            
            attributedString.append(NSAttributedString(string: convertedString, attributes: [
                .font: UIFont(name: "Roboto-Bold", size: 14.0)!,
                .baselineOffset: 0  // Adjust the offset to align the small text
            ]))
            
            price.attributedText = attributedString
            
            about.text = chaletProduct?.product?.description ?? ""
            viewControllerTitle = chaletProduct?.product?.name ?? ""
            if chaletProduct?.product?.isLiked == "1"{
                favImg.image = UIImage(named: "liked")
            }else{
                favImg.image = UIImage(named: "unliked")
            }
            setFacilites()
            setImageSlider()
        }
    }
    @IBAction func fullViewOfImageAction(_ sender: UIButton) {
        var array  = [String]()
        for item in self.chaletProduct?.product?.gallery ?? []{
            array.append(item.content)
        }
        let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
        VC.imageURLArray = array
        self.navigationController?.pushViewController(VC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack
       // viewControllerTitle = "Select Room"
        mediaSlider.layer.cornerRadius = 165
        mediaSlider.clipsToBounds = true
        mediaSlider.layer.maskedCorners = [.layerMaxXMaxYCorner]
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.scroller.isHidden = true
    }
    override func notificationBtnAction () {
        Coordinator.goToNotifications(controller: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        self.getChaletDetailsAPI()
    }
    @IBAction func bookNow(_ sender: UIButton) {
       // Coordinator.goToChaletCart(controller: self,chaletID: self.chaletID,start_date_time: "2023-06-20",end_date_time: "2023-06-30")
        Coordinator.goToChaletSetDate(controller: self,chaletId: self.chaletID)
    }
    func setFacilites() {
        collectionFacilitiesView.delegate = self
        collectionFacilitiesView.dataSource = self
        collectionFacilitiesView.register(UINib.init(nibName: "EventFaclitiesCell", bundle: nil), forCellWithReuseIdentifier: "EventFaclitiesCell")
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        self.collectionFacilitiesView.collectionViewLayout = layout2
        collectionFacilitiesView.reloadData()
    }
    
    func setImageSlider(){
        imagePageControl.numberOfPages = chaletProduct?.product?.gallery?.count ?? 0
        var localSource : [SDWebImageSource] = []
        var videoSource : [AVSource] = []
        
        if let gallery = self.chaletProduct?.product?.gallery {
            for single in gallery {
                if let encodedURLString = single.content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    if(single.type == "video"){
                        videoSource.append(AVSource(url: URL(string: encodedURLString)!, onAppear: .play))
                    }else{
                        localSource.append(SDWebImageSource(url: URL(string: encodedURLString)!,placeholder: UIImage(named: "placeholder_banner")))
                    }
                }
                
            }
        }
        
        
        mediaSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        mediaSlider.contentScaleMode = UIViewContentMode.scaleAspectFill
        mediaSlider.pageIndicator?.view.isHidden = true

        mediaSlider.pageIndicator = UIPageControl.withSlideshowColors()

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        mediaSlider.activityIndicator = DefaultActivityIndicator()
        mediaSlider.delegate = self

        mediaSlider.setMediaSources(localSource + videoSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSlider))
        mediaSlider.addGestureRecognizer(recognizer)
        
    }
    
    @objc func didTapSlider() {
        let fullScreenController = mediaSlider.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: UIActivityIndicatorView.Style.medium, color: nil)
    }
    
    @IBAction func btnFav(_ sender: Any) {
        if !SessionManager.isLoggedIn() {
            Coordinator.presentLogin(viewController: self)
        }else {
            self.AddTOFav()
        }
    }
}
extension CharletRoomDetails {
    
    func getChaletDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "id" : self.chaletID
        ]
        CharletAPIManager.getCharletListProductAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.chaletProduct = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func AddTOFav() {
        var fav = "1"
        if chaletProduct?.product?.isLiked == "1"{
            fav = "0"
        }
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "like" : fav,
            "id" : self.chaletID
        ]
        CharletAPIManager.charletListProductLikeAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getChaletDetailsAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension CharletRoomDetails: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return chaletProduct?.product?.facilities?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventFaclitiesCell", for: indexPath) as? EventFaclitiesCell else { return UICollectionViewCell() }
        
        cell.name.text! = chaletProduct?.product?.facilities?[indexPath.row].name ?? ""
        cell.img.sd_setImage(with: URL(string: "\( chaletProduct?.product?.facilities?[indexPath.row].icon ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 72, height:85)
        
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
        
    }
}

extension CharletRoomDetails : FSPagerViewDataSource,FSPagerViewDelegate {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.chaletProduct?.product?.gallery?.count ?? 0
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let single = self.chaletProduct?.product?.gallery?[index]
        cell.imageView?.sd_setImage(with: URL(string: single?.content ?? ""), placeholderImage: UIImage(named: "placeholder_banner"))
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = nil
        return cell
    }

    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        var array  = [LightboxImage]()
        if let gallery = self.chaletProduct?.product?.gallery {
            let single = gallery[index]
            if let encodedURLString = single.content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: encodedURLString) {
                    if(single.type == "video"){
                        array.append(LightboxImage(image: #imageLiteral(resourceName: "placeholder_banner"),text: "",videoURL: url))
                    }else{
                        array.append(LightboxImage(imageURL: url))
                    }
                }
            }
            
            for (indexV,item) in gallery.enumerated(){
                //array.append(item.content)
                if(indexV != index){
                    if let encodedURLString = item.content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        if let url = URL(string: encodedURLString) {
                            if(item.type == "video"){
                                array.append(LightboxImage(image: #imageLiteral(resourceName: "propic-placeholder"),text: "",videoURL: url))
                            }else{
                                array.append(LightboxImage(imageURL: url))
                            }
                        }
                    }
                }
                
                
            }
        }
        
        
        let controller = LightboxController(images: array)
        controller.dynamicBackground = true
        
        present(controller, animated: true, completion: nil)
        
        
        
//        let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
//        VC.imageURLArray = array
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.imagePageControl.set(progress: targetIndex, animated: true)
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.imagePageControl.set(progress: pagerView.currentIndex, animated: true)

    }
    
}


extension CharletRoomDetails: MediaSlideshowDelegate {
    func mediaSlideshow(_ mediaSlideshow: MediaSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        self.imagePageControl.set(progress: page, animated: true)
    }
}
