//
//  LiveStreamPlayerCell.swift
//  LiveMArket
//
//  Created by Muhammad Junaid Babar on 07/08/2023.
//

import UIKit
import GSPlayer
import WebRTCiOSSDK
import GrowingTextView
import WebRTC
import AsyncDisplayKit
import AVKit
protocol LiveStreamPlayerCellDelegate : AnyObject {
    func postCommentWith(_ comment : String,cell:LiveStreamPlayerCell,indexPath:IndexPath)
}

class LiveStreamPlayerCell: UICollectionViewCell {

    @IBOutlet weak var endedLiveView: UIView!
    @IBOutlet weak var thumbnailImgVw: UIImageView!
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var addCommentView: UIView!
    @IBOutlet weak var commentTxt: GrowingTextView!
    @IBOutlet weak var addCommentBtn: UIButton!
    @IBOutlet weak var commentListView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var parent:UIViewController?
    var isScrollEnabled = true
    var scrollTimer: Timer?
    weak var delegate : LiveStreamPlayerCellDelegate?
    var indexPath: IndexPath!
    var videoURL:URL!
    public lazy var playerNode = { () -> ASVideoNode in
        let node = ASVideoNode()
        node.shouldAutoplay = true
        node.shouldAutorepeat = true
        node.shouldAggressivelyRecoverFromStall = true
        node.gravity = AVLayerVideoGravity.resize.rawValue
        node.delegate = self
        node.shouldAutorepeat = true;
        node.shouldAutoplay = true;
        node.muted = true;
        return node
    }()
    var placeHoldURL:String?
    var channelID:String! {
        didSet {
            videoURL = URL(string:"https://livesoouq.com:5443/WebRTCAppEE/streams/\(channelID!)_adaptive.m3u8")!
            playerNode.url = URL(string: placeHoldURL ?? "")
            self.playerNode.assetURL =  videoURL
//            self.playerNode.asset = AVAsset(url: videoURL)
            self.playerContainerView.addSubview(playerNode.view)
            self.playerNode.frame = playerContainerView.bounds
            self.playerNode.muted = false
            self.playerNode.play()
            self.playerNode.player?.currentItem?.preferredForwardBufferDuration = 0
            self.playerNode.player?.currentItem?.canUseNetworkResourcesForLiveStreamingWhilePaused = true
            self.playerNode.player?.automaticallyWaitsToMinimizeStalling = true
            self.playerNode.player?.allowsExternalPlayback = false
            self.playerNode.player?.playImmediately(atRate: 1.0)
            self.playerNode.player?.volume = 1.0
            self.playerNode.player?.play()
            print("LiveStreamPlayerCell","Start Downloading At \(self.videoURL.absoluteString)")
        }
    }



    deinit {
        scrollTimer?.invalidate()
        scrollTimer = nil
        parent = nil
        playerNode.delegate = nil
        tableView?.delegate = nil
        tableView?.dataSource = nil
        commentTxt?.delegate = nil
    }

    override func prepareForReuse() {
        self.commentList = []
        super.prepareForReuse()
    }
    var commentList:[LiveStreamComments]? {
        didSet {
            tableView.reloadData()
            if commentList?.count ?? 0 > 0 {
                scrollToTop()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        playerNode.shouldAutoplay = true
        playerNode.player?.automaticallyWaitsToMinimizeStalling = false
        playerNode.shouldAutorepeat = false
        playerNode.delegate = self
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        commentTxt.delegate = self
        let gradient = CAGradientLayer()
        gradient.frame = tableView.superview?.bounds ?? .null
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.15, 0.25]
        tableView.superview?.layer.mask = gradient
        addCommentBtn.setImage(UIImage(named: "noun-send-887299"), for: .normal)
        addCommentBtn.setImageColor(color: UIColor(hex: "dd6515"), forState: .normal)
        addCommentBtn.isEnabled = false
        addTapGestureOnTable()
    }
    
    func addTapGestureOnTable(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.tableView.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.commentTxt.resignFirstResponder()
        self.tableView.isScrollEnabled = true
        disableScrollAfterDelay()
    }

    func disableScrollAfterDelay() {
        isScrollEnabled = false
        scrollTimer?.invalidate()
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.isScrollEnabled = true
        }
    }

