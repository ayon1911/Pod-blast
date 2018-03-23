//
//  UserDefaultsExt.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 21.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcast"
    static let downloadedEpisodeKey = "downloadedEpisodeKey"
    
    func savedPodcast() -> [Podcast] {
        guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        guard let savedPodcast = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastData) as? [Podcast] else { return [] }
        return savedPodcast
    }
    
    func deletePodcast(podcast: Podcast) {
        let favPodcast = savedPodcast()
        let filteredPodcast = favPodcast.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcast)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }
    
    func downloadEpisode(episode: Episode) {
        do {
            var downloadedEpisode = listOfDownloadedEpisodes()
            downloadedEpisode.append(episode)
            let data = try JSONEncoder().encode(downloadedEpisode)
            
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
        } catch let err {
            debugPrint(err as Any)
        }
    }
    
    func listOfDownloadedEpisodes() -> [Episode] {
        guard let episodeData = data(forKey: UserDefaults.downloadedEpisodeKey) else { return [] }
        do {
            let decodedEpisodeData = try JSONDecoder().decode([Episode].self, from: episodeData)
            return decodedEpisodeData
        } catch let err {
            debugPrint(err as Any)
        }
       return []
    }
    
    func deleteEpisode(episode: Episode) {
        let listOfEpisodes = listOfDownloadedEpisodes()
        let filteredEpisodes = listOfEpisodes.filter { (e) -> Bool in
            return e.auther != episode.auther && e.title != episode.title
        }
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
        } catch let err {
            debugPrint(err as Any)
        }
    }
}
