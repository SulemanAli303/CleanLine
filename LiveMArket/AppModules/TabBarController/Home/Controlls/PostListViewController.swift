//
//  PostListViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 07/07/23.
//

import UIKit
import AsyncDisplayKit
import FittedSheets
import AVFAudio

protocol PostListProtocol{
    func moveDiscoverController(hashTag:String)
}

class PostListViewController: BaseViewController,ObserverProtocol {

    var id: Int!
    
    func onSocketConnect(_ status: Bool) {
        lastFetchedPost = ""
        self.getSinglePosts(postID: currentPostID) { (status) in
         
        }
    }
    
    func newPost(_ post: [FeedPost_Base]) {
        
    }
    
    internal var scrollOperation: DelayedBlockOperation!
    internal var currentIndex:Int = -1
    
    var delegate:PostListProtocol?
    
    var beforeContentOFfset : CGPoint?
    var _collectionNode: ASCollectionNode!
    var containerStack = UIStackView()
    var offSet = CGPoint.zero
    var stackSuperViewTopConstraint: NSLayoutConstraint!
    var stackSafeAreaTopConstraint: NSLayoutConstraint!
    
    var postCollectionArray : [PostCollection] = []
    var postCollectionDummyArray : [PostCollection] = []
    var userTypeString:String = ""
    private var lastFetchedPost: String = ""
    private var pageIndex: Int = 0
    private var initialPageCount = 10
    var currentPostIndexPath:IndexPath?
    var isFromProfile:Bool = false
    var isFromOtherProfile:Bool = false
    var currentPostID:String = ""
    var videoIndexPath:IndexPath?
    var outputVolumeObserve: NSKeyValueObservation?
    let audioSession = AVAudioSession.sharedInstance()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let flowLayout = UICollectionViewFlowLayout() //CustomPaging
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        self._collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        setupInitialState()
        containerStack = UIStackView(arrangedSubviews: [_collectionNode.view])
        containerStack.axis = .vertical
        containerStack.alignment = .fill
        containerStack.distribution = .fill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerStack)
        //setupStoriesConstraints()
        setupStackConstraints()
        
        _collectionNode.view.contentInsetAdjustmentBehavior = .never
        //self._collectionNode.backgroundColor = .red
        //self.view.backgroundColor = .yellow
        
        // Do any additional setup after loading the view.
        _collectionNode.isPagingEnabled = true
        _collectionNode.view.alwaysBounceVertical = true
        stackSuperViewTopConstraint.isActive = true
        stackSafeAreaTopConstraint.isActive = false
        _collectionNode.cornerRadius = 0
        _collectionNode.maskedCorners =  []
        _collectionNode.backgroundColor = .black

        if self.beforeContentOFfset != nil{
            self._collectionNode.view.isScrollEnabled = true
            self._collectionNode.setContentOffset(self.beforeContentOFfset!, animated: true)
        }
        
        
        self.containerStack.layoutIfNeeded()
        
        if isFromProfile{
            self._collectionNode.alpha = 0
            postCollectionArray = postCollectionDummyArray
            if let indexPath = videoIndexPath{
                self._collectionNode.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                    self._collectionNode.scrollToItem(at: indexPath, at: .top, animated: false)
                    guard let node = self._collectionNode.nodeForItem(at: indexPath) as? FeedNode else {return}
                    self.currentIndex = indexPath.item
                    print("SETCURRENTINDEX \(self.currentIndex)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        VideoPlayerManager.shared.playVideo(in: node)
                        VideoPlayerManager.shared.playerView?.playVideo()
                    }

                    self._collectionNode.alpha = 1

                }
                
            }else{
                self._collectionNode.reloadData()
            }
            
            
        }else{
            let socket = SocketIOManager.sharedInstance
          //  socket.socket.disconnect()
            if socket.socket.status == .connected {
                lastFetchedPost = ""
                self.getSinglePosts(postID: currentPostID) { (status) in
                 
                }
            }else{
                socket.establishConnection()
                Utilities.showIndicatorView()
                socket.subject.addObserver(self)
            }
        }
    }
    
    
    deinit {
        VideoPlayerManager.shared.reset()
    }
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
//        if let visibleCell = self.visibleNode{
//            VideoPlayerManager.shared.playVideo(in: visibleCell)
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        VideoPlayerManager.shared.isVideoPaused = false
        self._collectionNode.setContentOffset(self.offSet, animated: true)
        //VideoPlayerManager.shared.resume()
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        Constants.shared.isFromFeed = true
        listenVolumeButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.offSet = self._collectionNode.contentOffset
        self.navigationController?.navigationBar.isHidden = false
        VideoPlayerManager.shared.isVideoPaused = true
        VideoPlayerManager.shared.pause(.hidden)
        Constants.shared.isFromFeed = false
    }
    
    func setupInitialState() {
        
        _collectionNode.dataSource = self
        _collectionNode.delegate = self
        _collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        _collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionFooter)
        _collectionNode.leadingScreensForBatching = 5
        _collectionNode.view.isPagingEnabled = true
        _collectionNode.alwaysBounceVertical = true
        _collectionNode.view.decelerationRate = UIScrollView.DecelerationRate.fast
        //_collectionNode.view.addSubview(refreshControl)
    }
    
    func setupStackConstraints() {
        stackSafeAreaTopConstraint = NSLayoutConstraint(item: containerStack, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0)
        stackSuperViewTopConstraint = NSLayoutConstraint(item: containerStack, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        
        stackSuperViewTopConstraint.isActive = true
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        [containerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ].forEach({ $0.isActive = true })
    }
    
    fileprivate func emptyCell() -> ASCellNodeBlock{
        let cellNodeBlock = {() -> ASCellNode in
            return { ASCellNode() }()
        }
        return cellNodeBlock
    }
    
    @objc func openShare(linkString:String)  {
        let message = "LiveMarket"
        if let link = URL(string: linkString) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true)
        }
        
    }
    func listenVolumeButton() {
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
               } catch _ {
            }
            do {
                try audioSession.setActive(true)
            } catch {}
            outputVolumeObserve = audioSession.observe(\.outputVolume, changeHandler: {(audioSession, changes) in
                    if self.visibleNode != nil {
                        if self.visibleNode?.postType == .Video || self.visibleNode?.postType == .Multiple {
                            VideoPlayerManager.shared.muted = false
                            self.visibleNode?.isMuted = false
                            if audioSession.outputVolume >= 0.05 {
                                VideoPlayerManager.shared.muted = false
                                self.visibleNode?.isMuted = false
                            } else {
                                VideoPlayerManager.shared.muted = true
                                self.visibleNode?.isMuted = true
                            }
                            NotificationCenter.default.post(name: NSNotification.Name("updateMuteIcon"), object: nil)
                            print("PPPPPPPP\(audioSession.outputVolume )")
                        }
                    }
                })
            
        }

}


