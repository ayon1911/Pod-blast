//
//  PodcastCell.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 06.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var trackLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var episodeLbl: UILabel!
    
    var podcast: Podcast! {
        didSet {
            trackLbl.text = podcast.trackName
            artistLbl.text = podcast.artistName
            episodeLbl.text = "\(podcast.trackCount ?? 0) Episodes"
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            
            podcastImage.sd_setImage(with: url, completed: nil)
        }
    }
}
