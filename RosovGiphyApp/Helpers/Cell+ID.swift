//
//  UITableViewCell+ID.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    static var id: String { get { return String(describing: self) } }
}

