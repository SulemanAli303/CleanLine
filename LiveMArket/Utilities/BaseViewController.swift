//
//  BaseViewController.swift
//  LiveMArket
//
//  Created by Albin Jose on 10/01/23.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseDynamicLinks
import SocketIO
import FittedSheets
enum ViewControllerType {
    case transperantBack
    case transperantBackWithTwo
    case backWithTop
    case backWithSearchButton
    case backWithNotifications
    case chatList
    case notifications
    case backWithSearchButton2
    case backTitleRightButton
    case accountsTop
    case chat
    case backWithoutTitle
    case backWithChatButton
}
var notificationCount = "0" {
    didSet {
        NotificationCenter.default.post(name: Notification.Name("notificationNumberChanged"), object: nil)
    }
}
var selectedSwitchImg = ""
class BaseViewController: UIViewController {
    var switchButton = UIButton(type: UIButton.ButtonType.custom)
    var type: ViewControllerType = .transperantBack
    var titleLabel: UILabel?
    var viewControllerTitle: String? {
        didSet {
            titleLabel?.text = viewControllerTitle?.localiz() ?? ""
        }
    }
    let notificationCountView = UIView()
    var notificationCountLabel: UILabel = {
        let cartCountLabel = UILabel()
        cartCountLabel.font = UIFont.systemFont(ofSize: 10)
        cartCountLabel.textColor = UIColor.white
        return cartCountLabel
        
    }()
   
    var profileImage = UIImageView()
    var hasTopNotch: Bool = Constants.shared.hasTopNotch

