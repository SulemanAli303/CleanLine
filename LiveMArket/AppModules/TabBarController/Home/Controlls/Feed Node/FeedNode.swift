//
//  FeedNode.swift
//  LiveMArket
//
//  Created by Greeniitc on 01/06/23.
//

import Foundation
import AsyncDisplayKit
import SDWebImage
import CHIPageControl

protocol CellActionsProtocol{
    func liveActions()
    func commentAction(postID:String,orderCount:Int,postUser_id:String)
    func menuAction(userTypeID: String, activityID: String,store_id:String)
    func shareAction(obj:PostCollection?)
    func storeAction()
    func individualAction()
    func storeAndIndividualAction()
    func profileAction(userTypeID:String,activityID:String,store_id:String,sender:ASButtonNode)
    func followAction(followerID:String,postID:String)
    func liveStreamList()
    func backActions()
    func usernameAction(userID:String)
    func goToProfile()
    func updateProgress(time: CMTime,videoPlayer:AVPlayer?)
    func longPressForVideo(postID:String)
}
protocol PostNodeDelegate : AnyObject {
//    func openComments(at index:Int)
//    func tapOnProfile(at index:Int)
//    func updateArrayFollowStatus(at index:Int)
//    func tapOnOptions(at index:Int, currentPlayingIndex:Int)
//    func tapOnShare(at index:Int, currentPlayingIndex:Int)
//    func tapOnFavourite(at index:Int, favStatus:Bool)
//    func tapOnSavePost(at index:Int, favStatus:Bool)
//    func tapOnSponserdbtn(at index:Int)
//    func tapOnWatchOnTeyaar(at index:Int, currentPlayingIndex:Int, currentCMTime : CMTime?)
//    func tapOnKeepWatching(at index:Int, currentPlayingIndex:Int, currentCMTime : CMTime?)
//    func tapOnTaggedUsers(at index:Int, currentPlayingIndex:Int)
    func tapOnHashTag(value:String)
//    func tapOnNameabel(at index:Int)
//    func tapOnLocation(at index:Int)
//    func tapOnUserTag(userId : String)
//    func tapOnInsights(at index:Int)
//    func tapOnSeeMoreDescription(at index:Int, currentPlayingIndex:Int)
//    func tapOnFeedMore(at index:Int, currentPlayingIndex:Int)
//    func toggleMute()
//    func doubleTapAction(at index:Int, favStatus:Bool)
}
enum PostContentType{
    case Image
    case Video
    case Multiple
}

class FeedNode: ASCellNode, ASCollectionDataSource {
    
    let usernameLabel = ASTextNode()
    let timeIntervalLabel = ASTextNode()
    let commentCountNode = ASTextNode()
    let descriptionLabel = ASTextNode()
    var delegate:CellActionsProtocol?
    var postData:PostCollection?
    var userData:User?
    var titleBottonHeight:CGFloat = 50
    var rightVerticalViewBottonHeight:CGFloat = 100
    var topViewTopHeight:CGFloat = 40
    var contentType: PostContentType = .Image
    var isFromProfile:Bool = false
    private var descriptionAvailable : Bool = false
    var postType : PostContentType = .Multiple
    internal var currentIndex:Int = -1
    var images: [String] = ["https://livemarketdxb.s3-accelerate.amazonaws.com/posts/169030993764c01531112f9.jpg","https://livemarketdxb.s3-accelerate.amazonaws.com/posts/169030993764c01531112f9.jpg","https://livemarketdxb.s3-accelerate.amazonaws.com/posts/169030993764c01531112f9.jpg"]
    var currentPageIndex = 0
    var automaticScrollTimer: Timer?
    deinit{
        automaticScrollTimer?.invalidate()
    }
    var isScrollEnabled = true
    var isAdminIsLive = false
    
    private var lastContentOffset: CGFloat = 0
    
    weak var postDelegate : PostNodeDelegate?
    
    public var isMuted = false {
        didSet{
            videoNode.playerNode.muted = isMuted
            
        }
    }
    
    init(post:PostCollection?,isProfilePage:Bool,delegate: PostNodeDelegate) {
        super.init()
        self.postDelegate = delegate
        isFromProfile = isProfilePage
        postData = post
        userData = SessionManager.getUserData()
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return  }

            loadVideoUrl()
                //usernameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                //timeIntervalLabel.backgroundColor = UIColor.black.withAlphaComponent(0.1)

