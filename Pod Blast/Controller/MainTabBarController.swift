//
//  MainTabBarController.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 05.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //variables
    let playerDetailsView = PlayerDetailsView.initFromNib()

    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        tabBar.barTintColor = #colorLiteral(red: 0.1725490196, green: 0, blue: 0.1176470588, alpha: 1)
        
        
        setupViewController()
        setupOfPlayerDetailsView()
//        perform(#selector(maximizePlayerDetailsView), with: nil, afterDelay: 1)
    }
        
    @objc func minimizePlayerDetailsView() {
        //animation
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
            
        }) { (success) in
            if success {
                print("Animation was successful")
            }
        }
    }
    
    func maximizePlayerDetailsView(episode: Episode?, playlistEpisodes: [Episode] = []) {
        //animation
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        if episode != nil {
            playerDetailsView.episode = episode
        }
        playerDetailsView.playListEpisodes = playlistEpisodes
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
            
        }) { (success) in
            if success {
                print("Animation was successful")
            }
        }
    }
    
    //MARK:- Setup Function
    fileprivate func setupOfPlayerDetailsView() {
       
//        view.addSubview(playerDetailsView)
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)

        // enabling auto layout
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint.isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
    }
    
    func setupViewController() {
        let layout = UICollectionViewFlowLayout()
        let favoritesVC = FavoritesVC(collectionViewLayout: layout)
        viewControllers = [
            generateNavigationController(with: PodcastsSearchVC(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: favoritesVC, title: "Favorite", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: DownloadsVC(), title: "Download", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    //MARK:- Helper Function
    fileprivate func generateNavigationController(with rootController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootController)
        navController.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navController.navigationBar.tintColor = #colorLiteral(red: 0.1725490196, green: 0, blue: 0.1176470588, alpha: 1)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 28) ?? UIFont.systemFont(ofSize: 28),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
        ]
        rootController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
