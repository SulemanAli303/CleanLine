//
//  DateAndCalanderVC.swift

//
//  Created by apple on 21/10/2022.
//


import Foundation
import UIKit
import FSPagerView
import PageControls
import SDWebImage
import FSPagerView
import CHIPageControl
import Lightbox

protocol DateAndCalanderVCDelegate: AnyObject {
    func selecetdServiceDate(_ date: String)
}

class DateAndCalanderVC: BaseViewController, TableCellDelegate {
    func cellWasTapped(cell: TableCell, tag: String) {
        
    }
    fileprivate lazy var dateFormatterMain: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var theTableView: UITableView! {
        didSet {
        }
    }
//    @IBOutlet weak var topImg: UIImageView!
    
    @IBOutlet weak var imagePageControl: CHIPageControlJaloro! {
        didSet{
            imagePageControl.tintColor = .white
            imagePageControl.currentPageTintColor = UIColor(named: "DarkOrange")
            imagePageControl.radius = 2
        }
    }
    @IBOutlet weak var imageSlider: FSPagerView!
    
    @IBOutlet weak var mediaSlider: MediaSlideshow!
    
    private var firstDate: Date?
    private var lastDate: Date?
    var chaletID = ""
    var chaletProduct : ChaletsDetailData? {
        didSet {
            //topImg.sd_setImage(with: URL(string: chaletProduct?.product?.cover_image ?? ""), placeholderImage: UIImage(named: "propic-placeholder"))
            viewControllerTitle = chaletProduct?.product?.name ?? ""
            setImageSlider()
        }
    }
    var avalible  : [String]? {
        didSet {
            theTableView.delegate = self
            theTableView.dataSource = self
            theTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .transperantBack
        registerXibs()
        self.getChaletDetailsAPI()
        self.getChaletAvaliableAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func registerXibs() {
        
        theTableView.register(UINib.init(nibName: "CalanderCell", bundle: nil), forCellReuseIdentifier: "CalanderCell")
        theTableView.register(UINib.init(nibName: "ButtonViewCell", bundle: nil), forCellReuseIdentifier: "ButtonViewCell")
        
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
    
    
    
    @IBAction func backPressed(_ sender: Any) {
        print("back")
        navigateBack()
    }
    
    func navigateBack(){
        if let _ = navigationController?.popViewController(animated: true) {
        } else {
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func cartPressed(_ sender: Any) {
        print("cartPressed")
        //Coordinator.goToCheckOut(delegate: self)
    }
    
    override func notificationBtnAction() {
        Coordinator.goToNotifications(controller: self)
    }
    
}

extension DateAndCalanderVC:DateAndCalanderVMDelegate{
    
    func updateView(_ date: String) {
        navigateBack()
    }
}

extension DateAndCalanderVC {
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
    func getChaletAvaliableAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "id" : self.chaletID
        ]
        CharletAPIManager.getCharletAvaliabliltyAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.avalible = result.oData?.list ?? []
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
// MARK: - UITableView Delegate & DataSource
extension DateAndCalanderVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = indexPath.section
        switch sections {
        case 0:
            guard let cell: CalanderCell = tableView.dequeueReusableCell(withIdentifier: "CalanderCell", for: indexPath) as? CalanderCell else { return UITableViewCell() }
            cell.avalible = avalible
            cell.theCaldenderateDelegate = self
            cell.notAvailableDates = self.chaletProduct?.bookings
            cell.fsCalender()
            cell.priceType = self.chaletProduct?.product?.price_type ?? "per_day"
            cell.didToggleCalenderView = { [weak self] in
                guard let self = self else { return }
                self.theTableView.beginUpdates()
                self.theTableView.endUpdates()
            }
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell: ButtonViewCell = tableView.dequeueReusableCell(withIdentifier: "ButtonViewCell", for: indexPath) as? ButtonViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.btnBack.addTarget(self, action: #selector(btnNextFun(sender:)), for: .touchUpInside)
            cell.btnNext.addTarget(self, action: #selector(btnBackFun(sender:)), for: .touchUpInside)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    @objc func btnBackFun(sender: UIButton){
        if self.firstDate == nil {
            Utilities.showWarningAlert(message: "Please select date".localiz()) {
                
            }
        }else  if self.lastDate == nil {
//            self.lastDate = Calendar.current.date(byAdding: .day, value: 1, to: self.firstDate ?? Date())!
            self.lastDate = self.firstDate
            let start : String = dateFormatterMain.string(from:self.firstDate ?? Date())
            let end : String = dateFormatterMain.string(from:self.lastDate ?? Date())
            if SessionManager.isLoggedIn() {
                Coordinator.goToChaletCart(controller: self,chaletID: self.chaletID,start_date_time: start,end_date_time: end)
            }else {
                Coordinator.presentLogin(viewController: self)
            }
        }else {
            let start : String = dateFormatterMain.string(from:self.firstDate ?? Date())
            let end : String = dateFormatterMain.string(from:self.lastDate ?? Date())
            if SessionManager.isLoggedIn() {
                Coordinator.goToChaletCart(controller: self,chaletID: self.chaletID,start_date_time: start,end_date_time: end)
            }else {
                Coordinator.presentLogin(viewController: self)
            }
        }
    }
    @objc func btnNextFun(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
extension DateAndCalanderVC: CalanderCellDelegate {
    func setDate(firstDate: Date?, lastDate: Date?) {
        self.firstDate = firstDate
        self.lastDate = lastDate
    }
}


extension DateAndCalanderVC : FSPagerViewDataSource,FSPagerViewDelegate {
    
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
        for item in self.chaletProduct?.product?.gallery ?? []{
            //array.append(item.content)
            if let encodedURLString = item.content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: encodedURLString) {
                    if(item.type == "video"){
                        array.append(LightboxImage(image: #imageLiteral(resourceName: "placeholder_banner"),text: "",videoURL: url))
                    }else{
                        array.append(LightboxImage(imageURL: url))
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

extension DateAndCalanderVC: MediaSlideshowDelegate {
    func mediaSlideshow(_ mediaSlideshow: MediaSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        self.imagePageControl.set(progress: page, animated: true)
    }
}
