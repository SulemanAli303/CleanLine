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
import ExpandableLabel
class LiveCommentVC: BaseViewController {
    var originalSize: CGSize?
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var bottamViewHeightConstraint: NSLayoutConstraint!
    
    
    
    var isShow = false
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var messageTextView: DPTagTextView!
    var taggedPeople: [TagOrSearchUsersModel.ODatum] = []
   // @IBOutlet weak var height: NSLayoutConstraint!
    var post_ID:String = ""
    var commentCollection:[CommentCollection] = []
    var commentID:String = "0"
    var parentId :String = "0"
    var userData:User?
    var pageCount = 1
    var pageLimit = 30
    var hasFetchedAll = false
    var orderCountValue:Int = 0
    var postUserID:String = ""
    var onDone : (() -> ())?
    
    @IBOutlet weak var bottomView: UIView!
    {
        didSet {
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bottomView.layer.cornerRadius = 25.0
            bottomView.setShadow(shadowRadius: 8, shadowOpacity: 0.8, shadowColor: .lightGray)
        }
    }
    
    
    var chatsArray = [ChatModel2]()
    
    var secondPersonID: String?
    var secondPersonUserId: String?
    var secondPersonName: String?
    var secondPersonImageURL: String?
    var secondPersonFCMToken: String?
    
    var chatRoomId: String?
    