extension PostListViewController{
    func getSinglePosts(postID:String,completion:@escaping(Bool)->()){
        let parameter = ["userId": SessionManager.getUserData()?.id ?? "0",
                         "postId": postID
        ] as [String : Any]
        print(parameter)
        //self.postCollectionArray.removeAll()
        Utilities.showIndicatorView()
        let socket = SocketIOManager.sharedInstance
        socket.getSinglePosts(request: parameter) {[weak self] dataArray in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                Utilities.hideIndicatorView()
            }
            
            guard self != nil else {return}
            //weakSelf.loading = false
            guard let dict = dataArray[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                
                if let decodedArray:FeedPost_Base = try? decoder.decode(FeedPost_Base.self, from: json){
                    print(decodedArray.postCollection ?? [])
                    
                    self?.postCollectionArray = decodedArray.postCollection ?? []
                    //self?.postCollectionArray = decodedArray.postCollection ?? []
                    Constants.shared.lastFeedPost = decodedArray.postCollection ?? []
                    self?._collectionNode.reloadData()
                    self?._collectionNode.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: 0, section: 0)
                        guard let node = self?._collectionNode.nodeForItem(at: indexPath) as? FeedNode else {return}
                        self?.currentIndex = indexPath.item
                        print("SETCURRENTINDEX \(self?.currentIndex)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            VideoPlayerManager.shared.playVideo(in: node)
                            VideoPlayerManager.shared.playerView?.playVideo()
                        }
                    }
                    completion(true)
                    
                }else{
                    print("error.localizedDescription")
                    completion(false)
                }
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    //MARK: - API Call
    
