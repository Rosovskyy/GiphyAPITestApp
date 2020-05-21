//
//  HomeRouter.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import UIKit
import MBProgressHUD

final class HomeRouter {
    
    weak var viewController: UIViewController?
    
    deinit {
        print("deinit HomeRouter")
    }
}

extension HomeRouter: HomeRouterProtocol {
    func showFailureAlert() {
        let alert = UIAlertController(title: "Some troubles..", message: "Couldn't find the gif :(", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.viewController!.view, animated: true)
            self.viewController?.present(alert, animated: true)
        }
    }
}
