//
//  LiveVideoViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 15/07/23.
//

import UIKit
import AVFoundation
import AVKit

class LiveVideoViewController: UIViewController {

    
    @IBOutlet weak var playButto̊n: UIButton!
    @IBOutlet weak var playerBGView: UIView!
    @IBOutlet weak var thumpImageView: UIImageView!
    var videoURL: URL?
    var player: AVPlayer?
    var playButtonClicked:Bool = false
    var playerController : AVPlayerViewController?
    var channelID : String?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AVPlayer(url: videoURL!)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChild(playerController!)
        self.playerBGView.addSubview(playerController!.view)
        
        DispatchQueue.main.async {
            self.playerController!.view.frame = self.playerBGView.frame
            self.playerBGView.layoutIfNeeded()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
//        let cancelButton = UIButton(frame: CGRect(x: self.view.bounds.width - 50, y: 40.0, width: 30.0, height: 30.0))
//        cancelButton.setImage(UIImage(named: "close"), for: UIControl.State())
//        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//        view.addSubview(cancelButton)
//        
//        let cancelButton1 = UIButton(frame: CGRect(x: self.view.bounds.width - 100, y: self.view.bounds.height - 100.0, width: 60.0, height: 60.0))
//        cancelButton1.setImage(UIImage(named: "send"), for: UIControl.State())
//        cancelButton1.addTarget(self, action: #selector(added), for: .touchUpInside)
//        cancelButton1.layer.cornerRadius = 30
//        cancelButton1.backgroundColor = .white
//        view.addSubview(cancelButton1)
        
        
        // Allow background audio to continue to play
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
            } else {
            }
        } catch let error as NSError {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error)
        }
        self.playButto̊n.bringSubviewToFront(playerBGView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
        player?.pause()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //player?.play()
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: CMTime.zero)
            self.player!.play()
        }
    }
    

    @IBAction func playButtonAction(_ sender: UIButton) {
//        
        if playButtonClicked{
            player?.pause()
            playButto̊n.setImage(UIImage(named: "playButtonWhite"), for: .normal)
        }else{
            player?.play()
            playButto̊n.setImage(UIImage(named: ""), for: .normal)
        }
        playButtonClicked.toggle()
    }
    @IBAction func shareVideoButtonAction(_ sender: UIButton) {
        Constants.shared.uploadVideoArray.removeAll()
        Constants.shared.uploadVideoArray.append(videoURL!)
        Coordinator.goToSubmitPictureVideo(controller: self, isTakePicture: false, isLive: true,channelID: self.channelID ?? "")
    }
    @IBAction func discardVideoButtonAction(_ sender: UIButton) {
        DispatchQueue.global(qos: .background).async {
            let parameters:[String:String] = [
                "access_token": SessionManager.getUserData()?.accessToken ?? "",
                "channel_id": self.channelID ?? "",
            ]
            
            LivePostAPIManager.discardLiveVideoAPI(parameters: parameters) { result in
                
            }
        }
        
        Coordinator.updateRootVCToTab()
    }

}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
