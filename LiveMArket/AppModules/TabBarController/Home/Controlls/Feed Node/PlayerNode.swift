//
//  PlayerNode.swift
//  LiveMArket
//
//  Created by Greeniitc on 01/06/23.
//


import Foundation
import AsyncDisplayKit
import GSPlayer
import AVFoundation
import UIKit
import SDWebImage
import SwiftUI
import ImageSlideshow
//import ACThumbnailGenerator_Swift

enum PausedReason {
    case hidden,tv,userInteraction
}

protocol VidelLongPressProtocol
{
    func longPressForVideo()
}

protocol VideoPlaterNodeProtocol : AnyObject {
    func videoSingleTap()
    func doubleTapOnNode()
    func videoLongPress()
    func videoStateChanged(status : VideoState)
}
protocol PagerNodeVideoPlaterNodeProtocol : AnyObject {
    func videoSingleTap()
    func doubleTapOnNode()
    func videoLongPress()
    func videoStateChanged(status : VideoState)
}
protocol PlayerNodeProtocol : AnyObject {
    func videoMuted(muted:Bool)
    
}
enum VideoState {
    case readyToPlay(URL)
    case play(URL)
    case pause(URL,PausedReason)
}

class BlurImageNode: ASDisplayNode {
    required override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    override func didLoad() {
        super.didLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
}

class PlayerNode : ASDisplayNode {
    var loadingFinished:((Bool)->())?
    var isFromProfile:Bool = false
    var timeObserver: Any?
    
    private lazy var thumbnailImageNode: ASNetworkImageNode = { () -> ASNetworkImageNode in
        let node = ASNetworkImageNode()
        //node.backgroundColor = UIColor(hexString: "#EEEEEE")
        return node
    }()
    
