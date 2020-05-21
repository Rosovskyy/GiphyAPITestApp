//
//  DBManager.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    
    private (set) var database: Realm
    static let shared = DBManager()
    
    init() {
        database = try! Realm()
    }
    
    func addData(object: Object) {
        do {
            try database.write {
                database.add(object)
            }
        } catch {
            print("DBManager add object ERROR!")
        }
    }
    
    func add(img: GiphRealm) {
        self.addData(object: img)
    }

    func delete(giph: GiphRealm) {
        let results = database.object(ofType: GiphRealm.self, forPrimaryKey: giph.id)
        if let res = results {
            try? database.write ({
                database.delete(res)
            })
        }
    }
    
    func getDataFromDB<T: Object>(with type: T.Type) -> Results<T> {
        let results: Results<T> = database.objects(type.self)
        return results
    }
    
    func deleteDataFromDB<T: Object>(with type: T.Type) {
        let results: Results<T> = database.objects(type.self)
        try? database.write {
            database.delete(results)
        }
    }
    
    func deleteAll() {
        try? database.write {
            database.deleteAll()
        }
    }
}
