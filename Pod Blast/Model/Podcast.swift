//
//  Podcast.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 06.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}