    public lazy var playerNode = { () -> ASVideoNode in
        let node = ASVideoNode()
        node.shouldAutoplay = false
        node.frame = UIScreen().bounds
        node.player?.currentItem!.preferredForwardBufferDuration = 0
        node.player?.automaticallyWaitsToMinimizeStalling = false
        node.shouldAutorepeat = true
        node.delegate = self
        return node
    }()
    private lazy var playButton = { () -> ASImageNode in
        let node = ASImageNode()
        node.image = UIImage(named: "play")
        node.contentMode = .scaleAspectFit
        node.clipsToBounds = true
        node.style.preferredSize = CGSize(width: 60.0, height: 60.0)
        node.isHidden = true
        return node
    }()
    private lazy var AudioNode = { () -> ASImageNode in
        let node = ASImageNode()
        node.image = UIImage(named: "soundBtn")
        node.contentMode = .scaleAspectFit
        node.clipsToBounds = true
        node.style.preferredSize = CGSize(width: 60.0, height: 60.0)
        node.addTarget(self, action: #selector(soundBtn), forControlEvents: .touchUpInside)
        node.isHidden = false
        return node
    }()
    
    private var imageUrl: URL?
    private var videoUrl: URL?
    
    // UI Components
    lazy private(set) var postProgressSlidser : VideoProgressNode = {
        let node = VideoProgressNode() //
        node.backgroundColor = UIColor.clear
        node.style.preferredSize = CGSize(width: Screen.width, height: 16)
        node.isUserInteractionEnabled = true
        node.isLayerBacked = false
        node.clipsToBounds = false
        return node
    }()
    var updateTime = false
    var sliderLableP: UILabel!
    //    fileprivate var asPlayer: AVPlayer? {
    //        get{
    //            return playerNode.player
    //        }
    //    }
    
    var playRequested: Bool = false
    var isReadyToPlay: Bool = false
    var failedToLoad: Bool = false
    var state: VideoState?
    
    var currentPlayingTime : CMTime?
    var isPaused = true
    var forcedStop = false
    
    var maxDuration : Int = 0
    
    var currentDuration : Int = 0 {
        didSet{
            guard let total = totalDuration else{return}
            //let (_, m, s) = self.secondsToHoursMinutesSeconds(seconds: total - self.currentDuration)
            //            let seconds = String(format: "%02d", s)
            //            let minutes = String(format: "%02d", m)
            //            let attributes = [NSAttributedString.Key.font:UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key : Any]
            // self.timeTextNode.attributedText = NSAttributedString(string: "\(minutes):\(seconds)", attributes: attributes)
        }
    }
    
    fileprivate var totalDuration : Int?
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    weak var delegate : VideoPlaterNodeProtocol?
    weak var playerDelegate : PlayerNodeProtocol?
    var longPressDelegate : VidelLongPressProtocol?
    private var content: PostsFiles?
    private var defaultPath: String?
    private var thumbImage: String?
    weak var pagerDelegate: PagerNodeVideoPlaterNodeProtocol?
    var cachingPlayerItem:CachingPlayerItem?
    private var isMP4Video: Bool{
        get{
            return false //self.videoUrl?.pathExtension.lowercased() == "mp4"
        }
    }
    
    var hasTopNotch: Bool =  Constants.shared.hasTopNotch

    required override init() {
        super.init()
        addSubnode(thumbnailImageNode)
        addSubnode(AudioNode)
        addSubnode(playerNode)
        addSubnode(postProgressSlidser)
        postProgressSlidser.delegate = self
        self.automaticallyManagesSubnodes = true
        NotificationCenter.default.addObserver(self, selector: #selector(onHideNotification(_:)), name: Notification.Name("HideProgressBar"), object: nil)
    }
   
    public var instantLoading: Bool = false
    public func set(content: PostsFiles?, instantLoading:Bool, filePath: String?, thumb: String?,isProfile:Bool) {
        self.content = content
//        self.startDownload(content: content)
        self.defaultPath = filePath
        self.instantLoading = instantLoading
        // Set Thumbnail Image
        self.thumbImage = thumb
        loadContent()
        isFromProfile = isProfile
    }
    func startDownload(content:PostsFiles?) {

        if let content = content {
            let filePath : String? = {
                return content.url
                if content.have_hls_url == "1" {
                    if let hlsCDNString = content.hls_cdn_url, content.hls_cdn_url != ""{
                        if URL(string: hlsCDNString) != nil{
                            return hlsCDNString
                        }
                    }else if let hlsString = content.hls_url, content.hls_url != ""{
                        if URL(string: hlsString) != nil{
                            return hlsString
                        }
                    }
                }
                return content.url
            }()
            var videoUrl: URL? {

                if let videoUrlString = filePath, let videoURL = URL(string:videoUrlString ) {
                    print("77cdnCdn77Url \(videoUrlString)")
                    return videoURL
                } else if let videoUrlString = content.url, let videoURL = URL(string: videoUrlString) {
                    print("77cdnCdn77Url \(videoUrlString)")
                    return videoURL
                } else {
                    return nil
                }
            }
            if let videoUrl = videoUrl {
                let pathExt = videoUrl.pathExtension.lowercased()
                guard  pathExt == "m3u8" || pathExt == "mp4" else {
                    return
                }
                DispatchQueue.main.async {
                    self.cachingPlayerItem = CachingPlayerItem(url: videoUrl)
                    self.playerNode.player?.replaceCurrentItem(with: self.cachingPlayerItem)
                    print("Suleman","Start Downloading At \(videoUrl.absoluteString)")
                    self.cachingPlayerItem!.delegate = self
                    if #available(iOS 15.0, *) {
                        self.cachingPlayerItem!.automaticallyHandlesInterstitialEvents = true
                    }
                    self.cachingPlayerItem!.automaticallyPreservesTimeOffsetFromLive = true
                    self.cachingPlayerItem!.preferredForwardBufferDuration = 3.0
                    self.cachingPlayerItem!.download()
                }
            }
        }
    }
    private var blurEffectView: UIVisualEffectView!
    private var avPlayer: AVPlayer?
    private var _playerLayer: AVPlayerLayer?
    var observer: NSKeyValueObservation?
    var avPayerReadyToPlay = false
    var progressTimer: Timer?
    deinit{
        progressTimer?.invalidate()
    }
    var lastProgres:Float = 0.0
    
    override func didLoad() {
        super.didLoad()
        let singleVideoTap = UITapGestureRecognizer(target: self, action:#selector(self.sigleTapOnVideo))
        singleVideoTap.numberOfTapsRequired = 1
        playerNode.view.addGestureRecognizer(singleVideoTap)
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTapOnVideo(gesture:)))
        playerNode.view.addGestureRecognizer(longTapGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.singleTapGesture(gesture:)))
        singleTapGesture.numberOfTapsRequired = 1
        playerNode.view.addGestureRecognizer(singleTapGesture)
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGesture(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        playerNode.view.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
        // playButton.backgroundColor = .green
        playButton.isHidden = true
        //  playButton.alpha = imagePost ? 0.0 : 1.0
        //
        //
        //
        //
        //        playButton.isHidden = true
        
        
        sliderLableP = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        sliderLableP.backgroundColor = .clear
        //            let trackRect: CGRect  = slider.trackRect(forBounds: slider.bounds)
        //            let thumbRect: CGRect  = slider.thumbRect(forBounds: slider.bounds , trackRect: trackRect, value: slider.value)
        let x = CGFloat(self.view.center.x) //thumbRect.origin.x + slider.frame.origin.x
        let y =  self.view.bounds.maxY - CGFloat(70.0) // postProgressSlidser.frame.origin.y - 30
        sliderLableP.center = CGPoint(x: x, y: y) // CGPoint(x: x, y: y)
        sliderLableP.textAlignment = NSTextAlignment.center
        sliderLableP.textColor = UIColor.white
        sliderLableP.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        self.view.addSubview(sliderLableP)
        self.view.bringSubviewToFront(sliderLableP)
        sliderLableP.isHidden = true
        
        // Add observer for AVPlayerItem DidPlayToEndTime notification
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: self.playerNode.currentItem)
        
