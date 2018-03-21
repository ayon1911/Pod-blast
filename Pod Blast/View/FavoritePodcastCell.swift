//
//  FavoritePodcastCell.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 21.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import SDWebImage

class FavoritePodcastCell: UICollectionViewCell {
    
    //MARK:- Variables

    let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    
    
    let podcastLbl = UILabel()
    let airtistLbl = UILabel()
    
    var podcast: Podcast! {
        didSet {
            podcastLbl.text = podcast.trackName
            airtistLbl.text = podcast.artistName
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            imageView.sd_setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        podcastLbl.text = "Podcast Name"
        airtistLbl.text = "Artist Name"
        stylizeUI()
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FavoritePodcastCell {
    //MARK:- setup views
    func setupStackView() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView,podcastLbl, airtistLbl])
        stackView.axis = .vertical
        //enabling auto layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func stylizeUI() {
        podcastLbl.font = UIFont(name: "AvenirNext-Medium", size: 16)
        airtistLbl.font = UIFont(name: "AvenirNext-Demibold", size: 14)
        podcastLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        airtistLbl.textColor = #colorLiteral(red: 0.9607843137, green: 0.7058823529, blue: 0.2, alpha: 1)

    }
}
