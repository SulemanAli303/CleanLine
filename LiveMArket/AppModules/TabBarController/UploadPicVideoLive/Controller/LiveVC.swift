//
//  TakePictureVC.swift
//  LiveMArket
//
//  Created by Zain on 25/01/2023.
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
//import PIPKit
//import UIPiPView

@available(iOS 15.0, *)
class LiveVC: UIViewController,UIScrollViewDelegate,PIPUsable {
    
    @IBOutlet weak var pipCloseButton: UIButton!
    @IBOutlet weak var liveVideoBottamStackView: UIStackView!
    @IBOutlet weak var sideButtonStackView: UIStackView!
    @IBOutlet weak var viewCountStackView: UIStackView!
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
    private var timerLabel: UILabel!
    var isLiveStart:Bool? = false
    private var screenRecorder = Recorder()
    var countDown:Double? = 5.0
    deinit{
        timer?.invalidate()

    }
    var channelID = ""
    var isFlashOn = false
    var isVideoOff = false
    var currentStoryId:String?
    var commentList:[LiveStreamComments]? {
        didSet {
            tableView.reloadData()
            if commentList?.count != 0 {
                scrollToTop()
            }
        }
    }
    var viewCount = "0" {
        didSet {
            viewCountLbl.text = viewCount
        }
    }
    var originalSize: CGSize?
    var isMuteSelected:Bool = true
    
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

    var webRTCClient: AntMediaClient = AntMediaClient.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videOnOffBtn.setBackgroundImage(UIImage(named: "video-on"), for: .normal)
        flashBtn.setBackgroundImage(UIImage(named: "flash-off"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(onShowNotificationPopup(_:)), name: Notification.Name("ShowDialogNotificationToLiveVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLive), name: Notification.Name("user_logout"), object: nil)
        let session = AVAudioSession.sharedInstance()
        do {
            // https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with: [
                    AVAudioSession.CategoryOptions.allowBluetooth,
                    AVAudioSession.CategoryOptions.defaultToSpeaker
                ])
                try session.setMode(.default)
            }
            try session.setActive(true)
        } catch {
            print(error)
        }
        setData()
        handleLiveRecord()
        webRtcSessionSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pipNotificationObserver), name: Notification.Name("PIPDismiss"), object: nil)
        muteButton.setBackgroundImage(UIImage(named: "unmuteSound"), for: .normal)
    }
    
    @objc func pipNotificationObserver()
    {
        DispatchQueue.main.async {
            self.startPIPMode()
        }
        self.hideViews()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if PIPKit.isPIP {
            DispatchQueue.main.async {
                self.stopPIPMode()
            }
            self.showViews()
        } else {
            DispatchQueue.main.async {
                self.startPIPMode()
            }
            self.hideViews()
        }
    }
    
    @objc func onShowNotificationPopup(_ notification: NSNotification) {
        if isLiveStart ?? false == true {
            DispatchQueue.main.async {
                self.startPIPMode()
            }
            self.hideViews()
        }
    }
    
    func didChangedState(_ state: PIPState) {
        switch state {
        case .pip:
            print("PIPViewController.pip")
            
        case .full:
            print("PIPViewController.full")
            
        }
    }
    
    func hideViews(){
        
        pipCloseButton.isHidden           = true
        liveVideoBottamStackView.isHidden = true
        sideButtonStackView.isHidden      = true
        viewCountStackView.isHidden       = true
        commentListView.isHidden          = true
        videoOffView.isHidden             = true
        commentView.isHidden              = true
        startLiveBtn.isHidden             = true
        self.liveLbl.isHidden             = true
        self.timerLbl.isHidden            = true
    }
    
    func showViews(){
        
        pipCloseButton.isHidden           = true
        liveVideoBottamStackView.isHidden = false
        sideButtonStackView.isHidden      = false
        viewCountStackView.isHidden       = false
        commentListView.isHidden          = true
        videoOffView.isHidden             = true
        commentView.isHidden              = true
        startLiveBtn.isHidden             = false
        self.liveLbl.isHidden             = false
        self.timerLbl.isHidden            = false
        
        if isLiveStart ?? false == true{
            commentView.isHidden          = false
            commentListView.isHidden      = false
            startLiveBtn.isHidden         = true
            self.liveLbl.isHidden         = true
        }
    }
        
    var liveData:LiveData?{
        didSet{
            if let data = liveData{
                if let urlSting = data.live_url, let url = URL(string: urlSting){
                    // no need to move now 
                   // Coordinator.goToLivePreviewVideo(controller: self, video_URL: url , channelID: self.channelID)
                }
            }
        }
    }
    
    func webRtcSessionSetup(){

        webRTCClient.delegate = self
        webRTCClient.setOptions(url: "wss://livesoouq.com:5443/WebRTCAppEE/websocket", streamId: self.channelID, mode: .publish, enableDataChannel: false)
        webRTCClient.setLocalView(container: self.cameraView , mode: .scaleAspectFill)
        webRTCClient.setWebSocketServerUrl(url: "wss://livesoouq.com:5443/WebRTCAppEE/websocket");
        webRTCClient.setCameraPosition(position: .back)
        //webRTCClient.addLocalStream(streamId: self.channelID)
        //webRTCClient.start()
        webRTCClient.setMaxVideoBps(videoBitratePerSecond: 3000000)
        webRTCClient.setTargetResolution(width: 1280, height: 720)
        webRTCClient.setTargetFps(fps: 30)
        self.webRTCClient.initPeerConnection(streamId: self.channelID)
    }
    
