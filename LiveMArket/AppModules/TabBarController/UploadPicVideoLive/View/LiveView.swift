//
//  LiveView.swift
//  LiveMArket
//
//  Created by Rupesh E on 19/10/23.
//

import CoreLocation
import UIKit
import Async
import GrowingTextView

import HaishinKit
import Photos
import VideoToolbox
import WebRTCiOSSDK
import FittedSheets
import AVKit

class LiveView: UIView {
    
        var currentController  = UIViewController()
    
        @IBOutlet weak var parentView: UIView!
        @IBOutlet weak var commentListView: UIView!
        @IBOutlet private weak var lfView: MTHKView!
    
        @IBOutlet weak var cameraView: UIView!
    
        @IBOutlet var startLiveBtn: UIButton!
    
        @IBOutlet weak var videoOffView: UIView!
        @IBOutlet weak var videOnOffBtn: UIButton!
        @IBOutlet weak var flashBtn: UIButton!
        @IBOutlet weak var muteButton: UIButton!
        @IBOutlet weak var liveLbl: UILabel!
        @IBOutlet weak var timerLbl: UILabel!
    
        @IBOutlet weak var beautyBtn: UIButton!
        @IBOutlet weak var viewCountLbl: UILabel!
    
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var commentView: UIView!
        @IBOutlet weak var sendBtn: UIButton!
        @IBOutlet weak var commentTxt: GrowingTextView!
        @IBOutlet weak var commentViewBottom: NSLayoutConstraint!
    
        let cameraManager = CameraManager()
        private var timer: Timer?
    deinit{
        timer?.invalidate()
    }
        private var timerLabel: UILabel!
        var isLiveStart:Bool? = false
        private var screenRecorder = Recorder()
        var countDown:Double? = 5.0
    
        var channelID = ""
        var isFlashOn = false
        var isVideoOff = false
        var currentStoryId:String?
        var commentList:[LiveStreamComments]? {
            didSet {
                tableView.reloadData()
                if commentList?.count != 0 {
                    //scrollToBottom()
                }
            }
        }
        var viewCount = "0" {
            didSet {
                viewCountLbl.text = viewCount
            }
        }
        var originalSize: CGSize?
    
        private var pipIntentView = UIView()
        private var rtmpConnection = RTMPConnection()
        private var rtmpStream: RTMPStream!
        private var sharedObject: RTMPSharedObject!
        private var currentEffect: VideoEffect?
        private var currentPosition: AVCaptureDevice.Position = .back
        private var retryCount: Int = 0
        private var videoBitRate = VideoCodecSettings.default.bitRate
        private static let maxRetryCount: Int = 5
    
    
        var isBackCamera = true
    
        public var isMuted: Bool {
            get {
                !self.rtmpStream.hasAudio
            }
            set(newValue) {
                self.rtmpStream.hasAudio = !newValue
            }
        }
    
        public var hasVideo: Bool {
            get {
                !self.rtmpStream.hasVideo
            }
            set(newValue) {
                self.rtmpStream.hasVideo = !newValue
            }
        }
    
        var hasTopNotch: Bool =  Constants.shared.hasTopNotch

        let webRTCClient: AntMediaClient = AntMediaClient.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
      }
      
      //initWithCode to init view from xib or storyboard
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
          webRtcSessionSetup()
        
      }
    override  func awakeFromNib() {
        super.awakeFromNib()
        webRtcSessionSetup()
    }
      
      //common func to init our view
      private func setupView() {
        backgroundColor = .red
      }
    
        func webRtcSessionSetup(){
    
            webRTCClient.delegate = self
            webRTCClient.setOptions(url: "wss://livesoouq.com:5443/WebRTCAppEE/websocket", streamId: self.channelID, mode: .publish, enableDataChannel: false)
            webRTCClient.setLocalView(container: self.cameraView , mode: .scaleAspectFill);
            webRTCClient.setWebSocketServerUrl(url: "wss://livesoouq.com:5443/WebRTCAppEE/websocket");
            webRTCClient.setCameraPosition(position: .back)
            //webRTCClient.addLocalStream(streamId: self.channelID)
            //webRTCClient.start()
            webRTCClient.setMaxVideoBps(videoBitratePerSecond: 3000000)
            webRTCClient.setTargetResolution(width: 1280, height: 720)
            webRTCClient.setTargetFps(fps: 30)
            self.webRTCClient.initPeerConnection(streamId: self.channelID);
    
        }
    
}
    
