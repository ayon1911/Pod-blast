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
    }
    
    //MARK:- setupTableView
    fileprivate func setuptableView() {
        let nidFile = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nidFile, forCellReuseIdentifier: CELL_ID)
        tableView.tableFooterView = UIView()
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
//        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? view.center.y : 0
    }
}
