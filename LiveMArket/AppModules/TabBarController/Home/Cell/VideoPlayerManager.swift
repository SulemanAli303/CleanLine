//
//  VideoPlayerManager.swift
//  LiveMArket
//
//  Created by Greeniitc on 13/06/23.
//


import Foundation
import ASPVideoPlayer

class VideoPlayerManager: NSObject {
   
   public static let shared = VideoPlayerManager()
   public var _playerView: PlayerNode? {
       willSet{
          // _playerView?.layer.speed = 0;
           //_playerView?.layer.removeAllAnimations()
           _playerView?.reset()
       }
       didSet{
           guard let new = _playerView else {
               return
           }
           //print("not PLAYSTARTED")
           new.playVideo()
       }
   }
   public var playerView: PlayerNode? {
       set {
           if self.playerView != newValue {
               self._playerView = newValue
           }else{
               guard let state = playerView?.state, case .pause(_, _) = state else {
                   return
               }
              self.resume()
           }
       } get {
           return _playerView
       }
   }
   public func playVideo(in view: FeedNode?) {
       self.playerView = view?.videoNode
   }
    public func pause(_ reason: PausedReason) {
       playerView?.pauseVideo(reason)
   }
   public func resume() {
       playerView?.playVideo()
   }
   
    public func reset(){
        playerView = nil
    }
    
//    public func playPagerVideo(in view: PagerPostNode?) {
//        self.playerView = view?.videoNode
//    }
    
    
    public var muted = false {
        didSet{
            self.playerView?.playerNode.muted = muted
        }
    }
    
    public var isVideoPaused = false
}
class ProfileVideoPlayerManager: NSObject {
   
   public static let shared = ProfileVideoPlayerManager()
    
    public var _playerView: ASPVideoPlayerView? {
        willSet{
           // _playerView?.layer.speed = 0;
            //_playerView?.layer.removeAllAnimations()
//            _playerView?.player.seek(to: .zero)
//            _playerView?.player.pause()
            _playerView?.seek(.zero)
            _playerView?.pauseVideo()
            _playerView?.startPlayingWhenReady = false
        }
        didSet{
            guard let new = _playerView else {
                return
            }
            new.startPlayingWhenReady = true
            new.playVideo()
        }
    }
    
    public var playerView: ASPVideoPlayerView? {
        set {
            if self.playerView != newValue {
                self._playerView = newValue
            }else{
                if playerView?.status == .paused  {
                    self.resume()
                }else if playerView?.status == .new{
                    self.resume()
                }else if playerView?.status == .readyToPlay{
                    self.resume()
                }
            }
        } get {
            return _playerView
        }
    }
     
    public func playVideo(in view: ASPVideoPlayerView?) {
        self.playerView = view
    }
     public func pause(_ reason: PausedReason) {
         playerView?.startPlayingWhenReady = false
         playerView?.pauseVideo()
    }
    public func resume() {
        playerView?.startPlayingWhenReady = true
        playerView?.playVideo()
    }
    
     public func reset(){
         pause(.hidden)
        // playerView?.player.replaceCurrentItem(with: nil)
        // playerView = nil
     }
    
    public func playPagerVideo(in view: ASPVideoPlayerView?) {
        self.playerView = view
    }
//
//
//    public var muted = false {
//        didSet{
//            self.playerView?.playerNode.muted = muted
//        }
//    }
}

class DelayedBlockOperation: Operation {
    private let deadline: DispatchTime
    private let block: (() -> Void)?
    private let queue: DispatchQueue

    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool {
        get { _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    private var _executing: Bool = false

    override var isFinished: Bool {
        get { _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    private var _finished: Bool = false

    init(deadline: DispatchTime,
         queue: DispatchQueue = .global(),
         _ block: @escaping () -> Void = { }) {
        self.deadline = deadline
        self.queue = queue
        self.block = block
    }

    override func start() {
        queue.asyncAfter(deadline: deadline) {
            guard !self.isCancelled else {
                self.isFinished = true
                return
            }
            guard let block = self.block else {
                self.isFinished = true
                return
            }
            self.isExecuting = true
            block()
            self.isFinished = true
        }
    }
}