    let subtitleLabel = UILabel()
    let img = UIImageView()
    
    
    func getChanelId () -> String {
        
        return ""
    }
    @IBAction func CallAction(_ sender: UIButton) {
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Comments".localiz()
       // height.constant = 100
        self.emptyView.isHidden = true
        messageTextView.placeholder = "Type your comment here...".localiz()
        //messageTextView.maxHeight = 100
        messageTextView.delegate = self
        messageTextView.enablesReturnKeyAutomatically = true;
        fetchUserDetails()
        checkChatRoomPresent()
        setChatChangeObserver()
        messageTextView.mentionTagTextAttributes = [NSAttributedString.Key.foregroundColor: Color.darkOrange.color(),NSAttributedString.Key.backgroundColor: UIColor.lightGray.withAlphaComponent(0.2),
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        self.messageTextView.dpTagDelegate = self
        userData = SessionManager.getUserData()
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
    }
    
    @objc func setupNotificationObserver()
    {
        getAllComments()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gestureOnImage(gesture: UIGestureRecognizer) {
        
        if let _currentUser = currentUser{
            // Coordinator.goToProfileView(delegate: self, user: _currentUser)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        //IQKeyboardManager.shared.isEnabled = true
        isShow = true
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        getAllComments()
        
        // check user done any order from this store
        //self.bottamViewHeightConstraint.constant = 120
        //self.bottomView.isHidden = false
//        if orderCountValue > 0 {
            self.bottamViewHeightConstraint.constant = 120
            self.bottomView.isHidden = false
//        }else{
//            if postUserID == userData?.id ?? ""{
//                self.bottamViewHeightConstraint.constant = 120
//                self.bottomView.isHidden = false
//            }else{
//                self.bottamViewHeightConstraint.constant = 0
//                self.bottomView.isHidden = true
//            }
//        }
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        //IQKeyboardManager.shared.isEnabled = true
        isShow = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.originalSize == nil {
                let originalSize = self.view.frame.size
                self.originalSize = originalSize
                self.view.frame.size = CGSize(
                    width: originalSize.width,
                    height: originalSize.height - keyboardSize.height + 40
                )
                tableViewChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let originalSize = self.originalSize {
            self.view.frame.size = originalSize
            self.originalSize = nil
            tableViewChat.contentInset = .zero
        }
    }
    
    var currentUser: ProfileDetailUser?
    func updateUI(userData: ProfileDetailUser) {
        
        //userName.text = secondPersonName
        
    }
    
    
    func checkForChatRoom(completion: @escaping (_ chatRoomId: String?) -> Void) {
        
    }
    
    func createChatRoom() -> String? {
        return ""
    }
    
    func checkChatRoomPresent() {
        let chatRoomId = self.getChanelId()
        fetchChats(chatRoomId: chatRoomId)
    }
    //
    func fetchChats(chatRoomId: String) {
        
    }
    
    
    func setChatChangeObserver() {
        
    }
    
    
    func setChatObserver(chatRoomId: String) {
        
    }
    
    func fetchUserDetails() {
        
    }
    
    func updateUserChats(timeStamp: [AnyHashable : Any], message: String) {
        
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
        
        guard self.messageTextView.text != "" else{
            Utilities.showWarningAlert(message: "Please type your comment".localiz()) {}
            return
        }
        postComments(commentText: messageTextView.text ?? "")
        self.messageTextView.setText("", arrTags: [])
        self.taggedPeople = []
    }
    
    
    func sendUpstreamPush(message: String)  {
        
    }
}


extension LiveCommentVC: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension LiveCommentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return chatsArray.count
        //return commentCollection.count ?? 0
        
        if commentCollection.count == 0 {
            tableView.setEmptyView(title: "No Comments Found!".localiz(), message: "", image: UIImage(named: "emptyCommentIcon"))
            return 0
        }
        tableView.backgroundView = nil
        return commentCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let otherUserCell = tableView.dequeueReusableCell(withIdentifier: "CommentListCell") as! CommentListCell
        otherUserCell.commentData = commentCollection[indexPath.row]
        otherUserCell.canYouDoReply = self.bottomView.isHidden ? false : true
        otherUserCell.delegate = self
        
        
        otherUserCell.selectionStyle = .none
        otherUserCell.expendLbl.numberOfLines = 0
//        if otherUserCell.expendLbl.text!.count > 10 {
//            let readmoreFont = AppFonts.regular.size(12)
//            let readmoreFontColor = UIColor(hex: "9B9B9B")
//            DispatchQueue.main.async {
//                otherUserCell.expendLbl.addTrailing(with: "...", moreText: "more", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
//            }
//        }
        
        return otherUserCell
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
        
        return UITableView.automaticDimension
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if SessionManager.isLoggedIn() {
//            ShopCoordinator.goToShopProfilePage(controller: self,storeID: commentCollection[indexPath.row].commentedUserId ?? "")
//        }else{
//            Coordinator.setRoot(controller: self)
//        }
//    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
        if  hasFetchedAll { return }
        pageCount += 1
        getAllComments()
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
}


extension LiveCommentVC{
    func getAllComments(completion:((Bool)->())? = nil){
        let parameter = ["postId": post_ID,
                         "limitPerPage": pageLimit.description ,
                         "pageOffset":  pageCount.description,
                         "userId": SessionManager.getUserData()?.id ?? ""] as [String : Any]
        print(parameter)
        Utilities.showIndicatorView()
        let socket = SocketIOManager.sharedInstance
        socket.getPostComments(request: parameter) { [weak self] dataArray in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                Utilities.hideIndicatorView()
            }
            
            guard self != nil else {return}
            //weakSelf.loading = false
            guard let dict = dataArray[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                
                if let decodedArray:PostCommont_Base = try? decoder.decode(PostCommont_Base.self, from: json){
                    print(decodedArray)
                    self?.commentCollection = decodedArray.commentCollection ?? []
                    let count = Int(self?.commentCollection.count ?? 0)
                    if count < (self?.pageLimit ?? 0) {
                        self?.hasFetchedAll = true
                    }
                    self?.tableViewChat.reloadData()
                    /*
                    self?.postCollectionArray = decodedArray.postCollection ?? []
                    Constants.shared.lastFeedPost = decodedArray.postCollection ?? []
                    self?._collectionNode.reloadData()
                    self?._collectionNode.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    self?.lastFetchedPost = self?.postCollectionArray.last?.postCreatedAt ?? ""
                    //  weakSelf.insertNewGroupsInTableView(decodedArray.postCollection ?? [])*/
                    completion?(true)
                }else{
                    completion?(false)
                }
            } catch {
                print(error.localizedDescription)
                 completion?(false)
            }
        }
    }
    
    func postComments(commentText : String){
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "post_id" : post_ID,
            "comment":commentText,
            "parent_id":parentId,
            "comment_id":commentID
        ]
        print(parameters)
        FeedPostAPIManager.postCommentAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.messageTextView.resignFirstResponder()
                self.parentId = "0"
                self.messageTextView.text = ""
                self.getAllComments()
                self.onDone?()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    func postCommentsLikeAnUnLike(comment_ID : String){
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "comment_id":comment_ID
        ]
        print(parameters)
        FeedPostAPIManager.postCommentLikeAnUnLikeAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getAllComments()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension LiveCommentVC:CommentProtocol{
    
    func profileNavigation(userID: String) {
        if SessionManager.isLoggedIn() {
            ShopCoordinator.goToShopProfilePage(controller: self,storeID: userID)
        }else{
            Coordinator.setRoot(controller: self)
        }
    }
    
    
    func likeApiCall(commentID: String) {
        postCommentsLikeAnUnLike(comment_ID: commentID)
    }
    
    
    func replyPressed(replyID: String, userName: String) {
        parentId = replyID
        self.messageTextView.placeholder = "\("Reply to".localiz()) \(userName)"
        self.messageTextView.setText(nil, arrTags: [])
        self.taggedPeople = []
        
        if userName != userData?.name{
            self.taggedPeople.append(TagOrSearchUsersModel.ODatum(id: userData?.user_type_id, name: nil, email: nil, dialCode: nil, phone: nil, phoneVerified: nil, role: nil, firstName: nil, lastName: nil, userImage: nil, userPhoneOtp: nil, userDeviceToken: nil, userDeviceType: nil, userAccessToken: nil, firebaseUserKey: nil, createdAt: nil, updatedAt: nil, countryID: nil, stateID: nil, cityID: nil, area: nil, active: nil, displayName: nil, businessName: nil, emailVerified: nil, userEmailOtp: nil, dob: nil, vendor: nil, store: nil, aboutMe: nil, verified: nil, designationID: nil, isPrivateProfile: nil, userName: userName, gender: nil, website: nil, walletAmount: nil, passwordResetCode: nil, passwordResetTime: nil))
            let tag = DPTag(name: userName, range: NSRange(location: 0, length: userName.count + 1), isHashTag: false)
            self.messageTextView.setText("@\(userName) ", arrTags: [tag])
        }
        self.messageTextView.becomeFirstResponder()
    }
    
    
}
extension LiveCommentVC : DPTagTextViewDelegate {
    func dpTagTextView(_ textView: DPTagTextView, didChangedTagSearchString strSearch: String, isHashTag: Bool) {
        if isHashTag {
            return
        }
        /*
        if (strSearch.count == 0) {
            //dropDown.isHidden = true
            //dropDown.hide()
            self.userListView.isHidden = true
        } else {
            //dropDown.show()
            //dropDown.isHidden = false
            self.userListView.isHidden = false
        }
        if self.commentTextField.text == "@"{
            //dropDown.isHidden = true
            //dropDown.hide()
            self.userListView.isHidden = true
        }
        print(strSearch)
         
        searchTaggedUsers(searchKey: strSearch)
         */
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didInsertTag tag: DPTag) {
        print("inserted")
    }
    func dpTagTextView(_ textView: DPTagTextView, didRemoveTag tag: DPTag) {
        let tagname = tag.name.replacingOccurrences(of: "@", with: "")
        print("removed: ", tagname)
        self.taggedPeople.removeAll(where: {$0.userName ?? "" == tagname})
        print(self.taggedPeople.count)
    }
    func dpTagTextView(_ textView: DPTagTextView, didSelectTag tag: DPTag) {
//        lblTagName.text = "\(tag.name) : \(tag.range) : \(tag.isHashTag ? tagTextView.hashTagSymbol : tagTextView.mentionSymbol)"
    }
    func dpTagTextView(_ textView: DPTagTextView, didChangedTags arrTags: [DPTag]) {
    }
}



