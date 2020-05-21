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
    private var api: GiphyAPI
    
    let giphsList = BehaviorRelay<[GiphResponse]>(value: [])
    let requestFailure = PublishRelay<Void>()
    
    // MARK: - Initialization
    init(api: GiphyAPI) {
        self.api = api
    }
    
    // MARK: - Private
    private func lastGiphGot(giphList: [GiphRealm]) {
        let gifs = giphList.map { GiphResponse(realm: $0) }
        giphsList.accept(gifs)
    }
}

// MARK: - Protocol
extension HomeViewModel {
    func getGiphByTag(tag: String) {
        if !tag.isAlphanumeric {
            requestFailure.accept(())
            return
        }
        
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

    func getLastGifs() {
        let lastGiph = DBManager.shared.getDataFromDB(with: GiphRealm.self)
        lastGiphGot(giphList: Array(lastGiph))
    }
    
    func getNumberOfGiphs() -> Int {
        return giphsList.value.count
    }
    
    func getGiphByIndexPath(indexPath: IndexPath) -> GiphResponse {
        return giphsList.value[indexPath.row]
    }
    
    func gifDeleted(indexPath: IndexPath) {
        var gifs = giphsList.value
        DBManager.shared.delete(giph: GiphRealm(resp: gifs[indexPath.row]))
        gifs.remove(at: indexPath.row)
        giphsList.accept(gifs)
    }
}