                //setContentTypes()
            let attributesName = [NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 17.0)!, NSAttributedString.Key.foregroundColor: UIColor.white]
            usernameLabel.attributedText = NSAttributedString(string: postData?.postedUserName ?? "", attributes: attributesName as [NSAttributedString.Key : Any])


            let attributesTime = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor.white]
            timeIntervalLabel.attributedText = NSAttributedString(string: Helper.convertTimestampFromString(timeStamp: postData?.postCreatedAt ?? "", short: false), attributes: attributesTime as [NSAttributedString.Key : Any])

            let attributesDesc = [NSAttributedString.Key.font: UIFont(name: "Poppins", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.white]
            descriptionLabel.attributedText = NSAttributedString(string: postData?.postCaption ?? "", attributes: attributesDesc as [NSAttributedString.Key : Any])

                // self.profileButtonNode.imageNode.sd_setImage(with: URL(string: postData?.postedUserImageurl ?? ""), placeholderImage: UIImage(named: "placeholder_profile"), for: .normal)

            if let description = post?.postCaption,!(description.isEmpty) {
                descriptionAvailable = true
                    //let trimmedString = description.trimmingCharacters(in: .whitespaces)

            }

            if descriptionAvailable {
                let trimmedString = (postData?.postCaption ?? "").trimmingCharacters(in: .whitespaces)
                scrollableNode.currentTerm = MessageV(text: trimmedString)
            }

            let attributesCommentCount = [NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 10.0)!, NSAttributedString.Key.foregroundColor: UIColor.white]
            commentCountNode.attributedText = NSAttributedString(string: postData?.commentCount ?? "0", attributes: attributesCommentCount as [NSAttributedString.Key : Any])

            usernameLabel.addTarget(self, action: #selector(self.usernameNodePressed), forControlEvents: .touchUpInside)





            addSubnode(overlyNode)
            addSubnode(videoNode)

            if self.postData?.postsFiles?.first?.url?.isImage() == true{
                addSubnode(pagerNode)
            }else{
                addSubnode(videoNode)
                addSubnode(muteButtonNode)
            }

                //addSubnode(backgroundNode)

            addSubnode(pageIndicatorNode)


            addSubnode(chatButtonNode)
            addSubnode(menuButtonNode)
            addSubnode(shareButtonNode)


            addSubnode(storeButtonNode)
            addSubnode(individualButtonNode)
            addSubnode(storeAndIndividualButtonNode)

            addSubnode(iconImageNode)
            addSubnode(liveButtonNode)
            addSubnode(backButtonNode)


            addSubnode(usernameLabel)
            addSubnode(timeIntervalLabel)
            addSubnode(descriptionLabel)

            addSubnode(profileImageNode)
            addSubnode(profileButtonNode)
            addSubnode(followButtonNode)
            if descriptionAvailable{
                scrollableNode.delegate = self.postDelegate
                scrollableNode.termNode.addTarget(self, action:  #selector(self.resetReadMoreText), forControlEvents: .touchUpInside)
                addSubnode(scrollableNode)
            }
            addSubnode(commentCountNode)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateMuteIcon(_:)), name: Notification.Name("updateMuteIcon"), object: nil)
        
    }
    
    @objc func updateMuteIcon(_ notification: Notification) {
        
        if VideoPlayerManager.shared.muted{
            self.muteButtonNode.setBackgroundImage(UIImage(named: "mute"), for: .normal)
        }else{
            self.muteButtonNode.setBackgroundImage(UIImage(named: "unmute"), for: .normal)
        }
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        
    }
    
    override func didExitPreloadState() {
        
    }
    
    override func didLoad() {
        super.didLoad()
        loadVideoUrl()
        if self.postData?.postsFiles?.first?.url?.isImage() == true {
            //layoutFinished = true
            pagerNode.reloadData()
            //self.reloadNotififer?()
            //startAutomaticScrolling()
        }
    }
    
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        if self.postData?.postsFiles?.first?.url?.isImage() == true {
            
            //startAutomaticScrolling()
        }
        if VideoPlayerManager.shared.muted{
            self.muteButtonNode.setBackgroundImage(UIImage(named: "mute"), for: .normal)
        }else{
            self.muteButtonNode.setBackgroundImage(UIImage(named: "unmute"), for: .normal)
        }
        self.buttonSetDefaultImages()
        if Constants.shared.selectedMode == "Store"{
            storeButtonNode.setBackgroundImage(UIImage(named: "selectedStore"), for: .normal)
        } else if Constants.shared.selectedMode == "Individual"{
            individualButtonNode.setBackgroundImage(UIImage(named: "selectedIndividual"), for: .normal)
        }else{
            storeAndIndividualButtonNode.setBackgroundImage(UIImage(named: "selectedStoreAndIndividual"), for: .normal)
        }
        
        DispatchQueue.main.async() {
            
            if let url = URL(string: self.postData?.postedUserImageurl ?? ""){
                self.profileImageNode.url = url
            }
            
            if self.postData?.isIamFollowing == "1"{
                self.followButtonNode.setImage(UIImage(named: "followCheck"), for: .normal)
            }else{
                self.followButtonNode.setImage(UIImage(named: "followAdd"), for: .normal)
            }
            
            if self.postData?.isLive == 1{
                self.profileButtonNode.setBackgroundImage(UIImage(named: "liveBorderIcon"), for: .normal)
            }else{
                self.profileButtonNode.setBackgroundImage(UIImage(named: "profileBorder"), for: .normal)
            }
            
        }
        
    }
    
    
    override func didExitVisibleState() {
        super.didExitVisibleState()
        // Invalidate the timer when the view is about to disappear
        automaticScrollTimer?.invalidate()
    }
    override func didEnterDisplayState() {
        super.didEnterDisplayState()
        //loadVideoUrl()
    }
    override func didExitDisplayState() {
        
    }
    
    func loadVideoUrl(){
        let content = self.postData?.postsFiles?.first
        let filePath : String? = {
            if content?.have_hls_url == "1" {
                if let hlsCDNString = content?.hls_cdn_url, content?.hls_cdn_url != ""{
                    if URL(string: hlsCDNString) != nil{
                        return hlsCDNString
                    }
                }else if let hlsString = content?.hls_url, content?.hls_url != ""{
                    if URL(string: hlsString) != nil{
                        return hlsString
                    }
                }
            }
            return content?.url
        }()
        
        //self.videoNode.set(url: filePath ?? "")
        if let videoUrl = filePath {
            videoNode.set(content: content, instantLoading: false, filePath: videoUrl, thumb: nil,isProfile: isFromProfile)
        }else{
            videoNode.set(content: nil, instantLoading: false, filePath: self.postData?.postsFiles?.first?.url, thumb: nil,isProfile: isFromProfile)
        }
        setMenuIcons()
    }
    
    lazy private(set) var overlyNode = { () -> GradientOverlyNode in
        let node = GradientOverlyNode()
        node.isLayerBacked = true
        node.backgroundColor = .black
        
        
        return node
    }()
    
    // UI Components
    lazy private(set) var scrollableNode : ScrollableTextNode = {
        
        let node = ScrollableTextNode() //
        //node.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        node.style.maxWidth = ASDimension(unit: .points, value: Screen.bounds.width - 100)
        node.delegateScroll = self
        return node
    }()
    
    lazy var profileButtonNode : ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        node.contentsGravity = AVLayerVideoGravity.resizeAspect.rawValue
        node.setBackgroundImage(UIImage(named: "profileBorder"), for: .normal)
        node.contentHorizontalAlignment = .middle
        node.imageNode.contentMode = .scaleToFill
        node.addTarget(self, action: #selector(self.profileButtonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var profileImageNode : ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.style.preferredSize = CGSize(width: 45.0, height: 45.0)
        //node.backgroundColor = .white
        node.url = URL(string: "https://livemarketdxb.s3.ap-southeast-1.amazonaws.com/account_types/Frame.png")
        node.contentMode = .scaleAspectFill
        return node
    }()
    
    lazy var followButtonNode : ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        //node.backgroundColor = .yellow
        node.addTarget(self, action: #selector(self.followButtonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var chatButtonNode : ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        //node.backgroundColor = .yellow
        node.setImage(UIImage(named: "comment"), for: .normal)
        node.addTarget(self, action: #selector(self.chatButtonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var menuButtonNode : ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        //node.backgroundColor = .green
        node.contentMode = .scaleToFill
        //node.setImage(UIImage(named: "menu"), for: .normal)
        node.addTarget(self, action: #selector(self.buttonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var shareButtonNode : ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        // node.backgroundColor = .yellow
        node.setImage(UIImage(named: "share"), for: .normal)
        node.addTarget(self, action: #selector(self.shareButtonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var videoNode = { () -> PlayerNode in
        let node = PlayerNode()
        node.playerDelegate = self
        node.longPressDelegate = self
        //node.backgroundColor = .green
        node.style.preferredSize = CGSize(width: Screen.width, height: 300)
        return node
    }()
    
    lazy var storeButtonNode : ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 45.0, height: 45.0)
        // node.backgroundColor = .yellow
        node.setBackgroundImage(UIImage(named: "store"), for: .normal)
        node.addTarget(self, action: #selector(self.storeButtonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var individualButtonNode : ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 45.0, height: 45.0)
        // node.backgroundColor = .yellow
        node.setBackgroundImage(UIImage(named: "individual"), for: .normal)
        node.addTarget(self, action: #selector(self.individualButtonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var storeAndIndividualButtonNode : ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 45.0, height: 45.0)
        // node.backgroundColor = .yellow
        node.setBackgroundImage(UIImage(named: "storeAndIndividual"), for: .normal)
        node.addTarget(self, action: #selector(self.storeAndIndividualButtonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var liveButtonNode : ASButtonNode = {
        let node = ASButtonNode()
        node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        // node.backgroundColor = .yellow
        node.setImage(UIImage(named: "live"), for: .normal)
        
        node.addTarget(self, action: #selector(self.liveButtonPressed), forControlEvents: .touchUpInside)
        return node
    }()
    
    lazy var iconImageNode : ASButtonNode = {
        let imageNode = ASButtonNode()
        //if isAdminIsLive {
            //imageNode.setImage(UIImage(named: "liveLogoGif"), for: .normal)
        //} else {
            //imageNode.setImage(UIImage(named: "liveLogo"), for: .normal)
        //}
        imageNode.style.preferredSize = CGSize(width: 70.0, height: 50.0)
        imageNode.addTarget(self, action: #selector(self.liveStremPressed), forControlEvents: .touchUpInside)
        return imageNode
    }()
    
    lazy var muteButtonNode : ASButtonNode = {
        let muteButtonNode = ASButtonNode()
        //muteButtonNode.setBackgroundImage(UIImage(named: "unmute"), for: .normal)
        muteButtonNode.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        //muteButtonNode.contentMode = .scaleAspectFit
        muteButtonNode.addTarget(self, action: #selector(self.muteButtonPressed), forControlEvents: .touchUpInside)
        return muteButtonNode
    }()
    
    lazy var backButtonNode : ASButtonNode = {
        let imageNode = ASButtonNode()
        imageNode.setImage(UIImage(named: "return"), for: .normal)
        imageNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        imageNode.addTarget(self, action: #selector(self.backButtonPressed), forControlEvents: .touchUpInside)
        return imageNode
    }()
    
    lazy var pagerFlowLayout : ASPagerFlowLayout = {
        let layout = ASPagerFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy  public var pagerNode : ASPagerNode = {
        let node = ASPagerNode(collectionViewLayout: pagerFlowLayout)
        node.backgroundColor = .black
        node.contentMode = .scaleAspectFit
        node.alwaysBounceHorizontal = false
        //node.style.preferredSize = CGSize(width: Screen.width, height: 500)
        node.delegate = self
        node.dataSource = self
        
        return node
    }()
    
    lazy private(set) var pageIndicatorNode : PageIndicatorNode = {
        let count : Int = {
            return self.postData?.postsFiles?.count ?? 0
        }()
        let node = PageIndicatorNode(numberOfPages: count) //
        node.backgroundColor = .clear
        node.style.preferredSize = CGSize(width: 100, height: 20)
        return node
    }()
    
    lazy private(set) var backgroundNode : GradientBackgroundNode = {
        let node = GradientBackgroundNode()
        node.style.preferredSize = CGSize(width: Screen.width, height: 100)
        return node
    }()
    
    @objc func resetReadMoreText(){
        if scrollableNode.termNode.maximumNumberOfLines == 0 {
 
            scrollableNode.termNode.maximumNumberOfLines = 2
            scrollableNode.style.maxHeight = .init()
            scrollableNode.termNode.setNeedsLayout()
            scrollableNode.termNode.layoutIfNeeded()
        }
    }
    
    func startAutomaticScrolling() {
           // Set up the automatic scroll timer
           automaticScrollTimer = Timer.scheduledTimer(
               timeInterval: 3.0, // Adjust the interval as needed (e.g., 5 seconds in this example)
               target: self,
               selector: #selector(scrollToNextPage),
               userInfo: nil,
               repeats: true
           )
       }
    
    @objc func scrollToNextPage() {
            //isScrollEnabled.toggle()
            let nextPageIndex = (currentPageIndex + 1) % images.count
            pagerNode.scrollToPage(at: nextPageIndex, animated: true)
            currentPageIndex = nextPageIndex
        }
    
    @objc func muteButtonPressed(){
        print("mute Button pressed")
        if videoNode.playerNode.muted == true{
            videoNode.playerNode.muted = false
            Constants.shared.videoMuted = false
            muteButtonNode.setBackgroundImage(UIImage(named: "unmute"), for: .normal)
        }else{
            videoNode.playerNode.muted = true
            Constants.shared.videoMuted = true
            muteButtonNode.setBackgroundImage(UIImage(named: "mute"), for: .normal)
        }
        VideoPlayerManager.shared.muted.toggle()
    }
    
    @objc func backButtonPressed(){
        print("back Button pressed")
        self.delegate?.backActions()
    }
    
    @objc func usernameNodePressed(){
        print("user name pressed")
        if (self.postData?.postedUserId ?? "") != (SessionManager.getUserData()?.id ?? "") {
            self.delegate?.usernameAction(userID: self.postData?.postedUserId ?? "")
        }else {
            self.delegate?.goToProfile()
        }
        
    }
    
    @objc func liveButtonPressed(){
        print("live Button pressed")
        self.delegate?.liveActions()
    }
    
    @objc func liveStremPressed(){
        print("live Button pressed")
        self.delegate?.liveStreamList()
    }
    
    @objc func followButtonPressed(){
        print("follow Button pressed")
        self.delegate?.followAction(followerID: self.postData?.postedUserId ?? "",postID: self.postData?.postId ?? "")
    }
    
    @objc func storeAndIndividualButtonPressed(){
        print("store and individual Button pressed")
        buttonSetDefaultImages()
        storeAndIndividualButtonNode.setBackgroundImage(UIImage(named: "selectedStoreAndIndividual"), for: .normal)
        self.delegate?.storeAndIndividualAction()
        //Constants.shared.selectedMode = "Both"
    }
    @objc func individualButtonPressed(){
        print("individual Button pressed")
        buttonSetDefaultImages()
        individualButtonNode.setBackgroundImage(UIImage(named: "selectedIndividual"), for: .normal)
        self.delegate?.individualAction()
        //Constants.shared.selectedMode = "Individual"
    }
    @objc func storeButtonPressed(){
        print("store Button pressed")
        buttonSetDefaultImages()
        storeButtonNode.setBackgroundImage(UIImage(named: "selectedStore"), for: .normal)
        self.delegate?.storeAction()
        //Constants.shared.selectedMode = "Store"
    }
    @objc func chatButtonPressed(){
        print("Chat Button pressed")
        self.delegate?.commentAction(postID: self.postData?.postId ?? "",orderCount: self.postData?.orderCount ?? 0,postUser_id: self.postData?.postedUserId ?? "")
    }
    @objc func profileButtonPressed(){
        print("Profile Button pressed \(self.postData?.postedUserId ?? "") \((SessionManager.getUserData()?.id ?? ""))")
        if (self.postData?.postedUserId ?? "") != (SessionManager.getUserData()?.id ?? "") {
            self.delegate?.profileAction(userTypeID: self.postData?.userTypeId ?? "", activityID: self.postData?.activityTypeId ?? "", store_id: self.postData?.postedUserId ?? "", sender: profileButtonNode)
        }else {
            self.delegate?.goToProfile()
         //   self.delegate.tabBar.selectedItem = 4
        }
    }
    
    @objc func buttonPressed(){
        print("Menu Button pressed")
        self.delegate?.menuAction(userTypeID: self.postData?.userTypeId ?? "", activityID: self.postData?.activityTypeId ?? "", store_id: self.postData?.postedUserId ?? "")
    }
    
    @objc func shareButtonPressed(){
        print("Share Button pressed")
        self.delegate?.shareAction(obj: postData)
    }
    
    func buttonSetDefaultImages(){
        storeAndIndividualButtonNode.setBackgroundImage(UIImage(named: "storeAndIndividual"), for: .normal)
        individualButtonNode.setBackgroundImage(UIImage(named: "individual"), for: .normal)
        storeButtonNode.setBackgroundImage(UIImage(named: "store"), for: .normal)
    }
    
    override func layout() {
        super.layout()
        profileImageNode.layer.cornerRadius = 22.5
        //videoNode.frame = self.view.frame
        pagerNode.isUserInteractionEnabled = true
        
        
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let hasTopNotch: Bool =  Constants.shared.hasTopNotch
        if hasTopNotch {
            titleBottonHeight = 20
            rightVerticalViewBottonHeight = 100//200
//            if isFromProfile {
//                rightVerticalViewBottonHeight = 150
//            }
            topViewTopHeight = 40
        } else {
            titleBottonHeight = 20
            rightVerticalViewBottonHeight = 130//150
            topViewTopHeight = 10
        }
//        if isFromProfile{
//            titleBottonHeight = 30
//        }
        
        
        let titleDescriptionStack = ASStackLayoutSpec.horizontal()
        usernameLabel.style.flexShrink = 1.0
        timeIntervalLabel.style.spacingBefore = 10
        timeIntervalLabel.style.alignSelf = .end
        titleDescriptionStack.children = [usernameLabel, timeIntervalLabel]
        let titleStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .end, alignItems: .start, children: [titleDescriptionStack,scrollableNode])
        let titleInsetSpec1 = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 20, bottom: titleBottonHeight, right: 80), child: titleStackSpec)
        

        let overLySpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .end, alignItems: .start, children: [backgroundNode])
        let overLyInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: titleBottonHeight - 20, right: 0), child: overLySpec)
        
        let titleInsetSpec = ASOverlayLayoutSpec(child: overLyInsetSpec, overlay: titleInsetSpec1)
        
        let pageStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .end, alignItems: .center, children: [pageIndicatorNode])
        let pageInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 0, bottom: 150, right: 0), child: pageStackSpec)
        
        
        var profileButtonFinalOverLayout = ASOverlayLayoutSpec()
        
       // if self.postData?.postedUserId == userData?.id {
            ///Profile Button
            let profileImageInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            let profileImageInsertSpec = ASInsetLayoutSpec(insets: profileImageInset, child: profileImageNode)
            profileButtonFinalOverLayout = ASOverlayLayoutSpec(child: profileButtonNode, overlay: profileImageInsertSpec)
            
//        }else{
//            ///Profile Button
//            let profileImageInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//            let profileImageInsertSpec = ASInsetLayoutSpec(insets: profileImageInset, child: profileImageNode)
//            let profileButtonOverLayout = ASOverlayLayoutSpec(child: profileButtonNode, overlay: profileImageInsertSpec)
//            let followButtonInset = UIEdgeInsets(top: 25, left: 0, bottom: -25, right: 0)
//            let followButtonInsertSpec = ASInsetLayoutSpec(insets: followButtonInset, child: followButtonNode)
//            profileButtonFinalOverLayout = ASOverlayLayoutSpec(child: profileButtonOverLayout, overlay: followButtonInsertSpec)
//        }
        
        /// Right side menus
        let commentCountInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        let commentCountInsertSpec = ASInsetLayoutSpec(insets: commentCountInset, child: commentCountNode)
        let commentStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .center, children: [chatButtonNode,commentCountInsertSpec])
        
        
        var verticalRightInsert = ASInsetLayoutSpec()
        var verticatRightStack = ASStackLayoutSpec()
        if self.postData?.userTypeId == "3"{
            if self.postData?.hasProduct != 0{
                if (self.postData?.postedUserId ?? "") != (userData?.id ?? "") {
                    verticatRightStack = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .end, alignItems: .end, children: [profileButtonFinalOverLayout,commentStack,menuButtonNode,shareButtonNode])
                }else {
                    verticatRightStack = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .end, alignItems: .end, children: [profileButtonFinalOverLayout,commentStack,shareButtonNode])
                }
            }else{
                let shaareButtonInset = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
                let shareButtonInsertSpec = ASInsetLayoutSpec(insets: shaareButtonInset, child: shareButtonNode)
                verticatRightStack = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .end, alignItems: .end, children: [profileButtonFinalOverLayout,commentStack,shareButtonInsertSpec])
            }
            verticalRightInsert = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: rightVerticalViewBottonHeight, right: 10), child: verticatRightStack)
        }else{
            if (self.postData?.postedUserId ?? "") != (userData?.id ?? "") {
                verticatRightStack = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .end, alignItems: .end, children: [profileButtonFinalOverLayout,commentStack,menuButtonNode,shareButtonNode])
                verticalRightInsert = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: rightVerticalViewBottonHeight, right: 10), child: verticatRightStack)
            }else {
                verticatRightStack = ASStackLayoutSpec(direction: .vertical, spacing: 15, justifyContent: .end, alignItems: .end, children: [profileButtonFinalOverLayout,commentStack,shareButtonNode])
                verticalRightInsert = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: rightVerticalViewBottonHeight, right: 10), child: verticatRightStack)
            }
        }
        
        
        let verticatLeftStack = ASStackLayoutSpec(direction: .vertical, spacing: 20, justifyContent: .start, alignItems: .start, children: [storeButtonNode,individualButtonNode,storeAndIndividualButtonNode])
        let verticalLeftInsert = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 110, left: 20, bottom: 0, right: 0), child: verticatLeftStack)
        var topHeaderStack = ASStackLayoutSpec()
        var topHeaderMuteInsert = ASInsetLayoutSpec()
        if isFromProfile{
            topHeaderStack = ASStackLayoutSpec(direction: .horizontal, spacing: 30, justifyContent: .spaceBetween, alignItems: .start, children: [backButtonNode,muteButtonNode])
        }else{
            topHeaderStack = ASStackLayoutSpec(direction: .horizontal, spacing: 30, justifyContent: .spaceBetween, alignItems: .start, children: [iconImageNode, liveButtonNode])
            let topHeaderMuteStack = ASStackLayoutSpec(direction: .horizontal, spacing: 30, justifyContent: .end, alignItems: .start, children: [muteButtonNode])
            topHeaderMuteInsert = ASInsetLayoutSpec(insets: UIEdgeInsets(top: topViewTopHeight + 60, left: 15, bottom: 0, right: 20), child: topHeaderMuteStack)
        }
        
        let topHeaderInsert = ASInsetLayoutSpec(insets: UIEdgeInsets(top: topViewTopHeight, left: 15, bottom: 0, right: 10), child: topHeaderStack)
        
        
        
        
        let overlayInsert = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let overlaySepcInsert = ASInsetLayoutSpec(insets: overlayInsert, child: overlyNode)
        
        var finalLayout4 = ASOverlayLayoutSpec()
        