    func followAndUnfollowAPI(follow_userID:String,id:String) {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "follow_user_id" : follow_userID
        ]
        StoreAPIManager.followAndUnfollowAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                if let index = self.postCollectionArray.firstIndex(where:{$0.postId == id}){
                    if result.message ?? "" == "Un followed"{
                        self.postCollectionArray[index].isIamFollowing =  "0"
                    }else{
                        self.postCollectionArray[index].isIamFollowing =  "1"
                    }
                    self._collectionNode.reloadItems(at: [IndexPath(item: index, section: 0)])
                }
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}
extension PostListViewController:ASCollectionDataSource,ASCollectionDelegate{
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        
//        if postCollectionArray.count > 0{
//            return postCollectionArray.count
//        }else{
//            return Constants.shared.lastFeedPost.count
//        }
        
        return postCollectionArray.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellNodeBlockFianl = {() -> ASCellNode in
            
//            if self.postCollectionArray.count > 0{
//                let cell  = FeedNode(post: self.postCollectionArray[indexPath.row], isProfilePage: true)
//
//                cell.delegate = self
//                self.pageIndex += 1
//                return cell
//            }else{
//                let cell  = FeedNode(post: Constants.shared.lastFeedPost[indexPath.row],isProfilePage: true)
//                cell.delegate = self
//                return cell
//            }
            
            
            let cell  = FeedNode(post: self.postCollectionArray[indexPath.row], isProfilePage: true, delegate: self)
            
            cell.delegate = self
            self.pageIndex += 1
            return cell
            
        }
        return cellNodeBlockFianl
    }
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        
        return ASSizeRange(min: self.view.frame.size,max: self.view.frame.size)
        
    }
    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
        guard collectionNode.visibleNodes.count > 0 else {return}
        print("########## count \(node.indexPath?.row ?? 0)")
        pageIndex -= 1
        if node.indexPath?.item == 0{
            if currentIndex == -1{
                self.currentIndex = 0
            }
        }
        if VideoPlayerManager.shared.playerView == nil {
            let _node = node as? FeedNode
            _node?.isMuted = Constants.shared.videoMuted
            VideoPlayerManager.shared.playVideo(in: _node)
        }
    }
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        let nextPage = self.postCollectionArray.count / 10 + 1 // Assuming 10 items per page
        print("########## \(nextPage)")
        // Perform batch fetch for the next page
//        self.getAllPosts(page: nextPage) { (status) in
//            context.completeBatchFetching(true)
//        }
        
        // Signal the completion of batch fetch
    }
    
    
    
   
    
    
    /*
     func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
     
     Thread.sleep(forTimeInterval: 1)
     self.getAllPosts { (status) in
     context.completeBatchFetching(true)
     }
     return
     }
     func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
     guard collectionNode.numberOfItems(inSection: 0) > 0 else {return  false}
     if pageIndex == 1 {
     return true
     }else{
     return false
     }
     
     
     }*/
}
extension PostListViewController:CellActionsProtocol{
    func longPressForVideo(postID: String) {
        
    }
    
    
    
    func commentAction(postID: String, orderCount: Int,postUser_id:String) {
        if SessionManager.isLoggedIn() {
            Coordinator.goToCommentsList(controller: self,postID: postID,orderCount: orderCount, userID: postUser_id, onDone: {
                
                guard let index = self.postCollectionArray.firstIndex(where: {$0.postId == postID}) else{return}
                var commentCount = Int(self.postCollectionArray[index].commentCount ?? "0") ?? 0
                commentCount += 1
                self.postCollectionArray[index].commentCount = "\(commentCount)"
                self._collectionNode.reloadItems(at: [IndexPath(item: index, section: 0)])
            })
        }else {
            let tabbar = tabBarController as? TabbarController
            tabbar?.hideTabBar()
            Coordinator.setRoot(controller: self)
        }
    }
    
