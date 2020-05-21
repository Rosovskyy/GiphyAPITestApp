//
//  GiphCell.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import UIKit
import SDWebImage
import EasySwiftLayout

class GiphCell: UICollectionViewCell {
    
    // MARK: - Properties
    var giphResponse: GiphResponse? {
        didSet {
            guard let resp = self.giphResponse else { return }
            pictureImageView.backgroundColor = .white
            pictureImageView.sd_setImage(with: resp.giphURL, placeholderImage: #imageLiteral(resourceName: "no-photo-available"), options: [.waitStoreCache]) { (image, _, _, _) in
            }
        }
    }
    
    // MARK: - Delegates
    var didGifDeleted: ((Void) -> Void)?
    
    // MARK: - Views
    let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupUI() {
        
        pictureImageView
            .add(toSuperview: self)
            .pinEdgesToSuperview()
        
        closeButton
            .add(toSuperview: self)
            .pin(topTo: self.topAnchor, leftTo: nil, bottomTo: nil, rightTo: self.rightAnchor, withInsets: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 6), priority: UILayoutPriority(1000))
            .width(24)
            .height(24)
        
        closeButton.addTarget(self, action: #selector(deleteGifTapped), for: .touchUpInside)
    }
    
    // MARK: - OBJcActions
    @objc func deleteGifTapped() {
        self.didGifDeleted?(())
    }
}