//        let contentOverly : ASOverlayLayoutSpec = {
//            let overlyInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//            let overlyInsetSpec = ASInsetLayoutSpec(insets: overlyInsets, child: overlyNode)
//            let videoInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//            if postType == .Image{
////                let videoInsetSpec = ASInsetLayoutSpec(insets: videoInsets, child: imageNode)
////                return ASOverlayLayoutSpec(child: videoInsetSpec, overlay: overlyInsetSpec)
//                return ASOverlayLayoutSpec()
//            }else if postType == .Video{
//                let videoInsetSpec = ASInsetLayoutSpec(insets: videoInsets, child: videoNode)
//                return ASOverlayLayoutSpec(child: videoInsetSpec, overlay: overlyInsetSpec)
//            }else{
//                let videoInsetSpec = ASInsetLayoutSpec(insets: videoInsets, child: pagerNode)
//                return ASOverlayLayoutSpec(child: videoInsetSpec, overlay: overlyInsetSpec)
//            }
//        }()
        
        if isFromProfile{
            let overlayout   = ASOverlayLayoutSpec(child: overlaySepcInsert, overlay: verticalRightInsert)
            var finalLayout  = ASOverlayLayoutSpec()
            if self.postData?.postsFiles?.first?.url?.isImage() == true{
                let layout = ASOverlayLayoutSpec(child: overlayout, overlay: pagerNode)
                 finalLayout  = ASOverlayLayoutSpec(child: layout, overlay: pageInsetSpec)
            }else{
                 finalLayout  = ASOverlayLayoutSpec(child: overlayout, overlay: videoNode)
            }
            let finalLayout1 = ASOverlayLayoutSpec(child: finalLayout, overlay: titleInsetSpec)
             finalLayout4 = ASOverlayLayoutSpec(child: finalLayout1, overlay: topHeaderInsert)
        }else{
            let overlayout   = ASOverlayLayoutSpec(child: overlaySepcInsert, overlay: verticalRightInsert)
            var finalLayout  = ASOverlayLayoutSpec()
            if self.postData?.postsFiles?.first?.url?.isImage() == true{
                let layout = ASOverlayLayoutSpec(child: overlayout, overlay: pagerNode)
                 finalLayout  = ASOverlayLayoutSpec(child: layout, overlay: pageInsetSpec)
            }else{
                 finalLayout  = ASOverlayLayoutSpec(child: overlayout, overlay: ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), child: videoNode))
            }
            
            let finalLayout1 = ASOverlayLayoutSpec(child: finalLayout, overlay: titleInsetSpec)
            let finalLayout2 = ASOverlayLayoutSpec(child: finalLayout1, overlay: verticalLeftInsert)
            let finalLayout3 = ASOverlayLayoutSpec(child: finalLayout2, overlay: topHeaderInsert)
            finalLayout4 = ASOverlayLayoutSpec(child: finalLayout3, overlay: topHeaderMuteInsert)
            
        }
        

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0), child: finalLayout4)
    }
    private func setContentTypes(){
        if let pWidth = self.postData?.postsFiles?.first?.width, let pHeight = self.postData?.postsFiles?.first?.height{
            let ratio = (Double(pHeight) ?? 0) / (Double(pWidth) ?? 0)
            let height = (Screen.width) * ratio
            //videoNode.style.preferredSize = CGSize(width: Screen.width - 40, height: min(height, Screen.height * 0.55))
            
        }else{
            //videoNode.style.preferredSize = CGSize(width: Screen.width, height: 300)
        }
        
        if (postData?.postsFiles?.count ?? 0) > 1{
            postType = .Multiple
        }else if (postData?.postsFiles?.count ?? 0) == 1{
            if postData?.postsFiles?.first?.extensions == "jpeg"{
                postType = .Image
            }else{
                postType = .Video
            }
        }
    }
    
    func setMenuIcons(){

        let urlString = self.postData?.activityTypeLogo ?? ""
        
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            // Now you have a valid URL
            self.menuButtonNode.url = url
        } else {
            // Handle the case where the URL string is invalid
            print("Invalid URL")
        }
        
        /*
        if let userID = self.postData?.userTypeId,let activityID = self.postData?.activityTypeId{
        
            if userID == "1"{//COMMERCIAL CENTERS(SHOPS)
                if activityID == "11"{//Clothing
                    self.menuButtonNode.setImage(UIImage(named: "cloth"), for: .normal)
                }else if activityID == "12"{//Restaurant
                    self.menuButtonNode.setImage(UIImage(named: "hotelMenu"), for: .normal)
                }else if activityID == "13"{//Medicine
                    self.menuButtonNode.setImage(UIImage(named: "medicine"), for: .normal)
                }else if activityID == "14"{//Fruit Vegetable
                    self.menuButtonNode.setImage(UIImage(named: "gocery"), for: .normal)
                }else if activityID == "9"{//Super Market
                    self.menuButtonNode.setImage(UIImage(named: "shop"), for: .normal)
                }else if activityID == "23"{//CAFE
                    self.menuButtonNode.setImage(UIImage(named: "cafeIcon"), for: .normal)
                }else if activityID == "10"{//Shoping
                    self.menuButtonNode.setImage(UIImage(named: "shop"), for: .normal)
                }else{
                    self.menuButtonNode.setImage(UIImage(named: "hotelMenu"), for: .normal)
                }
                
            }else if userID == "2"{//RESERVATIONS
                
                if activityID == "6"{//Chalets
                    self.menuButtonNode.setImage(UIImage(named: "chaletIcon"), for: .normal)
                }else if activityID == "16"{//Gym
                    self.menuButtonNode.setImage(UIImage(named: "gymIcon"), for: .normal)
                }else if activityID == "4"{//Hotels
                    self.menuButtonNode.setImage(UIImage(named: "hotelIcon"), for: .normal)
                }else if activityID == "24"{//Wedding Halls
                    self.menuButtonNode.setImage(UIImage(named: "shop"), for: .normal)
                }else if activityID == "17"{//Playground
                    self.menuButtonNode.setImage(UIImage(named: "playGround"), for: .normal)
                }else{
                    self.menuButtonNode.setImage(UIImage(named: "hotelMenu"), for: .normal)
                }
            }else if userID == "3"{//INDIVIDUALS
                if activityID == "7"{//Car Repaire
                    self.menuButtonNode.setImage(UIImage(named: "carRepairIcon"), for: .normal)
                }else {//individuals
                    self.menuButtonNode.setImage(UIImage(named: "individualIcon"), for: .normal)
                }
            }else if userID == "4"{//SERVICES PROVIDERS
                self.menuButtonNode.setImage(UIImage(named: "serviceIcon"), for: .normal)
            }else if userID == "5"{//WHOLESELLERS
                if activityID == "5"{//Appartments
                    self.menuButtonNode.setImage(UIImage(named: "hotelIcon"), for: .normal)
                }else if activityID == "2"{//Wedding Halls
                    self.menuButtonNode.setImage(UIImage(named: "shop"), for: .normal)
                }else if activityID == "1"{//Sports Clubs
                    self.menuButtonNode.setImage(UIImage(named: "shop"), for: .normal)
                }else{
                    self.menuButtonNode.setImage(UIImage(named: "shop"), for: .normal)
                }
            }else if userID == "6"{
                if activityID == "8"{//Restaurants
                    self.menuButtonNode.setImage(UIImage(named: "hotelMenu"), for: .normal)
                }else{
                    self.menuButtonNode.setImage(UIImage(named: "hotelMenu"), for: .normal)
                }
            }else{
                
            }
        }*/
    }
}
class GradientOverlyNode: ASDisplayNode {
    
