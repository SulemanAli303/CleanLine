//
//  SocketIOManager.swift
//  LiveMArket
//
//  Created by Greeniitc on 02/06/23.
//

import UIKit
import Foundation
import SocketIO

struct PostRequestModel : SocketData {
    let userId: String
    let page: Int
    let limitPerPage: Int
    let lastFetechedPostDateTime: String
    
    func socketRepresentation() -> SocketData {
        return ["userId": userId, "currentPage": page, "limitPerPage": limitPerPage, "lastFetechedPostDateTime": lastFetechedPostDateTime] as [String : Any]
    }
}
struct LiveListRequestModel : SocketData {
    let userId: String
    let pageOffSet: Int
    let limitPerPage: Int
    let isAdmin : String
    
    func socketRepresentation() -> SocketData {
        return ["userId": userId, "limitPerPage": limitPerPage, "pageOffset": pageOffSet , "isAdmin":isAdmin] as [String : Any]
    }
}
struct ForYouPostsRequestModel : SocketData {
    let userId: String
    let page: Int
    let limitPerPage: Int
    
    func socketRepresentation() -> SocketData {
        return ["userId": userId, "currentPage": page, "limitPerPage": limitPerPage] as [String : Any]
    }
}
//// live
struct CreateLiveViewCountModel : SocketData {
    let storyId : String
    let userId : String
    
    func socketRepresentation() -> SocketData {
        return ["storyId": storyId, "userId": userId] as [String : Any]
    }
}
struct GetLiveViewCountModel : SocketData {
    let storyId : String
    let limitPerPage : Int
    let offset : Int
    
    func socketRepresentation() -> SocketData {
        return ["storyId": storyId, "limitPerPage": limitPerPage,"offset" : offset] as [String : Any]
    }
}

struct CreateStoryCommentModel : SocketData {
    let storyId : String
    let userId : String
    let comment : String
    
    func socketRepresentation() -> SocketData {
        return ["storyId": storyId, "userId": userId, "comment" : comment] as [String : Any]
    }
}
struct GetStoryCommentModel : SocketData {
    let storyId : String
    let limitPerPage : Int
    let offset : Int
    
    func socketRepresentation() -> SocketData {
        return ["storyId": storyId, "limitPerPage": limitPerPage, "offset" : offset] as [String : Any]
    }
}
struct MarkLiveStartModel : SocketData {
    let storyId : String
    
    func socketRepresentation() -> SocketData {
        return ["storyId": storyId] as [String : Any]
    }
}
struct EndLiveViewModel : SocketData {
    let storyId : String
    let userId : String
    
    func socketRepresentation() -> SocketData {
        return ["storyId": storyId,"userId" : userId] as [String : Any]
    }
}
private var _SingletonSharedSocket:SocketIOManager! = SocketIOManager()

class SocketIOManager: NSObject {
    
    class var sharedInstance : SocketIOManager { //Singleton Instance
        
        if _SingletonSharedSocket == nil {
            _SingletonSharedSocket = SocketIOManager()
            return _SingletonSharedSocket
        }
        
        return _SingletonSharedSocket
    }
    
    private var accessToken : String? {
        get{
            return SessionManager.getAccessToken()
        }
    }
    
    // static let sharedInstance = SocketIOManager()
    private var manager : SocketManager!
    
    public var socket:SocketIOClient!
    var getInitialPost:((Any) -> ())?
    public var subject : Observable<Any>!
    public var newPost : Observable<[Post]> = Observable(value: []) //2
    
    override init() {
        super.init()
        print("TOOKK \(accessToken ?? "0")")
        manager = SocketManager(socketURL: URL(string: "http://soouqlive.com:8080")!,config: [.log(false),.connectParams(["token":"\(accessToken ?? "0")"]), .compress, .forceWebsockets(true)]) //.forceWebsockets(true)
        self.socket = manager.defaultSocket;
        self.subject = Observable(value: nil)
        //        socket.joinNamespace("/swift") // Create a socket for the /swift namespac
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected \(data)")
            //  self.getInitialPost?(data)
            self.subject.notifySocketConnect()
            self.observeNewPost()
        }
        self.socket.on(clientEvent: .error) {data, ack in
            print("error connected \(data)")
        }
        self.socket?.on(clientEvent: .disconnect){data, ack in
            print("disconnect")
        }
        
