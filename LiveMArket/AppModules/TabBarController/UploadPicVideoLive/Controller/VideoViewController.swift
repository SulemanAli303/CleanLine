

import UIKit
import AVFoundation
import AVKit
import Photos

class VideoViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var trimView: TrimmerView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var videoURL: URL?
    var asset1:AVAsset?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?

    deinit{
        playbackTimeCheckerTimer?.invalidate()
        trimmerPositionChangedTimer?.invalidate()
    }
    var startTime:Float? = 0.0
    var endTime:Float? = 0.0
    var player: AVPlayer?
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
        player?.pause()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        let cancelButton = UIButton(frame: CGRect(x: self.view.bounds.width - 50, y: 50.0, width: 30.0, height: 30.0))
        cancelButton.setImage(UIImage(named: "close"), for: UIControl.State())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        trimView.delegate = self
        asset1 =  AVAsset(url: videoURL!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addVideoPlayer(with: self.asset1!, playerView: self.videoView, isLandscape: false)
            self.trimView.asset = self.asset1
        }
        
        
        // Allow background audio to continue to play
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch let error as NSError {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
        player?.volume = 1
    }
    
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func added() {
        
        self.saveTrimmedVideo()
        
    }
    
    func saveTrimmedVideo(){
        Utilities.showIndicatorView()
        self.trimVideo(sourceURL1: videoURL!, statTime: trimView.startTime!, endTime: trimView.endTime!) { result, errorString in
            DispatchQueue.main.async {
                Utilities.hideIndicatorView()
                if result != nil{
                    do {
                        if let url = result {
                            self.player?.pause()
                            Constants.shared.uploadVideoArray.removeAll()
                            Constants.shared.uploadVideoArray.append(url)
                            Coordinator.goToSubmitPictureVideo(controller: self, isTakePicture: false,isLive: false)
                        }
                        
                    } catch let error {
                        
                    }
                }else{
                    
                }
            }
            
        }
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: CMTime.zero)
            self.player!.play()
        }
    }
    
    func startPlaybackTimeChecker() {

        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
            #selector(self.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }

    func stopPlaybackTimeChecker() {

        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }
    
    @objc func onPlaybackTimeChecker() {

        guard let startTime = trimView.startTime, let endTime = trimView.endTime, let player = player else {
            return
        }

        let playBackTime = player.currentTime()
        trimView.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            trimView.seek(to: startTime)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

extension VideoViewController: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.play()
        startPlaybackTimeChecker()
    }
    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        let duration = (trimView.endTime! - trimView.startTime!).seconds

        self.startTime = Float(trimView.startTime?.value ?? CMTimeValue(0.0))
        self.endTime = Float(trimView.endTime?.value ?? CMTimeValue(0.0))
        
    }
    
}


extension VideoViewController{
    private func addVideoPlayer(with asset: AVAsset, playerView: UIView, isLandscape: Bool) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        layer.videoGravity = isLandscape ? AVLayerVideoGravity.resizeAspect : .resizeAspectFill
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
        
        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
            player.volume = 1
            startPlaybackTimeChecker()
        } else {
            player.pause()
            stopPlaybackTimeChecker()
        }
    }
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        if let startTime = trimView.startTime {
            player?.seek(to: startTime)
            if (player?.isPlaying != true) {
                player?.play()
            }
        }
    }

   
    func trimVideo(sourceURL1: URL, statTime:CMTime, endTime:CMTime,completionHandler : @escaping(_ result: URL?, _ errorString:String?) -> Void){
      let manager = FileManager.default

      guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
      let mediaType = "mp4"
      if mediaType == "mov" as String || mediaType == "mp4" as String {
          let asset = AVAsset(url: sourceURL1 as URL)
          let length = Float(asset.duration.value) / Float(asset.duration.timescale)
          print("video length: \(length) seconds")
          
          var outputURL = documentDirectory.appendingPathComponent("output")
          do {
              try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
              outputURL = outputURL.appendingPathComponent("\(UUID().uuidString).\(mediaType)")
          }catch let error {
              print(error)
          }

          //Remove existing file
          _ = try? manager.removeItem(at: outputURL)

//          let size = UIScreen.main.bounds.size
//          let encoder = SDAVAssetExportSession(asset: asset)
//          encoder?.outputFileType = "mp4";
//          encoder?.outputURL = outputURL;
//          encoder?.updateDefaultSettings(size)
//          encoder?.exportAsynchronously(completionHandler: {
//              if encoder?.status == .completed{
//                  completionHandler(outputURL,nil)
//              }
//          })

          guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHEVC1920x1080) else {return}
          exportSession.outputURL = outputURL
          exportSession.outputFileType = .mp4
          exportSession.shouldOptimizeForNetworkUse = true
          let startTime = statTime
          let endTime = endTime
          let timeRange = CMTimeRange(start: startTime, end: endTime)
          exportSession.timeRange = timeRange
          exportSession.exportAsynchronously{
              switch exportSession.status {
                  case .completed:
                      print("exported at \(outputURL)")
                      completionHandler(outputURL,nil)
                        //self.saveToCameraRoll(URL: outputURL as NSURL?)
                  case .failed:
                      print("failed \(String(describing: exportSession.error))")
                      completionHandler(nil,exportSession.error?.localizedDescription)
                  case .cancelled:
                      print("cancelled \(String(describing: exportSession.error))")
                      completionHandler(nil,exportSession.error?.localizedDescription)

                  default: break
              }
          }
      }
  }
    //Save Video to Photos Library
    func saveToCameraRoll(URL: NSURL!) {
        PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL as URL)
      }) { saved, error in
        if saved {
          DispatchQueue.main.async {
              let alertController = UIAlertController(title: "Cropped video was successfully saved", message: nil, preferredStyle: .alert)
              let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
              alertController.addAction(defaultAction)
              self.present(alertController, animated: true, completion: nil)
          }
      }}}
}

extension AVPlayer {

    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
