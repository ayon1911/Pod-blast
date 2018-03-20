//
//  EpisodeCell.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 07.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var pubDateLbl: UILabel!
    @IBOutlet weak var podcastTitleLbl: UILabel! {
        didSet{
            podcastTitleLbl.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLbl: UILabel! {
        didSet{
            descriptionLbl.numberOfLines = 2
        }
    }
    
    var episode: Episode! {
        didSet {
            descriptionLbl.text = episode.description
            podcastTitleLbl.text = episode.title
            pubDateLbl.text = dateFormatter(withDate: episode.pubDate)
            
            let url = URL(string: episode.episodeImageUrl?.secureHttps() ?? "")
            episodeImageView.sd_setImage(with: url) 
        }
    }
    func dateFormatter(withDate date: Date) -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMM dd, YYYY"
        let formattedDate = dateFormate.string(from: date)
        return formattedDate
    }
}
