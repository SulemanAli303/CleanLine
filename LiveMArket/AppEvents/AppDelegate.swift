//
//  AppDelegate.swift
//  LiveMArket
//
//  Created by Albin Jose on 31/12/22.
//
import UserNotifications
import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Stripe
import Firebase
import FirebaseCore
import FirebaseMessaging
import Siren
import SocketIO
import AVFAudio
import goSellSDK
import TapApplePayKit_iOS
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var tokenData : Data?
    var deviceTokenStr = ""
    
    var notificationSoundEffect = AVAudioPlayer()
    var getTopViewController: UIViewController? {
         return UIApplication.getTopViewController()
    }
    static weak var appDelegateInstance: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        Constants.shared.sharedReferralCode = ""
        //if SessionManager.getAccessToken() != nil {
            let socket = SocketIOManager.sharedInstance
            socket.establishConnection()
        //}
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        

        GoSellSDK.secretKey = goSellSDK.SecretKey(sandbox: tapLiveKey, production: tapLiveKey)
        GoSellSDK.mode = .sandbox
        TapApplePay.secretKey = .init(sandbox: tapTestKey, production: tapLiveKey)
        TapApplePay.sdkMode = .sandbox

        StripeAPI.defaultPublishableKey = "pk_test_51KdqxdBjsMxFtgBeSKmSXVjwG6yqKIUT89jWGFrZcON2gxqhtfhH6EFSHYVdrqPAU4UxEsIlAUEhnmPAlkvxMkzK0009RlNxWJ"
        STPPaymentConfiguration.shared.publishableKey =
            "pk_test_51KdqxdBjsMxFtgBeSKmSXVjwG6yqKIUT89jWGFrZcON2gxqhtfhH6EFSHYVdrqPAU4UxEsIlAUEhnmPAlkvxMkzK0009RlNxWJ"
        FirebaseApp.configure()
        if  let bundleID = Bundle.main.bundleIdentifier{
            FirebaseOptions.defaultOptions()?.deepLinkURLScheme = bundleID
        }
        GMSPlacesClient.provideAPIKey(Config.googleApiKey)
        GMSServices.provideAPIKey(Config.googleApiKey)
        requestNotificationAuth(application: application)
        forceUpdateSetup()
        
        IQKeyboardManager.shared.enable = true
        if #available(iOS 15.0, *) {
            IQKeyboardManager.shared.disabledDistanceHandlingClasses = [LTChatViewController.self,LiveVC.self,PostCommentVC.self]
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            IQKeyboardManager.shared.disabledToolbarClasses = [LTChatViewController.self,LiveVC.self,PostCommentVC.self]
        } else {
            // Fallback on earlier versions
        }
        if Locale.preferredLanguages.count > 0 {
            if Locale.preferredLanguages[0].count >= 2 {
                let preferredLanguage = Locale.preferredLanguages[0].prefix(2)
                UserDefaults.standard.set(preferredLanguage, forKey: "language")
//                if preferredLanguage == "ar"{
//                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
//                }
                LanguageHandler()
            }
        }
        
        let storyBoard = UIStoryboard(name: "LaunchViewController", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = vc
        
        return true
    }
    
    func LanguageHandler() {
            
            if let languageValue = UserDefaults.standard.object(forKey: "language") as? String{
                if languageValue == "ar"{
                    //Language Setup
                    Live_Market.LanguageManager.shared.defaultLanguage = .ar
                    let language = Live_Market.LanguageManager.shared.currentLanguage.rawValue
                    Live_Market.LanguageManager.shared.setLanguage(language: Languages(rawValue: language) ?? .ar)
                    UserDefaults.standard.set("ar", forKey: "language")
                    languageBool = true
                }else{
                    //Language Setup
                    Live_Market.LanguageManager.shared.defaultLanguage = .en
                    let language = Live_Market.LanguageManager.shared.currentLanguage.rawValue
                    Live_Market.LanguageManager.shared.setLanguage(language: Languages(rawValue: language) ?? .en)
                    UserDefaults.standard.set("en", forKey: "language")
                    languageBool = false
                }
            }else{
                //Language Setup
                Live_Market.LanguageManager.shared.defaultLanguage = .en
                let language = Live_Market.LanguageManager.shared.currentLanguage.rawValue
                Live_Market.LanguageManager.shared.setLanguage(language: Languages(rawValue: language) ?? .en)
                UserDefaults.standard.set("en", forKey: "language")
                languageBool = false
            }
        }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        return true
    }
    
    func forceUpdateSetup() {
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .critical,
                                          showAlertAfterCurrentVersionHasBeenReleasedForDays: 1)
        if languageBool {
            siren.presentationManager = PresentationManager(forceLanguageLocalization: .arabic)
        } else {
            siren.presentationManager = PresentationManager(forceLanguageLocalization: .english)
        }
        siren.wail()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        let socket = SocketIOManager.sharedInstance
        socket.socket.disconnect()
    }
    
    func playBeep(){
        if Constants.isBeepPlayed {
            return 
        }
        if let path = Bundle.main.path(forResource: "sample", ofType:"mp3"){
            let url = URL(fileURLWithPath: path)
            do {
                try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try? AVAudioSession.sharedInstance().setActive(true)
                self.notificationSoundEffect = try AVAudioPlayer(contentsOf: url,fileTypeHint: AVFileType.mp3.rawValue)
                self.notificationSoundEffect.volume = 1.0
                self.notificationSoundEffect.play()
                self.notificationSoundEffect.numberOfLoops = 500
                Constants.isBeepPlayed = true
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
        
    func stopAlaram() {
        Constants.isBeepPlayed = false
        self.notificationSoundEffect.stop()
    }
}

extension AppDelegate:  MessagingDelegate, UNUserNotificationCenterDelegate {
    func requestNotificationAuth(application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // [START set_messaging_delegate]
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("APNs token retrieved: \(deviceToken)")
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        deviceTokenStr = deviceTokenString
        tokenData = deviceToken
        self.updateDeviceToken()
        
    }
    
    func updateDeviceToken()
    {
        UserDefaults.standard.set(deviceTokenStr, forKey: "user_device_token")
        UserDefaults.standard.synchronize()
        Messaging.messaging().apnsToken = tokenData
        print("Token is here   \(String(describing: Messaging.messaging().fcmToken))")
      //  print("Token is here   \(String(describing: Messaging.messaging().apnsToken))")
        if let token = Messaging.messaging().fcmToken {
            SessionManager.setFCMToken(token: token)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        SessionManager.setFCMToken(token: fcmToken ?? "")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        completionHandler(.newData)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

        guard let type = userInfo["type"] as? String else { return }
        switch type.lowercased() {
            case "driver_new_order", "new_order", "new_service_request", "new_chalet_booking", "gym_subscription_completed", "new_gym_subscription", "new_hotel_booking", "new_playground_booking" ,
                "food_new_order", "new_table_booking_placed_store", "deligate_new_order_driver":
                self.playBeep()
            case "deligate_request_accepted_driver",
                "deligate_service_on_the_way_driver" :
                self.playBeep()
            default:
                break
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        if userInfo["type"] as? String == "chat" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "chatBadge"), object: nil)
            if UserDefaults.standard.bool(forKey: "ChatPage") == true{
                return
            }
        } else if userInfo["type"] as? String == "chatDelegate" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "chatDelegate"), object: nil)
            if UserDefaults.standard.bool(forKey: "ChatPage") == true{
                return
            }
        }
        guard let type = userInfo["type"] as? String else { return }
        switch type.lowercased() {
            case "driver_new_order", "new_order", "new_service_request", "new_chalet_booking", "gym_subscription_completed", "new_gym_subscription", "new_hotel_booking", "new_playground_booking",
                "food_new_order", "new_table_booking_placed_store", "deligate_new_order_driver" :
                playBeep()
            default:
                print("Default Case")
        }
