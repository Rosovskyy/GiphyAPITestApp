//
//  HomeVM.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: HomeVMProtocol {
    
    // MARK: - Properties
    var api: GiphyAPI
    
    let giphsList = BehaviorRelay<[GiphResponse]>(value: [])
    let requestFailure = PublishRelay<Void>()
    
    // MARK: - Initialization
    init(api: GiphyAPI) {
        self.api = api
    }
}

extension HomeViewModel {
    func getGiphByTag(tag: String) {
        api.getGiphByTag(tag: tag, success: { (resp) in
            var giphs = self.giphsList.value
            giphs.insert(resp, at: 0)
            self.giphsList.accept(giphs)
            
            DispatchQueue.main.async {
                DBManager.shared.add(img: GiphRealm(resp: resp))
            }
        }) {
            self.requestFailure.accept(())
        }
    }
    
    func lastGiphGot(giph: GiphRealm) {
        giphsList.accept([GiphResponse(realm: giph)])
    }
    
    func getNumberOfGiphs() -> Int {
        return giphsList.value.count
    }
    
    func getGiphByIndexPath(indexPath: IndexPath) -> GiphResponse {
        return giphsList.value[indexPath.row]
    }
    
    func gifDeleted(indexPath: IndexPath) {
        var gifs = giphsList.value
        gifs.remove(at: indexPath.row)
        giphsList.accept(gifs)
        
        if indexPath.row == 0 {
            if gifs.count > 0 {
                DispatchQueue.main.async {
                    DBManager.shared.add(img: GiphRealm(resp: gifs[0]))
                }
            } else {
                DBManager.shared.deleteAll()
            }
        }
    }
}

