//
//  GifStorageManager.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import Foundation
import UIKit

final class GifStorageManager {
    
    static let shared = GifStorageManager()
    
    // This functions were got from https://programmingwithswift.com/save-images-locally-with-swift-5/
    func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key)
    }
    
    func store(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.sd_imageData() {
            if let filePath = filePath(forKey: key) {
                do {
                    try pngRepresentation.write(to: filePath, options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
    
    func retrieveImage(forKey key: String) -> UIImage? {
        if let filePath = self.filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
}
