//
//  PostCommentVC.swift
//  LiveMArket
//
//  Created by Zain on 26/01/2023.
//

import UIKit
import GrowingTextView
import WebRTCiOSSDK
import WebRTC


class PostCommentVC: UIViewController {
    
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.register(UINib(nibName: "LiveStreamPlayerCell", bundle: nil), forCellWithReuseIdentifier: "LiveStreamPlayerCell")
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var liveCountLbl: UILabel!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var noLiveView: UIView!
    @IBOutlet weak var messageLbl: UILabel!

    var lastIndexPath:IndexPath?
    var liveStreamCollection = [LiveStreamList]() {
        didSet {
            if liveStreamCollection.count != 0 {
                addCommentObserver()
                addViewObserver()
                addEndStreamObserver()
            }
        }
    }
    var viewCount = "0"
    var endedStories = [String]()
    var viewCounts:[String:String] = [:]
    var isAdmin : String = "0"
    var hasTopNotch: Bool = Constants.shared.hasTopNotch
    var socket:SocketIOManager?
    var isOnCurrentController = false
    override func viewDidLoad() {
        super.viewDidLoad()
        isOnCurrentController = true
        socket = SocketIOManager.sharedInstance
        self.setData()
        profileImgVw.layer.cornerRadius = profileImgVw.frame.width / 2
        profileImgVw.clipsToBounds = true
        userInfoView.layer.cornerRadius = userInfoView.frame.height / 2
        Utilities.showIndicatorViewGif()
        handleLiveStreamList()
        noLiveView.isHidden = false
        collectionView.isHidden = true
        if isAdmin == "1" {
            messageLbl.text = "No Admin Live!".localiz()
        }else{
            messageLbl.text = "No Live Found!".localiz()
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.multiRoute, mode: .default, options: [ .allowBluetoothA2DP, .allowBluetooth,.defaultToSpeaker])
            try session.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }

        NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: nil) { notification in
            guard let userInfo = notification.userInfo,
                  let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
                return
            }
            switch reason {
                case .newDeviceAvailable, .oldDeviceUnavailable:
                    self.updateAudioRoute()
                    print("Old device unavailable")
                // Handle old device disconnection, switch audio output back to default
                default:
                    break
            }
        }
        self.updateAudioRoute()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("AVAudioSession error: \(error.localizedDescription)")
        }
    }

    func updateAudioRoute() {
        let session = AVAudioSession.sharedInstance()
        let currentRoute = session.currentRoute

        if let bluetoothOutput = currentRoute.outputs.first(where: { $0.portType == .bluetoothA2DP || $0.portType == .bluetoothLE || $0.portType == .bluetoothHFP }) {
                // Bluetooth is connected
            try? session.overrideOutputAudioPort(.none)
            print("Bluetooth device connected: \(bluetoothOutput.portName)")
        } else if let headphoneOutput = currentRoute.outputs.first(where: { $0.portType == .headphones || $0.portType == .headsetMic }) {
                // Headphones/Headset is connected
            try? session.overrideOutputAudioPort(.none)
            print("Headphones or headset connected: \(headphoneOutput.portName)")
        } else {
                // No Bluetooth or Headphones/Headset connected, use speaker
            try? session.overrideOutputAudioPort(.speaker)
            print("No Bluetooth or headphones connected, using speaker")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        addStartStreamObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let session = AVAudioSession.sharedInstance()
        try? session.overrideOutputAudioPort(.none)
        super.viewWillDisappear(animated)
        btnClose(UIButton())
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = keyboardSize.height
            if(hasTopNotch){
                keyboardHeight = keyboardSize.height - 20
            }
            UIView.animate(withDuration: 0.2) {
                if let lastIndexPath = self.lastIndexPath, let cell = self.collectionView.cellForItem(at: lastIndexPath) as? LiveStreamPlayerCell {
                    cell.addCommentView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
                    cell.commentListView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
                }
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            if let lastIndexPath = self.lastIndexPath,let cell = self.collectionView.cellForItem(at: lastIndexPath) as? LiveStreamPlayerCell {
                cell.addCommentView.transform = .identity
                cell.commentListView.transform = .identity
            }
        }
    }
    

    func setData() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
         self.collectionView.addGestureRecognizer(tap)
     }
     @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
         self.view.endEditing(true)
     }
    
    @IBAction func btnClose(_ sender: Any) {
        endPreviousView()
        lastIndexPath = nil
        socket = nil
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? LiveStreamPlayerCell {
                cell.playerNode.view.removeFromSuperview()
                cell.playerNode.delegate = nil
                cell.tableView.delegate = nil
                cell.tableView.dataSource = nil
                cell.commentTxt.delegate = nil
                cell.commentTxt = nil
                cell.scrollTimer?.invalidate()
                cell.scrollTimer = nil
            }
        }
        liveStreamCollection.removeAll()
        collectionView.reloadData()
        isOnCurrentController = false
        NotificationCenter.default.removeObserver(self, name:AVAudioSession.routeChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.removeObserver(self)
        let session = AVAudioSession.sharedInstance()
        try? session.overrideOutputAudioPort(.none)
        self.navigationController?.popViewController(animated: true)
    }
   
    //once
    fileprivate func handleLiveStreamList() {
        let parameter = LiveListRequestModel(userId: SessionManager.getUserData()?.id ?? "", pageOffSet: 0, limitPerPage: 1000,isAdmin: self.isAdmin)

        socket?.getLiveStremList(request: parameter) {[weak self] dataArray in
            guard let self = self,isOnCurrentController else {
                Utilities.hideIndicatorViewGif()
                return
            }
            guard let dict = dataArray[0] as? [String:Any] else {
                Utilities.hideIndicatorViewGif()
                return
            }
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let decoder = JSONDecoder()

                    if let decodedArray:LiveStreamBase = try? decoder.decode(LiveStreamBase.self, from: json) {
                        print("Streams Found",decodedArray.liveStreamCollection)
                        if decodedArray.liveStreamCollection.count == 0 {
                            self.noLiveView.isHidden = false
                            Utilities.hideIndicatorViewGif()
                        } else {
                            self.liveStreamCollection = decodedArray.liveStreamCollection
                            self.collectionView.reloadData()
                            self.collectionView.isHidden = false
                            self.noLiveView.isHidden = true
                                //                        self?.collectionView.isPagingEnabled = true
                            self.updateAudioRoute()
                        }
                    }

                } catch {
                    print(error.localizedDescription)
                        // completion?(false)
                }
            }
        }
    }
        //once
    func updateViewCount(storyId:String) {
        let parameter = CreateLiveViewCountModel(storyId: storyId, userId: SessionManager.getUserData()?.id ?? "")

        socket?.UpdateLiveViewCount(request: parameter) {[weak self] response in
            guard let self = self,isOnCurrentController else {return}
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    if let decodedResponse:SocketGeneralResponse = try? decoder.decode(SocketGeneralResponse.self, from: json) {
                        if decodedResponse.status == 1 {
                            print("Success")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
//once
    func getStoryViews(storyId:String) {
        let parameter = GetLiveViewCountModel(storyId: storyId,limitPerPage: 1000,offset: 0)
        socket?.GetAllLiveViewCount(request: parameter) {[weak self] response in
            guard let self = self,isOnCurrentController else {return}
            DispatchQueue.main.async {
                guard let dict = response[0] as? [String:Any] else {return}
                do {
                    let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    if let decodedResponse:LiveStreamViewsBase = try? decoder.decode(LiveStreamViewsBase.self, from: json) {
                        if decodedResponse.status == 1 {
                            self.viewCount = decodedResponse.viewerCount
                            self.viewCounts[storyId] = decodedResponse.viewerCount
                            self.liveCountLbl.text = self.viewCount
                        }
                    }else{
                            //completion?(false)
                    }
                } catch {
                    print(error.localizedDescription)
                        // completion?(false)
                }
            }
        }
    }
    //once
    func addComment(storyId:String,comment:String,indexPath:IndexPath) {
        let parameter = CreateStoryCommentModel(storyId: storyId, userId: SessionManager.getUserData()?.id ?? "", comment: comment)
        socket?.CreateLiveComments(request: parameter) {[weak self] response in
            guard let self = self,isOnCurrentController else {return}
            self.getComments(storyId: storyId)
        }
    }
    //once
    func getComments(storyId:String) {
        let parameter = GetStoryCommentModel(storyId: storyId, limitPerPage: 100000,offset: 0)
        socket?.GetAllLiveComments(request: parameter) {[storyId, weak self] response in
            guard let self = self,isOnCurrentController else {return}
            guard let dict = response[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                if let decodedResponse:LiveStreamCommentsBase = try? decoder.decode(LiveStreamCommentsBase.self, from: json) {
                    if decodedResponse.status == 1 {
                        print("Success")
                        DispatchQueue.main.async {[storyId, weak self] in
                            guard let self = self else {return}
                            if let index = self.liveStreamCollection.firstIndex(where: {$0.storyID == storyId }) {
                                if let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? LiveStreamPlayerCell {
                                    cell.commentListView.isHidden = false
                                    cell.tableView.isHidden = false
                                    cell.commentList = decodedResponse.commentCollection.sorted(by: {$0.commentAt.toDate ?? Date() > $1.commentAt.toDate ?? Date()})
                                }
                            }
                        }
                    }
                }else{
                        //completion?(false)
                }
            } catch {
                print(error.localizedDescription)
                    // completion?(false)
            }
        }
    }
    //multiple
    func addCommentObserver() {
        socket?.GetLiveComment {[weak self] response in
            guard let self = self,isOnCurrentController else {return}
            DispatchQueue.main.async {
                guard let dict = response[0] as? [String:Any] else {return}
                do {
                    let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    if let decodedResponse:LiveComment = try? decoder.decode(LiveComment.self, from: json) {
                        self.getComments(storyId: decodedResponse.storyId)
                    }
                } catch {
                    print(error.localizedDescription)
                        // completion?(false)
                }
            }
        }
    }
        //multiple
    func addViewObserver() {
        socket?.GetLiveViewCount {[weak self] response in
            guard let self = self,isOnCurrentController else {return}
            DispatchQueue.main.async {
                if !self.liveStreamCollection.isEmpty {
                    if let lastIndexPath = self.lastIndexPath,lastIndexPath.row<self.liveStreamCollection.count {
                        let data = self.liveStreamCollection[lastIndexPath.row]
                        self.getStoryViews(storyId: data.storyID)
                    }

                }
            }
        }
    }
        //once
    func endPreviousView() {
        if let lastIndexPath = self.lastIndexPath, liveStreamCollection.count > lastIndexPath.item {
            let data = self.liveStreamCollection[lastIndexPath.item]
            let parameter = EndLiveViewModel(storyId: data.storyID, userId: SessionManager.getUserData()?.id ?? "")
            socket?.EndLiveView(request: parameter) { response in
            }
        }
    }
        //multiple
    func addEndStreamObserver() {
        socket?.ObserveEndStream { [weak self ] response in
            guard let self = self,isOnCurrentController else {return}

            guard let dict = response[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                if let decodedResponse:EndStream = try? decoder.decode(EndStream.self, from: json) {
                    DispatchQueue.main.async {
                        self.checkStoryEndStatus(storyId: decodedResponse.storyId)
                    }
                }
            } catch {
                print(error.localizedDescription)
                    // completion?(false)
            }
        }
    }
    func checkStoryEndStatus(storyId:Int) {
        if let findIndex = liveStreamCollection.firstIndex(where: {$0.storyID == "\(storyId)"}) {
//           var moveToIndexPath = findIndex + 1
//            let newCount = liveStreamCollection.count-1
//            if newCount > 0 {
//                moveToIndexPath = moveToIndexPath % newCount
//            }

            self.liveStreamCollection.remove(at: findIndex)
           
            self.collectionView.reloadData()
//
            if liveStreamCollection.isEmpty {
                self.noLiveView.isHidden = false
                self.collectionView.isHidden = true
            }
//            self.handleLiveStreamList()
        }
    }
    func addStartStreamObserver() {
       let objse = socket?.ObserveStartStream {[weak self] dataArray in
            guard let self = self,isOnCurrentController else { return }
            DispatchQueue.main.async { [dataArray, weak self]  in
                guard let self = self else {return}
                guard let dict = dataArray[0] as? [String:Any] else {return}
                do {
                    let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    if let decodedArray:LiveStreamObserverBase = try? decoder.decode(LiveStreamObserverBase.self, from: json) {
                        self.liveStreamCollection.append(decodedArray.data)
                        print("New Streams Found",decodedArray.data)
                        if self.liveStreamCollection.count == 1 {
                            Utilities.showIndicatorViewGif()
                        }
                        self.noLiveView.isHidden = true
                        self.collectionView.isHidden = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {[weak self] in
                                self?.collectionView.reloadData()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension PostCommentVC: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveStreamCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveStreamPlayerCell", for: indexPath) as? LiveStreamPlayerCell else { return UICollectionViewCell() }
        print(#function,indexPath)
        let data = liveStreamCollection[indexPath.row]
        cell.indexPath = indexPath
        cell.parent = self
        cell.thumbnailImgVw.sd_setImage(with: URL(string: data.storyThumb))
        cell.delegate = self
        cell.placeHoldURL  = data.storyThumb ?? ""
        cell.channelID = data.channelID
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let data = liveStreamCollection[indexPath.row]
        print(#function,indexPath)
        guard let cell = cell as? LiveStreamPlayerCell else {return}
        if let lastIndexPath = lastIndexPath, let oldCell =  collectionView.cellForItem(at: lastIndexPath) as? LiveStreamPlayerCell {
            oldCell.playerNode.pause()
            oldCell.playerNode.player?.volume = 0
            oldCell.playerNode.player?.pause()
        }
        lastIndexPath = indexPath
        cell.playerNode.play()
        cell.playerNode.player?.volume = 1
        cell.playerNode.player?.play()
        self.profileImgVw.sd_setImage(with: URL(string: data.postedUserImageurl))
        self.profileNameLbl.text = data.postedUserName
        self.liveCountLbl.text = viewCounts[data.storyID] ?? "0"
        self.updateViewCount(storyId: data.storyID)
        self.getStoryViews(storyId:data.storyID)
        self.getComments(storyId: data.storyID)
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenheight = UIScreen.main.bounds.size.height
        return CGSize(width: screenWidth, height: screenheight)
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
}

extension PostCommentVC: LiveStreamPlayerCellDelegate {
    func postCommentWith(_ comment: String, cell: LiveStreamPlayerCell, indexPath: IndexPath) {
        let item = self.liveStreamCollection[indexPath.item]
        self.addComment(storyId: item.storyID, comment: comment,indexPath: indexPath)
    }
}
