//
//  APIConfiguration.swift
//  OneRoad
//
//  Created by Rameshwar Kumavat on 04/01/22.
//

import Foundation

import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var url: URL { get }
    var parameters: [String: String] { get }
    var headers: HTTPHeaders { get }
}

protocol UploadAPIConfiguration: APIConfiguration {
    var images: [String: [UIImage?]] { get set }
    var uploadImages: [BBMedia] { get set }
    var documents: [String: [UploadMedia?]] { get set }
}

protocol AddPostUploadAPIConfiguration: APIConfiguration {
    var images: [String: [UIImage?]] { get set }
    var firstImages: [String: [UIImage?]] { get set }
    var uploadImages: [BBMedia] { get set }
    var documents: [String: [UploadMedia?]] { get set }
}

protocol AddPostVideoUploadAPIConfiguration: APIConfiguration {
    var images: [String: [URL?]] { get set }
    var firstImages: [String: [URL?]] { get set }
    var uploadImages: [BBMedia] { get set }
    var documents: [String: [UploadMedia?]] { get set }
}
protocol UploadAPIConfiguration_Video: APIConfiguration {
    var images: [String: [UIImage?]] { get set }
    var uploadImages: [BBMedia] { get set }
    var documents: [String: [UploadMedia?]] { get set }
}
protocol UploadMediaAPIConfiguration: APIConfiguration {
    var images: [String: [UIImage?]] { get set }
    var uploadImages: [BBMedia] { get set }
    var documents: [String: [UploadMedia?]] { get set }
}
protocol UploadDocsAPIConfiguration: APIConfiguration {
    var images: [String: [UIImage?]] { get set }
    var documents: [String: [Data?]] { get set }
}
protocol KeyValuePairAPIConfiguration: APIConfiguration {
    var keyValues: KeyValuePairs<String, String> { get }
}
struct UploadMedia {
    let data: Data?
    let mimeType: String?
}
extension APIConfiguration {
    var headers: HTTPHeaders {
        var tempHeaders: HTTPHeaders = HTTPHeaders()
        for (field, value) in Constants.headers {
            tempHeaders.add(HTTPHeader(name: field, value: value))
        }
        return tempHeaders
    }
    
    var url: URL {
        let baseURL = URL(string: Constants.baseURL)!
        return baseURL.appendingPathComponent(path)
    }
    var urlv2: URL {
        let baseURL = URL(string: Constants.baseURLv2)!
        return baseURL.appendingPathComponent(path)
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseURL = URL(string: Constants.baseURL)!

        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        Constants.headers.forEach { (field, value) in
            urlRequest.addValue(value, forHTTPHeaderField: field)
        }

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            throw AFError.parameterEncoderFailed(reason: AFError.ParameterEncoderFailureReason.encoderFailed(error: error))
        }

        return urlRequest
    }
}
