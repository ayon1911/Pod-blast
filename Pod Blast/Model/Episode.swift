//
//  Episode.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 07.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable {
    let title: String
    let auther: String
    let pubDate: Date
    let description: String
    let streamUrl: String
    
    var fileUrl: String?
    var episodeImageUrl: String?
    
    
    init(feedItem: RSSFeedItem) {
        
        self.title = feedItem.title ?? ""
        self.auther = feedItem.iTunes?.iTunesAuthor ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description?.convertHtml().string ?? ""
        self.episodeImageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
