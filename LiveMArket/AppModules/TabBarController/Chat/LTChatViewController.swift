//
//  LTChatViewController.swift
//  LovelyThais
//
//  Created by Mac User on 14/02/20.
//  Copyright © 2020 Mac User. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GrowingTextView
import SDWebImage
import Alamofire
import IQKeyboardManagerSwift
import Firebase
import FirebaseStorage
import AudioStreaming
import AVFoundation

class LTChatViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var bottomHideView: UIView!
    ///Record View
    @IBOutlet weak var audioRecordingTimeLbl: UILabel!
    @IBOutlet weak var cancelRecordingBtn: UIButton!
    @IBOutlet weak var pauseRecordingBtn: UIButton!
    @IBOutlet weak var sendAudioBtn: UIButton!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var playTimerLbl: UILabel!
    @IBOutlet weak var recordedTimerLbl: UILabel!
    @IBOutlet weak var waveImageVw: UIImageView!
    @IBOutlet weak var secondWaveImageWidConst: NSLayoutConstraint!
    @IBOutlet weak var waveImageView2: UIImageView!
    @IBOutlet weak var playAudioVw: UIView!
    @IBOutlet weak var playAudioBtn: UIButton!
    @IBOutlet weak var chatNotAllowedLabel: UILabel!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isPaused: Bool = false
    var audioPlayer: AVAudioPlayer!
    var playTimer: Timer!
    var waveTimer: Timer!
    var timer: Timer?
    
    @IBOutlet weak var sendingStatusLbl: UILabel!
    
    
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var chatViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendingImageLabel: UILabel!
    @IBOutlet weak var bottamViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachementWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachmentButton: UIButton!
    var originalSize: CGSize?
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var activenow: UILabel!
    @IBOutlet weak var activeimage: UIImageView!
    var isShow = false
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var messageTextView: GrowingTextView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableBottom: NSLayoutConstraint!
    var isDeliverd:Bool = false
    var isFromDelegateService:Bool = false
    let refChatRoom = Database.database().reference().child("ChatRoom")
    
    @IBOutlet weak var bottomView: UIView!
    {
        didSet {
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bottomView.layer.cornerRadius = 25.0
            bottomView.setShadow(shadowRadius: 8, shadowOpacity: 0.8, shadowColor: .lightGray)
        }
    }
    var chatsArray = [ChatModel2]()
    var firbaseUserId: String?
    var secondPersonUserId: String?
    var secondPersonName: String?
    var secondPersonImageURL: String?
    var secondPersonFCMToken: String?
    var isHideProfile: String?
    var chatRoomId: String?
    let subtitleLabel = UILabel()
    let img = UIImageView()
    var delegateOrderID:String = ""
    var serviceID: String = ""
    var isDriver: Bool = false
    var isSeller: Bool = false
    var parentController: String = ParentController.None.rawValue
    var orderIdDetails: String = ""
    
    var refChats = Database.database().reference().child("ChatRoom")
    var refUser = Database.database().reference().child("Users")
    let refUserChats = Database.database().reference().child("UserChats")
    
    func getChanelId () -> String {
        
        return ""
    }
    
    var keyBoardHeight:CGFloat = 0
    
    deinit{
        playTimer?.invalidate()
        waveTimer?.invalidate()
        timer?.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //  type = .chat
        //  height.constant = 100
        self.emptyView.isHidden = true
        messageTextView.placeholder = "Type a message...".localiz()
        chatNotAllowedLabel.text = "Chat is not allowed as the order has been Delivered.".localiz()
        messageTextView.maxHeight = 100
        messageTextView.delegate = self
        messageTextView.enablesReturnKeyAutomatically = true;
        fetchUserDetails()
        avatarView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureOnImage(gesture:)))
        avatarView.addGestureRecognizer(gesture)
        
        tableViewChat.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        tableViewChat.register(UINib(nibName: "ChatSenderImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSenderImageTableViewCell")
        tableViewChat.register(UINib(nibName: "ChatReceiverImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatReceiverImageTableViewCell")
        tableViewChat.register(UINib(nibName: "ChatSenderAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSenderAudioTableViewCell")
        tableViewChat.register(UINib(nibName: "ChatReceiverAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatReceiverAudioTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            
            UIView.animate(withDuration: 0.3) {
                // Adjust the constraints or frame of your chat view here
                // For example, increase the bottom constraint to move the chat view up
                self.chatViewBottomConstraint.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            // Reset the constraints or frame to their original positions
            self.chatViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func  setUserDetails() {
        avatarView.sd_setImage(with: URL(string: secondPersonImageURL ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
        userName.text = secondPersonName
        //   viewControllerTitle = secondPersonName
        guard let userData = SessionManager.getUserData() else { return }
        
        if isFromDelegateService{
            if chatRoomId == "" {
                guard let userData = SessionManager.getUserData() else { return }
                chatRoomId = delegateOrderID
                self.checkRoomIDExitOrNot(roomID: chatRoomId ?? "") { [self] status in
                    if status {
                        self.fetchChats(chatRoomId: self.chatRoomId ?? "")
                    }else{
                        self.chatRoomId = delegateOrderID
                        self.fetchChats(chatRoomId: self.chatRoomId  ?? "")
                    }
                }
            } else {
                fetchChats(chatRoomId: chatRoomId ?? "")
            }
        } else {

            if chatRoomId == "" {
                guard let userData = SessionManager.getUserData() else { return }
                var uppwerValue = ""
                var lowerValue = ""
                if let firstUser = Int(userData.id ?? "0"), let secondUser = Int(secondPersonUserId ?? "0") {
                    if firstUser > secondUser {
                        lowerValue = "\(secondUser)"
                        uppwerValue = "\(lowerValue)"
                    } else {
                        uppwerValue  = "\(secondUser)"
                        lowerValue = "\(lowerValue)"
                    }
                    self.chatRoomId = "\(lowerValue)_\(uppwerValue)"
                    self.checkRoomIDExitOrNot(roomID: chatRoomId ?? "") { [self] status in
                        if status {
                            self.fetchChats(chatRoomId: self.chatRoomId ?? "")
                        } else {
                            self.checkRoomIDExitOrNot(roomID: self.chatRoomId ?? "") { [self] status in
                                if status {
                                    self.fetchChats(chatRoomId: self.chatRoomId ?? "")
                                } else {
                                    self.fetchChats(chatRoomId: self.chatRoomId  ?? "")
                                }
                            }
                        }
                    }
                }
            } else {
                fetchChats(chatRoomId: chatRoomId ?? "")
            }
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gestureOnImage(gesture: UIGestureRecognizer) {
        
        if let _currentUser = currentUser{
            // Coordinator.goToProfileView(delegate: self, user: _currentUser)
        }
        
    }
    
    func setListner() {
        guard let userData = SessionManager.getUserData() else { return }
        chatRoomId = "\(userData.id ?? "")_\(secondPersonUserId ?? "")"

    }
    
    func checkRoomIDExitOrNot(roomID:String,completion: @escaping (Bool) -> Void) {
        Utilities.showIndicatorView()
        let refNotifications = Database.database().reference().child("ChatRoom")
        var query = DatabaseQuery()
        query = refNotifications.child(roomID).queryOrderedByKey()
        query.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let `self` = self else { return }
            Utilities.hideIndicatorView()
            guard snapshot.exists(), let _ = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Child does not exist")
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        navigationController?.navigationBar.isHidden = true
        tabbar?.hideTabBar()
        if let tabItems = tabbar?.tabBar.items {
            let tabItem = tabItems[3]
            Constants.shared.chatBadgeCount = 0
            Constants.shared.chatDelegateCountID[chatRoomId ?? ""] = 0
            tabItem.badgeValue = nil
        }
        
        isShow = true
        
        // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillUpdate(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //        if isFromDelegateService{
        //            self.attachmentButton.isHidden = false
        //            self.attachementWidthConstraint.constant = 50
        //        }else{
        //            self.attachmentButton.isHidden = true
        //            self.attachementWidthConstraint.constant = 0
        //        }
        self.attachmentButton.isHidden = false
        self.attachementWidthConstraint.constant = 50
        if isDeliverd{
            self.bottomView.isHidden = true
            self.bottamViewHeightConstraint.constant = 0
            self.bottomHideView.isHidden  = false
        }else{
            self.bottomView.isHidden = false
            self.bottamViewHeightConstraint.constant = 80
            self.bottomHideView.isHidden  = true
        }
        UserDefaults.standard.set(true, forKey: "ChatPage")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
        isShow = false
        UserDefaults.standard.set(false, forKey: "ChatPage")
        if let index = self.chatsArray.firstIndex(where: {$0.isPlaying == true}), let cell = tableViewChat.cellForRow(at: IndexPath(row: index, section: 0)) as? ChatSenderAudioTableViewCell {
            cell.audioPlayer?.stop()
        }
        if let index = self.chatsArray.firstIndex(where: {$0.isPlaying == true}), let cell = tableViewChat.cellForRow(at: IndexPath(row: index, section: 0)) as? ChatReceiverAudioTableViewCell {
            cell.audioPlayer?.stop()
        }
        Constants.shared.chatDelegateCountID[chatRoomId ?? ""] = 0
    }
    
    //    @objc func keyboardWillShow(_ notification: NSNotification) {
    //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
    //            if self.originalSize == nil {
    //                let originalSize = self.view.frame.size
    //                self.originalSize = originalSize
    //                self.view.frame.size = CGSize(
    //                    width: originalSize.width,
    //                    height: originalSize.height - keyboardSize.height + 40
    //                )
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    //                    if self.chatsArray.count > 0 {
    //                        self.tableViewChat.scrollToBottom()
    //                    }
    //                }
    //            }
    //        }
    //    }
    /*
     @objc func keyboardWillUpdate(_ notification: NSNotification) {
     if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
     if self.originalSize == nil {
     let originalSize = self.view.frame.size
     self.originalSize = originalSize
     self.view.frame.size = CGSize(
     width: originalSize.width,
     height: originalSize.height - keyboardSize.height + 40
     )
     } else {
     self.view.frame.size = originalSize ?? CGSizeZero
     self.view.frame.size = CGSize(
     width: UIScreen.main.bounds.width,
     height:  self.view.frame.size.height - keyboardSize.height + 40
     )
     }
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
     if self.chatsArray.count > 0 {
     self.tableViewChat.scrollToBottom()
     }
     }
     
     }
     }
     @objc func keyboardWillHide(_ notification: NSNotification) {
     if let originalSize = self.originalSize {
     self.view.frame.size = originalSize
     self.originalSize = nil
     keyBoardHeight = 0
     }
     }
     
     */
    
    var currentUser: ProfileDetailUser?
    func checkForChatRoom(completion: @escaping (_ chatRoomId: String?) -> Void) {
        
    }
    
    func createChatRoom() -> String? {
        //        guard let authId = SessionManager.getUserData()?.firebaseUserKey, let userId = secondPersonID , let actualUserId = secondPersonUserId else { return nil }
        //
        //        guard let chatRoomId = refUserChats.child(authId).childByAutoId().key else { return nil }
        //
        //        let timeStamp = ServerValue.timestamp()
        //        refUserChats.child(authId).child(chatRoomId).setValue(["userId": userId, "createdAt": timeStamp])
        //        refUserChats.child(userId).child(chatRoomId).setValue(["userId": authId, "createdAt": timeStamp])
        //        refChats.child(authId).child(userId).setValue(["chatRoomId": chatRoomId])
        //        refChats.child(userId).child(authId).setValue(["chatRoomId": chatRoomId])
        return ""
    }
    //
    func fetchChats(chatRoomId: String) {
        self.chatsArray.removeAll()
        self.refChats.child(chatRoomId).observeSingleEvent(of: .value, with: { snapshot in
            
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = item.value as? [String:Any] {
                    do {
                        let json = try JSONSerialization.data(withJSONObject: value)
                        var chat = try JSONDecoder().decode(ChatModel2.self, from: json)
                        chat.key = item.key
                        self.chatsArray.append(chat)
                    } catch {
                        
                    }
                }
            }
            
            Utilities.hideIndicatorView()
            
            self.setChatObserver(chatRoomId: chatRoomId)
            //  self.setChatChangeObserver()
            self.tableViewChat.reloadData()
            self.chatsArray = self.chatsArray.reversed()
            if self.chatsArray.count == 0
            {
                //  self.updateTableContentInset()
                //  self.tableViewChat.setContentOffset(CGPoint(x: 0, y: self.tableViewChat.contentSize.height - self.tableViewChat.frame.height), animated: false)
            }
            else
            {
                let indexPath = IndexPath(row: self.chatsArray.count - 1, section: 0)
                //  self.updateTableContentInset()
                // self.tableViewChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        })
    }
    
    
    func setChatChangeObserver() {
        let chatRoomId = getChanelId()
        refChats.child(chatRoomId).observe(.childChanged, with: { snapshot in
            if let value = snapshot.value as? [String:Any] {
                
                do {
                    let json = try JSONSerialization.data(withJSONObject: value)
                    var chat = try JSONDecoder().decode(ChatModel2.self, from: json)
                    chat.key = snapshot.key
                    
                    for (index,item) in self.chatsArray.enumerated(){
                        if(item.key == chat.key){
                            self.chatsArray[index] = chat
                            self.tableViewChat.reloadData()
                            break
                        }
                    }
                    
                } catch {
                    
                }
                
            }
        })
    }
    
    
    func setChatObserver(chatRoomId: String) {
        var childCount = 0
        
        refChats.child(chatRoomId).observe(.childAdded, with: { snapshot in
            childCount += 1
            if childCount > self.chatsArray.count {
                if let value = snapshot.value as? [String:Any] {
                    
                    do {
                        let json = try JSONSerialization.data(withJSONObject: value)
                        var chat = try JSONDecoder().decode(ChatModel2.self, from: json)
                        chat.key = snapshot.key
                        self.chatsArray.insert(chat, at: 0)
                        // self.chatsArray.append(chat)
                        let indexPath = IndexPath(row: self.chatsArray.count - 1, section: 0)
                        if let chatUserId = chat.userId, let currentUserId = SessionManager.getUserData()?.firebase_user_key {
                            if chatUserId == currentUserId {
                                self.tableViewChat.insertRows(at: [indexPath], with: .right)
                            } else if chatUserId == self.secondPersonUserId {
                                if(self.isShow){
                                    let chatRoomId = self.getChanelId()
                                    // self.refUserChats.child(SessionManager.getUserData()?.firebase_user_key ?? "").child(chatRoomId).updateChildValues(["read":"1"])
                                }
                                
                                self.tableViewChat.insertRows(at: [indexPath], with: .left)
                            }
                            self.tableViewChat.reloadData()
                            //                            self.tableViewChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    } catch {
                        
                    }
                }
            }
        })
    }
    
    func fetchUserDetails() {
        guard let userId = firbaseUserId else {
            return
        }
        self.refUser.child(userId).observe(.value) { [weak self] (snapShot) in
            guard let `self` = self else { return }
            guard snapShot.exists() else {
                return
            }
            if let snap = snapShot.value as? [String:Any] {
                self.secondPersonFCMToken = snap["fcm_token"] as? String
                self.isHideProfile = snap["access_token"] as? String
                self.secondPersonImageURL = snap["user_image"] as? String
                self.secondPersonUserId = snap["user_id"] as? String
                self.secondPersonName =  snap["user_name"] as? String
                self.setUserDetails()
                //                do {
                //                    let json = try JSONSerialization.data(withJSONObject: snap)
                //                    let user = try JSONDecoder().decode(ProfileDetailUser.self, from: json)
                //
                //                    DispatchQueue.main.async {
                //
                //                        if user.is_active == true  {
                //                            self.activeimage.image =  UIImage(named: "Ellipse 741")
                //                            self.activenow.text = "Active now"
                //                        } else {
                //                            self.activeimage.image =  UIImage(named: "inactive-")
                //                            self.activenow.text = "Inactive now"
                //                        }
                //                    }
                //                } catch {
                //
                //                }
                
                
                
                if let timestamp = snap["last_active"] as? Int
                {
                    //                    if Utilities.isUserOnline(timeStamp: NSNumber(value: timestamp))
                    //                    {
                    //                        self.subtitleLabel.text = "Online"
                    //                        self.img.image = #imageLiteral(resourceName: "toggle-actv")
                    //                    }
                    //                    else
                    //                    {
                    //                        self.subtitleLabel.text = "Offline"
                    //                        self.img.image = #imageLiteral(resourceName: "green-radio")
                    //                    }
                }
                else
                {
                    self.subtitleLabel.text = "Offline".localiz()
                    // self.img.image = #imageLiteral(resourceName: "green-radio")
                }
                
                //self.profileImageView.sd_setImage(with: URL(string: self.secondPersonImageURL ?? ""), placeholderImage: UIImage(named: "profile-pic"))
                
            }
        }
    }
    
    func updateUserChats(timeStamp: [AnyHashable : Any], message: String) {
        guard let authId = SessionManager.getUserData()?.firebase_user_key, let userId = firbaseUserId else { return }
        let chatRoomId = chatRoomId ?? ""
        refUserChats.child(authId).child(chatRoomId).updateChildValues(["updatedAtUTS":timeStamp,"message":message,"read" : "0","userId": userId])  //child("updatedAtUTS").setValue(timeStamp)
        refUserChats.child(userId).child(chatRoomId).updateChildValues(["updatedAtUTS":timeStamp,"message":message,"read" : "0","userId": authId])
        //child("updatedAtUTS").setValue(timeStamp)
    }
    
    
    var rfcDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }
    
    var localDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        return formatter
    }
    
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        guard let message = messageTextView.text else { return }
        messageTextView.text = ""
        if message.trimmingCharacters(in: .whitespaces) == "" { return }
        // message = message.removeEmailAndNumbers()
        guard let currentUserId = SessionManager.getUserData()?.firebase_user_key else { return }
        let timeStamp = ServerValue.timestamp()
        let messageData = [
            "sentBy" : currentUserId,
            "message": message,
            "type":"chat",
            "read" : "0",
            "senderImageURL" : SessionManager.getUserData()?.image ?? "",
            "messageTimeStamp": timeStamp
        ] as [String : Any]
        guard let roomId = chatRoomId else { return }
        self.refChats.child(roomId).childByAutoId().setValue(messageData)
        if isFromDelegateService{
            
        }else{
            self.updateUserChats(timeStamp: timeStamp, message: message)
        }
        self.sendUpstreamPush(message: message)
        sendBtn.isEnabled = false
        //   }
        self.view.endEditing(true)
    }
    
    
    func sendUpstreamPush(message: String)  {
        guard let authId = SessionManager.getUserData()?.firebase_user_key, let authName = SessionManager.getUserData()?.name else { return }
        let userData = SessionManager.getUserData()
        var name = userData?.name ?? ""
        guard let userFCMToken = secondPersonFCMToken else { return }
        let chatRoomId = chatRoomId ?? ""
        var pushData :[String:Any] = [:]
        
        var sellerStatus = self.isSeller ? "0" : "1"
        if self.isDriver {
            sellerStatus = "0"
        }

        if isHideProfile == nil || (isHideProfile?.isEmpty ?? true) {
            return
        }

        if isFromDelegateService {
            pushData = [
                "to": userFCMToken,
                "priority": "high",
                "content_available": false,
                "notification": [
                    "body": message,
                    "title": "New message recieved from \(name)",
                    "click_action": "chatDelegate",
                    "message" :message,
                    "android_channel_id": "general_channel_new",
                    "sound" : "noti_2sec.mp3",
                ],
                "data": [
                    "type": "chatDelegate",
                    "sender_id": authId,
                    "sender_user_id": SessionManager.getUserData()?.id ?? "",
                    "sender_name" : authName,
                    "sender_image": SessionManager.getUserData()?.image ?? "",
                    "chatRoomId": chatRoomId,
                    "serviceId" : self.serviceID,
                    "isDriver" : self.isDriver,
                    "isSeller" : sellerStatus,
                    "parentController": self.parentController,
                    "orderId" : self.orderIdDetails
                ]
            ] as [String: Any]
        } else {
            pushData = [
                "to": userFCMToken,
                "priority": "high",
                "content_available": true,
                "notification": [
                    "body": message,
                    "title": "New message recieved from \(name)",
                    "click_action": "chat",
                    "message" :message,
                    "android_channel_id": "general_channel_new",
                    "sound" : "noti_2sec.mp3",
                    "content_available": true,
                ],
                "data": [
                    "type": "chat",
                    "sender_id": authId,
                    "sender_user_id": SessionManager.getUserData()?.id ?? "",
                    "sender_name" : authName,
                    "sender_image": SessionManager.getUserData()?.image ?? "",
                    "chatRoomId": chatRoomId,
                    "serviceId" : self.serviceID
                ]
            ] as [String: Any]
            
        }
 let headers : HTTPHeaders = [
            "Authorization": "key=AAAA5DleGXo:APA91bH3LQPqEV0-Z06N0rSR_k_b-0pxbsgu6c8uXHSomx-rOiLby3RC25tzHTnkATMDHCVWyiqk5CT6zJ9gpUdtqZSpKsZRg7JwMqv_im1e6d5-UXBjg0X-HX03eUj5g4rwlgIhC8Gc",
            "Content-Type": "application/json"
        ]

        AF.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: pushData, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }
        
    }
    
    @IBAction func choosePhotoAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Image Source".localiz(), message: nil, preferredStyle: .actionSheet)
        
        // Option to pick a photo from the photo library
        let libraryAction = UIAlertAction(title: "Photo Library".localiz(), style: .default) { [weak self] _ in
            self?.openImagePicker(sourceType: .photoLibrary)
        }
        actionSheet.addAction(libraryAction)
        
        // Option to capture a new photo using the camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera".localiz(), style: .default) { [weak self] _ in
                self?.showCamera()
               // self?.openImagePicker(sourceType: .camera)
            }
            actionSheet.addAction(cameraAction)
        }
        
        // Cancel option
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        // Present the action sheet
        if let popoverController = actionSheet.popoverPresentationController {
            // Set up the popover source if needed, for example, on iPads
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let vc =  UIStoryboard(name: "CameraImagePickerStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CameraImagePickerViewController") as! CameraImagePickerViewController
        vc.delegate = self
        self.present(vc, animated: true)
    }

    @IBAction func chooseAudoAction(_ sender: UIButton) {
        
        if let index = self.chatsArray.firstIndex(where: {$0.isPlaying == true}), let cell = tableViewChat.cellForRow(at: IndexPath(row: index, section: 0)) as? ChatSenderAudioTableViewCell {
            cell.audioPlayer?.stop()
        }
        if let index = self.chatsArray.firstIndex(where: {$0.isPlaying == true}), let cell = tableViewChat.cellForRow(at: IndexPath(row: index, section: 0)) as? ChatReceiverAudioTableViewCell {
            cell.audioPlayer?.stop()
        }
        
        //self.easyTipView?.dismiss()
        self.audioRecordingTimeLbl.text = "00:00"
//        self.playSound()
        self.enableSendBtn(isEnable: true)
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1113)) {
            DispatchQueue.main.async {
                if self.recordingSession == nil {
                    self.recordAudio()
                } else {
                    self.recordTapped()
                }
                self.pauseRecordingBtn.isSelected = false
                self.setRecorderVisiblity(isHidden: false)
               // self.bottomVwBConst.constant = 0
            }
        }
    }
    
    
    
    func setRecorderVisiblity(isHidden: Bool) {
        self.recordView.isHidden = isHidden
        //self.inputTF.isHidden = !isHidden
        //self.mediaStack.isHidden = !isHidden
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // UIImagePickerControllerDelegate method to handle image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if var selectedImage = info[.originalImage] as? UIImage {
            uploadImage(selectedImage)
        }
        DispatchQueue.main.async {
            self.sendingImageLabel.isHidden = false
        }
    }
    
    // Function to upload image to Firebase Storage
    func uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imageFileName = "\(UUID().uuidString).jpg"
        
        let storageRef = Storage.storage().reference().child("images/\(imageFileName)")
        
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Image upload error: \(error)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    // Save the image URL to Firestore or Realtime Database along with other metadata
                    self.sendImageMessage(downloadURL.absoluteString)
                }
            }
        }
    }
    
    func uploadAudioFileIntFDB(localFile: URL) {
        
       // guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let audioFileName = "\(UUID().uuidString).aac"
        let storageRef = Storage.storage().reference().child("audio/\(audioFileName)")
        //let audioRef = storageRef.child("audio/\(localFile.lastPathComponent)")
        
        let uploadTask = storageRef.putFile(from: localFile, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading audio: \(error.localizedDescription)")
            } else {
                print("Audio uploaded successfully! ()")
                // You can access the download URL of the uploaded file using metadata.downloadURL()
                storageRef.downloadURL { [self] url, error in
                    if let downloadURL = url {
                        print("Download URL: \(downloadURL.absoluteString)")
                        self.sendAudioChatMessage(downloadURL.absoluteString)
                    } else {
                        print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }
    
    
    
    
    // Function to save the image message to Firestore or Realtime Database
    func sendImageMessage(_ imageURL: String) {
        // Save the message with imageURL to Firestore or Realtime Database
        // Include sender ID, receiver ID, timestamp, etc.
        //guard let message = messageTextView.text else { return }
        messageTextView.text = ""
        //if message.trimmingCharacters(in: .whitespaces) == "" { return }
        // message = message.removeEmailAndNumbers()
        guard let currentUserId = SessionManager.getUserData()?.firebase_user_key else { return }
        let timeStamp = ServerValue.timestamp()
        let messageData = [
            "sentBy" : currentUserId,
            "message": "",
            "type":"image",
            "read" : "0",
            "senderImageURL" : SessionManager.getUserData()?.image ?? "",
            "ImageURL" : imageURL ,
            "messageTimeStamp": timeStamp
        ] as [String : Any]
        guard let roomId = chatRoomId else { return }
        self.refChats.child(roomId).childByAutoId().setValue(messageData)
        
        if isFromDelegateService{
            
        }else{
            self.updateUserChats(timeStamp: timeStamp, message: "image")
        }
        
        self.sendUpstreamPush(message: "image")
        sendBtn.isEnabled = false
        DispatchQueue.main.async {
            self.sendingImageLabel.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    func sendAudioChatMessage(_ audioURLString: String) {
        // Save the message with imageURL to Firestore or Realtime Database
        // Include sender ID, receiver ID, timestamp, etc.
        //guard let message = messageTextView.text else { return }
        messageTextView.text = ""
        //if message.trimmingCharacters(in: .whitespaces) == "" { return }
        // message = message.removeEmailAndNumbers()
        guard let currentUserId = SessionManager.getUserData()?.firebase_user_key else { return }
        let timeStamp = ServerValue.timestamp()
        let messageData = [
            "id":generateRandomID(length: 10),
            "sentBy" : currentUserId,
            "message": "",
            "type":"audio",
            "read" : "0",
            "messageType":"3",
            "senderImageURL" : SessionManager.getUserData()?.image ?? "",
            "ImageURL" : "" ,
            "audioURL":audioURLString,
            "messageTimeStamp": timeStamp
        ] as [String : Any]
        guard let roomId = chatRoomId else { return }
        self.refChats.child(roomId).childByAutoId().setValue(messageData)
        
        if isFromDelegateService{
            
        }else{
            self.updateUserChats(timeStamp: timeStamp, message: "audio")
        }
        
        self.sendUpstreamPush(message: "Audio")
        sendBtn.isEnabled = false
        DispatchQueue.main.async {
            self.sendingImageLabel.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func imageTap(_ sender: UIButton) {
        let chat = self.chatsArray[sender.tag]
        let  VC = AppStoryboard.ShopDetail.instance.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
        VC.imageURLArray = [chat.ImageURL ?? ""]
        self.present(VC, animated: true)
    }
}
extension String {
    func removeEmailAndNumbers() -> String {
        var text = self.replacingOccurrences(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", with: " ",
                                             options: [.regularExpression, .caseInsensitive])
        text = text.replacingOccurrences(of: "[0-9]{5,12}", with: " ", options: .regularExpression)
        
        return text
    }
}

extension LTChatViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        if text == "" && (textView.text.count == 1) {
            sendBtn.isEnabled = false
            return true
        }
        sendBtn.isEnabled = true
        return true
    }
}

extension LTChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if chatsArray.count == 0 {
        //            tableView.setEmptyView(title: "No Messages Found!", message: "", image: UIImage(named: "emptyMessageIcon"))
        //            return 0
        //        }
        //        tableView.backgroundView = nil
        if chatsArray.count == 0 {
            self.emptyView.isHidden = false
        }else {
            self.emptyView.isHidden = true
        }
        return chatsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chat = self.chatsArray[indexPath.row]
        if let chatUserId = chat.userId, let currentUserId = SessionManager.getUserData()?.firebase_user_key {
            if chatUserId == currentUserId {
                if chat.type == "chat"{
                    let senderCell = tableView.dequeueReusableCell(withIdentifier: "senderCell") as! ChatTableViewCell
                    senderCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    senderCell.selectionStyle = .none
                    senderCell.messageLabel.text = chat.message
                    let numberValue = NSNumber(value: chat.messageTimeStamp ?? 0)
                    senderCell.timeStampLabel.text = self.convertTimeStamp(createdAt: numberValue)
                    return senderCell
                }else if chat.type == "image"{
                    let senderImageCell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderImageTableViewCell") as! ChatSenderImageTableViewCell
                    senderImageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    senderImageCell.selectionStyle = .none
                    //senderCell.messageLabel.text = chat.message
                    senderImageCell.chatData = chat
                    senderImageCell.imageButton.tag = indexPath.row
                    senderImageCell.imageButton.addTarget(self, action: #selector(imageTap(_:)), for: .touchUpInside)
                    return senderImageCell
                }else if chat.type == "audio"{
                    let senderImageCell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderAudioTableViewCell") as! ChatSenderAudioTableViewCell
                    senderImageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    senderImageCell.selectionStyle = .none
                    senderImageCell.controller = self
                    senderImageCell.currentIndex = indexPath.row
                    senderImageCell.chatData = chat
                    //senderImageCell.chatMessage(chat: chat)
                    //senderCell.messageLabel.text = chat.message
//                    senderImageCell.chatData = chat
//                    senderImageCell.imageButton.tag = indexPath.row
//                    senderImageCell.imageButton.addTarget(self, action: #selector(imageTap(_:)), for: .touchUpInside)
                    return senderImageCell
                }else{
                    return UITableViewCell()
                }
                
            } else {
                
                if chat.type == "chat"{
                    let otherUserCell = tableView.dequeueReusableCell(withIdentifier: "otherUserCell") as! ChatTableViewCell
                    otherUserCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    otherUserCell.selectionStyle = .none
                    otherUserCell.messageLabel.text = chat.message
                    let numberValue = NSNumber(value: chat.messageTimeStamp ?? 0)
                    otherUserCell.timeStampLabel.text = self.convertTimeStamp(createdAt: numberValue)
                    //otherUserCell.avatarImageView.sd_setImage(with: URL(string: chat.senderImageURL ?? ""), placeholderImage: nil)
                    otherUserCell.avatarImageView.sd_setImage(with: URL(string: secondPersonImageURL ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
                    return otherUserCell
                }else if chat.type == "image"{
                    let OtherImageCell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverImageTableViewCell") as! ChatReceiverImageTableViewCell
                    OtherImageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    OtherImageCell.selectionStyle = .none
                    //senderCell.messageLabel.text = chat.message
                    OtherImageCell.chatData = chat
                    OtherImageCell.imageButton.tag = indexPath.row
                    OtherImageCell.imageButton.addTarget(self, action: #selector(imageTap(_:)), for: .touchUpInside)
                    return OtherImageCell
                }else if chat.type == "audio"{
                    let OtherImageCell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverAudioTableViewCell") as! ChatReceiverAudioTableViewCell
                    OtherImageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    OtherImageCell.selectionStyle = .none
                    OtherImageCell.controller = self
                    OtherImageCell.chatData = chat
//                    OtherImageCell.chatData = chat
//                    OtherImageCell.imageButton.tag = indexPath.row
//                    OtherImageCell.imageButton.addTarget(self, action: #selector(imageTap(_:)), for: .touchUpInside)
                    return OtherImageCell
                }else{
                    return UITableViewCell()
                }
                
            }
        }
        return UITableViewCell()
    }
    
    func convertTimeStamp(createdAt: NSNumber?) -> String {
        guard let createdAt = createdAt else { return "a moment ago" }
        
        let converted = Date(timeIntervalSince1970: Double(truncating: createdAt) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        let dateString = dateFormatter.string(from: converted)
        
        let date = self.rfcDateFormatter.date(from: dateString)
        let localDate = self.localDateFormatter.string(from: date!)
        
        return localDate.changeTimeToFormat(frmFormat: "dd-MM-yyyy HH:mm:ss Z", toFormat: "hh:mm a")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = self.chatsArray[indexPath.row]
        if chat.type == "chat"{
            return UITableView.automaticDimension
        }else if chat.type == "image"{
            return 260
        }else if chat.type == "audio"{
            return 70
        }else{
            return UITableView.automaticDimension
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func updateTableContentInset() {
        let numRows = tableView(self.tableViewChat, numberOfRowsInSection: 0)
        var contentInsetTop = self.tableViewChat.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableViewChat.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
            }
        }
        self.tableViewChat.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 0, right: 0)
    }
    
    func formatDate(value: Double) -> String {
        let date = Date(timeIntervalSince1970: value)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // You can change the format as per your requirements
        dateFormatter.timeZone = TimeZone.current // This will use the current local time zone
        let localTimeString = dateFormatter.string(from: date)
        return localTimeString
    }
}

extension LTChatViewController: SwiftyCamDidCaptureImage {
    func didCaptureImage(image: UIImage, viewController: UIViewController) {
        uploadImage(image)
        self.sendingImageLabel.isHidden = false
        viewController.dismiss(animated: true)
    }

    func didCancel(viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
}

extension UIViewController {
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
}

extension UIView {
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius =  newValue
        }
    }
    
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity =  newValue
        }
    }
    
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func setShadow(shadowRadius: CGFloat, shadowOpacity: Float, shadowColor: UIColor, shadowOffset: CGSize = CGSize(width: 0, height: 0)) {
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
    }
}

