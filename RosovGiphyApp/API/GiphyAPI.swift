//
//  GiphyAPI.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 20.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import Foundation

class GiphyAPI {
    
    // Singleton
    static let shared = GiphyAPI()
    
    // MARK: - Properties
    private var dataTask: URLSessionDataTask?
    
    fileprivate let baseUrl = "http://api.giphy.com/v1/gifs/search"
    fileprivate let token = "TQ49Iozhk1rdpArk68uThhC7QyRu3Q5K"
    fileprivate let limit = 5
     
    func getGiphByTag(tag: String, success: @escaping (GiphResponse) -> (), failure: @escaping () -> ()) {
        let path = baseUrl + "?api_key=\(token)&limit=\(limit)&q=\(tag)".replacingOccurrences(of: " ", with: "%20")
        
        guard let url = URL(string: path) else { return }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForResource = 8
        let session = URLSession(configuration: sessionConfig)
        
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            defer {
              self?.dataTask = nil
            }
            
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let result = (json["data"] as! [AnyObject]).randomElement() {
                    print(result)
                    if let giphResponse = GiphResponse(json: result as! [String: Any], tag: tag) {
                        success(giphResponse)
                    } else {
                        failure()
                    }
                } else {
                    failure()
                }
            } else {
                failure()
            }
        }
        dataTask?.resume()
    }
}