    func goToProfile() {
        if SessionManager.isLoggedIn() {
            self.tabBarController?.selectedIndex = 4
        }else{
            Coordinator.presentLogin(viewController: self)
        }
    }
    
    func updateProgress(time: CMTime, videoPlayer: AVPlayer?) {
        
    }
    
    
    func usernameAction(userID: String) {
        ShopCoordinator.goToShopProfilePage(controller: self,storeID: userID)
    }
    
    
    
    func backActions() {
        
        if self.navigationController == nil{
            Coordinator.updateRootVCToTab()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func menuAction() {
        
    }
    
    func shareAction() {
        
    }
    
    func followAction(followerID: String, postID: String) {
        self.followAndUnfollowAPI(follow_userID: followerID, id: postID )
    }
    
    func liveStreamList() {
        
        if SessionManager.isLoggedIn() {
            Coordinator.goToPostComment(controller: self)
        }else{
            Coordinator.setRoot(controller: self)
        }
    }
    
    
    
    func profileAction(userTypeID: String, activityID: String,store_id:String,sender:ASButtonNode) {
        
        sender.isEnabled = false
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if SessionManager.isLoggedIn() {
                ShopCoordinator.goToShopProfilePage(controller: self,storeID: store_id)
            }else{
                Coordinator.setRoot(controller: self)
            }
            sender.isEnabled = true
        //}
        
        
        /*
        if userTypeID == "1"{//COMMERCIAL CENTERS(SHOPS)
            if activityID == "12"{//Restaurant
                //ShopCoordinator.goToShopProfilePage(controller: self,storeID: store_id)
                ShopCoordinator.goToFoodShopProfileDetail(controller: self,resturantID: store_id)
            }else{
                ShopCoordinator.goToShopProfilePage(controller: self,storeID: store_id)
            }
            
        }else if userTypeID == "2"{//RESERVATIONS
            
            if activityID == "16"{//Gym
                Coordinator.goToGymList(controller: self,storeID: store_id)
            }else if activityID == "6" {//Charlets
                //chaletss
                Coordinator.goToCharletsList(controller: self,chaletID: store_id)
            }else if activityID == "4"{//Hotels
                Coordinator.goToHotelBookingFlow(controller: self,store_ID: store_id )
            }else if activityID == "24"{//Wedding Halls
                
            }else if activityID == "17"{//Playground
                PlayGroundCoordinator.goToBookNow(controller: self,store_ID: store_id)
            }else{
                
            }
        }else if userTypeID == "3"{//INDIVIDUALS
            if activityID == "7"{//Car Repaire
                Coordinator.goToCarBookingFlow(controller: self, store_ID: store_id)
            }else {//individuals
                Coordinator.goToIndvidualSellerFlow(controller: self, step: store_id)
            }
            
        }else if userTypeID == "4"{//SERVICES PROVIDERS
            Coordinator.goToServices(controller: self,storeID: store_id)
        }else if userTypeID == "5"{
            if activityID == "5"{//Appartments
                
            }else if activityID == "2"{//Wedding Halls
                
            }else if activityID == "1"{//Sports Clubs
                
            }else{
                
            }
        }else if userTypeID == "6"{//DELIVERY REPRESENTATIVE
            if activityID == "8"{//Restaurants
                
            }else{
                
            }
        }else{
            
        }*/
        
    }
    
    
    func commentAction(postID:String) {
        
        //self.getSinglePosts(postID: "370")
        if SessionManager.isLoggedIn() {
            Coordinator.goToCommentsList(controller: self,postID: postID, userID: "", onDone: {
                
            })
        }else{
            Coordinator.setRoot(controller: self)
        }
    }
    
    func menuAction(userTypeID: String, activityID: String,store_id:String) {
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if userTypeID == "1"{//COMMERCIAL CENTERS(SHOPS)
            if activityID == "12"{//Restaurant
                ShopCoordinator.goToFoodShopProfileDetail(controller: self,resturantID: store_id)
            }else{
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: store_id)
            }
            
        }else if userTypeID == "2"{//RESERVATIONS
            
            if activityID == "6"{//Chalets
                Coordinator.goToCharletsListVC(controller: self, venderID: store_id)
            }else if activityID == "16"{//Gym
                Coordinator.goToGymPackegesList(controller: self,id: store_id)
            }else if activityID == "4"{//Hotels
                Coordinator.goToRoomLIst(controller: self,store_id: store_id)
            }else if activityID == "24"{//Wedding Halls
                
            }else if activityID == "17"{//Playground
                PlayGroundCoordinator.goToBookNowDetail(controller: self, store_ID: store_id )
            }else{
                
            }
        }else if userTypeID == "3"{//INDIVIDUALS
            if activityID == "7"{//Car Repaire
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: store_id)
            }else if activityID == "12"{//Food store
                ShopCoordinator.goToFoodShopProfileDetail(controller: self,resturantID: store_id)
            }else if activityID == "6"{//Chalets
                Coordinator.goToCharletsListVC(controller: self, venderID: store_id)
            }else if activityID == "16"{//Gym
                Coordinator.goToGymPackegesList(controller: self,id: store_id)
            }else if activityID == "4"{//Hotels
                Coordinator.goToRoomLIst(controller: self,store_id: store_id)
            }else if activityID == "24"{//Wedding Halls
                
            }else if activityID == "17"{//Playground
                PlayGroundCoordinator.goToBookNowDetail(controller: self, store_ID: store_id )
            }else {//individuals
                ShopCoordinator.goToShopProfileDetail(controller: self,storeID: store_id)
                //SellerOrderCoordinator.goToIndividualSellerOrderDetail(controller: self)
            }
            
        }else if userTypeID == "4"{//SERVICES PROVIDERS
            Coordinator.goToAddServices(controller: self,serviceId: store_id)
        }else if userTypeID == "5"{
            if activityID == "5"{//Appartments
                
            }else if activityID == "2"{//Wedding Halls
                
            }else if activityID == "1"{//Sports Clubs
                
            }else{
                
            }
        }else if userTypeID == "6"{//DELIVERY REPRESENTATIVE
            if activityID == "8"{//Restaurants
                
            }else{
                
            }
        }else{
            
        }
        // }
    }
    
//    func shareAction(shareLink:String?) {
//        // NotificationCenter.default.post(name: Notification.Name("OpenSahre"), object: nil)
//        self.openShare(linkString: shareLink ?? "")
//    }
    