    var getNotchHeight : CGFloat{
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.addObserver(self, selector: #selector(switchObserver), name: Notification.Name("switchAccount"), object: nil)
        
         print("Pushed class-------------\(NSStringFromClass(self.classForCoder))")

        // Do any additional setup after loading the view.
    }
    @objc func switchObserver(_ notification: NSNotification) {
        solidNavigationBar()
        setUpAccountsVC(isDriver: false)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        switch type {
        case .transperantBack:
            solidNavigationBar()
            setUpBAckBarButtons()
        case .backWithoutTitle:
            solidNavigationBar()
            setUpWithotBAckBarButtons()
        case .backWithTop :
            solidBackNav()
            setBackWithBar()
        case .backWithSearchButton :
            solidBackNav()
            setBackWithBar()
            addSearchRight()
            
        case .backWithNotifications:
            solidBackNav()
            self.setUpbackWithNotifications(doAddNotification: true)
        case .transperantBackWithTwo:
            solidNavigationBar()
            setBackwithTwo()
        case .chatList:
            solidBackNav()
            setChatList()
        case .notifications:
            solidBackNav()
            setNotifications()
        case .backWithSearchButton2:
          //  solidNavigationBar()
            setUpBAckBarButtons()
            addSearchRight()
        case .backTitleRightButton :
            solidBackNav()
            setAddress()
        case .accountsTop:
            solidNavigationBar()
            setUpAccountsVC()
        case .chat:
            solidBackNav()
            setChatBtns()
        case .backWithChatButton:
            solidBackNav()
            setCommentBtns()
        default:
            break
        }
        super.viewWillAppear(true)
    }
    func addSearchRight() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 130.0, height: 80.0))
        let image = #imageLiteral(resourceName: "Group 235111")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(SearchAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems?.append(barButton)
    }
    @objc func SearchAction() {
        
    }
    @objc func liveAction() {
        
    }
    @objc func ChatAction() {
        
    }
    //MARK: - Methods
    func solidNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        let image = #imageLiteral(resourceName: "I").stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundImage = UIImage()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.backgroundColor = .clear
        }
    }
    
    func solidBackNav() {
        navigationController?.navigationBar.isTranslucent = true
        let image = UIImage(named: "Rectangle 25274")!.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundImage = image
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.backgroundColor = .clear
        }
        
    }
    func addClear() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120.0, height: 60.0))
        button.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.setTitle("CLEAR ALL".localiz(), for: .normal)
        button.titleLabel?.font = AppFonts.regular.size(14)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems?.append(barButton)
    }
    
    func addAddress() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 140.0, height: 60.0))
        button.addTarget(self, action: #selector(addNewAddress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.setTitle("Add new address".localiz(), for: .normal)
        button.titleLabel?.font = AppFonts.regular.size(14)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems?.append(barButton)
    }
    @objc func clearAll() {
        
    }
    @objc func removeRightBarbuttons() {
        navigationItem.rightBarButtonItems = []
    }
    @objc func addNewAddress() {
        
    }
    func setUpbackWithNotifications(doAddNotification:Bool = true) {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
        addTitleLabel()
        doAddNotification ? addNotification() : print("no Need")
    }
    
    func setBackwithTwo(doAddNotification:Bool = true) {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
        addTitleLabel()
        addLiveIcon()
        doAddNotification ? addNotification() : print("no Need")
    }
    func setUpBAckBarButtons(doAddNotification:Bool = true) {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
        addTitleLabel()
        doAddNotification ? addNotification() : print("no Need")
    }
    func setUpWithotBAckBarButtons(doAddNotification:Bool = true) {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
       // doAddNotification ? addNotification() : print("no Need")
    }
    func setUpAccountsVC(doAddNotification:Bool = true,isDriver:Bool = false) {

        if (self.view.window != nil){
           
            if (self .isKind(of: ProfileViewController.self))
            {
                navigationItem.leftBarButtonItems = []
                navigationItem.rightBarButtonItems = []
                if isDriver == true {
                    addSwitchBtn()
                    addHideSwitchBtn()
                }else {
                    addHideSwitchBtn()
                }

                addNotification()
                addLikeIcon()
            }
        }
        else{
            print("no view window")
        }
      
        
    }
    func setBackWithBar(doAddNotification:Bool = true) {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
        addTitleLabel()
    }
    func setChatBtns() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addChatButtons()
        addTitleLabel()
    }
    func setCommentBtns() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
        addChatButtonRight()
        addTitleLabel()
    }
    func setAddress(doAddNotification:Bool = true) {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
        addTitleLabel()
        addAddress()
    }
    func setChatList() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addTitleLabel()
        addNotification()
    }
    func setNotifications() {
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = []
        addBackButton()
        addTitleLabel()
        addClear()
    }
    func addLikeIcon() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
        let image = #imageLiteral(resourceName: "filled-wish")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems?.append(barButton)
    }
    func addBackButton() {
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "roundWhiteBack"), for: .normal)
        backButton.setBackgroundImage(#imageLiteral(resourceName: "roundWhiteBack"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        
        backButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.30).cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        backButton.layer.shadowOpacity = 1.0
        backButton.layer.shadowRadius = 10.0
        backButton.layer.masksToBounds = false
        
        
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: backButton))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    func addLiveIcon() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
        let image = #imageLiteral(resourceName: "Group 235123")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(liveAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems?.append(barButton)
    }
    func addBackButtonWithSimple() {
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "roundWhiteBack"), for: .normal)
       // backButton.setBackgroundImage(#imageLiteral(resourceName: "Path 402"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: backButton))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    func addTitleLabel() {
        titleLabel = UILabel()
        if let titleLabel = titleLabel {
            titleLabel.text = viewControllerTitle ?? ""
            titleLabel.font = UIFont(name:"Poppins-Bold", size: 18)
            titleLabel.textColor = UIColor.white
            
            titleLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.30).cgColor
            titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
            titleLabel.layer.shadowOpacity = 1.0
            titleLabel.layer.shadowRadius = 10.0
            titleLabel.layer.masksToBounds = false
            
            let stack = UIStackView(arrangedSubviews: [titleLabel])
            let barButton = UIBarButtonItem(customView: stack)
            navigationItem.leftBarButtonItems?.append(barButton)
            
        }
    }
    func addNotification() {
        let notificationView = UIView(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
        let notificationButton = UIButton(type: UIButton.ButtonType.custom)
        notificationButton.addTarget(self, action: #selector(notificationBtnAction), for: .touchUpInside)
        notificationButton.setImage(UIImage(named: "Group 235268"), for: .normal)
        notificationButton.imageView?.contentMode = .scaleAspectFit
        notificationView.addSubview(notificationButton)
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        notificationButton.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 0).isActive = true
        notificationButton.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 0).isActive = true
        notificationButton.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: 0).isActive = true
        notificationButton.rightAnchor.constraint(equalTo: notificationView.rightAnchor, constant: 0).isActive = true
        notificationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        notificationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //cartButton.addNormalShadow = true
        notificationButton.backgroundColor = .clear
        notificationButton.ibcornerRadius = 5
        notificationButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        notificationCountView.backgroundColor = .red
        notificationCountView.layer.cornerRadius = 18/2
        notificationCountView.isUserInteractionEnabled = false
        notificationCountLabel.textColor = .white
        if notificationCount == "0" {
            notificationCountView.isHidden = true
        } else {
            notificationCountView.isHidden = false
        }
        notificationCountLabel.text = "\(notificationCount)"
        notificationCountLabel.adjustsFontSizeToFitWidth = true
        notificationCountView.addSubview(notificationCountLabel)
        notificationCountLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationCountLabel.centerXAnchor.constraint(equalTo: notificationCountView.centerXAnchor, constant: 0).isActive = true
        notificationCountLabel.centerYAnchor.constraint(equalTo: notificationCountView.centerYAnchor, constant: 0).isActive = true
        notificationView.addSubview(notificationCountView)
        notificationCountView.translatesAutoresizingMaskIntoConstraints = false
        notificationCountView.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: 3).isActive = true
        notificationCountView.centerYAnchor.constraint(equalTo: notificationView.topAnchor, constant:4).isActive = true
        notificationCountView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        notificationCountView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [notificationView])
        stack.spacing = 8
        let barButton = UIBarButtonItem(customView: stack)
        navigationItem.rightBarButtonItems?.append(barButton)
    }
    func addChatButtons() {
        let backBtnView = UIView(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
        let backBtn = UIButton(type: UIButton.ButtonType.custom)
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backBtn.setImage(#imageLiteral(resourceName: "roundWhiteBack"), for: .normal)
       // backBtn.setBackgroundImage(#imageLiteral(resourceName: "roundWhiteBack"), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtnView.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.topAnchor.constraint(equalTo: backBtnView.topAnchor, constant: 0).isActive = true
        backBtn.bottomAnchor.constraint(equalTo: backBtnView.bottomAnchor, constant: 0).isActive = true
        backBtn.leftAnchor.constraint(equalTo: backBtnView.leftAnchor, constant: 0).isActive = true
        backBtn.rightAnchor.constraint(equalTo: backBtnView.rightAnchor, constant: 0).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 27).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 27).isActive = true
        //cartButton.addNormalShadow = true
        backBtn.backgroundColor = .clear
        backBtn.ibcornerRadius = 5
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        let profileView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        profileView.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.backgroundColor = .clear
        profileView.addSubview(profileImage)
        
        profileImage.layer.cornerRadius = 3
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 0).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 0).isActive = true
        profileImage.leftAnchor.constraint(equalTo: profileView.leftAnchor, constant: 0).isActive = true
        profileImage.rightAnchor.constraint(equalTo: profileView.rightAnchor, constant: 0).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        
        let stack = UIStackView(arrangedSubviews: [backBtnView,profileView])
        stack.spacing = 8
        let barButton = UIBarButtonItem(customView: stack)
        navigationItem.leftBarButtonItems?.append(barButton)
    }
    
    func addSwitchBtn() {
        let notificationView = UIView(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
        switchButton = UIButton(type: UIButton.ButtonType.custom)
        switchButton.addTarget(self, action: #selector(SwitchBtnAction), for: .touchUpInside)
        switchButton.setImage(UIImage(named: selectedSwitchImg), for: .normal)
        if (SessionManager.getUserData()?.is_notifiable ?? "") == "1" {
            switchButton.setImage(UIImage(named: "Group 236528"), for: .normal)
        }else {
            switchButton.setImage(UIImage(named: "Group 236529"), for: .normal)
        }
        switchButton.imageView?.contentMode = .scaleAspectFit
        notificationView.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 0).isActive = true
        switchButton.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 0).isActive = true
        switchButton.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: 0).isActive = true
        switchButton.rightAnchor.constraint(equalTo: notificationView.rightAnchor, constant: 0).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //cartButton.addNormalShadow = true
        switchButton.backgroundColor = .clear
        switchButton.ibcornerRadius = 5
        switchButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

        let stack = UIStackView(arrangedSubviews: [notificationView])
        stack.spacing = 8
        let barButton = UIBarButtonItem(customView: stack)
        navigationItem.leftBarButtonItems?.append(barButton)
    }
    
    func addHideSwitchBtn() {
        let notificationView = UIView(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
        switchButton = UIButton(type: UIButton.ButtonType.custom)
        switchButton.addTarget(self, action: #selector(SwitchBtnAction_hide), for: .touchUpInside)
        switchButton.setImage(UIImage(named: selectedSwitchImg), for: .normal)
        if (SessionManager.getUserData()?.hide_profile ?? "") == "1" {
            switchButton.setImage(UIImage(named: "Group 236530"), for: .normal)
        }else {
            switchButton.setImage(UIImage(named: "Group 236531"), for: .normal)
        }
        switchButton.imageView?.contentMode = .scaleAspectFit
        notificationView.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 0).isActive = true
        switchButton.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: 0).isActive = true
        switchButton.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: 0).isActive = true
        switchButton.rightAnchor.constraint(equalTo: notificationView.rightAnchor, constant: 0).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //cartButton.addNormalShadow = true
        switchButton.backgroundColor = .clear
        switchButton.ibcornerRadius = 5
        switchButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

        let stack = UIStackView(arrangedSubviews: [notificationView])
        stack.spacing = 8
        let barButton = UIBarButtonItem(customView: stack)
        navigationItem.leftBarButtonItems?.append(barButton)
    }
    
    func addChatButtonRight() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 130.0, height: 80.0))
        let image = #imageLiteral(resourceName: "chatIconBig")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(ChatAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems?.append(barButton)
    }
    
    //MARK: - Actions
    @objc func backButtonAction() {
        if let _ = navigationController?.popViewController(animated: true) {
            
        } else {
            navigationController?.tabBarController?.selectedIndex = 0
            dismiss(animated: true, completion: nil)
            
        }
    }
    @objc func notificationBtnAction() {
        Coordinator.goToNotifications(controller: self)
    }
    @objc func SwitchBtnAction() {
     
    }
    @objc func SwitchBtnAction_hide() {
     
    }
    @objc func likeAction() {
    }
    
    func showMapOptions(latitude : String , longitude : String , name : String) {
    
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // Google Maps action
        let googleMapsAction = UIAlertAction(title: "Google Maps".localiz(), style: .default) { _ in
            self.openGoogleMaps(latitude : latitude , longitude : longitude , name : name)
        }
        alertController.addAction(googleMapsAction)

        // Apple Maps action
        let appleMapsAction = UIAlertAction(title: "Apple Maps".localiz(), style: .default) { _ in
            self.openAppleMaps(latitude : latitude , longitude : longitude , name : name)
        }
        alertController.addAction(appleMapsAction)

        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Present the action sheet
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openGoogleMaps(latitude : String , longitude : String , name : String) {

        let coordinates = "\(latitude ),\(longitude )"
        
        let urlString = "comgooglemaps://?center=\(coordinates)&zoom=14&views=traffic&q=\(coordinates)"
        
        guard let googleMapsURL = URL(string: urlString) else {
            return
        }
        if UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        }else{
            let urlString = "https://www.google.com/maps/search/?api=1&query=\(latitude ?? "0"),\(longitude ?? "0")"
            guard let googleMapsURL = URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        }
    }

    func openAppleMaps(latitude : String , longitude : String , name : String) {
        // Open Apple Maps with a specific location
        
        let coordinate = CLLocationCoordinate2D(latitude: Double(latitude ?? "0") ?? 0, longitude: Double(longitude ?? "0") ?? 0)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps()
    }
    
    
    func createShareURL(id : String , type : String , title : String , image : String) {
        Utilities.showIndicatorView()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "soouqlive.com"
        components.path = "/public/share"
        
        let queryItem = URLQueryItem(name: "id", value: id)
        let type = URLQueryItem(name: "type", value: type)
        
        components.queryItems = [queryItem,type]
        
        guard let linkParameter = components.url else {
            return
        }
        
        print("i am sharing \(linkParameter.absoluteString)")
        
        guard  let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://livemarketapp.page.link") else {
            return
        }
    
        
        if  let bundleID = Bundle.main.bundleIdentifier{
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        }
        shareLink.iOSParameters?.appStoreID = ""
        shareLink.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
        shareLink.navigationInfoParameters?.isForcedRedirectEnabled = true
        
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.mobiria.livemarket")
        
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = title
        shareLink.socialMetaTagParameters?.descriptionText = ""
        if let url = URL(string: image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
            shareLink.socialMetaTagParameters?.imageURL = url
        }
    
        
        guard let longurl = shareLink.url else {
            return
        }
        print("long sharing \(longurl.absoluteString)")
        
        shareLink.shorten {(url, warning, error) in
            Utilities.hideIndicatorView()
            if let error = error{
                print(error)
                return
            }
            
            if let shareURL = url {
                let items: [Any] = [title,shareURL]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            }
        
        }
        
    }
    
    func connectSocket(){
        var manager : SocketManager!
        var socket:SocketIOClient!
        manager = SocketManager(socketURL: URL(string: "http://soouqlive.com:8080")!,config: [.log(false),.connectParams(["token":"\(SessionManager.getAccessToken() ?? "0")"]), .compress, .forceWebsockets(true)]) //.forceWebsockets(true)
        socket = manager.defaultSocket;
       // self.subject = Observable(value: nil)
        //        socket.joinNamespace("/swift") // Create a socket for the /swift namespac
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected \(data)")
            //  self.getInitialPost?(data)
            //self.subject.notifySocketConnect()
            SocketIOManager.sharedInstance.subject.notifySocketConnect()
            SocketIOManager.sharedInstance.observeNewPost()
        }
        socket.on(clientEvent: .error) {data, ack in
            print("error connected \(data)")
        }
        socket?.on(clientEvent: .disconnect){data, ack in
            print("disconnect")
        }
        
        //self.socket.status == .connected
    }
    
    func showCompletedPopup(titleMessage:String,confirmMessage:String,invoiceID:String,viewcontroller:UIViewController){
        DispatchQueue.main.async {
            let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
            //controller.delegate = viewcontroller as! any SuccessProtocol
          
            controller.heading = titleMessage
            controller.confirmationText = confirmMessage
            controller.buttonOption = .showAll
            controller.invoiceNumber = invoiceID
            let sheet = SheetViewController(
                controller: controller,
                sizes: [.fullscreen],
                options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
            sheet.minimumSpaceAbovePullBar = 0
            sheet.dismissOnOverlayTap = false
            sheet.dismissOnPull = false
            sheet.contentBackgroundColor = UIColor.black.withAlphaComponent(0.5)
            controller.onReviewPressed = {
                controller.dismiss(animated: true)
                self.performSelector(onMainThread: Selector("showRating"), with: nil, waitUntilDone: false)
            }
            viewcontroller.present(sheet, animated: true, completion: nil)
        }
    }
    
    func showCompletedPopupWithHomeButtonOnly(titleMessage:String,confirmMessage:String,invoiceID:String,viewcontroller:UIViewController){
        DispatchQueue.main.async {
            let  controller =  AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
            //controller.delegate = viewcontroller as! any SuccessProtocol
          
            controller.heading = titleMessage
            controller.confirmationText = confirmMessage
            controller.buttonOption = .showHome
            controller.invoiceNumber = invoiceID
            let sheet = SheetViewController(
                controller: controller,
                sizes: [.fullscreen],
                options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
            sheet.minimumSpaceAbovePullBar = 0
            sheet.dismissOnOverlayTap = false
            sheet.dismissOnPull = false
            sheet.contentBackgroundColor = UIColor.black.withAlphaComponent(0.5)
            controller.onReviewPressed = {
                controller.dismiss(animated: true)
                self.performSelector(onMainThread: Selector("showRating"), with: nil, waitUntilDone: false)
            }
            viewcontroller.present(sheet, animated: true, completion: nil)
        }
    }
    
    func generateRandomID(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomID = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            randomID.append(randomCharacter)
        }
        
        return randomID
    }
    
    func navigateGoogleMap(lat:String, longi:String){
        
        if isGoogleMapsInstalled() {
            print("Google Maps is installed on the device.")
            // "comgooglemaps://?q=\(lat),\(longi)"
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Handle the case where Google Maps is not installed.
                }
            }
        } else {
            print("Google Maps is not installed on the device.")
            Utilities.showWarningAlert(message: "Google Maps is not installed on the device.".localiz())
        }
        
    }
    
    func navigateAppleMap(lat:String, longi:String){
        if let url = URL(string: "http://maps.apple.com/?q=\(lat),\(longi)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Handle the case where Apple Maps is not available.
            }
        }
    }
    
    func isGoogleMapsInstalled() -> Bool {
        let googleMapsURL = URL(string: "comgooglemaps://")!
        
        // Check if the Google Maps URL can be opened
        return UIApplication.shared.canOpenURL(googleMapsURL)
    }
    
    func takeScreenshot(of view: UIView) -> UIImage? {
        // Create a UIGraphicsImageRenderer for the view's bounds
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        
        // Use the renderer to capture a screenshot
        let screenshot = renderer.image { context in
            // Render the specified view into the image context
            view.layer.render(in: context.cgContext)
        }
        
        return screenshot
    }

    func openGoogleMapsDirections(fromLat: String, fromLng: String, toLat: String, toLng: String) {
        let googleMapsURLString = "https://www.google.com/maps/dir/?api=1&origin=\(fromLat),\(fromLng)&destination=\(toLat),\(toLng)&travelmode=driving"

        if let url = URL(string: googleMapsURLString) {
                // Check if Google Maps is installed
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                    // Construct a URL for opening in the Google Maps app
                let googleMapsAppURLString = "comgooglemaps://?saddr=\(fromLat),\(fromLng)&daddr=\(toLat),\(toLng)&directionsmode=driving"
                if let appUrl = URL(string: googleMapsAppURLString) {
                    UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
                }
            } else {
                    // Open in Safari if Google Maps is not installed
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            print("Could not create URL")
        }
    }
    
    func openAppleMapsWithDriving(fromLat: String, fromLng: String, toLat: String, toLng: String) {
        let coordinateFrom = CLLocationCoordinate2D(latitude: Double(fromLat)!, longitude: Double(fromLng)!)
        let coordinateTo = CLLocationCoordinate2D(latitude: Double(toLat)!, longitude: Double(toLng)!)

        let placemarkFrom = MKPlacemark(coordinate: coordinateFrom)
        let placemarkTo = MKPlacemark(coordinate: coordinateTo)

        let mapItemFrom = MKMapItem(placemark: placemarkFrom)
        let mapItemTo = MKMapItem(placemark: placemarkTo)

        mapItemFrom.name = "Start Location"  // Optional: set a name
        mapItemTo.name = "Destination Location"  // Optional: set a name

            // Set options for the direction
        let options = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,  // Use `.walking`, `.transit` for other modes
            MKLaunchOptionsShowsTrafficKey: true
        ] as [String : Any]
        MKMapItem.openMaps(with: [mapItemFrom, mapItemTo], launchOptions: options)
    }


    func loadMapFromURL(_ url:URL,completion: @escaping (UIImage) -> Void ) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(UIImage())
                    return
                }
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(UIImage())
                }
            }
        }
        task.resume()
    }
}