//        guard let type = userInfo["type"] as? String else { return }
        //case "driver_new_order","new_order","store_order_payment_completed","order_payment_completed","payment_completed_user","payment_completed","new_service_request","new_gym_subscription","new_chalet_booking" :
        // Utilities.showWarningAlert(message:type )
//        switch type.lowercased() {
//            case "driver_new_order","new_order","store_order_payment_completed" , "new_service_request","payment_completed","new_chalet_booking","gym_subscription_completed","new_gym_subscription","new_hotel_booking", "new_playground_booking" , "reserved_playground_booking","food_new_order", "new_table_booking_placed_store":
//
//                self.playBeep()
//            case "deligate_new_order_driver",
//                "deligate_request_accepted_driver",
//                "deligate_payment_completed_driver",
//                "deligate_service_on_the_way_driver",
//                "deligate_service_completed_driver" :
//                self.playBeep()
//            case "identity_verification":
////                self.handleFaceValidationNotification(userInfo: userInfo)
//            default:
//                break
//        }
        //guard let type = userInfo["type"] as? String else { return }
//        NotificationCenter.default.post(name: Notification.Name("ShowDialogNotification"), object: nil,userInfo: userInfo)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "OrderStatusChanged"), object: userInfo)

        if userInfo["type"] as? String == "chatDelegate" && !SessionManager.isLoggedIn() {
            return
        }
        completionHandler([.alert, .badge, .sound])
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        handleUserNotifications(userInfo: userInfo)
        
        completionHandler()
    }
    func handleUserNotifications(userInfo: [AnyHashable: Any]) {
        
        if SessionManager.isLoggedIn() {

            guard let type = userInfo["type"] as? String else { return }
            switch type.lowercased() {
                case "driver_new_order","new_order", "new_service_request","payment_completed","new_chalet_booking","gym_subscription_completed","new_gym_subscription","new_hotel_booking", "new_playground_booking" , "reserved_playground_booking","food_new_order", "new_table_booking_placed_store":
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    return
                case "deligate_new_order_driver",
                    "deligate_request_accepted_driver",
                    "deligate_payment_completed_driver",
                    "deligate_service_on_the_way_driver",
                    "deligate_service_completed_driver" :
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    return
                case "identity_verification":
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    return
                default:
                    break
            }
                NotificationCenter.default.post(name: Notification.Name("newNotificationClickEvent"), object: nil,userInfo: userInfo)
        }
    }
}
