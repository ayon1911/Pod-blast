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
}
