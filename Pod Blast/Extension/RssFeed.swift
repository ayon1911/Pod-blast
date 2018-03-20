//
//  RssFeed.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 08.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import FeedKit

extension RSSFeed {
    func toFeedEpisodes() -> [Episode] {
        
        let podcastImageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]()
        items?.forEach({ (feedItem) in
            
            var episode = Episode(feedItem: feedItem)
            if episode.episodeImageUrl == nil {
                episode.episodeImageUrl = podcastImageUrl
            }
            episodes.append(episode)
        })
        return episodes
    }
}
