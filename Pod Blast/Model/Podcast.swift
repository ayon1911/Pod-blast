//
//  Podcast.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 06.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation

class Podcast: NSObject, Decodable, NSCoding {
    //MARK:- Variables
    fileprivate let trackNameKey = "trackNameKey"
    fileprivate let artistNameKey = "artistNameKey"
    fileprivate let artworkUrl600Key = "artworkUrl600Key"
    fileprivate let feedUrlKey = "feedUrlKey"
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    //MARK:- stubs
    func encode(with aCoder: NSCoder) {
       aCoder.encode(trackName ?? "", forKey: trackNameKey)
        aCoder.encode(artistName ?? "", forKey: artistNameKey)
        aCoder.encode(artworkUrl600 ?? "", forKey: artworkUrl600Key)
        aCoder.encode(feedUrl, forKey: feedUrlKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.trackName = aDecoder.decodeObject(forKey: trackNameKey) as? String
        self.artistName = aDecoder.decodeObject(forKey: artistNameKey) as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: artworkUrl600Key) as? String
        self.feedUrl = aDecoder.decodeObject(forKey: feedUrlKey) as? String
    }  
}

