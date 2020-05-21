//
//  UITextField+Done.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addCloseButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.closeButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func closeButtonAction() {
        self.resignFirstResponder()
    }
}
