//
//  MainContext.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class MainContext {
    static let shared = MainContext()
    
    private var currentContext = Container()
    
    func createContext() -> Container {
        let context = Container()
        
        //Service
        context.register(GiphyAPI.self) { _ in GiphyAPI() }
        
        //Router
        context.register(HomeRouter.self) { _ in HomeRouter() }
        
        //ViewModel
        context.register(HomeViewModel.self) { r in
            let vm = HomeViewModel(
                api: r.resolve(GiphyAPI.self)!
            )
            return vm
            }.inObjectScope(.container)

        //View
        context.storyboardInitCompleted(HomeViewController.self) { r, c in
            let router = r.resolve(HomeRouter.self)
            let vm = r.resolve(HomeViewModel.self)
            router?.viewController = c
            c.viewModel = vm
            c.router = router
        }
        
        self.currentContext = context
        return context
    }
    
    var context: Container {
        get {
            return self.currentContext
        }
    }
}


