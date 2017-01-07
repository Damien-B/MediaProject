//
//  Server.swift
//  MediaProject
//
//  Created by Clément Peyrabere on 02/12/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import Foundation
import Alamofire

public class Server {
    
    private static var SERVER_BASE_URL: String = "https://clementpeyrabere.net:8003";
    private static var LIST_AUDIO_ROUTE: String = "/list/audio";
    private static var LIST_VIDEO_ROUTE: String = "/list/video";
    private static var UPLOAD_ROUTE: String = "/upload";
    private static var DOWNLOAD_VIDEO_ROUTE: String = "/download/video";
    private static var DOWNLOAD_AUDIO_ROUTE: String = "/download/audio";
    
    public static let shared = Server();
    
    init() {
        
    }
    
    public static func listAudio(_ completion: @escaping (_ error: Bool, _ success: Bool, _ result: [AnyObject]) -> Void) {
        let url: String = SERVER_BASE_URL + LIST_AUDIO_ROUTE;
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if((response.result.error) != nil) {
                completion(true, false, [AnyObject]());
            } else {
                let data = response.result.value as! [AnyObject]
                completion(false, true, data);
            }
            
        }
    }
    
    public static func listVideo(_ completion: @escaping (_ error: Bool, _ success: Bool, _ result: [AnyObject]) -> Void) {
        let url: String = SERVER_BASE_URL + LIST_VIDEO_ROUTE;
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if((response.result.error) != nil) {
                completion(true, false, [AnyObject]());
            } else {
                let data = response.result.value as! [AnyObject]
                completion(false, true, data);
            }
            
        }
    }
    
    public static func downloadAudio(_ songId: String, _ destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequest {
        let url: String = SERVER_BASE_URL + DOWNLOAD_AUDIO_ROUTE + "/" + songId;
    
        return Alamofire.download(url, to: destination);
    }
    
    public static func downloadVideo(_ videoId: String, _ destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequest {
        let url: String = SERVER_BASE_URL + DOWNLOAD_VIDEO_ROUTE + "/" + videoId;
        
        return Alamofire.download(url, to: destination);
    }
    
    public static func uploadVideo(_ videoURL: URL, _ name: String, _ extensionString: String, encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        let url: String = SERVER_BASE_URL + UPLOAD_ROUTE;
    
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(videoURL, withName: "videoname", fileName: "\(name).\(extensionString)", mimeType: "video/quicktime")
            },
            to: url,
            encodingCompletion: encodingCompletion
        )
    }
    
}
