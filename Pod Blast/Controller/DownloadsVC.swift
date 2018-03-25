//
//  DownloadVC.swift
//  Pod Blast
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
        
        setupObservers()
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
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress) , name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadProgressComplete, object: nil)
    }
    
    @objc func handleDownloadProgress(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        
        guard let index = self.downloadedEpisodes.index(where: { $0.title == title }) else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
        cell.progressLbl.isHidden = false
        cell.progressLbl.text = "\(Int(progress * 100))%"
        
        if progress == 1 {
            cell.progressLbl.isHidden = true
        }
    }
    
    @objc func handleDownloadComplete(notification: Notification) {
        guard let downloadCompleObjc = notification.object as? DownloadService.downloadCompletedTuple else { return }
        guard let index = self.downloadedEpisodes.index(where: { $0.title == downloadCompleObjc.title }) else { return }
        self.downloadedEpisodes[index].fileUrl = downloadCompleObjc.fileUrl
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .downloadProgressComplete, object: nil)
        NotificationCenter.default.removeObserver(self, name: .downloadProgress, object: nil)
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
        if episode.fileUrl != nil {
            UIApplication.mainTabBarController()?.maximizePlayerDetailsView(episode: episode, playlistEpisodes: self.downloadedEpisodes)
        } else {
            alertIfFileUrlIsInvalid(episode: episode)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let episode = self.downloadedEpisodes[indexPath.row]
        downloadedEpisodes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        UserDefaults.standard.deleteEpisode(episode: episode)
    }
    
    fileprivate func alertIfFileUrlIsInvalid(episode: Episode) {
        let alertController = UIAlertController(title: "Failed to play audio", message: "The downloaded file is invalid please select to play audio from internet", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            UIApplication.mainTabBarController()?.maximizePlayerDetailsView(episode: episode, playlistEpisodes: self.downloadedEpisodes)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}




