//
//  ChatVC.swift
//  CounselHub
//
//  Created by Zain on 07/07/2022.
//

import UIKit
import FirebaseDatabase
import FittedSheets

struct ChatListModel {
    var message : String?
    var updatedAtUTS : NSNumber?
    var userId : String?
    var read:String?
    var roomId:String?
}

class ChatVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            //  tableView.register(types: NotificationCell.self)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    var userProfile : ProfileDetailUser? {
        didSet {
            
        }
    }
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTxt: UITextField!
    
    var chatArray: [ChatMainModel] = []
    var chatArrayFinal: [ChatListModel] = []
    var searchChatArrayFinal: [ChatListModel] = []
    var searchChatArray: [ChatMainModel] = []
    let refChats = Database.database().reference().child("UserChats")
    let refUserData = Database.database().reference().child("Users")
    var isFetching = false
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .chatList
        isSearching = false
        viewControllerTitle = "Messages".localiz()
        searchTxt.placeholder = "Search By Name".localiz()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableView.register(UINib(nibName: "EmptyCell", bundle: nil), forCellReuseIdentifier: "EmptyCell")
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("openOptionsMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        OpenPopUp()
    }
    @objc func setupNotificationObserver()
    {
        setListner()
    }
    override func notificationBtnAction() {
        Coordinator.goToNotifications(controller: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchView.isHidden = true
        setListner()
        let tabbar = tabBarController as? TabbarController
        tabbar?.popupDelegate = self
        tabbar?.showTabBar()
        if let tabItems = tabbar?.tabBar.items {
            let tabItem = tabItems[3]
            Constants.shared.chatBadgeCount = 0
            tabItem.badgeValue = nil
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    func OpenPopUp(){
        
        let tabbar = tabBarController as? TabbarController
        tabbar?.selectedIndex = 0
        
        DispatchQueue.main.async {
            Constants.shared.isPopupShow = false
            NotificationCenter.default.post(name: Notification.Name("openOptionsHome"), object: nil)
        }
        /*
        let  controller =  AppStoryboard.Floating.instance.instantiateViewController(withIdentifier: "FloatingVC") as! FloatingVC
        controller.delegate = self
        let sheet = SheetViewController(
            controller: controller,
            sizes: [.fullscreen],
            options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
        sheet.minimumSpaceAbovePullBar = 0
        sheet.dismissOnOverlayTap = false
        sheet.dismissOnPull = false
        sheet.contentBackgroundColor = .clear
        self.present(sheet, animated: true, completion: nil)
        */
    }
    func setListner() {
        Utilities.showIndicatorView()
        isFetching = true
        let authId = SessionManager.getUserData()?.firebase_user_key
        if (authId ?? "").isEmpty {
            print("firebase_user_key is empty")
            isFetching = false
            Utilities.hideIndicatorView()
            return
        }
        //guard let authId = SessionManager.getUserData()?.firebase_user_key else {return}
        refChats.child(authId ?? "").queryOrdered(byChild: "updatedAtUTS").removeAllObservers()
        refChats.child(authId ?? "").queryOrdered(byChild: "updatedAtUTS").observe(.value, with: { snapContents in
            Utilities.hideIndicatorView()
            guard snapContents.exists() else{
                print("empty chats")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            if let content = snapContents.value as? [String:Any] {
                
                let group = DispatchGroup()
                
                for (key, value) in content {
                    
//                    if key.hasPrefix("Store_"){
                        guard let chatRoomDetails = value as? [String: Any] else {
                            continue
                        }
                        guard let message = chatRoomDetails["message"] as? String,let readStatus = chatRoomDetails["read"] as? String,  let updatedTime = chatRoomDetails["updatedAtUTS"] as? NSNumber, let userid = chatRoomDetails["userId"] as? String   else {
                            continue
                        }
                        let final = ChatListModel(message: message,updatedAtUTS: updatedTime,userId: userid, read: readStatus,roomId: key)
                      
                        
                        let userExist = self.chatArrayFinal.firstIndex(where: { element in
                            return element.userId == final.userId
                        })
                        
                        if let indexExist = userExist{
                            self.chatArrayFinal[indexExist] = final
                        } else{
                            if let roomId = final.roomId
                            {
                                if !roomId.contains("-")
                                {
                                    self.chatArrayFinal.append(final)
                                }
                            }
                            else
                            {
                                self.chatArrayFinal.append(final)
                            }
                            
                        }
                    }
//                }
                group.notify(queue: DispatchQueue.main) {
                    self.chatArrayFinal.sort(by: { Int64(truncating: $0.updatedAtUTS ?? 0) > Int64(truncating: $1.updatedAtUTS ?? 0) })
                    self.isFetching = false
                    DispatchQueue.main.async {
                        self.tableView.reloadSections([0], with: .fade)
                    }
                  //self.fetchUserChangedObserver()
                }
            }
            
        })
    }
    
    //MARK:- API
    
    func checkUserProductExistOrNotAPI() {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "user_id" : SessionManager.getUserData()?.id ?? ""
            ]
            CMSAPIManager.checkUserProductExistAPI(parameters: parameters) { [weak self] result in
                switch result.status {
                case "1":
                    let  controller =  AppStoryboard.Floating.instance.instantiateViewController(withIdentifier: "FloatingVC") as! FloatingVC
                    controller.delegate = self
                    let sheet = SheetViewController(
                        controller: controller,
                        sizes: [.fullscreen],
                        options: SheetOptions(pullBarHeight : 0, shrinkPresentingViewController: false, useInlineMode: false))
                    sheet.minimumSpaceAbovePullBar = 0
                    sheet.dismissOnOverlayTap = false
                    sheet.dismissOnPull = false
                    sheet.contentBackgroundColor = .clear

                    self?.present(sheet, animated: true, completion: nil)
                default:
                    DispatchQueue.main.async {
                        Utilities.showWarningAlert(message: result.message ?? "") {
                            
                        }
                    }
                }
            }
        }


    
}

// MARK: - UITableView Implemetation
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chatArrayFinal.count == 0 {
            tableView.setEmptyView(title: "No Messages Found!".localiz(), message: "", image: UIImage(named: "emptyMessageIcon"))
            return 0
        }
        tableView.backgroundView = nil
        return chatArrayFinal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.chatModel = self.chatArrayFinal[indexPath.row]
        let chat = chatArrayFinal[indexPath.row]
        if let userKey = chat.userId {
            self.refUserData.child(userKey).observe(.value, with: { snapShot in
                guard snapShot.exists() else {
                    cell.avatarImageView.image = UIImage(named: "placeholder_profile")
                    return
                }
                if let snap = snapShot.value as? [String:Any] {
                    if let profileUrl = snap["user_image"] as? String {
                        cell.avatarImageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: UIImage(named: "placeholder_profile"), options: .continueInBackground, completed: nil)
                        
                    } else {
                        cell.avatarImageView.image = UIImage(named: "placeholder_profile")
                    }
                    if let name =  snap["user_name"] as? String {
                        cell.name.text = name
                    }
                }
            })
        }
        
        if chat.read == "0"{
            cell.unReadView.isHidden = false
            cell.message.font = UIFont(name: "Poppins-SemiBold", size: 14)
        }else{
            cell.unReadView.isHidden = true
            cell.message.font = UIFont(name: "Poppins-Regular", size: 14.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chatArrayFinal[indexPath.row]
        if let read = chat.read, read == "0", let key = chat.roomId, let userId = SessionManager.getUserData()?.firebase_user_key {
            refChats.child(userId).child(key).child("read").setValue("1")
        }
        let item = self.chatArrayFinal[indexPath.row]
        Coordinator.goToChatDetails(delegate: self, user_name: "", firebaseUserKey: item.userId ?? "",roomId:item.roomId ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
extension ChatVC: FloatingVCDelegate {
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
extension ChatVC: PopupProtocol{
    func openPopup() {
        if SessionManager.isLoggedIn() {
            self.checkUserProductExistOrNotAPI()
        }else{
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
    }
}
