//
//  LTChatViewController+Audio.swift
//  LiveMArket
//
//  Created by Rupesh E on 07/10/23.
//

import Foundation
import AVFAudio
import UIKit
import FirebaseDatabase
import GrowingTextView
import SDWebImage
import Alamofire
import IQKeyboardManagerSwift
import Firebase
import FirebaseStorage
import AudioStreaming
import AVFoundation

extension LTChatViewController{
    
    func enableSendBtn(isEnable: Bool) {
//        if !isEnable {
//            self.sendBtn.isUserInteractionEnabled = false
//            self.sendBtn.backgroundColor = .clear
//            self.sendBtn.borderColor = .gray
//            self.sendBtn.borderWidth = 1.0
//            self.sendBtn.setTitleColor(.gray, for: .normal)
//        }else {
//            self.sendBtn.isUserInteractionEnabled = true
//            self.sendBtn.backgroundColor = Color.darkOrange.color()
//            self.sendBtn.borderColor = .clear
//            self.sendBtn.borderWidth = 0
//            self.sendBtn.setTitleColor(.white, for: .normal)
//        }
    }
    @IBAction func playAudioTapped(_ sender: Any) {
        if playAudioBtn.isSelected == false {
            audioPlayer.play()
            playAudioBtn.isSelected = true
            
            playTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            timer  = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        }else {
            audioPlayer.pause()
            updateTime()
            timerFired()
            playAudioBtn.isSelected = false
        }
    }
    

    @IBAction func cancelRecording(_ sender: Any) {
        if audioRecorder != nil {
            audioRecorder = nil
        }
        if meterTimer != nil {
            meterTimer.invalidate()
        }
        handlePlayAudioView(isShow: true)
        self.pauseRecordingBtn.isSelected = false
        self.isPaused = false
        self.setRecorderVisiblity(isHidden: true)
        resetAudioView()
        //self.bottomVwBConst.constant = -15
        
    }
    fileprivate func resetAudioView() {
        self.pauseRecordingBtn.isSelected = false
        self.playAudioBtn.isSelected = false
        handlePlayAudioView(isShow: true)
        if audioPlayer != nil {
            audioPlayer.stop()
            timer?.invalidate()
        }
        playTimerLbl.text = "00:00"
        secondWaveImageWidConst.constant = 0
    }
    
    @IBAction func pauseAudioRecording(_ sender: Any) {
        if audioRecorder != nil {
            if isPaused {
                isPaused = false
                audioRecorder.record()
                resetAudioView()
            } else {
                self.isPaused = true
                self.pauseRecordingBtn.isSelected = true
                self.audioRecorder.pause()
                 handlePlayAudioView(isShow: false)
                self.setupAudioPlayer()
            }
        }
    }
    @IBAction func sendAudioBtnPressed(_ sender: Any) {
        self.pauseRecordingBtn.isSelected = false
        if audioRecorder != nil {
            isPaused = false
            self.audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            handlePlayAudioView(isShow: true)
        }
        //self.recordView.isHidden = true
        self.setRecorderVisiblity(isHidden: true)
        resetAudioView()
    }
    
    func handlePlayAudioView(isShow: Bool) {
        playAudioVw.isHidden = isShow
    }
    
    func setupAudioPlayer() {
        var error : NSError?
        do {
            let player = try AVAudioPlayer(contentsOf: audioRecorder!.url)
            audioPlayer = player
            audioPlayer.volume = 3.0
            audioPlayer.isMeteringEnabled = true
        } catch {
            print(error)
        }
        
        audioPlayer?.delegate = self
        
        if let err = error{
            print("audioPlayer error: \(err.localizedDescription)")
        }else{
            audioPlayer?.prepareToPlay()
            //            playAudioBtn.isSelected = true
            let waveformImageDrawer = WaveformImageDrawer()
            waveformImageDrawer.waveformImage(
                fromAudioAt: audioPlayer!.url!,
                with: .init(
                    size: self.waveImageVw.bounds.size,
                    style: .striped(.init(color: .gray, width: 3, spacing: 3, lineCap: .round)),
                    position: .middle)) { image in
                        // need to jump back to main queue
                        DispatchQueue.main.async {
                            if let image = image {
                                self.setupWaveFormImages(image: image)
                            }
                        }
                    }
            playTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            timer  = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTime() {
        if audioPlayer != nil {
            let currentTime = Int(audioPlayer.currentTime)
            let duration = Int(audioPlayer.duration)
            let total = currentTime - duration
            let totalString = String(total)
            
            let minutes = currentTime/60
            let seconds = currentTime - minutes * 60
            
            playTimerLbl.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
        
    }
    

    
    func setupWaveFormImages(image: UIImage) {
        self.waveImageVw.image = image.withRenderingMode(.alwaysTemplate)
        self.waveImageView2.image = image.withRenderingMode(.alwaysTemplate)
    }
    
}
extension LTChatViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playAudioBtn.isSelected = false
        playTimer.invalidate()
        timer?.invalidate()
        secondWaveImageWidConst.constant = 0
        audioPlayer.stop()
        isPaused = true
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
        playAudioBtn.isSelected = false
        playTimer.invalidate()
        timer?.invalidate()
        secondWaveImageWidConst.constant = 0
        audioPlayer.stop()
        isPaused = false
    }
    
    @objc func timerFired() {
        if self.audioPlayer != nil {
            DispatchQueue.main.async {
                let currentTime = self.audioPlayer?.currentTime ?? 0
                let totalTime = self.audioPlayer?.duration ?? 0
                let width = self.waveImageVw.width
                let rate = width / totalTime
                let pWidth = rate * currentTime
                self.secondWaveImageWidConst.constant = pWidth
                UIView.animate(withDuration: 1.0) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
}
//MARK: - Audio Recording -
extension LTChatViewController: AVAudioRecorderDelegate {
    
    func recordAudio() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord,options: .defaultToSpeaker)
            try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordTapped()
                    } else {
                        // failed to record!
                        Utilities.showWarningAlert(message: "MicSetting")
                    }
                }
            }
        } catch let error {
            // failed to record!
            print(error.localizedDescription)
        }
    }
    func recordTapped() {
        
        if audioRecorder == nil {
            startRecording()
//            self.viewModel?.changeRecordingStatus(groupId: groupId ?? "", status: true)
        } else {
            finishRecording(success: true)
        }
    }
    
    
    
    func startRecording() {
//        let audioFilename = getDocumentsDirectory().appendingPathComponent("liveMarket_chat_recording.caf")
//        
//        let settings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
//                             AVEncoderBitRateKey: 16,
//                          AVNumberOfChannelsKey : 2,
//                                 AVSampleRateKey: 44100.0] as [String : Any] as [String : Any] as [String : Any] as [String : Any]
//        
//        do {
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//            audioRecorder.isMeteringEnabled = true
//            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
//            //recordButton.setTitle("Tap to Stop", for: .normal)
//        } catch {
//            finishRecording(success: false)
//        }
        
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
        } catch {
            finishRecording(success: false)
        }
        
        
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getAudioFileUrl() -> URL
    {
        let filename = "myRecording.aac"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        meterTimer.invalidate()
        audioRecorder = nil
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if self.isPaused {
            return
        }
        if !flag {
            finishRecording(success: false)
        } else {
            self.sendAudioMessage(url: recorder.url)
        }
    }
    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording {
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            audioRecordingTimeLbl.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func sendAudioMessage(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            self.sendingImageLabel.text = "SendingVoice".localiz()
            self.sendingImageLabel.isHidden = false
            self.uploadAudioFileIntFDB(localFile: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}