    override init() {
        super.init()
        //        DispatchQueue.main.async { [weak self] in
        //            self?.applyGradientOnTopAndBottom(colours: [.black,.clear,.clear,.black], locations: [0.0, 0.3,0.7, 1.0])
        //        }
        
    }
    override func didLoad() {
        super.didLoad()
        
        // applyGradientOnTopAndBottom(colours: [.black,.clear,.clear,.black], locations: [0.0, 0.3,0.7, 1.0])
    }
    func applyGradientOnTopAndBottom(colours: [UIColor], locations: [NSNumber]?) {
        guard (self.layer
            .sublayers?
            .filter({ $0 is CAGradientLayer }).isEmpty ?? true) else { return }
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = .init(origin: .zero, size: self.calculatedSize)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.addSublayer(gradient)
        //return gradient
    }
    
}
class Helper{
    static func convertTimestampFromString(timeStamp:String, short:Bool? = false) -> String {
        //    let converted = Date(timeIntervalSince1970: Double(truncating: timeStamp) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        let myString = timeStamp
        
        let date = Helper.rfcDateFormatter.date(from: myString)
        let dateLocal = Helper.localDateFormatter.date(from: myString)
        guard let finalDate = date ?? dateLocal else {return myString}
        let localDate = self.localDateFormatter.string(from: finalDate)
        
        let dateObj = dateFormatter.date(from: localDate)!
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "h:mm a"
        newDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        newDateFormatter.dateFormat = "h:mm a"
        newDateFormatter.amSymbol = "AM"
        newDateFormatter.pmSymbol = "PM"
        return dateObj.getElapsedInterval(short: short)
    }
    static var rfcDateFormatter2 : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }
    static var localDateFormatter2 : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        return formatter
    }
    
    static var rfcDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }
    static var localDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        return formatter
    }
    
}
struct Screen{
    static let bounds = UIScreen.main.bounds
    static let width  = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let tabBarHeight = CGFloat(49)
}

