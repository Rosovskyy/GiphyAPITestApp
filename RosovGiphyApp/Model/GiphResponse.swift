//
//  GiphResponse.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import Foundation

struct GiphResponse {
    let tag: String
    let giphURL: URL
}

extension GiphResponse {
    init?(json: [String: Any], tag: String) {
        guard let images = json["images"] as? [String: Any], let originalGif = images["original"] as? [String: Any], let giphURL = originalGif["url"] as? String else {
            return nil
        }

        self.tag = tag
        self.giphURL = URL(string: giphURL)!
    }
    
    init(realm: GiphRealm) {
        self.tag = realm.tag
        self.giphURL = URL(string: realm.giphURL)!
    }
}