        // Add time observer for progress update
        let interval = CMTime(value: 1, timescale: 2) // Update the progress every 0.5 seconds
        timeObserver = self.playerNode.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let player = self?.playerNode.player, let playerItem = player.currentItem else {
                return
            }
            let duration = playerItem.duration.seconds
            let currentTime = time.seconds
            let progress = currentTime / duration
            print("Video Progress: \(progress)")
        }
    }
    
    // Called when the video finishes playing
        @objc func videoDidPlayToEnd(notification: Notification) {
         //   print("Video playback reached the end")
            self.postProgressSlidser.setProgress(progress: 1.0, animated: true)
            // You can perform any actions here when the video finishes playing, such as replaying the video, showing a replay button, etc.
        }
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
    }
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
    }
    
    override func didExitPreloadState() {
        super.didExitPreloadState()
        // playerNode.resetToPlaceholder()
    }
    
    @objc func sigleTapOnVideo() {
        if let _ = self.pagerDelegate {
            pagerDelegate?.videoSingleTap()
            return
        }
        delegate?.videoSingleTap()
    }
    
    @objc func soundBtn() {
        
    }
    
    //MARK:- Notification
    @objc func onHideNotification(_ notification: NSNotification) {
        if notification.userInfo?["type"] as? Bool == true {
            self.postProgressSlidser.isHidden = true
        }else{
            self.postProgressSlidser.isHidden = false
        }
    }
    
    @objc func singleTapGesture(gesture: UIGestureRecognizer){
        
        if playerNode.isPlaying(){
            VideoPlayerManager.shared.pause(.userInteraction)
            self.playButton.isHidden = false
        }else{
            VideoPlayerManager.shared.resume()
            self.playButton.isHidden = true
        }
        
    }
    @objc func doubleTapGesture(gesture: UIGestureRecognizer){
//        if let _ = self.pagerDelegate {
//            pagerDelegate?.doubleTapOnNode()
//            return
//        }
//        self.delegate?.doubleTapOnNode()
        if playerNode.isPlaying(){
            playerNode.player?.pause()
        }else{
            playerNode.player?.play()
        }
    }
    @objc func longTapOnVideo(gesture:UIGestureRecognizer){
        if let _ = self.pagerDelegate {
            pagerDelegate?.videoLongPress()
            return
        }
        self.delegate?.videoLongPress()
        
        if let deleg = self.longPressDelegate{
            deleg.longPressForVideo()
        }
    }
    @objc func didManualTap(gesture : UIGestureRecognizer) {
        
        if forcedStop {
            return
        }
        guard let state = self.state, case .pause(let url, _) = state else {
            self.pauseVideo(.userInteraction)
            return
        }
        self.state = .readyToPlay(url)
        self.playVideo()
    }
    
    private func loadContent(){
        if self == nil,postProgressSlidser == nil,defaultPath == nil, content == nil,thumbnailImageNode == nil,state == nil {
            return
        }
        self.totalDuration = Int(content?.duration ?? "0") ?? 0
        if self.totalDuration == 0 {
            self.postProgressSlidser.isHidden = true
        }

        
        var videoUrl: URL? {

            if let videoUrlString = defaultPath, let videoURL = URL(string:videoUrlString ) {
                print("77cdnCdn77Url \(videoUrlString)")
                return videoURL
            }else if let videoUrlString = content?.url, let videoURL = URL(string: videoUrlString) {
                print("77cdnCdn77Url \(videoUrlString)")
                return videoURL
            } else {
                return nil
            }
        }
        if let videoUrl = videoUrl {
            let pathExt = videoUrl.pathExtension.lowercased()
            
            guard  pathExt == "m3u8" || pathExt == "mp4" else {
                return
            }
            self.videoUrl = videoUrl
            
            
            let asset = AVURLAsset(url: videoUrl)
                self.playerNode.asset = asset
//                self.playerNode.player?.replaceCurrentItem(with: self.cachingPlayerItem)
                //self.playerNode.forceLoadAsset()
            self.playerNode.gravity = self.getVideoRatio()
            
            
        }
        //self.thumbnailImageNode.isHidden = true
        if let thumbStr = content?.thumb_cdn_image, let thumbUrl = URL(string: thumbStr) {
            self.thumbnailImageNode.url = thumbUrl  //R.image.placeholder()
            thumbnailImageNode.contentMode = self.getImageRatio()
        }else if let thumbStr = content?.thumb_image, let thumbUrl = URL(string: thumbStr) {
            self.thumbnailImageNode.url = thumbUrl  //R.image.placeholder()
            thumbnailImageNode.contentMode = self.getImageRatio()
        }
        else{
            print("NOO \(content?.thumb_image ?? "___")")
        }
        
                if let videoUrl = videoUrl {
                    self.state = .readyToPlay(videoUrl)
                }
    }
   
    
    override func layout() {
        super.layout()
        _playerLayer?.frame = UIScreen().bounds
        //playerNode.frame = self.view.bounds
    }
    
    func playVideo() {
        
        guard let _videoUrl = videoUrl else {return}

        if isReadyToPlay{

            self.playerNode.muted = VideoPlayerManager.shared.muted
            self.playerNode.player?.currentItem?.preferredForwardBufferDuration = 0
            self.playerNode.player?.automaticallyWaitsToMinimizeStalling = false
            self.playButton.isHidden = true
            self.state = .play(_videoUrl)
           // print(_videoUrl)
            if(VideoPlayerManager.shared.isVideoPaused){
                self.pauseVideo(.hidden)
            }else{
                self.playerNode.play()
            }
            
        }else{
            self.playRequested = true
            //print("PLAYSTARTED FAILED")
        }
        
    }
    
    func resume(){
        
        if isMP4Video{
            avPlayer?.play()
        }else{
            playerNode.play()
        }
        //playerView.resume()
    }
    
    func pauseVideo(_ reason: PausedReason) {
        guard let state = self.state, case .play(let url) = state else { return }
        if isMP4Video{
            self.avPlayer?.pause()
        }else{
            self.playerNode.pause()
        }
        self.state = .pause(url, reason)
        self.playButton.isHidden = true
    }
    
    func reset() {
        self.playRequested = false
        
        if isMP4Video{
            avPlayer?.seek(to: .zero)
            avPlayer?.pause()
        }else{
            playerNode.player?.seek(to: .zero)
            playerNode.pause()
        }
        
        
    }
    
    private func videoRatioLayout() -> ASLayoutSpec {

        let videoRatioLayout = ASRatioLayoutSpec(ratio: 1.0,
                                                 child: self.playerNode)
        let playButtonCenterLayout = ASCenterLayoutSpec(centeringOptions: .XY,
                                                        sizingOptions: [],
                                                        child: playButton)
        return ASOverlayLayoutSpec(child: videoRatioLayout,
                                   overlay: playButtonCenterLayout)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        //   if isMP4Video{
        thumbnailImageNode.style.preferredSize =  constrainedSize.max
        let videoRatioLayout = ASRatioLayoutSpec(ratio: 1.0,
                                                 child: videoRatioLayout())
        let ovrlySpec = ASOverlayLayoutSpec(child: thumbnailImageNode, overlay: videoRatioLayout)
        //return ovrlySpec
        //        }else{
        //            let videoRatioLayout = ASRatioLayoutSpec(ratio: 1.0,
        //                                                     child: videoRatioLayout())
        //            return videoRatioLayout
        //        }
        var overlyInsetSpec = ASInsetLayoutSpec()
        
        let overlyInsets = UIEdgeInsets(top: .infinity, left: 0.0, bottom: 0.0, right: 0.0)
         overlyInsetSpec = ASInsetLayoutSpec(insets: overlyInsets, child: postProgressSlidser)
//        if Constants.shared.isFromFeed == true{
//            let overlyInsets = UIEdgeInsets(top: .infinity, left: 0.0, bottom: 90.0, right: 0.0)
//             overlyInsetSpec = ASInsetLayoutSpec(insets: overlyInsets, child: postProgressSlidser)
//        }else{
//            let overlyInsets = UIEdgeInsets(top: .infinity, left: 0.0, bottom: 90.0, right: 0.0)
//             overlyInsetSpec = ASInsetLayoutSpec(insets: overlyInsets, child: postProgressSlidser)
//        }
        let contentFinalOverly = ASOverlayLayoutSpec(child:ovrlySpec, overlay:overlyInsetSpec)
        return contentFinalOverly
    }
    
    func getImageRatio() -> UIViewContentMode {
        return .scaleToFill
        let width = Float(self.content?.width
                        ?? "0") ?? 320
        let height = Float(self.content?.height ?? "0") ?? 640
        
        if width == Float(Screen.width)*2 || height == Float(Screen.width*2)
        {
            return .scaleToFill
        }
        return .scaleAspectFit
//        let screenRatio = Float(height/width)
//        let videoRatio = Float(Screen.height/Screen.width)
     
    }
    
    func getVideoRatio() -> String {

        return AVLayerVideoGravity.resize.rawValue
        let width = Float(self.content?.width
                          ?? "0") ?? 320.0
        let height = Float(self.content?.height ?? "0") ?? 640.0
       // let videoRatio = Float(height/width)
        
        if width == Float(Screen.width)*2 || height == Float(Screen.width*2){
            return AVLayerVideoGravity.resize.rawValue
        }
        return AVLayerVideoGravity.resizeAspect.rawValue
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {

        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: frame.width, height: frame.height)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }
    }
    

}

