//
//  GiphResponseRealm.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import RealmSwift

class GiphRealm: Object, Encodable {
    
    // MARK: - Properties
    @objc dynamic var id: String = ""
    @objc dynamic var giphURL: String = ""
    @objc dynamic var tag: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(resp: GiphResponse) {
        self.init()
        self.id = "generalId"
        self.giphURL = resp.giphURL.absoluteString
        self.tag = resp.tag
    }
}
