//
//  Constants.swift
//  TalentBazar
//
//  Created by Muneeb on 05/05/2022.
//


import Foundation
import UIKit
import WebRTCiOSSDK
import FirebaseDatabase


enum MediaType {
    case photo
    case video
    case file
}

struct Media {
    var mediaType: MediaType
    var imageData: UIImage? = nil
    var videoData: Data? = nil
    var videoURL: URL? = nil
    var videoThumbnail: UIImage? = nil
    var fileData: Data? = nil
    var fileURL: URL? = nil
    var mediaID: Int?
    var mediaLink: String?
    var media_Type: Int?
}

var languageBool = false
var placeholderImage: UIImage = UIImage(named: "noData") ?? UIImage()
var sd_PlaceHolder : UIImage = UIImage(named: "placHolder") ?? UIImage()
var cartErrorMessage = "First remove Product or Service from cart after you can book  Event/Package"
var carErrorForProducts = "First remove Events or Packages from cart after you can book  Product/Service"
//var tapLiveKey = "sk_test_1FqNA6Zd9jRz5VJBtS7Qv8mw"
//var tapTestKey = "pk_test_iCpy6rVD3gQEhqTZzcsW8uLH"









class Constants {
    static let shared: Constants = Constants()
   // new base url https://dxbitprojects.com/livemarket/public/api/v1 Rupesh Danish Nasrulla @app dev
    //static let baseURL = "https://jarsite.com/myevents/api/"   https://myevent.ae/
  //  static let baseURL = "https://a2itworld.com/livemarket/public/api/v1" //"https://Jarsite.com/myeventstest/api/"//
    //static let baseURL = "https://dxbitprojects.com/livemarket/public/api/v1"
//    static let baseURL = "https://soouqlive.com/27auo3um/public/api/v1"
    static let baseURL   = "https://soouqlive.com/pa05szr48v/public/api/v1"
//    static let baseURLv2 = "https://soouqlive.com/27auo3um/public/api/v2"
    static let baseURLv2 = "https://soouqlive.com/pa05szr48v/public/api/v2"

    static var deviceType = "iOS"
    var languageBool: Bool = false
    static let headers: [(String, String)] = [
//        ("APP-USER", ""),//lovebake
//        ("APP-PWD" , "")//df014f04b7e13046a2d057c9f2ce3e2b
    ]
    var uploadImageArray:[UIImage] = []
    var uploadVideoArray:[URL] = []
    var lastFeedPost:[PostCollection] = []
    var appliedCoupon:String = ""
    var videoMuted:Bool = false
    var selectedMode:String = ""
    var uploading:Bool = false
    var isCommingFromOrderPopup:Bool = false
    var isDeliveryOrder:Bool = false
    var hasTopNotch:Bool = false
    var isPopupShow:Bool = false
    var isFromFeed:Bool = false
    var searchHashTagText:String = ""
    var navigationConstant:UINavigationController?
    var deletedPostID:String = ""
    var chatBadgeCount:Int = 0
    var chatDelegateCount:Int = 0
    var chatDelegateCountID:[String:Int] = [:]
    var referralCode:String = ""
    var sharedReferralCode:String = ""
    var referralText:String = ""
    var isLiveChannelID:String = ""
    var webRTCClient: AntMediaClient?
    var isAlreadyLive:Bool = false
    var tabbarHeight:CGFloat = 95.0
    static var isBeepPlayed = false

}

enum Config {
    
   ///old key - "AIzaSyDpeMGQV5I2tOkgkUL4TQhdyHIbn68pSF0"
//    static let googleApiKey_ = "AIzaSyD3vBoHrfM_Hz0LPzkJjfwC-EJK6eCEzgo"
   // static let googleApiKey = "AIzaSyDUevmddtT7gawQofFM-OsZOD1PnzMKh80"
//    static let googleSignInClientID_ = "352956133390-u06av643uule4p5eu1n76990uko2uiil.apps.googleusercontent.com"
//    static let googleSignInClientID = "706408135428-p9mlo5rafs5gs3n6a9uuu55t9kqbsh03.apps.googleusercontent.com"

    //static let LliveRTMPUrl = "rtmp://ec2-3-28-222-195.me-central-1.compute.amazonaws.com:1935/live/"
//    static let LliveRTMPUrl_ = "rtmp://635b90d0941c1.streamlock.net:1935/moda-ll-stream/"

    //static let playBackLiveURL = "http://ec2-3-28-222-195.me-central-1.compute.amazonaws.com:1935/live/"
//    static let playBackLiveURL_ = "https://635b90d0941c1.streamlock.net/moda-ll-stream/"

}
enum Constants_scanner {
  static let circleViewAlpha: CGFloat = 0.7
  static let rectangleViewAlpha: CGFloat = 0.3
  static let shapeViewAlpha: CGFloat = 0.3
  static let rectangleViewCornerRadius: CGFloat = 10.0
  static let maxColorComponentValue: CGFloat = 255.0
  static let originalScale: CGFloat = 1.0
  static let bgraBytesPerPixel = 4
}
