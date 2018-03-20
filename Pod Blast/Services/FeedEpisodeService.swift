//
//  FeedEpisodeService.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 08.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import FeedKit

class FeedEpisodeService {
    
    static let shared = FeedEpisodeService()
    
    func feedEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
        let securedFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: securedFeedUrl) else { return }
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            
            parser?.parseAsync(result: { (result) in
                print("succefully parse feed:", result.isSuccess)
                
                if let err = result.error {
                    print("Failed to parse xml feed:", err)
                }
                guard let feed = result.rssFeed else { return }
                let episodes = feed.toFeedEpisodes()
                completionHandler(episodes)
            })
        }
    }
}