extension FeedNode: PlayerNodeProtocol{
    func videoMuted(muted: Bool) {
//        if muted == true{
//            muteButtonNode.image = UIImage(named: "mute")
//        }else{
//            muteButtonNode.image = UIImage(named: "unmute")
//        }
    }
    
    
}
extension FeedNode : ScrollableNodeDelegate{
    func didTapSeeMore(){
        self.overlyNode.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
}

class PagerPostNode : ASCellNode {
    
    var vc: FeedNode?
//    lazy private(set) var mutePagerButton = { () -> ASButtonNode in
//        let node = ASButtonNode()
//
//        node.setBackgroundImage(R.image.soundBtn(), for: .selected)
//        node.setBackgroundImage(R.image.unMute(), for: .normal)
//
//        node.style.preferredSize = CGSize(width: 30, height: 30)
//        node.cornerRadius = 15
//        node.addTarget(self, action: #selector(self.tapMute), forControlEvents: .touchUpInside)
//        return node
//    }()
//
//    public var isMuted = true {
//        didSet{
//
//            videoNode.playerNode.muted = isMuted
//            mutePagerButton.isSelected = isMuted
//        }
//    }
//
//    public weak var delegate : PostNodeDelegate?
    
//    @objc func tapMute(){
//        mutePagerButton.isSelected.toggle()
//
//        isMuted = mutePagerButton.isSelected
//        delegate?.toggleMute()
//    }
    
//    public func requestPlay(){
//        if self.contentType != .Video{
//            VideoPlayerManager.shared.pause(.hidden)
//            //VideoPlayerManager.shared.playVideo(in: nil)
//        }else{
//            VideoPlayerManager.shared.playPagerVideo(in: self)
//        }
//    }
    
