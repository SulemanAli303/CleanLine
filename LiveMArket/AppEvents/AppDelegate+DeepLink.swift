//
//  AppDelegate+DeepLink.swift
//  LiveMArket
//
//  Created by Greeniitc on 09/06/23.
//

import Foundation
import UIKit
import SocketIO
import FirebaseDynamicLinks

extension AppDelegate {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("userActivity loaded")
        
        if let incomingURL = userActivity.webpageURL {
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (link, error) in
                if((error) != nil){
                    return
                }

                if let dynamicLink = link{
                    Coordinator.updateRootVCToTab()
                    DispatchQueue.main.asyncAfter(wallDeadline: .now()) {
                        self.handleIncomingDynamicLink(dynamicLink)
                    }
                }

            }
            if(linkHandled){
                return true
            }else{
                return false
            }
        }
        return false
        
        let home = BaseViewController()
        
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
////            let socket = SocketIOManager.sharedInstance
////            socket.establishConnection()
//            guard let url = userActivity.webpageURL else { return false }
//            print(url.absoluteString)
//            Coordinator.updateRootVCToTab()
//            //handle url and open whatever page you want to open.
//            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3.0) {
//                self.handleUrlFromDeepLink(urlString: url.absoluteString)
//            }
//        }
//
//        return false
    }
    
    func handleIncomingDynamicLink(_ dynamicLink : DynamicLink){
        print(dynamicLink)
        print("=====================")
        print(dynamicLink.url)
        guard let url = dynamicLink.url else{
            
            return
        }
        
        let urlStr = url.absoluteString
        let urlComponents = URLComponents(string: urlStr)
        if let queryItems = urlComponents?.queryItems {
            var type = ""
            var id = ""
            for queryItem in queryItems {
                if queryItem.name == "type" {
                    type = queryItem.value ?? ""
                }
                if queryItem.name == "id" {
                    id = queryItem.value ?? ""
                }
            }
            
//            let serviceDetails:[String:String?] = ["serviceId" : id,"serviceName":type]
//            NotificationCenter.default.post(name: Notification.Name("newUserActivityLoaded"), object: nil,userInfo: serviceDetails as [AnyHashable : Any])
            
            if type == "profile"{
               // guard let profileID = id else { return }
//                let  VC = AppStoryboard.ISellerOrder.instance.instantiateViewController(withIdentifier: "ISellerOrderViewController") as! ISellerOrderViewController
//                VC.storeID = id
//                UIApplication.shared.windows.first?.rootViewController = VC
//                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
                let serviceDetails:[String:String?] = ["serviceId" : id,"serviceName":type]
                NotificationCenter.default.post(name: Notification.Name("newUserActivityLoaded"), object: nil,userInfo: serviceDetails as [AnyHashable : Any])
                
            }else if type == "referralCode"{
                
                 let serviceDetails:[String:String?] = ["serviceId" : id,"serviceName":type]
                 NotificationCenter.default.post(name: Notification.Name("newUserActivityLoaded"), object: nil,userInfo: serviceDetails as [AnyHashable : Any])
                 
            }else if type == "homePost"{
                //guard let postID = id else { return }
                let  VC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "PostListViewController") as! PostListViewController
                VC.currentPostID = id
                VC.isFromProfile = false
                UIApplication.shared.windows.first?.rootViewController = VC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }else{
                
            }
        }
    }
    
    func handleUrlFromDeepLink(urlString:String) {
        let replaced = urlString.replacingOccurrences(of: "https://", with: "")
        let Wreplaced = replaced.replacingOccurrences(of: "http://", with: "")
        let urlString = Wreplaced.components(separatedBy: "/")
        if urlString.count >= 2 {
            let contentArray = urlString.suffix(2)
            let serviceName = contentArray.first
            let serviceId = contentArray.last
            let serviceDetails:[String:String?] = ["serviceId" : serviceId,"serviceName":serviceName]
            NotificationCenter.default.post(name: Notification.Name("newUserActivityLoaded"), object: nil,userInfo: serviceDetails as [AnyHashable : Any])
        }
    }
}
