//
//  ChatSenderAudioTableViewCell.swift
//  LiveMArket
//
//  Created by Rupesh E on 09/10/23.
//

import UIKit
import AudioStreaming
import NVActivityIndicatorView
import FirebaseStorage
import Cache
import AVFAudio

class ChatSenderAudioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var waveforImageView: UIImageView!
    @IBOutlet weak var waveforImageView2: UIImageView!
    @IBOutlet weak var secondWaveFormViewWidth: NSLayoutConstraint!
    var timer: Timer?
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var playBtnView: UIView! {
        didSet {
            playBtnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.playAudioBtnPressed(_:))))
        }
    }
    @IBOutlet weak var savedLineWidContraint: NSLayoutConstraint!
    @IBOutlet weak var savedLineTrailContraint: NSLayoutConstraint!
   
    @IBOutlet weak var activityLoader: NVActivityIndicatorView!
    
    
    

    
    //var message: MessageModel?
    var audioPlayer: AudioPlayer?
    var vc: UIViewController?
    var originalCenter = CGPoint()
    
    
    var rfcDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }
    
    var localDateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        return formatter
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    var controller:UIViewController?{
        didSet{
            
        }
    }
    
    var currentIndex:Int?{
        didSet{
            
        }
    }
    
    var chatData:ChatModel2?{
        didSet{
            let numberValue = NSNumber(value: chatData?.messageTimeStamp ?? 0)
            timeLbl.text = self.convertTimeStamp(createdAt: numberValue)
            if chatData?.audioURL == ""{
                playBtnView.isHidden = true
                activityIndicatorView.isHidden = false
            }else{
                playBtnView.isHidden = false
                activityIndicatorView.isHidden = true
            }
            
//            if let file = chatData?.waveFormImage {
//                self.setupWaveFormImages(image: file)
//            } else {
//                //            self.activityLoader.startAnimating()
//                self.checkBookFileExists(withLink: chatData?.audioURL ?? "") { [self] filePath in
//                    if let vc = self.controller as? LTChatViewController {
//                        vc.chatsArray[self.currentIndex ?? 0].localFile = filePath
//                    }
//                    self.chatData?.localFile = filePath
//                    let waveformImageDrawer = WaveformImageDrawer()
//                    waveformImageDrawer.waveformImage(
//                        fromAudioAt: filePath,
//                        with: .init(
//                            size: self.waveforImageView.bounds.size,
//                            style: .striped(.init(color: .gray, width: 3, spacing: 3, lineCap: .round)),
//                            position: .middle)) { image in
//                                // need to jump back to main queue
//
//                                DispatchQueue.main.async {
//                                    //                                self.activityLoader.stopAnimating()
//
//                                    chatData?.waveFormImage = image
//                                    if let vc = controller as? LTChatViewController {
//                                        vc.chatsArray[currentIndex ?? 0].localFile = filePath
//                                    }
//                                    if let image = image {
//                                        self.setupWaveFormImages(image: image)
//                                    }
//                                }
//                            }
//                }
//            }
            
        }
    }
    
    func setupWaveFormImages(image: UIImage) {
        self.waveforImageView.image = image.withRenderingMode(.alwaysTemplate)
        self.waveforImageView2.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    func convertTimeStamp(createdAt: NSNumber?) -> String {
        guard let createdAt = createdAt else { return "a moment ago" }
        
        let converted = Date(timeIntervalSince1970: Double(truncating: createdAt) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        let dateString = dateFormatter.string(from: converted)
        
        let date = self.rfcDateFormatter.date(from: dateString)
        let localDate = self.localDateFormatter.string(from: date!)
        
        return localDate.changeTimeToFormat(frmFormat: "dd-MM-yyyy HH:mm:ss Z", toFormat: "hh:mm a")
        
    }
    
    func formatDate(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let dateFromString = dateFormatter.date(from: date) {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "d MMM yyyy h:mma"
            let dateString = formatter.string(from: dateFromString)
            return dateString
        }
        return ""
    }
    
    
    
    @objc func playAudioBtnPressed(_ sender: UITapGestureRecognizer) {
        //pause.circle.fill
        //
        if audioPlayer != nil {
            if sender.view?.tag == 1 {
                self.audioPlayer?.pause()
            } else {
                if audioPlayer?.state == .stopped {
                    self.playAudio()
                } else if audioPlayer?.state == .paused {
                    self.audioPlayer?.resume()
                }
            }
        } else {
            self.playAudio()
        }
    }
    
    func playAudio() {
        
//        guard let message = chatData else {
//            return
//        }
        if let vc = (controller as? LTChatViewController),let index = vc.chatsArray.firstIndex(where: {$0.isPlaying == true}) {
            if let cell = vc.tableViewChat.cellForRow(at: IndexPath(row: index, section: 0)) as? ChatSenderAudioTableViewCell {
                cell.audioPlayer?.stop()
                vc.chatsArray[index].isPlaying = false
            }
            if let cell = vc.tableViewChat.cellForRow(at: IndexPath(row: index, section: 0)) as? ChatReceiverAudioTableViewCell {
                cell.audioPlayer?.stop()
                vc.chatsArray[index].isPlaying = false
            }
        }
        guard let url = URL(string: chatData?.audioURL ?? "") else {
            Utilities.showWarningAlert(message: "Invalid audio")
            return
        }
        audioPlayer = AudioPlayer()
        audioPlayer?.play(url: url)
        audioPlayer?.delegate = self
    }
    
}
//MARK: Audio Player delegate
extension ChatSenderAudioTableViewCell: AudioPlayerDelegate {
    func audioPlayerDidStartPlaying(player: AudioStreaming.AudioPlayer, with entryId: AudioStreaming.AudioEntryId) {
        self.playImageView.image = UIImage(systemName: "pause.circle.fill")
        if let vc = (controller as? LTChatViewController), let index = vc.chatsArray.firstIndex(where: {$0.id == self.chatData?.id}) {
            vc.chatsArray[index].isPlaying = true
        }
    }
    func audioPlayerDidFinishBuffering(player: AudioStreaming.AudioPlayer, with entryId: AudioStreaming.AudioEntryId) {
    }
    @objc func timerFired() {
        DispatchQueue.main.async {
            let currentTime = self.audioPlayer?.progress ?? 0
            let totalTime = self.audioPlayer?.duration ?? 0
            let width = self.waveforImageView.width
            let rate = width / totalTime
            let pWidth = rate * currentTime
//            print("current time = \(currentTime)")
//            print("totalTime time = \(totalTime)")
            //self.secondWaveFormViewWidth.constant = pWidth
            let sliderValue = Float(currentTime/totalTime)
            UIView.animate(withDuration: 1.0, animations: {
              self.slider.setValue(sliderValue, animated:true)
                self.slider.layoutIfNeeded()
            })
        }
    }
    func audioPlayerStateChanged(player: AudioStreaming.AudioPlayer, with newState: AudioStreaming.AudioPlayerState, previous: AudioStreaming.AudioPlayerState) {
        print(newState)
        switch newState {
        case .ready:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.playBtnView.tag = 0
        case .running:
            self.playImageView.image = UIImage(systemName: "pause.circle.fill")
            self.playBtnView.tag = 1
        case .playing:
            self.playImageView.image = UIImage(systemName: "pause.circle.fill")
            self.playBtnView.tag = 1
            timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            timer?.fire()
        case .bufferring:
            self.playImageView.image = UIImage(systemName: "pause.circle.fill")
            self.playBtnView.tag = 1
        case .paused:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.playBtnView.tag = 0
            self.timer?.invalidate()
        case .stopped:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.playBtnView.tag = 0
            audioPlayer = nil
            self.playBtnView.tag = 0
            self.timer?.invalidate()
            self.secondWaveFormViewWidth.constant = 0
            self.slider.setValue(0, animated: false)
        case .error:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.secondWaveFormViewWidth.constant = 0
            self.slider.setValue(0, animated: false)
        case .disposed:
            self.playImageView.image = UIImage(systemName: "play.circle.fill")
            self.secondWaveFormViewWidth.constant = 0
            self.slider.setValue(0, animated: false)
        }
    }

    func audioPlayerDidFinishPlaying(player: AudioStreaming.AudioPlayer, entryId: AudioStreaming.AudioEntryId, stopReason: AudioStreaming.AudioPlayerStopReason, progress: Double, duration: Double) {
        self.playImageView.image = UIImage(systemName: "play.circle.fill")
    }

    func audioPlayerUnexpectedError(player: AudioStreaming.AudioPlayer, error: AudioStreaming.AudioPlayerError) {

    }

    func audioPlayerDidCancel(player: AudioStreaming.AudioPlayer, queuedItems: [AudioStreaming.AudioEntryId]) {

    }

    func audioPlayerDidReadMetadata(player: AudioStreaming.AudioPlayer, metadata: [String : String]) {
        print(metadata)
    }
}
// MARK: - Pan Gesture -
extension ChatSenderAudioTableViewCell {
    func setupPanGesture() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    //MARK: - horizontal pan gesture methods
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        let translation = recognizer.translation(in: self)
        if recognizer.state == .began {
            originalCenter = center
        }
        // 2
        if recognizer.state == .changed {
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
        }
        // 3
        if recognizer.state == .ended {
            if -(translation.x) > self.bounds.size.width / 4 {
//                if let vc = vc as? MessageInboxVC {
//                    vc.setupReplyView(message)
//                }
            }
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            //}
        }
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if translation.x > 0 {
                return false
            }
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
        let urlString = link
        if let url  = URL.init(string: urlString) {
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){

                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)

                do {
                    if try filePath.checkResourceIsReachable() {
                        print("file exist")
                        completion(filePath)

                    } else {
                        print("file doesnt exist")
                        downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                    }
                } catch {
                    print("file doesnt exist")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            }else{
                 print("file doesnt exist")
            }
        }else{
                print("file doesnt exist")
        }
    }
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }

}