    //sponsoredUrl //isSponsored
//    var muteStatus : Bool = false {
//        didSet{
//            //self.mmPlayerLayer.player?.isMuted = muteStatus
//        }
//    }
//    lazy var videoNode = { () -> PlayerNode in
//        let node = PlayerNode()
//        node.pagerDelegate = self
//        node.backgroundColor = .black
//        node.delegate = self.vc
//        node.style.preferredSize = CGSize(width: Screen.width, height: 300)
//        return node
//    }()
    lazy private(set) var imageNode  : ASNetworkImageNode = {
        let node = ASNetworkImageNode()
       // node.backgroundColor = .clear
        node.contentMode = .scaleAspectFill
        node.style.preferredSize = CGSize(width: Screen.width, height: Screen.height)
        return node
    }()
    
    var contentType: PostContentType = .Image
    var postContent:PostsFiles?
    
    init(with type: PostContentType, file : String,vc:FeedNode, thumb: String?,data:PostsFiles?) {
        super.init()
        self.postContent = data
        contentType = type
        self.vc = vc
        addSubnode(imageNode)
        
        var imageUrl: URL? {
            if  let imageURL = URL(string: file) {
                return imageURL
            } else{
                return nil
            }
        }
        if let imageUrl = imageUrl {
            imageNode.url = imageUrl
        }
        imageNode.contentMode = .scaleAspectFit
        automaticallyManagesSubnodes = true
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let overlyInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let videoInsetSpec = ASInsetLayoutSpec(insets: overlyInsets, child: imageNode)
        return videoInsetSpec
    }
    
