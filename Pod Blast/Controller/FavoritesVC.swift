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
    var podcasts = UserDefaults.standard.savedPodcast()
    fileprivate let cellID = "favoriteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        podcasts = UserDefaults.standard.savedPodcast()
        collectionView?.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    //MARK:- Setup functions
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.2156862745, blue: 0.4901960784, alpha: 1)
        collectionView?.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellID)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handlelongPress))
        collectionView?.addGestureRecognizer(longPress)
    }
    
    //MARK:- handler
    @objc fileprivate func handlelongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let selectedIndexpath = collectionView?.indexPathForItem(at: location) else { return }
        
        
        let alertController = UIAlertController(title: "Remove Podcast? ", message: nil, preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            let selectedPodcast = self.podcasts[selectedIndexpath.item]
            self.podcasts.remove(at: selectedIndexpath.item)
            self.collectionView?.deleteItems(at: [selectedIndexpath])
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
}
//MARK:- CollectionView Cell
extension FavoritesVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? FavoritePodcastCell else { return UICollectionViewCell() }
        
        cell.podcast = self.podcasts[indexPath.item]

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesVC = EpisodesVC()
        episodesVC.podcast = self.podcasts[indexPath.item]
        
        navigationController?.pushViewController(episodesVC, animated: true)
    }
}
//MARK:- CollectionView FlowLayout
extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3  * 16) / 2
        
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}








