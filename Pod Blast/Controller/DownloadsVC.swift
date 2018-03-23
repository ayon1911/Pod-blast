//
//  DownloadVC.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 23.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import UIKit

class DownloadsVC: UITableViewController {
    //MARK:- Variables
    var downloadedEpisodes = UserDefaults.standard.listOfDownloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadedEpisodes = UserDefaults.standard.listOfDownloadedEpisodes().reversed()
        tableView.reloadData()
    }
    
    //MARK:- setup
    fileprivate func setupController() {
        tableView.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.2156862745, blue: 0.4901960784, alpha: 1)
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DOWNCELL_ID)
    }
}
//MARK:- UITAbleView
extension DownloadsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DOWNCELL_ID, for: indexPath) as! EpisodeCell
        cell.episode = self.downloadedEpisodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.downloadedEpisodes[indexPath.row]
        
        UIApplication.mainTabBarController()?.maximizePlayerDetailsView(episode: episode, playlistEpisodes: self.downloadedEpisodes)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let episode = self.downloadedEpisodes[indexPath.row]
        downloadedEpisodes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        UserDefaults.standard.deleteEpisode(episode: episode)
    }
}