//    var currentController  = UIViewController()
//
//    @IBOutlet weak var parentView: UIView!
//    @IBOutlet weak var commentListView: UIView!
//    @IBOutlet private weak var lfView: MTHKView!
//
//    @IBOutlet weak var cameraView: UIView!
//
//    @IBOutlet var startLiveBtn: UIButton!
//
//    @IBOutlet weak var videoOffView: UIView!
//    @IBOutlet weak var videOnOffBtn: UIButton!
//    @IBOutlet weak var flashBtn: UIButton!
//    @IBOutlet weak var muteButton: UIButton!
//    @IBOutlet weak var liveLbl: UILabel!
//    @IBOutlet weak var timerLbl: UILabel!
//
//    @IBOutlet weak var beautyBtn: UIButton!
//    @IBOutlet weak var viewCountLbl: UILabel!
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var commentView: UIView!
//    @IBOutlet weak var sendBtn: UIButton!
//    @IBOutlet weak var commentTxt: GrowingTextView!
//    @IBOutlet weak var commentViewBottom: NSLayoutConstraint!
//
//    let cameraManager = CameraManager()
//    private var timer: Timer?
//    private var timerLabel: UILabel!
//    var isLiveStart:Bool? = false
//    private var screenRecorder = Recorder()
//    var countDown:Double? = 5.0
//
//    var channelID = ""
//    var isFlashOn = false
//    var isVideoOff = false
//    var currentStoryId:String?
//    var commentList:[LiveStreamComments]? {
//        didSet {
//            tableView.reloadData()
//            if commentList?.count != 0 {
//                scrollToBottom()
//            }
//        }
//    }
//    var viewCount = "0" {
//        didSet {
//            viewCountLbl.text = viewCount
//        }
//    }
//    var originalSize: CGSize?
//
//    private var pipIntentView = UIView()
//    private var rtmpConnection = RTMPConnection()
//    private var rtmpStream: RTMPStream!
//    private var sharedObject: RTMPSharedObject!
//    private var currentEffect: VideoEffect?
//    private var currentPosition: AVCaptureDevice.Position = .back
//    private var retryCount: Int = 0
//    private var videoBitRate = VideoCodecSettings.default.bitRate
//    private static let maxRetryCount: Int = 5
//
//
//    var isBackCamera = true
//
//    public var isMuted: Bool {
//        get {
//            !self.rtmpStream.hasAudio
//        }
//        set(newValue) {
//            self.rtmpStream.hasAudio = !newValue
//        }
//    }
//
//    public var hasVideo: Bool {
//        get {
//            !self.rtmpStream.hasVideo
//        }
//        set(newValue) {
//            self.rtmpStream.hasVideo = !newValue
//        }
//    }
//
//    var hasTopNotch: Bool {
//        if #available(iOS 11.0, tvOS 11.0, *) {
//            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
//        }
//        return false
//    }
//
//    let webRTCClient: AntMediaClient = AntMediaClient.init()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        //commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        //commonInit()
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//        videOnOffBtn.setBackgroundImage(UIImage(named: "video-on"), for: .normal)
//        flashBtn.setBackgroundImage(UIImage(named: "flash-off"), for: .normal)
//
//        let session = AVAudioSession.sharedInstance()
//        do {
//            // https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
//            if #available(iOS 10.0, *) {
//                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
//            } else {
//                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with: [
//                    AVAudioSession.CategoryOptions.allowBluetooth,
//                    AVAudioSession.CategoryOptions.defaultToSpeaker
//                ])
//                try session.setMode(.default)
//            }
//            try session.setActive(true)
//        } catch {
//            print(error)
//        }
//
//
//        setData()
//        handleLiveRecord()
//        //        setupCameraManager()
//        webRtcSessionSetup()
//
//    }
//
//
//
//    var liveData:LiveData?{
//        didSet{
//            if let data = liveData{
//                if let urlSting = data.live_url, let url = URL(string: urlSting){
//                    Coordinator.goToLivePreviewVideo(controller: currentController, video_URL: url , channelID: self.channelID)
//                }
//            }
//        }
//    }
//
//    func webRtcSessionSetup(){
//
//        webRTCClient.delegate = self
//        webRTCClient.setOptions(url: "wss://livesoouq.com:5443/WebRTCAppEE/websocket", streamId: self.channelID, mode: .publish, enableDataChannel: false)
//        webRTCClient.setLocalView(container: self.cameraView , mode: .scaleAspectFill);
//        webRTCClient.setWebSocketServerUrl(url: "wss://livesoouq.com:5443/WebRTCAppEE/websocket");
//        webRTCClient.setCameraPosition(position: .back)
//        //webRTCClient.addLocalStream(streamId: self.channelID)
//        //webRTCClient.start()
//        webRTCClient.setMaxVideoBps(videoBitratePerSecond: 3000000)
//        webRTCClient.setTargetResolution(width: 1280, height: 720)
//        webRTCClient.setTargetFps(fps: 30)
//        self.webRTCClient.initPeerConnection(streamId: self.channelID);
//
//    }
//
//
//    func setData() {
//        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
//        tableView.dataSource = self
//        tableView.delegate = self
//        self.tableView.reloadData()
//        commentTxt.placeholder = "Comment..."
//        commentTxt.maxHeight = 100
//        commentTxt.delegate = self
//        commentTxt.enablesReturnKeyAutomatically = true;
//        sendBtn.isEnabled = false
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
//        // tap.delegate = self
//        tap.cancelsTouchesInView = false
//        //self.cameraView.addGestureRecognizer(tap)
//        self.tableView.addGestureRecognizer(tap)
//
//        let gradient = CAGradientLayer()
//
//        gradient.frame = tableView.superview?.bounds ?? .null
//        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
//        gradient.locations = [0.0, 0.15, 0.25]
//        tableView.superview?.layer.mask = gradient
//
//
//
//        sendBtn.setImage(UIImage(named: "noun-send-887299"), for: .normal)
//        sendBtn.setImageColor(color: UIColor(hex: "dd6515"), forState: .normal)
//
//    }
//
//    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
//        self.endEditing(true)
//    }
//    func scrollToBottom()  {
//        //let index = IndexPath(row: 3, section: 0)
//        let row = (self.commentList?.count ?? 0) - 1
//        let indexPath = IndexPath(row: row , section: 0)
//        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//    }
//    func handleLiveRecord() {
//        //        Async.main({
//        //            self.screenRecorder.view = self.cameraView
//        //        })
//        //        session?.muted = false
//        //setupAudioAndVideoPermissions()
//        self.channelID = "\(Date().currentTimeMillis())"
//    }
//
//    private func setupAudioAndVideoPermissions(){
//        //        Async.main({ [weak self] in
//        //            self?.session?.preView = self?.cameraView
//        //        })
//        self.requestAccessForAudio()
//        self.requestAccessForVideo()
//        CountdownView.shared.dismissStyle = .none
//    }
//
//    func requestAccessForAudio() -> Void {
//        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
//        switch status  {
//        case AVAuthorizationStatus.notDetermined:
//            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
//                //self.session?.running = true
//            })
//            break;
//        case AVAuthorizationStatus.authorized:
//            break;
//        case AVAuthorizationStatus.denied: break
//        case AVAuthorizationStatus.restricted:break;
//        default:
//            break;
//        }
//    }
//
//    func requestAccessForVideo() -> Void {
//        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
//        switch status  {
//        case AVAuthorizationStatus.notDetermined:
//            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
//                if(granted){
//                    DispatchQueue.main.async {
//                        // self.session?.running = true
//                    }
//                }
//            })
//            break;
//        case AVAuthorizationStatus.authorized:
//            //session?.running = true;
//            break;
//        case AVAuthorizationStatus.denied: break
//        case AVAuthorizationStatus.restricted:break;
//        default:
//            break;
//        }
//    }
//
//
//    private lazy var stopwatch = Stopwatch(timeUpdated: { [weak self] timeInterval in
//        guard let strongSelf = self else { return }
//        if timeInterval == 1200.0{
//            strongSelf.stopLive()
//        }
//        strongSelf.timerLbl.text = strongSelf.timeString(from: timeInterval)
//    })
//
//    private func timeString(from timeInterval: TimeInterval) -> String {
//        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
//        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
//        let hours = Int(timeInterval / 3600)
//        return String(format: "%.2d:%.2d", minutes, seconds)
//    }
//
//
//    //    @objc func keyboardWillShow(_ notification: NSNotification) {
//    //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//    //            if self.originalSize == nil {
//    //                let originalSize = self.view.frame.size
//    //                self.originalSize = originalSize
//    //                var keyboardsHeight = keyboardSize.height
//    //                if keyboardsHeight < 300 {
//    //                    keyboardsHeight += 40
//    //                } else {
//    //                    keyboardsHeight -= 40
//    //                }
//    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//    //                    self.commentViewBottom.constant = keyboardsHeight
//    //                }
//    //            }
//    //        }
//    //    }
//
//
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            var keyboardHeight = keyboardSize.height
//            if(hasTopNotch){
//                keyboardHeight = keyboardSize.height - 30
//            }
//
//            UIView.animate(withDuration: 0.3) {
//                self.commentView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
//                self.commentListView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//        UIView.animate(withDuration: 0.3) {
//            self.commentView.transform = .identity
//            self.commentListView.transform = .identity
//        }
//    }
//
//    //    @objc func keyboardWillUpdate(_ notification: NSNotification) {
//    //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//    //            if self.originalSize == nil {
//    //                let originalSize = self.view.frame.size
//    //                self.originalSize = originalSize
//    //                var keyboardsHeight = keyboardSize.height
//    //                if keyboardsHeight < 300 {
//    //                    keyboardsHeight += 40
//    //                } else {
//    //                    keyboardsHeight -= 40
//    //                }
//    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//    //                    self.commentViewBottom.constant = keyboardsHeight
//    //                }
//    //            } else {
//    //                let originalSize = self.view.frame.size
//    //                self.originalSize = originalSize
//    //                var keyboardsHeight = keyboardSize.height
//    //                if keyboardsHeight < 300 {
//    //                    keyboardsHeight += 40
//    //                } else {
//    //                    keyboardsHeight -= 40
//    //                }
//    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//    //                    self.commentViewBottom.constant = keyboardsHeight
//    //                }
//    //            }
//    //        }
//    //    }
//    //    @objc func keyboardWillHide(_ notification: NSNotification) {
//    //        originalSize = nil
//    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//    //            self.commentViewBottom.constant = 0
//    //        }
//    //    }
//    // MARK: - ViewController
//    fileprivate func setupCameraManager() {
//        cameraManager.shouldEnableExposure = true
//        //cameraManager.cameraOutputQuality = .hd1280x720
//        cameraManager.writeFilesToPhoneLibrary = false
//        cameraManager.shouldFlipFrontCameraImage = false
//        cameraManager.showAccessPermissionPopupAutomatically = false
//        cameraManager.cameraDevice = .back
//    }
//
//
//
//
//    private func startLive(channelID:String){
//        self.startLiveBtn.isHidden = true
//        self.liveLbl.isHidden = true
//        CountdownView.show(countdownFrom: self.countDown ?? 0.0, spin: true, animation: .zoomIn, autoHide: true) { [self] in
//
//            //                let stream = LFLiveStreamInfo()
//            //                stream.url = "\(Config.LliveRTMPUrl)\(channelID)"
//            //                self.session?.startLive(stream)
//            //                self.session?.captureDevicePosition = .front
//            //self.screenRecorder.start()
//            UIApplication.shared.isIdleTimerDisabled = true
//            self.isLiveStart = true
//            self.stopwatch.toggle()
//            DispatchQueue.main.async {
//                self.startLiveApi()
//            }
//            self.webRTCClient.publish(streamId: channelID)
//
//            //            rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
//            //            rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
//            //            rtmpConnection.connect(Config.LliveRTMPUrl)
//        }
//    }
//
//    func stopLive(){
//        UIApplication.shared.isIdleTimerDisabled = false
//        //        rtmpConnection.close()
//        //        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
//        //        rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
//
//        self.webRTCClient.stop()
//        self.startLiveBtn.isHidden = true
//        self.isLiveStart = false
//        // self.session?.stopLive()
//        self.stopwatch.stop()
//        self.screenRecorder.stop { saveURL in
//        }
//        self.timer?.invalidate()
//        NotificationCenter.default.removeObserver(self)
//        stopLiveApi()
//    }
//    @objc func updateLiveStatus() {
//        markLiveStart(storyId: currentStoryId ?? "")
//    }
//    func startLiveApi() {
//        let parameters:[String:String] = [
//            "access_token": SessionManager.getUserData()?.accessToken ?? "",
//            "channel_id": channelID,
//            "broadcast_key": SessionManager.getUserData()?.firebase_user_key ?? "",
//        ]
//        LivePostAPIManager.liveStartAPI(image: self.cameraView.takeScreenshot() ?? UIImage(), parameters: parameters) { response in
//            switch response.status {
//            case "1" :
//                self.currentStoryId = response.oData?.story_id
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//                    self.tableView.isHidden = false
//                    self.commentView.isHidden = false
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    self.addCommentObserver()
//                    self.addViewObserver()
//                }
//                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.updateLiveStatus), userInfo: nil, repeats: true)
//                break
//            default :
//                self.tableView.isHidden = true
//                self.commentView.isHidden = true
//                Utilities.showWarningAlert(message: response.message ?? "")
//            }
//        }
//    }
//
//    func stopLiveApi() {
//        let parameters:[String:String] = [
//            "access_token": SessionManager.getUserData()?.accessToken ?? "",
//            "channel_id": channelID,
//        ]
//        LivePostAPIManager.liveStopAPI(parameters: parameters) { response in
//            switch response.status {
//            case "1" :
//                print(response.oData ?? "")
//                self.liveData = response.oData
//            default :
//                break
//            }
//        }
//    }
//    func addCommentObserver() {
//        let socket = SocketIOManager.sharedInstance
//        socket.GetLiveComment { response in
//            guard let dict = response[0] as? [String:Any] else {return}
//            do {
//                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
//                let decoder = JSONDecoder()
//                if let decodedResponse:LiveComment = try? decoder.decode(LiveComment.self, from: json) {
//                    if(decodedResponse.storyId == self.currentStoryId){
//                        self.getComments()
//                    }
//                }
//            } catch {
//                print(error.localizedDescription)
//                // completion?(false)
//            }
//        }
//    }
//    func addViewObserver() {
//        let socket = SocketIOManager.sharedInstance
//        socket.GetLiveViewCount { response in
//            self.getStoryViews()
//        }
//    }
//    func getComments() {
//        let parameter = GetStoryCommentModel(storyId: currentStoryId ?? "", limitPerPage: 100000,offset: 0)
//        let socket = SocketIOManager.sharedInstance
//        socket.GetAllLiveComments(request: parameter) {[weak self] response in
//            guard let _ = self else {return}
//            guard let dict = response[0] as? [String:Any] else {return}
//            do {
//                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
//                let decoder = JSONDecoder()
//                if let decodedResponse:LiveStreamCommentsBase = try? decoder.decode(LiveStreamCommentsBase.self, from: json) {
//                    if decodedResponse.status == 1 {
//                        print("Success")
//                        // print(decodedResponse.commentCount)
//                        self?.commentList = decodedResponse.commentCollection.sorted(by: {$0.commentAt.toDate ?? Date() > $1.commentAt.toDate ?? Date()})
//                    }
//                }else{
//                    //completion?(false)
//                }
//            } catch {
//                print(error.localizedDescription)
//                // completion?(false)
//            }
//        }
//    }
//    func getStoryViews() {
//        let parameter = GetLiveViewCountModel(storyId: currentStoryId ?? "",limitPerPage: 100000,offset: 0)
//        let socket = SocketIOManager.sharedInstance
//        socket.GetAllLiveViewCount(request: parameter) {[weak self] response in
//            guard let _ = self else {return}
//            guard let dict = response[0] as? [String:Any] else {return}
//            do {
//                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
//                let decoder = JSONDecoder()
//                if let decodedResponse:LiveStreamViewsBase = try? decoder.decode(LiveStreamViewsBase.self, from: json) {
//                    if decodedResponse.status == 1 {
//                        print("Success")
//                        print(decodedResponse.viewerCount)
//                        self?.viewCount = decodedResponse.viewerCount
//                    }
//                }else{
//                    //completion?(false)
//                }
//            } catch {
//                print(error.localizedDescription)
//                // completion?(false)
//            }
//        }
//    }
//    func addComment(storyId:String,comment:String) {
//        let parameter = CreateStoryCommentModel(storyId: currentStoryId ?? "", userId: SessionManager.getUserData()?.id ?? "", comment: comment)
//        let socket = SocketIOManager.sharedInstance
//        socket.CreateLiveComments(request: parameter) {[weak self] response in
//            guard let _ = self else {return}
//            self?.sendBtn.isEnabled = false
//            self?.commentTxt.text = ""
//            self?.getComments()
//        }
//    }
//    func markLiveStart(storyId:String) {
//        let parameter = MarkLiveStartModel(storyId: currentStoryId ?? "")
//        let socket = SocketIOManager.sharedInstance
//        socket.MarkLiveStart(request: parameter) {[weak self] response in
//            guard let _ = self else {return}
//        }
//    }
//    @IBAction func sendBtnAction(_ sender: Any) {
//        if commentTxt.text.trimmingCharacters(in: .whitespaces) == "" {
//            return
//        }
//        addComment(storyId: currentStoryId ?? "", comment: commentTxt.text ?? "")
//    }
//    // Function to resize and move the view
//    func resizeAndMoveToCorner() {
//        UIView.animate(withDuration: 0.5) {
//            // Set the new frame for the view (in this case, moving to the top-right corner and resizing)
//            let newFrame = CGRect(x: UIScreen.main.bounds.width - 150, y: 0, width: 150, height: 150)
//            self.frame = newFrame
//        }
//    }
//    @IBAction func mutePressed(_ sender: UIButton) {
//
//        //self.isMuted.toggle()
//        self.webRTCClient.toggleAudio()
//        if sender.isSelected {
//            muteButton.setBackgroundImage(UIImage(named: "Group 235547"), for: .normal)
//            sender.isSelected = false
//        } else {
//            muteButton.setBackgroundImage(UIImage(named: "unmuteSound"), for: .normal)
//            sender.isSelected = true
//        }
////        if (!parentView.isPictureInPictureActive()) {
////            parentView.startPictureInPicture(withRefreshInterval: (0.1 / 60.0))
////        } else {
////            parentView.stopPictureInPicture()
////        }
//
//    }
//
//    func toggleFlash() {
//        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
//        guard device.hasTorch else { return }
//
//        do {
//            try device.lockForConfiguration()
//
//            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
//                device.torchMode = AVCaptureDevice.TorchMode.off
//            } else {
//                do {
//                    try device.setTorchModeOn(level: 1.0)
//                } catch {
//                    print(error)
//                }
//            }
//
//            device.unlockForConfiguration()
//        } catch {
//            print(error)
//        }
//        //self.webRTCClient.setVideoEnable(enable: false)
//    }
//
//
//    @IBAction func flashOnOff(_ sender: Any) {
//        self.toggleFlash()
//        if isFlashOn {
//            isFlashOn = false
//            flashBtn.setBackgroundImage(UIImage(named: "flash-off"), for: .normal)
//        }else {
//            isFlashOn = true
//            flashBtn.setBackgroundImage(UIImage(named: "Group 235548"), for: .normal)
//        }
//    }
//
//    @IBAction func changeCameraDevice() {
//        //        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
//        //        let devicePositon = session?.captureDevicePosition;
//        //        session?.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.back) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back;
//
//        //        let position: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
//        //        rtmpStream.videoCapture(for: 0)?.isVideoMirrored = position == .front
//        //        rtmpStream.attachCamera(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)) { error in
//        //        }
//        //        if #available(iOS 13.0, *) {
//        //            rtmpStream.videoCapture(for: 1)?.isVideoMirrored = currentPosition == .front
//        //            rtmpStream.attachMultiCamera(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentPosition)) { error in
//        //            }
//        //        }
//
//        //        let position: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
//        //        rtmpStream.videoCapture(for: 0)?.isVideoMirrored = position == .front
//        //        rtmpStream.attachCamera(AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)) { error in
//        //        }
//        //        currentPosition = position
//        if isBackCamera {
//            isBackCamera = false
//            UIView.transition(with: cameraView, duration: 0.5, options: .transitionFlipFromRight, animations: {
//                self.cameraView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//            }, completion: nil)
//        } else {
//            isBackCamera = true
//            UIView.transition(with: cameraView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
//                self.cameraView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            }, completion: nil)
//        }
//        self.webRTCClient.switchCamera()
//    }
//
//    @IBAction func videoOnOff(_ sender: Any) {
//
//        //self.hasVideo.toggle()
//        self.webRTCClient.toggleVideo()
//
//        if isVideoOff {
//            isVideoOff = false
//            videoOffView.isHidden = true
//            videOnOffBtn.setBackgroundImage(UIImage(named: "video-on"), for: .normal)
//        }else {
//            isVideoOff = true
//            videoOffView.isHidden = false
//            videOnOffBtn.setBackgroundImage(UIImage(named: "Group -3"), for: .normal)
//        }
//    }
//
//
//    @IBAction func Close() {
//        if isLiveStart ?? false{
//            Utilities.showQuestionAlert(message: "Are you sure you want to end your live stream?") {
//                self.tableView.isHidden = true
//                self.commentView.isHidden = true
//                self.stopLive()
//                //self.navigationController?.popViewController(animated: true)
//            }
//        }else{
//            //self.navigationController?.popViewController(animated: true)
//            self.removeFromSuperview()
//        }
//    }
//
//
//
//    @IBAction func startLive(_ sender: Any) {
//        self.startLive(channelID: channelID)
//    }
//
//    @IBAction func beautyFilter(_ sender: Any) {
//        //        session?.beautyFace = !(session?.beautyFace ?? false);
//        //        beautyBtn.isSelected = !(session?.beautyFace ?? false)
//    }
//
//    @objc
//    private func rtmpStatusHandler(_ notification: Notification) {
//        let e = Event.from(notification)
//        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
//            return
//        }
//
//        let url = Config.LliveRTMPUrl
//        switch code {
//        case RTMPConnection.Code.connectSuccess.rawValue:
//            retryCount = 0
//            rtmpStream.publish(self.channelID)
//            // sharedObject!.connect(rtmpConnection)
//        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
//            guard retryCount <= LiveView.maxRetryCount else {
//                return
//            }
//            Thread.sleep(forTimeInterval: pow(2.0, Double(retryCount)))
//            rtmpConnection.connect(url)
//            retryCount += 1
//        default:
//            break
//        }
//    }
//
//    @objc
//    private func rtmpErrorHandler(_ notification: Notification) {
//        let url = Config.LliveRTMPUrl
//        rtmpConnection.connect(url)
//    }
//
//
//    @objc
//    private func didInterruptionNotification(_ notification: Notification) {
//    }
//
//    @objc
//    private func didRouteChangeNotification(_ notification: Notification) {
//    }
//
//    @objc
//    private func on(_ notification: Notification) {
//        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
//            return
//        }
//        rtmpStream.videoOrientation = orientation
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        if Thread.isMainThread {
//        }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        //            if touch.view == pipIntentView {
//        //                let destLocation = touch.location(in: view)
//        //                let prevLocation = touch.previousLocation(in: view)
//        //                var currentFrame = pipIntentView.frame
//        //                let deltaX = destLocation.x - prevLocation.x
//        //                let deltaY = destLocation.y - prevLocation.y
//        //                currentFrame.origin.x += deltaX
//        //                currentFrame.origin.y += deltaY
//        //                pipIntentView.frame = currentFrame
//        //                rtmpStream.multiCamCaptureSettings = MultiCamCaptureSettings(
//        //                    mode: rtmpStream.multiCamCaptureSettings.mode,
//        //                    cornerRadius: 16.0,
//        //                    regionOfInterest: currentFrame,
//        //                    direction: .east
//        //                )
//        //            }
//    }
//
//}
//
//
//
//extension LiveView: UITableViewDataSource,UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return commentList?.count ?? 0
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.0
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
//        cell.transparent.isHidden = true
//        cell.img.isHidden = true
//        cell.userComment = commentList?[indexPath.row]
//        cell.selectionStyle = .none
//        return cell
//    }
//}
//
//extension LiveView: GrowingTextViewDelegate {
//    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
//        UIView.animate(withDuration: 0.2) {
//            self.layoutIfNeeded()
//        }
//    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
//            return false
//        }
//        if text == "" && (textView.text.count == 1) {
//            sendBtn.isEnabled = false
//            return true
//        }
//        sendBtn.isEnabled = true
//        return true
//    }
//}
//
//
//extension LiveView: RTMPConnectionDelegate {
//    func connection(_ connection: RTMPConnection, publishInsufficientBWOccured stream: RTMPStream) {
//        // Adaptive bitrate streaming exsample. Please feedback me your good algorithm. :D
//        videoBitRate -= 32 * 1000
//        stream.videoSettings.bitRate = max(videoBitRate, 64 * 1000)
//    }
//
//    func connection(_ connection: RTMPConnection, publishSufficientBWOccured stream: RTMPStream) {
//        videoBitRate += 32 * 1000
//        stream.videoSettings.bitRate = min(videoBitRate, VideoCodecSettings.default.bitRate)
//    }
//
//    func connection(_ connection: RTMPConnection, updateStats stream: RTMPStream) {
//    }
//
//    func connection(_ connection: RTMPConnection, didClear stream: RTMPStream) {
//        videoBitRate = VideoCodecSettings.default.bitRate
//    }
//}
//
//
//extension LiveView: IORecorderDelegate {
//    // MARK: IORecorderDelegate
//    func recorder(_ recorder: IORecorder, errorOccured error: IORecorder.Error) {
//    }
//
//    func recorder(_ recorder: IORecorder, finishWriting writer: AVAssetWriter) {
//        PHPhotoLibrary.shared().performChanges({() -> Void in
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: writer.outputURL)
//        }, completionHandler: { _, error -> Void in
//            do {
//                try FileManager.default.removeItem(at: writer.outputURL)
//            } catch {
//                print(error)
//            }
//        })
//    }
//}
//
//
//extension UIButton {
//    func setImageColor(color: UIColor, forState state: UIControl.State = .normal) {
//        if let image = self.image(for: state)?.withRenderingMode(.alwaysTemplate) {
//            self.setImage(image, for: state)
//            self.tintColor = color
//        }
//    }
//}
//
//
//
extension LiveView: AntMediaClientDelegate {

    func clientHasError(_ message: String) {

    }


    func disconnected(streamId: String) {
        print("Disconnected -> \(streamId)")
    }

    func remoteStreamRemoved(streamId: String) {
        print("Remote stream removed -> \(streamId)")

    }

    func localStreamStarted(streamId: String) {
        print("Local stream added")
    }


    func playStarted(streamId: String)
    {
        print("play started");
    }

    func playFinished(streamId: String) {
        print("play finished")
    }

    func publishStarted(streamId: String)
    {

    }

    func publishFinished(streamId: String) {

    }

    func audioSessionDidStartPlayOrRecord(streamId: String) {
        AntMediaClient.speakerOn()
    }

    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {


    }

    func streamInformation(streamInfo: [StreamInformation]) {

    }

    func showToast(controller: UIViewController, message : String, seconds: Double)
    {
        let alert = UIAlertController(title: "Received Message", message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

    func eventHappened(streamId: String, eventType: String) {

    }
}
//
//
//extension LiveView: AVPictureInPictureControllerDelegate{
//
//}