    @IBAction func addCommentAction(_ sender: Any) {
        if commentTxt.text.trimmingCharacters(in: .whitespaces) == "" {
            return
        }
        self.commentTxt.resignFirstResponder()
        self.delegate?.postCommentWith(commentTxt.text,cell:self,indexPath:indexPath)
        self.addCommentBtn.isEnabled = false
        self.commentTxt.text = ""
    }

    func scrollToBottom()  {
        let row = (self.commentList?.count ?? 0) - 1
        let indexPath = IndexPath(row: row , section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    private func scrollToTop(){
            let indexPath = IndexPath(row: 0 , section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}


extension LiveStreamPlayerCell: UITableViewDataSource {
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension LiveStreamPlayerCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension LiveStreamPlayerCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Invalidate the scroll timer and enable scrolling
        scrollTimer?.invalidate()
        isScrollEnabled = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Disable scrolling after a delay if it's not already disabled
        disableScrollAfterDelay()
    }
}


extension LiveStreamPlayerCell: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.contentView.layoutIfNeeded()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
                return false
            }
        if text == "" && (textView.text.count == 1) {
            addCommentBtn.isEnabled = false
            return true
        }
        addCommentBtn.isEnabled = true
        return true
    }
}
extension LiveStreamPlayerCell: CachingPlayerItemDelegate {
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        self.playerNode.player?.play()
        self.playerNode.play()
        print("Suleman","File is downloaded and ready for storing \(playerItem)")

    }

    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        self.playerNode.player?.play()
        self.playerNode.play()
        DispatchQueue.main.async {
            self.thumbnailImgVw.isHidden = true
        }

        print("LiveStreamPlayerCell","\(bytesDownloaded)/\(bytesExpected)")
    }

    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        print("LiveStreamPlayerCell","Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
    }

    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print("LiveStreamPlayerCell",error)
    }

}
extension LiveStreamPlayerCell : ASVideoNodeDelegate {
    func videoNodeDidRecover(fromStall videoNode: ASVideoNode) {
        print(#function)
        videoNode.play()
    }


    func videoNode(_ videoNode: ASVideoNode, didFailToLoadValueForKey key: String, asset: AVAsset, error: Error) {
        print(#function,key,error.localizedDescription)
        videoNode.play()
    }

    func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {
        if toState == .playing {
            videoNode.muted = false
            videoNode.player?.volume = 1.0
            Utilities.hideIndicatorViewGif()
        }
        print(#function,state.rawValue ,
              "0=>Unknown",
              "1=>InitialLoading",
              "2=>ReadyToPlay",
              "3=>PlaybackLikelyToKeepUpButNotPlaying",
              "4=>Playing",
              "5=>Loading",
              "6=>Paused",
              "7=>Finished"
        )
    }


    func videoNode(_ videoNode: ASVideoNode, didPlayToTimeInterval timeInterval: TimeInterval) {
        print(#function)

    }

    func videoDidPlay(toEnd videoNode: ASVideoNode) {
        print(#function)
    }


    func didTap(_ videoNode: ASVideoNode) {
        print(#function)
    }

    func videoNode(_ videoNode: ASVideoNode, didSetCurrentItem currentItem: AVPlayerItem) {
        print(#function)
        currentItem.preferredForwardBufferDuration = 0
        currentItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true
        videoNode.play()
    }
    func videoNodeDidStartInitialLoading(_ videoNode: ASVideoNode) {
        print(#function)

    }
    func videoNodeDidFinishInitialLoading(_ videoNode: ASVideoNode) {
        print(#function)

    }
    func videoNode(_ videoNode: ASVideoNode, didStallAtTimeInterval timeInterval: TimeInterval) {
        print(#function)

    }
    func videoNode(_ videoNode: ASVideoNode, shouldChangePlayerStateTo state: ASVideoNodePlayerState) -> Bool {
        print(#function)
        return true
    }
}