    func getImageRatio() -> UIView.ContentMode {
        let width = Int(self.postContent?.width
                        ?? "0") ?? 320
        let height = Int(self.postContent?.height ?? "0") ?? 640
        return (width < height) ? .scaleAspectFill : .scaleAspectFit
    }
    
    @objc func goToViewOtherPost() {
        //guard let vc = self.vc?.closestViewController as? SocialFeedViewController else {return}
       // vc.viewModel?.goToShowOtherPost(object: self.vc?.post,currentIndex: self.vc?.currentIndex ?? 0, isMuted: isMuted)
    }
    
    @objc func likeAnimation(_ sender: UITapGestureRecognizer? = nil) {
        doubleTapPagerNode()
    }
    
    func doubleTapPagerNode(isVideo: Bool = false) {
//        HeartAnimation.shared.animate(isVideo ? videoNode.view : imageNode.view, isFeed: true)
//        if !(vc?.isNotLikedByPostTouch ?? false){
//            vc?.likeDislikePost(postID: vc?.post?.postID ?? "")
//        }
    }
    
    override func layout() {
        imageNode.isUserInteractionEnabled = false
        
        let singlePagerTap = UITapGestureRecognizer(target: self, action:#selector(self.goToViewOtherPost))
        singlePagerTap.numberOfTapsRequired = 1
        imageNode.view.addGestureRecognizer(singlePagerTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action:#selector(self.likeAnimation))
        doubleTap.numberOfTapsRequired = 2
        imageNode.view.addGestureRecognizer(doubleTap)
        
        singlePagerTap.require(toFail: doubleTap)
    }
}
//extension FeedNode : ASPagerDelegate, ASPagerDataSource {
//
//
//    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
//        return self.postData?.postsFiles?.count ?? 0
//    }
//    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
//        let cellNodeBlockFianl = {() -> ASCellNode in
//
//            let item = self.postData?.postsFiles?[index]
//
//
//            let contentType = item?.url?.isImage()
//            if let imageFileUrl = item?.thumb_image {
//                let cellFinal = PagerPostNode(with: .Image, file: imageFileUrl, vc: self, thumb: nil)
//                cellFinal.backgroundColor = .white
//                return cellFinal
//            }else{
//                let cellFinal = ASCellNode()
//                cellFinal.backgroundColor = .white
//                return cellFinal
//            }
//
//        }
//        return cellNodeBlockFianl
//    }
//    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
//        guard collectionNode.visibleNodes.count > 0 else {return}
//        if node.indexPath?.item == 0{
////            if currentIndex == -1{
////                self.currentIndex = 0
////                if let _node = node as? PagerPostNode, _node.contentType == .Video {
////                    VideoPlayerManager.shared.playPagerVideo(in: _node)
////                }
////            }
//        }
//    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            // scrollFunction(scrollView)
//        }
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        // scrollFunction(scrollView)
//    }
//
////    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        let index = Int((pagerNode.contentOffset.x / pagerNode.frame.width)
////            .rounded(.toNearestOrAwayFromZero))
////        self.currentIndex = index
////        let attributesIndex = [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor.white]
////        pageIndicator.textNode.attributedText = NSAttributedString(string: "\(index + 1)/\(self.post.postContents?.count ?? 0)", attributes: attributesIndex)
////        scrollFunction(scrollView)
////    }
//
////    internal func scrollFunction(_ scrollView: UIScrollView){
////        scrollOperation?.cancel()
////        let operation = DelayedBlockOperation(deadline: .now() + 0.1, queue: .main) {
////            guard let indexPath = self.visibleIndexPath  else {return}
////            guard let node = self.pagerNode.nodeForItem(at: indexPath) as? PagerPostNode else {return}
////
////            node.muteStatus = self.isMuted
////            self.currentIndex = indexPath.item
//////            print("SETCURRENTINDEX \(self.currentIndex)")
////            if node.contentType != .Video{
////                VideoPlayerManager.shared.pause(.hidden)
////                //VideoPlayerManager.shared.playVideo(in: nil)
////                self.muteButton.isHidden = true
////            }else{
////                VideoPlayerManager.shared.playPagerVideo(in: node)
////                self.muteButton.isHidden = false
////
////            }
////        }
////        scrollOperation = operation
////        operation.start()
////    }
//
//    var contentOffset: CGPoint? {
//        get{
//            return pagerNode.contentOffset
//        }
//    }
//
//    private var visibleSize: CGSize? {
//        get {
//            return pagerNode.bounds.size
//        }
//    }
//
//    private var visibleIndexPath: IndexPath? {
//        get {
//            var visibleRect = CGRect()
//            visibleRect.origin = self.contentOffset ?? CGPoint.zero
//            visibleRect.size = self.visibleSize ?? CGSize.zero
//            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//            return pagerNode.indexPathForItem(at: visiblePoint)
//        }
//    }
//
//    internal var visibleNode: PagerPostNode? {
//        get{
//            guard let visibleIndexPath = visibleIndexPath else {
//                return nil
//            }
//            let node = self.pagerNode.nodeForItem(at: visibleIndexPath) as? PagerPostNode
//            //node?.isMuted = self.muteStatus
//            return node
//        }
//    }
//
//    private var currentPlayingCell: PagerPostNode? {
//        get{
//            return self.pagerNode.nodeForItem(at: IndexPath(item: currentIndex, section: 0)) as? PagerPostNode
//        }
//    }
//
//    //
//
//}
extension FeedNode: ASPagerDataSource, ASPagerDelegate {
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return self.postData?.postsFiles?.count ?? 0
    }

    func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
        // Create and return a cell node with the image
//        let imageNode = ASImageNode()
//        imageNode.image = images[index]
        //return imageNode
        let cellFinal = PagerPostNode(with: .Image, file: self.postData?.postsFiles?[index].url ?? "", vc: self, thumb: nil, data: self.postData?.postsFiles?[index])
        //cellFinal.backgroundColor = .white
        return cellFinal
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
        print("Willindex;;;;;; \(node.indexPath?.item ?? 0)")
    }
    func collectionNode(_ collectionView: ASCollectionNode, didEndDisplayingItemWith node: ASCellNode) {
        print("Endindex;;;;;; \(node.indexPath?.item ?? 0)")

    }
    
    
    
//
//    // Disable scrolling if isScrollEnabled is false
//        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//            if !isScrollEnabled {
//                scrollView.setContentOffset(scrollView.contentOffset, animated: false)
//            }
//        }
//
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            if !isScrollEnabled {
//                scrollView.setContentOffset(scrollView.contentOffset, animated: false)
//            }
//        }
}

extension FeedNode : VidelLongPressProtocol{
    func longPressForVideo(){
        self.delegate?.longPressForVideo(postID: self.postData?.postId ?? "")
    }
}

extension FeedNode : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // guard isVisibleCell else {return}
        if (self.lastContentOffset > scrollView.contentOffset.x) {
            var visibleRect = CGRect()
            visibleRect.origin = scrollView.contentOffset
            visibleRect.size = self.pagerNode.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.minX, y: visibleRect.midY)
            guard let indexPath = self.pagerNode.indexPathForItem(at: visiblePoint) else { return }
            