extension PlayerNode: CachingPlayerItemDelegate {

    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        print("Suleman","File is downloaded and ready for storing \(playerItem)")

    }

    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        print("Suleman","\(bytesDownloaded)/\(bytesExpected)")
        self.playerNode.player?.play()
    }

    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        print("Suleman","Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
    }

    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print("Suleman",error)
    }

}
//extension PlayerNode : ACThumbnailGeneratorDelegate{
//    
//    func generator(_ generator: ACThumbnailGenerator, didCapture image: UIImage, at position: Double) {
//       thumbnailImageNode.image = image
//    }
//}
extension PlayerNode : ASVideoNodeDelegate {
    func videoNodeDidRecover(fromStall videoNode: ASVideoNode) {
        if self.playRequested{
            // self.playVideo()
        }
        //        }
    }
    
    
    func videoNode(_ videoNode: ASVideoNode, didFailToLoadValueForKey key: String, asset: AVAsset, error: Error) {
        failedToLoad = true
        print("failedToLoad ")
        if self.instantLoading {
            self.loadingFinished?(false)
        }
    }
    
    func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {
        
        if (toState == .finished){
            self.postProgressSlidser.setProgress(progress: 1.0, animated: true)
        }
        
        // return
        if (toState == .playing){
            //print("PLAYING")
            
        }
        if (toState == .readyToPlay) {
            
            if self.instantLoading {
                self.loadingFinished?(true)
                self.loadingFinished = nil
            }
            // blurEffectView?.isHidden = true
            isReadyToPlay = true
            failedToLoad = false
            
            if self.playRequested{
                self.playVideo()
                self.postProgressSlidser.setProgress(progress: 0.0, animated: false)
            }else{
                 //self.playerNode.playTemp()
                
            }
            
        }
    }
    
    
    func videoNode(_ videoNode: ASVideoNode, didPlayToTimeInterval timeInterval: TimeInterval) {
        
        guard let state = self.state, case .play( _) = state else {
            return
        }
        let cmTime = CMTime(seconds: timeInterval, preferredTimescale: 1000000)
        
        self.currentPlayingTime = cmTime
        
        guard let player = self.playerNode.player, let playerItem = player.currentItem else {
            return
        }
        
        if player.currentItem?.status == .readyToPlay {
            self.postProgressSlidser.isHidden = false
        }
        
        let duration = (playerItem.duration.seconds)
        //postProgressSlidser.slider.maximumValue = 99
       // guard let currentTime =  player.currentItem?.currentTime().seconds else { return  }//cmTime.seconds
        let progress = cmTime.seconds / duration
//        print("Video Progress: \(progress)")
//        print("Video Progress time: \(cmTime.seconds)")
//        print("Video Progress duration: \(duration)")
        self.lastProgres = Float(progress)
        if(!self.updateTime){
            self.postProgressSlidser.setProgress(progress: Float(progress), animated: true)
        }
        //let asset = AVAsset(url: player.currentItem?.asset.duration)
        
        guard let duration1 = player.currentItem?.asset.duration else { return  }//asset.duration
        let durationTime = CMTimeGetSeconds(duration1)
        
       // print(durationTime)
        
    }
    
