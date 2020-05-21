//
//  HomeProtocols.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import Foundation
import RxCocoa

protocol HomeRouterProtocol {
    func showFailureAlert()
}

protocol HomeVMProtocol {
    var giphsList: BehaviorRelay<[GiphResponse]> { get }
    var requestFailure: PublishRelay<Void> { get }
    
    func getGiphByTag(tag: String)
    func getLastGifs()
    
    // DataSource
    func getNumberOfGiphs() -> Int
    func getGiphByIndexPath(indexPath: IndexPath) -> GiphResponse
    func gifDeleted(indexPath: IndexPath)
}