    func shareAction(obj: PostCollection?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if SessionManager.isLoggedIn() {
                self.createShareURL(id: obj?.postId ?? "", type: "homePost", title: obj?.postedUserName ?? "", image: obj?.postedUserImageurl ?? "")
            }else {
                let tabbar = self.tabBarController as? TabbarController
                tabbar?.hideTabBar()
                Coordinator.setRoot(controller: self)
            }
        }
    }
    
    func storeAction() {
        userTypeString = "shop"
        lastFetchedPost = ""
//        self.getAllPosts(page: 1) { (status) in
//
//        }
    }
    
    func individualAction() {
        userTypeString = "user"
        lastFetchedPost = ""
//        self.getAllPosts(page: 1) { (status) in
//
//        }
    }
    
    func storeAndIndividualAction() {
        userTypeString = ""
        lastFetchedPost = ""
//        self.getAllPosts(page: 1) { (status) in
//
//        }
    }
    func proAction() {
        
    }
    func liveActions() {
        Coordinator.goToLive(controller: self)
    }
}
extension PostListViewController: FloatingVCDelegate {
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

extension PostListViewController:PostNodeDelegate{
    func tapOnHashTag(value: String) {
        if isFromProfile{
            if isFromOtherProfile{
                Constants.shared.searchHashTagText = value
                Coordinator.updateRootVCToTab()
            }else{
                self.delegate?.moveDiscoverController(hashTag: value)
                self.navigationController?.popViewController(animated: true)
            }
            
        }else{
            Constants.shared.searchHashTagText = value
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
}
