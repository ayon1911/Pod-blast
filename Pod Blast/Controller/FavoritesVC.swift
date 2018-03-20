//
//  FavouritesVC.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 20.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class FavoritesVC: UICollectionViewController {
    
    //MARK:- Variables
    fileprivate let cellID = "favoriteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //MARK:- Setup functions
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.2156862745, blue: 0.4901960784, alpha: 1)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
}
//MARK:- CollectionView Cell
extension FavoritesVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.7058823529, blue: 0.2, alpha: 1)
        return cell
    }
}
//MARK:- CollectionView FlowLayout
extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3  * 16) / 2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}








