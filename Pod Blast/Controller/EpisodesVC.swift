//
//  EpisodesVC.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 07.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesVC: UITableViewController {
    //MARK:- Variables
    fileprivate let CELL_ID = "cellID"
    
    
    var podcast: Podcast? {
        didSet {
            fetchEpisodes()
            navigationItem.title = podcast?.trackName
        }
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        FeedEpisodeService.shared.feedEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptableView()
        setupNavBarButtons()
    }
    
    //MARK:- setupView
    fileprivate func setuptableView() {
        let nidFile = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nidFile, forCellReuseIdentifier: CELL_ID)
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func setupNavBarButtons() {
        let savedPodcast = UserDefaults.standard.savedPodcast()
        //returns nil if the predicate doesnt match the array.
        if savedPodcast.index(where: { $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName}) != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))
//                UIBarButtonItem(title: "Fetched", style: .plain, target: self, action: #selector(handleFetchSavedPodcast))
            ]
        }
    }
    
    //MARK:- handler
    @objc fileprivate func handleSaveFavorite() {
        guard let podcast = podcast else { return }
        //fetch the saved podcast first
        
        
        var listOfPodcast = UserDefaults.standard.savedPodcast()
        listOfPodcast.append(podcast)
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcast)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
        
        showBadgeHighLight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite"), style: .plain, target: nil, action: nil)
    }
    
    @objc fileprivate func handleFetchSavedPodcast() {
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return }
        let savedPodcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]
        savedPodcast?.forEach { (podcast) in
            
        }
    }
    
    fileprivate func showBadgeHighLight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
}

extension EpisodesVC {
    //MARK:- UiTableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]

        let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabbarController?.maximizePlayerDetailsView(episode: episode, playlistEpisodes: self.episodes)
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = #colorLiteral(red: 0.1725490196, green: 0, blue: 0.1176470588, alpha: 1)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? view.center.y : 0
    }
}
