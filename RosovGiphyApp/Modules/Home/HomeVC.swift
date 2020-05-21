//
//  HomeVC.swift
//  RosovGiphyApp
//
//  Created by Serhiy Rosovskyy on 21.05.2020.
//  Copyright © 2020 Serhiy Rosovskyy. All rights reserved.
//

import UIKit
import NSObject_Rx
import MBProgressHUD

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: HomeVMProtocol?
    var router: HomeRouterProtocol?
        
    // MARK: - Views
    private let searchTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Type tag here"
        textField.borderStyle = .line
        textField.returnKeyType = .done
        textField.textColor = .white
        return textField
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let gifsLabel: UILabel = {
        let label = UILabel()
        label.text = "Gifs:"
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private let enterTagLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the tag:"
        label.textColor = .white
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupUI()
        prepareBind()
    }
    
    // MARK: - Private
    private func setupUI() {
        
        // View
        view.backgroundColor = .blackBackground
        
        // Delegates
        searchTextField.addCloseButtonOnKeyboard()
        searchTextField.delegate = self
        
        // TableView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GiphCell.self, forCellWithReuseIdentifier: GiphCell.id)
        
        // Data
        viewModel?.getLastGifs()
    }
    
    private func setupViews() {
        
        enterTagLabel
            .add(toSuperview: view)
            .pin(topTo: view.topAnchor, leftTo: view.leftAnchor, bottomTo: nil, rightTo: nil, withInsets: UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 0), priority: UILayoutPriority(1000))
        
        searchTextField
            .add(toSuperview: view)
            .pin(topTo: enterTagLabel.bottomAnchor, leftTo: enterTagLabel.leftAnchor, bottomTo: nil, rightTo: view.rightAnchor, withInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 20), priority: UILayoutPriority(1000))
        
        gifsLabel
            .add(toSuperview: view)
            .pin(topTo: searchTextField.bottomAnchor, leftTo: enterTagLabel.leftAnchor, bottomTo: nil, rightTo: nil, withInsets: UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0), priority: UILayoutPriority(1000))
        
        collectionView
            .add(toSuperview: view)
            .pin(topTo: gifsLabel.bottomAnchor, leftTo: view.leftAnchor, bottomTo: view.bottomAnchor, rightTo: view.rightAnchor, withInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), priority: UILayoutPriority(1000))
    }
    
    private func prepareBind() {
        viewModel?.giphsList.bind { [weak self] _ in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self!.view, animated: true)
                self?.collectionView.reloadData()
                
                self?.gifsLabel.isHidden = !((self?.viewModel?.getNumberOfGiphs() ?? 0) > 0)
            }
        }.disposed(by: rx.disposeBag)
        
        viewModel?.requestFailure.bind { [weak self] _ in
            self?.router?.showFailureAlert()
        }.disposed(by: rx.disposeBag)
    }
}

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getNumberOfGiphs() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiphCell.id, for: indexPath) as! GiphCell
        
        cell.giphResponse = viewModel?.getGiphByIndexPath(indexPath: indexPath)
        cell.didGifDeleted = { [weak self] _ in
            self?.viewModel?.gifDeleted(indexPath: indexPath)
        }
        
        return cell
    }
    
    //FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.row % 5 == 0) || ((indexPath.row - 1) % 5 == 0) || ((indexPath.row - 2) % 5 == 0) {
            return CGSize(width: self.collectionView.frame.size.width / 3 ,height: self.collectionView.frame.size.width / 3)
        } else {
            if indexPath.row % 2 == 1 {
                return CGSize(width: self.collectionView.frame.size.width / 3 * 2 ,height: self.collectionView.frame.size.width / 3 * 2)
            } else {
                return CGSize(width: self.collectionView.frame.size.width / 3,height: self.collectionView.frame.size.width / 3 * 2)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - TextField
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel?.getGiphByTag(tag: text)
        
        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
}
