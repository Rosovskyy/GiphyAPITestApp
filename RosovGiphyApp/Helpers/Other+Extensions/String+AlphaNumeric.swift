//
//  String+AlphaNumeric.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import Foundation

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
