//
//  LivePostAPIManager.swift
//  LiveMArket
//
//  Created by Ramamoorthy on 09/06/23.
//

import Foundation
import Alamofire

class LivePostAPIManager {
    
    struct LivePostConfig: UploadAPIConfiguration {
        var images: [String : [UIImage?]]
        var uploadImages: [BBMedia]
        var documents: [String : [UploadMedia?]]
        
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/start_live"
    }
    
    public class func liveStartAPI(image: UIImage,parameters: [String: String], completionHandler : @escaping(_ result: StartLive_Base) -> Void) {
        var config = LivePostConfig(images: ["thumb_image": [image]], uploadImages: [], documents: [:])
        config.parameters = parameters
        APIClient.multiPartRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(StartLive_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    struct StopLiveConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/stop_recording"
    }
    
    public class func liveStopAPI(parameters: [String: String], completionHandler : @escaping(_ result: LiveModel_Base) -> Void) {
        var config = StopLiveConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(LiveModel_Base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    struct DiscardLiveVideoConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/discard_share"
    }
    
    public class func discardLiveVideoAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = DiscardLiveVideoConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
}