//    func rtmpSessionSetup(){
//        
//        rtmpConnection.delegate = self
//
//        pipIntentView.layer.borderWidth = 1.0
//        pipIntentView.layer.borderColor = UIColor.white.cgColor
//        pipIntentView.bounds = MultiCamCaptureSettings.default.regionOfInterest
//        pipIntentView.isUserInteractionEnabled = true
//        view.addSubview(pipIntentView)
//
//        rtmpStream = RTMPStream(connection: rtmpConnection)
//        if let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
//            rtmpStream.videoOrientation =  DeviceUtil.videoOrientation(by: orientation)!
//            rtmpStream.videoSettings = VideoCodecSettings(
//                videoSize: .init(width: (orientation.isPortrait) ? 720 : 1280 , height: (orientation.isPortrait) ? 1280 : 720),
//                bitRate: 3000000, profileLevel: kVTProfileLevel_H264_Main_AutoLevel as String,
//                maxKeyFrameIntervalDuration: 0
//            )
//        }
//        
//        rtmpStream.sessionPreset = AVCaptureSession.Preset.hd1280x720
//        rtmpStream.frameRate = 24
//        
//
//        rtmpStream.audioSettings = AudioCodecSettings(
//            bitRate: 128000
//        )
//
//        //lfView.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        rtmpStream.mixer.recorder.delegate = self
//        
//    
//        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
//        
//    }
    
    
    
    func setData() {
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
        commentTxt.placeholder = "Comment...".localiz()
        commentTxt.maxHeight = 100
        commentTxt.delegate = self
        commentTxt.enablesReturnKeyAutomatically = true;
        sendBtn.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
       // tap.delegate = self
        tap.cancelsTouchesInView = false
        //self.cameraView.addGestureRecognizer(tap)
        self.tableView.addGestureRecognizer(tap)
        
        let gradient = CAGradientLayer()

        gradient.frame = tableView.superview?.bounds ?? .null
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.15, 0.25]
        tableView.superview?.layer.mask = gradient
        
        
        
        sendBtn.setImage(UIImage(named: "noun-send-887299"), for: .normal)
        sendBtn.setImageColor(color: UIColor(hex: "dd6515"), forState: .normal)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    func scrollToBottom()  {
        //let index = IndexPath(row: 3, section: 0)
        let row = (self.commentList?.count ?? 0) - 1
        let indexPath = IndexPath(row: row , section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func scrollToTop(){
            let indexPath = IndexPath(row: 0 , section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func handleLiveRecord() {
//        Async.main({
//            self.screenRecorder.view = self.cameraView
//        })
//        session?.muted = false
        //setupAudioAndVideoPermissions()
        self.channelID = "\(Date().currentTimeMillis() + Int64.random(in: 0...1000000))"
    }
    
    private func setupAudioAndVideoPermissions(){
//        Async.main({ [weak self] in
//            self?.session?.preView = self?.cameraView
//        })
        self.requestAccessForAudio()
        self.requestAccessForVideo()
        CountdownView.shared.dismissStyle = .none
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                //self.session?.running = true
            })
            break;
        case AVAuthorizationStatus.authorized:
            break;
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                       // self.session?.running = true
                    }
                } else {

                }
            })
            break;
        case AVAuthorizationStatus.authorized:
            //session?.running = true;
            break;
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
  func  showPermissionAlert() {
      Utilities.showMultipleChoiceAlert(message: "Camera Permissions are required please enable it from setting. do you want to go to settings?", firstHandler:{
          guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
              return
          }
          if UIApplication.shared.canOpenURL(settingsUrl) {
              UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                  print("Settings opened: \(success)") // Prints true
              })
          }
      } ,secondHandler: {

      } )

    }

    private lazy var stopwatch = Stopwatch(timeUpdated: { [weak self] timeInterval in
        guard let strongSelf = self else { return }
//        if timeInterval == 1200.0{
//            strongSelf.stopLive()
//        }
        strongSelf.timerLbl.text = strongSelf.timeString(from: timeInterval)
    })
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        let hours = Int(timeInterval / 3600)
        if hours > 0 {
            return String(format: "%.2d:%.2d:%.2d",hours, minutes, seconds)
        } else {
            return String(format: "%.2d:%.2d", minutes, seconds)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        if isLiveStart ?? false == true{
            DispatchQueue.main.async {
                self.startPIPMode()
            }
            self.hideViews()
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = keyboardSize.height
            if(hasTopNotch){
                keyboardHeight = keyboardSize.height - 30
            }

            UIView.animate(withDuration: 0.3) {
                self.commentView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
                self.commentListView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.commentView.transform = .identity
            self.commentListView.transform = .identity
        }
    }
    
    // MARK: - ViewController
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = true
        //cameraManager.cameraOutputQuality = .hd1280x720
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.shouldKeepViewAtOrientationChanges = true
        cameraManager.showAccessPermissionPopupAutomatically = false
        cameraManager.cameraDevice = .back
    }
    
    
    
    
    private func startLive(channelID:String){
        self.startLiveBtn.isHidden = true
        self.liveLbl.isHidden = true
        CountdownView.show(countdownFrom: self.countDown ?? 0.0, spin: true, animation: .zoomIn, autoHide: true) { [self] in
            
            //                let stream = LFLiveStreamInfo()
            //                stream.url = "\(Config.LliveRTMPUrl)\(channelID)"
            //                self.session?.startLive(stream)
            //                self.session?.captureDevicePosition = .front
            //self.screenRecorder.start()
            UIApplication.shared.isIdleTimerDisabled = true
            self.isLiveStart = true
            self.stopwatch.toggle()
            DispatchQueue.main.async {
                self.startLiveApi()
            }
            self.webRTCClient.publish(streamId: channelID)

        }
    }
    
  @objc func stopLive() {
        UIApplication.shared.isIdleTimerDisabled = false
//        rtmpConnection.close()
//        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
//        rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
      //  Constants.shared.webRTCClient = nil
        self.webRTCClient.stop()
        self.startLiveBtn.isHidden = true
        self.isLiveStart = false
       // self.session?.stopLive()
        self.stopwatch.stop()
        self.screenRecorder.stop { saveURL in
        }
        self.timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
        stopLiveApi()
    }
    @objc func updateLiveStatus() {
      markLiveStart(storyId: currentStoryId ?? "")
    }
    func startLiveApi() {
        let parameters:[String:String] = [
            "access_token": SessionManager.getUserData()?.accessToken ?? "",
            "channel_id": channelID,
            "broadcast_key": SessionManager.getUserData()?.firebase_user_key ?? "",
            ]
        LivePostAPIManager.liveStartAPI(image: self.cameraView.takeScreenshot() ?? UIImage(), parameters: parameters) { response in
            switch response.status {
            case "1" :
                Utilities.hideIndicatorView()
                self.currentStoryId = response.oData?.story_id
                Constants.shared.isAlreadyLive = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    self.tableView.isHidden = false
                    self.commentView.isHidden = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.addCommentObserver()
                    self.addViewObserver()
                }
                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.updateLiveStatus), userInfo: nil, repeats: true)
                break
            default :
                self.tableView.isHidden = true
                self.commentView.isHidden = true
                Utilities.showWarningAlert(message: response.message ?? "")
            }
        }
    }
    
    func stopLiveApi() {
        let parameters:[String:String] = [
            "access_token": SessionManager.getUserData()?.accessToken ?? "",
            "channel_id": channelID,
            ]
        LivePostAPIManager.liveStopAPI(parameters: parameters) { response in
            switch response.status {
                case "1" :
                    print(response.oData ?? "")
                    self.liveData = response.oData
                    Constants.shared.isAlreadyLive = false
                    if let navigation = self.navigationController{
                        navigation.popViewController(animated: true)
                    } else {
                        Coordinator.moveToRooVC()
                        PIPKit.dismiss(animated: true)
                    }
                default :
                    break
            }
        }
    }
    func addCommentObserver() {
        let socket = SocketIOManager.sharedInstance
        socket.GetLiveComment { response in
            guard let dict = response[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                if let decodedResponse:LiveComment = try? decoder.decode(LiveComment.self, from: json) {
                    if(decodedResponse.storyId == self.currentStoryId){
                        self.getComments()
                    }                    
                }
            } catch {
                print(error.localizedDescription)
                // completion?(false)
            }
        }
    }
    func addViewObserver() {
        let socket = SocketIOManager.sharedInstance
        socket.GetLiveViewCount { response in
            self.getStoryViews()
        }
    }
    func getComments() {
        let parameter = GetStoryCommentModel(storyId: currentStoryId ?? "", limitPerPage: 100000,offset: 0)
            let socket = SocketIOManager.sharedInstance
            socket.GetAllLiveComments(request: parameter) {[weak self] response in
                guard let _ = self else {return}
                guard let dict = response[0] as? [String:Any] else {return}
                do {
                    let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    if let decodedResponse:LiveStreamCommentsBase = try? decoder.decode(LiveStreamCommentsBase.self, from: json) {
                        if decodedResponse.status == 1 {
                            print("Success")
                            // print(decodedResponse.commentCount)
                            self?.commentList = decodedResponse.commentCollection.sorted(by: {$0.commentAt.toDate ?? Date() > $1.commentAt.toDate ?? Date()})
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
    func getStoryViews() {
        let parameter = GetLiveViewCountModel(storyId: currentStoryId ?? "",limitPerPage: 100000,offset: 0)
        let socket = SocketIOManager.sharedInstance
        socket.GetAllLiveViewCount(request: parameter) {[weak self] response in
            guard let _ = self else {return}
            guard let dict = response[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                if let decodedResponse:LiveStreamViewsBase = try? decoder.decode(LiveStreamViewsBase.self, from: json) {
                    if decodedResponse.status == 1 {
                        print("Success")
                        print(decodedResponse.viewerCount)
                        self?.viewCount = decodedResponse.viewerCount
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
    func addComment(storyId:String,comment:String) {
        let parameter = CreateStoryCommentModel(storyId: currentStoryId ?? "", userId: SessionManager.getUserData()?.id ?? "", comment: comment)
        let socket = SocketIOManager.sharedInstance
        socket.CreateLiveComments(request: parameter) {[weak self] response in
            guard let _ = self else {return}
            self?.sendBtn.isEnabled = false
            self?.commentTxt.text = ""
            self?.getComments()
        }
    }
    func markLiveStart(storyId:String) {
        let parameter = MarkLiveStartModel(storyId: currentStoryId ?? "")
        let socket = SocketIOManager.sharedInstance
        socket.MarkLiveStart(request: parameter) {[weak self] response in
            guard let _ = self else {return}
        }
    }
    @IBAction func sendBtnAction(_ sender: Any) {
        if commentTxt.text.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        addComment(storyId: currentStoryId ?? "", comment: commentTxt.text ?? "")
    }
    // Function to resize and move the view
       func resizeAndMoveToCorner() {
           UIView.animate(withDuration: 0.5) {
               // Set the new frame for the view (in this case, moving to the top-right corner and resizing)
               let newFrame = CGRect(x: UIScreen.main.bounds.width - 150, y: 0, width: 150, height: 150)
               self.view.frame = newFrame
           }
       }
    @IBAction func minimizePressed(_ sender: UIButton) {
        if PIPKit.isPIP {
            DispatchQueue.main.async {
                self.stopPIPMode()
            }
            self.showViews()
        } else {
            DispatchQueue.main.async {
                self.startPIPMode()
            }
            self.hideViews()
        }
    }
    @IBAction func mutePressed(_ sender: UIButton) {
        
        //self.isMuted.toggle()
        self.webRTCClient.toggleAudio()
        if isMuteSelected {
            muteButton.setBackgroundImage(UIImage(named: "Group 235547"), for: .normal)
            isMuteSelected = false
        } else {
            muteButton.setBackgroundImage(UIImage(named: "unmuteSound"), for: .normal)
            isMuteSelected = true
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: parentView)
        parentView.center = CGPoint(x: parentView.center.x + translation.x, y: parentView.center.y + translation.y)
        gesture.setTranslation(.zero, in: parentView)
    }
    @objc func handleTap(_ gesture: UIPanGestureRecognizer) {
        parentView.removeFromSuperview()
        Coordinator.goToLive(controller: self)
    }
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
        //self.webRTCClient.setVideoEnable(enable: false)
    }

  
    @IBAction func flashOnOff(_ sender: Any) {
        self.toggleFlash()
        if isFlashOn {
            isFlashOn = false
            flashBtn.setBackgroundImage(UIImage(named: "flash-off"), for: .normal)
        }else {
            isFlashOn = true
            flashBtn.setBackgroundImage(UIImage(named: "Group 235548"), for: .normal)
        }
    }
    
    @IBAction func changeCameraDevice() {
        if isBackCamera {
            isBackCamera = false
            UIView.transition(with: cameraView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                self.cameraView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }, completion: nil)
        } else {
            isBackCamera = true
            UIView.transition(with: cameraView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.cameraView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
        self.webRTCClient.switchCamera()
    }
    
    @IBAction func videoOnOff(_ sender: Any) {
        
        //self.hasVideo.toggle()
        self.webRTCClient.toggleVideo()
        
        if isVideoOff {
            isVideoOff = false
            videoOffView.isHidden = true
            videOnOffBtn.setBackgroundImage(UIImage(named: "video-on"), for: .normal)
        }else {
            isVideoOff = true
            videoOffView.isHidden = false
            videOnOffBtn.setBackgroundImage(UIImage(named: "Group -3"), for: .normal)
        }
    }
    
    
    @IBAction func Close() {
        if isLiveStart ?? false{
            Utilities.showQuestionAlert(message: "Are you sure you want to end your live stream?".localiz()) {
                self.tableView.isHidden = true
                self.commentView.isHidden = true
                self.stopLive()
            }
        }else{
            
            if let navigation = self.navigationController{
                navigation.popViewController(animated: true)
            }else{
                Coordinator.moveToRooVC()
                PIPKit.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func dismissPipView(_ sender: UIButton) {
        if isLiveStart ?? false{
            Utilities.showQuestionAlert(message: "Are you sure you want to end your live stream?".localiz()) {
                self.tableView.isHidden = true
                self.commentView.isHidden = true
                self.stopLive()
                PIPKit.dismiss(animated: true)
            }
        }else{
            PIPKit.dismiss(animated: true)
        }
    }
    
    
    @IBAction func startLive(_ sender: Any) {
        self.startLive(channelID: channelID)
    }
    
    @IBAction func beautyFilter(_ sender: Any) {
//        session?.beautyFace = !(session?.beautyFace ?? false);
//        beautyBtn.isSelected = !(session?.beautyFace ?? false)
    }
    
    @objc
    private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        
        let url = Config.LliveRTMPUrl
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            retryCount = 0
            rtmpStream.publish(self.channelID)
        // sharedObject!.connect(rtmpConnection)
        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
            guard retryCount <= LiveVC.maxRetryCount else {
                return
            }
            Thread.sleep(forTimeInterval: pow(2.0, Double(retryCount)))
            rtmpConnection.connect(url)
            retryCount += 1
        default:
            break
        }
    }

    @objc
    private func rtmpErrorHandler(_ notification: Notification) {
        let url = Config.LliveRTMPUrl
        rtmpConnection.connect(url)
    }
    
    
    @objc
    private func didInterruptionNotification(_ notification: Notification) {
    }

    @objc
    private func didRouteChangeNotification(_ notification: Notification) {
    }

    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
//        rtmpStream.videoOrientation = orientation
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if Thread.isMainThread {
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if touch.view == pipIntentView {
            let destLocation = touch.location(in: view)
            let prevLocation = touch.previousLocation(in: view)
            var currentFrame = pipIntentView.frame
            let deltaX = destLocation.x - prevLocation.x
            let deltaY = destLocation.y - prevLocation.y
            currentFrame.origin.x += deltaX
            currentFrame.origin.y += deltaY
            pipIntentView.frame = currentFrame
            rtmpStream.multiCamCaptureSettings = MultiCamCaptureSettings(
                mode: rtmpStream.multiCamCaptureSettings.mode,
                cornerRadius: 16.0,
                regionOfInterest: currentFrame,
                direction: .east
            )
        }
    }
    
}


@available(iOS 15.0, *)
extension LiveVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.transparent.isHidden = true
        cell.img.isHidden = true
        cell.userComment = commentList?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
@available(iOS 15.0, *)
extension LiveVC: GrowingTextViewDelegate {
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

@available(iOS 15.0, *)
extension LiveVC: RTMPConnectionDelegate {
    func connection(_ connection: RTMPConnection, publishInsufficientBWOccured stream: RTMPStream) {
        // Adaptive bitrate streaming exsample. Please feedback me your good algorithm. :D
        videoBitRate -= 32 * 1000
        stream.videoSettings.bitRate = max(videoBitRate, 64 * 1000)
    }

    func connection(_ connection: RTMPConnection, publishSufficientBWOccured stream: RTMPStream) {
        videoBitRate += 32 * 1000
        stream.videoSettings.bitRate = min(videoBitRate, VideoCodecSettings.default.bitRate)
    }

    func connection(_ connection: RTMPConnection, updateStats stream: RTMPStream) {
    }

    func connection(_ connection: RTMPConnection, didClear stream: RTMPStream) {
        videoBitRate = VideoCodecSettings.default.bitRate
    }
}

@available(iOS 15.0, *)
extension LiveVC: IORecorderDelegate {
    // MARK: IORecorderDelegate
    func recorder(_ recorder: IORecorder, errorOccured error: IORecorder.Error) {
    }

    func recorder(_ recorder: IORecorder, finishWriting writer: AVAssetWriter) {
        PHPhotoLibrary.shared().performChanges({() -> Void in
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: writer.outputURL)
        }, completionHandler: { _, error -> Void in
            do {
                try FileManager.default.removeItem(at: writer.outputURL)
            } catch {
                print(error)
            }
        })
    }
}


@available(iOS 15.0, *)
extension LiveVC: AntMediaClientDelegate {
        
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
        let alert = UIAlertController(title: "Received Message".localiz(), message: message, preferredStyle: .alert)
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

@available(iOS 15.0, *)
extension LiveVC: AVPictureInPictureControllerDelegate{
    
}
extension UIButton {
    func setImageColor(color: UIColor, forState state: UIControl.State = .normal) {
        if let image = self.image(for: state)?.withRenderingMode(.alwaysTemplate) {
            self.setImage(image, for: state)
            self.tintColor = color
        }
    }
}