            guard currentPageIndex != indexPath.item else {
                return
            }
            self.currentPageIndex = indexPath.item
            self.pageIndicatorNode.pageControl.set(progress: indexPath.item, animated: true)
        }
        else if (self.lastContentOffset < scrollView.contentOffset.x) {
            var visibleRect = CGRect()
            visibleRect.origin = scrollView.contentOffset
            visibleRect.size = self.pagerNode.bounds.size
            let visiblePoint = CGPoint(x:visibleRect.maxX - 10 , y: visibleRect.midY)
            guard let indexPath = self.pagerNode.indexPathForItem(at: visiblePoint) else { return }
            
            guard currentPageIndex != indexPath.item else {
                return
            }
            self.currentPageIndex = indexPath.item
            self.pageIndicatorNode.pageControl.set(progress: indexPath.item, animated: true)
            
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
}


class PageIndicatorNode : ASDisplayNode{
    
    var pageControl : CHIPageControlAji!
    var count : Int = 0
    init(numberOfPages:Int) { //numberOfPages:Int
        super.init()
        count = numberOfPages
    }
    override func didLoad() {
        super.didLoad()
        pageControl = CHIPageControlAji(frame: self.bounds)
        pageControl.backgroundColor = .clear
        pageControl.numberOfPages = count
        pageControl.tintColor = .white
        pageControl.hidesForSinglePage = true
        //pageControl.elementWidth = 12
        pageControl.radius = 5
        pageControl.padding = 5
        self.layer.addSublayer(pageControl.layer)
    }
    override func layout() {
        super.layout()
        pageControl.frame = self.bounds
    }
}


class GradientBackgroundNode: ASDisplayNode {
    private let gradientLayer = CAGradientLayer()

    override init() {
        super.init()
        // Define your gradient colors here
    }
    
    override func didLoad() {
        super.didLoad()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [0.0, 1.0]

        // Add the gradient layer as a sublayer
        self.layer.addSublayer(self.gradientLayer)
    }

    override func layout() {
        super.layout()

        // Ensure the gradient layer fills the bounds
        gradientLayer.frame = bounds
    }
}