    func videoDidPlay(toEnd videoNode: ASVideoNode) {
        self.postProgressSlidser.setProgress(progress: 1.0, animated: true)
    }
    
    
    func didTap(_ videoNode: ASVideoNode) {
        
    }
}

extension PlayerNode: PostProgressDelegate {
    func didStartDrag() {
        let x = CGFloat(self.view.center.x) //thumbRect.origin.x + slider.frame.origin.x
        let y =  self.view.bounds.maxY - CGFloat(200.0) // postProgressSlidser.frame.origin.y - 30
        sliderLableP.center = CGPoint(x: x, y: y) // CGPoint(x: x, y: y)
        self.sliderLableP.isHidden = false
        self.updateTime = true
    }
    
    func didEndDrag() {
        self.sliderLableP.isHidden = true
    }
    
    func didUpdateTimeTo(float: Float) {
        guard let tPlayer = self.playerNode.player ,let currentItem = tPlayer.currentItem else { return }
        tPlayer.pause()
        let durationToSeek = Float(CMTimeGetSeconds(currentItem.duration)) * float
        
        let seekTime = CMTimeMakeWithSeconds(Float64(durationToSeek), preferredTimescale: 600)
        
    
        tPlayer.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { [unowned self] (finish) in
            self.updateTime = false
            tPlayer.play()
        })
    }
    
    func didChangeSlider(float: Float){
        if postProgressSlidser.slider != nil {
            guard let tPlayer = self.playerNode.player ,let currentItem = tPlayer.currentItem else { return }
            
            let duration = CMTimeGetSeconds(currentItem.duration)
            
            let durationToSeek = Float(duration) * float

            let hours:Int = Int(durationToSeek / 3600)
            let minutes:Int = Int(durationToSeek.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds:Int = Int(durationToSeek.truncatingRemainder(dividingBy: 60))
            let final = String(format: "%02i:%02i", minutes, seconds)
            self.sliderLableP.text = "\(final)/\(currentItem.duration.durationText)"

        }
    }
}

@objc extension AVPlayerItem {
    
    static var loaderPrefix: String = "__loader__"
    
    
    @objc convenience init(loader url: URL) {
        if url.isFileURL || url.pathExtension == "m3u8" {
            self.init(url: url)
            return
        }
        
        guard let loaderURL = (AVPlayerItem.loaderPrefix + url.absoluteString).url else {
            VideoLoadManager.shared.reportError?(NSError(
                domain: "me.gesen.player.loader",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Wrong url \(url.absoluteString)，unable to initialize Loader"]
            ))
            self.init(url: url)
            return
        }
        
        let urlAsset = AVURLAsset(url: loaderURL)
        urlAsset.resourceLoader.setDelegate(VideoLoadManager.shared, queue: .main)
        print("URLASSE ")
        self.init(asset: urlAsset)
        
        
    }
    
}
extension String {
    
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    var int: Int? {
        return Int(self)
    }
    
    
    var url: URL? {
        return URL(string: self)
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
}
extension AVAsset {
    
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
extension CMTime {
    var durationText:String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}