        //self.socket.status == .connected
    }
    
    
    func resetSocket() {
        _SingletonSharedSocket = nil
        // sharedInstance = nil
    }
    deinit {
        print("deinit singleton")
    }
    
    
    func establishConnection() {
        socket.connect()  //connect(withPayload: ["query":"token=" + "\(accessToken ?? "0")"])
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    var fetchHomeId : UUID?
    var fetchForYouID : UUID?
    
    func resetOperations(){
        if let fetchHomeId = fetchHomeId {
            self.socket.off(id: fetchHomeId)
        }
        if let fetchForYouID = fetchForYouID {
            self.socket.off(id: fetchForYouID)
        }
    }
    
    func getOnlineUsers(request:PostRequestModel, completionHandler:@escaping([Any])->()){
        self.socket.emit("getHomeTimeline",request)
        fetchHomeId = self.socket.once("observeHomeTimeline") {data, ack in
          //  print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
        
    }
    
    func getLiveStremList(request:LiveListRequestModel, completionHandler:@escaping([Any])->()){
        self.socket.emit("getLiveStreams",request)
        self.socket.once(
            "observeLivestreams") {data, ack in
           // print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
        
    }
    
    func observeNewPost() {
        self.socket.on("onPostSave") {data, ack in
            print("DATANEWPOSR \(data)")
            
            guard let dict = data[0] as? [String:Any] else {return}
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let decoder = JSONDecoder()
                if let decodedPost:FeedPost_Base = try? decoder.decode(FeedPost_Base.self, from: json){
                    self.newPost.notifyNewPost(post: [decodedPost])
                }
            } catch {
                print(error.localizedDescription)
            }
        };
    }
    
    func getPublicPost(parameter: [String:Any]) {
        socket.emit("getPublicPosts", parameter)
    }
    
    func getPublicPosts(request:[String:Any], completionHandler:@escaping([Any])->()){
        self.socket.emit("getPublicPosts",request)
        self.socket.once("observePublicPosts") {data, ack in
            //print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func getPostComments(request:[String:Any], completionHandler:@escaping([Any])->()){
        self.socket.emit("getPostComments",request)
        self.socket.once("observePostComments") {data, ack in
         //   print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func getUserPosts(request:[String:Any], completionHandler:@escaping([Any])->()){
        self.socket.emit("getUserPosts",request)
        self.socket.once("observeUserPosts") {data, ack in
            //print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func getSinglePosts(request:[String:Any], completionHandler:@escaping([Any])->()){
        self.socket.emit("getPost",request)
        self.socket.once("observePost") {data, ack in
          //  print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func searchPublicPosts(request:[String:Any], completionHandler:@escaping([Any])->()){
        self.socket.emit("searchPublicPosts",request)
        self.socket.once("observeSearchPublicPosts") {data, ack in
         //   print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func updateDriverLocations(request:[String:Any], completionHandler:@escaping([Any])->()){
           self.socket.emit("updateUserLocation",request)
           self.socket.once("observeUpdateUserLocation") {data, ack in
         //      print("DATAARRAy \(data as NSArray)")
               completionHandler(data)
           };
       }
    
    ////Live
    func UpdateLiveViewCount(request:CreateLiveViewCountModel, completionHandler:@escaping([Any])->()){
        self.socket.emit("createStoryView",request)
        self.socket.once("observeCreateStoryView") {data, ack in
          //  print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    func GetAllLiveViewCount(request:GetLiveViewCountModel, completionHandler:@escaping([Any])->()){
        self.socket.emit("getStoryViews",request)
        self.socket.once("observeStoryViews") {data, ack in
           // print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func CreateLiveComments(request:CreateStoryCommentModel, completionHandler:@escaping([Any])->()){
        self.socket.emit("createStoryComment",request)
        self.socket.once("observeCreateStoryComment") {data, ack in
         //   print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    func GetAllLiveComments(request:GetStoryCommentModel, completionHandler:@escaping([Any])->()){
        self.socket.emit("getStoryComments",request)
        self.socket.once("observeStoryComments") {data, ack in
         //   print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func MarkLiveStart(request:MarkLiveStartModel, completionHandler:@escaping([Any])->()){
        self.socket.emit("markLivestreamAsLive",request)
        self.socket.once("observeMarkLivestreamAsLive") {data, ack in
         //   print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    func EndLiveView(request:EndLiveViewModel, completionHandler:@escaping([Any])->()){
        self.socket.emit("removeStoryView",request)
        self.socket.once("observeRemoveStoryView") {data, ack in
            completionHandler(data)
        };
    }
    //// common observers
    func GetLiveComment(completionHandler:@escaping([Any])->()){
        self.socket.on("observeStoryComment") {data, ack in
          //  print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func GetLiveViewCount (completionHandler:@escaping([Any])->()){
        self.socket.on("observeStoryViewCount") {data, ack in
         //   print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func ObserveEndStream(completionHandler:@escaping([Any])->()){
        self.socket.on("observeEndStreamNotification") {data, ack in
            //print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
    func ObserveStartStream(completionHandler:@escaping([Any])->()){
        self.socket.on("observeStartStreamNotification") {data, ack in
          //  print("DATAARRAy \(data as NSArray)")
            completionHandler(data)
        };
    }
    
}



