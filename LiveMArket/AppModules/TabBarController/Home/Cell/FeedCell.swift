//
//  FeedCell.swift
//  GSPlayer_Example
//
//  Created by Gesen on 2020/5/17.
//  Copyright © 2020 Gesen. All rights reserved.
//

import GSPlayer
import ASPVideoPlayer
import ExpandableLabel

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoPlayerBackgroundView: UIView!
    
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var expendLbl: UILabel!
    var base: UIViewController!
    @IBOutlet weak var FullImg: UIImageView!
    @IBOutlet weak var btnType: UIButton!
    
    @IBOutlet weak var btnStore: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnMerge: UIButton!
    
    private var url: URL!
    var videoPlayer: ASPVideoPlayerView?
    var type = 0
    var isSelectedMerge = false
    var isSelectedProfile = false
    var isSelectedStore = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //playerView.isHidden = true
    }
    
    func set(url: URL) {
        
    }
    
    func play() {
        videoPlayer = ASPVideoPlayerView()
        guard let firstVideoURL = Bundle.main.url(forResource: "pexels-mehmet-ali-turan-5512609", withExtension: "mp4") else { return }
        //  self.url = firstVideoURL
        videoPlayer?.videoURL = firstVideoURL
        videoPlayer?.gravity = .aspectFill
        videoPlayer?.shouldLoop = false
        videoPlayer?.startPlayingWhenReady = true
        videoPlayer?.backgroundColor = UIColor.black
        
        videoPlayer?.newVideo = {
            print("newVideo")
        }
        
        videoPlayer?.readyToPlayVideo = {
            print("readyToPlay")
        }
        
        videoPlayer?.startedVideo = {
            print("start")
            
        }
        videoPlayer?.frame = playerContainerView.frame
        guard let player = videoPlayer else { return }
        playerContainerView.addSubview(player)
        
    }
    
    func pause() {
        videoPlayer?.stopVideo()
        videoPlayer?.removeFromSuperview()
        videoPlayer = nil
        
    }
    @IBAction func btnDetails(_ sender: Any) {
     //   Coordinator.goToGymManagment(controller: base)
        //   Coordinator.goToServices(controller: base)
    //    Coordinator.goToServiceProviderBooking(controller: base)  // Service Provide Bookimhg Flow
    //    Coordinator.goToCarBookingFlow(controller: base)   //Delivery Representative order manaement flow

        if (type == 0){
            ShopCoordinator.goToShopProfilePage(controller: base)
        }else if (type == 1){
            PlayGroundCoordinator.goToBookNow(controller: base, store_ID: "")
        }else if (type == 2){
            Coordinator.goToServices(controller: base, storeID: "")
        }else if (type == 3){
            Coordinator.goToCarBookingFlow(controller: base, store_ID: "")
        }
        else if (type == 4){
            Coordinator.goToCharletsList(controller: base)
        }
        else if (type == 5){
            Coordinator.goToHotelBookingFlow(controller: base, store_ID: "")
        }else if (type == 6){
            Coordinator.goToGymList(controller: base, storeID: "288")
        }
    }
    @IBAction func btnComment(_ sender: Any) {
        Coordinator.goToCommentsList(controller: base, postID: "", userID: "", onDone: {
            
        })
       
    }
    @IBAction func share(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("OpenSahre"), object: nil)
    }
    
    @IBAction func Live(_ sender: Any) {
        Coordinator.goToPostComment(controller: base)
        
    }
    @IBAction func store(_ sender: Any) {
        guard let firstVideoURL = Bundle.main.url(forResource: "video(1)", withExtension: "mp4") else { return }
        videoPlayer?.videoURL = firstVideoURL
        videoPlayer?.playVideo()
        
        self.btnProfile.setImage(UIImage(named: "Group 236123"), for: .normal)
        self.btnMerge.setImage(UIImage(named: "Group 236131"), for: .normal)
        self.btnStore.setImage(UIImage(named: "selectStore"), for: .normal)

    }
    @IBAction func MergeAction(_ sender: Any) {
        
        guard let firstVideoURL = Bundle.main.url(forResource: "pexels-mehmet-ali-turan-5512609", withExtension: "mp4") else { return }
        //  self.url = firstVideoURL
        videoPlayer?.videoURL = firstVideoURL
        videoPlayer?.playVideo()
        
        self.btnProfile.setImage(UIImage(named: "Group 236123"), for: .normal)
        self.btnMerge.setImage(UIImage(named: "Group 236124"), for: .normal)
        self.btnStore.setImage(UIImage(named: "Group 236122"), for: .normal)

    }
    @IBAction func profile(_ sender: Any) {
        guard let firstVideoURL = Bundle.main.url(forResource: "video", withExtension: "mp4") else { return }
        videoPlayer?.videoURL = firstVideoURL
        videoPlayer?.playVideo()
        self.btnProfile.setImage(UIImage(named: "Group -2 1"), for: .normal)
        self.btnMerge.setImage(UIImage(named: "Group 236131"), for: .normal)
        self.btnStore.setImage(UIImage(named: "Group 236122"), for: .normal)

    }
    @IBAction func storeAction2(_ sender: Any) {
        //ShopCoordinator.goToShopProfilePage(controller: base,storeID: "216")
        Coordinator.goToHotelBookingFlow(controller: base, store_ID: "")
       // Coordinator.goToTrackOrder(controller: base)
    }
    @IBAction func storeAction(_ sender: Any) {
        if (type == 0){
            ShopCoordinator.goToShopProfilePage(controller: base,storeID: "174")
        }else if (type == 1){
            PlayGroundCoordinator.goToBookNow(controller: base, store_ID: "")
        }else if (type == 2){
            Coordinator.goToServices(controller: base, storeID: "")
        }else if (type == 3){
            Coordinator.goToCarBookingFlow(controller: base, store_ID:"")
        }
        else if (type == 4){
            if SessionManager.getUserData()?.user_type_id ?? "" == "2" {
                Coordinator.goToChaletsReservationManagment(controller: base)
            }else {
                Coordinator.goToCharletsList(controller: base)
            }
        }
        else if (type == 5){
            Coordinator.goToHotelBookingFlow(controller: base, store_ID: "")
        }else if (type == 6){
            Coordinator.goToGymList(controller: base, storeID: "")
        }
    }
}

