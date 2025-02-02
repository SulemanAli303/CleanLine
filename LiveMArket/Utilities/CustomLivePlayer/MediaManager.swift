//
//  MediaManager.swift
//  EZPlayerExample
//
//  Created by yangjun zhu on 2016/12/28.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

import UIKit
import EZPlayer
import SwiftEventBus
class MediaManager {
    
    
     var pipForcedStop = false
     var player: EZPlayer?
     var mediaItem: MediaItem?
     var embeddedContentView: UIView?

    static let sharedInstance = MediaManager()
    private init(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidPlayToEnd(_:)), name: .EZPlayerPlaybackDidFinish, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerStatusChange(_:)), name: .EZPlayerStatusDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pipStoped(_:)), name: .EZPlayerPIPControllerDidEnd, object: nil)

    }

    func playEmbeddedVideo(url: URL, embeddedContentView contentView: UIView? = nil, userinfo: [AnyHashable : Any]? = nil) {
        var mediaItem = MediaItem()
        mediaItem.url = url
        self.playEmbeddedVideo(mediaItem: mediaItem, embeddedContentView: contentView, userinfo: userinfo )
    }

    func playEmbeddedVideo(mediaItem: MediaItem, embeddedContentView contentView: UIView? = nil , userinfo: [AnyHashable : Any]? = nil ) {
        //stop
        self.releasePlayer()

        if let skinView = userinfo?["skin"] as? UIView{
         self.player =  EZPlayer(controlView: skinView)
            //player?.configPIP()
        }else{
          self.player = EZPlayer()
        }
        

//        self.player!.slideTrigger = (left:EZPlayerSlideTrigger.none,right:EZPlayerSlideTrigger.none)

        if let autoPlay = userinfo?["autoPlay"] as? Bool{
            self.player!.autoPlay = autoPlay
        }
        self.player!.videoGravity = .aspectFill
        if let floatMode = userinfo?["floatMode"] as? EZPlayerFloatMode{
            self.player!.floatMode = floatMode
        }

        if let fullScreenMode = userinfo?["fullScreenMode"] as? EZPlayerFullScreenMode{
            self.player!.fullScreenMode = fullScreenMode
        }

        self.player!.backButtonBlock = { fromDisplayMode in
            if fromDisplayMode == .embedded {
                self.releasePlayer()
            }else if fromDisplayMode == .fullscreen {
                if self.embeddedContentView == nil && self.player!.lastDisplayMode != .float{
                    self.releasePlayer()
                }

            }else if fromDisplayMode == .float {
                if self.player!.lastDisplayMode == .none{
                    self.releasePlayer()
                }
            }

        }
        
//        self.player!.startPIP { error in
//
//        }
//        self.player!.endPIPWithCompletion = {
//            print("PIPCOM")
//        }
        self.embeddedContentView = contentView

        self.player!.playWithURL(mediaItem.url! , embeddedContentView: self.embeddedContentView)
    }




    func releasePlayer(){
        self.player?.stop()
        self.player?.view.removeFromSuperview()

        self.player = nil
        self.embeddedContentView = nil
        self.mediaItem = nil

    }

    @objc  func playerDidPlayToEnd(_ notifiaction: Notification) {
       //结束播放关闭播放器
       //self.releasePlayer()

    }

    @objc  func playerStatusChange(_ notifiaction: Notification) {
       //结束播放关闭播放器
       //self.releasePlayer()
        if self.player!.state == EZPlayerState.playing{
            SwiftEventBus.postToMainThread("VideoPlaying")
            //self.player?.configPIP()
        }
    }
    @objc  func pipStoped(_ notifiaction: Notification) {
        pipForcedStop = true
    }

}

