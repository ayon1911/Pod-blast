//
//  PodcastsSearchVC.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 06.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchVC: UITableViewController {
    
    var podcasts = [Podcast]()
    //delaying variable for the search podcast method
    var timer: Timer?
    var podcastSearchingView = Bundle.main.loadNibNamed("PodcastSearchingView", owner: self, options: nil)?.first as? UIView
    
    //Implementing a UiSearchController
    let searchcontroller = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        searchBar(searchcontroller.searchBar, textDidChange: "606")
 
    }
    //MARK:- initial Setup
    fileprivate func setupSearchBar() {
        //Only available in IOS-11 sdk
        self.definesPresentationContext = true
        navigationItem.searchController = searchcontroller
        navigationItem.hidesSearchBarWhenScrolling = false
        searchcontroller.dimsBackgroundDuringPresentation = false
        searchcontroller.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        //Register a cell
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PODCAST_CELL_ID)
        tableView.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.2156862745, blue: 0.4901960784, alpha: 1)
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PODCAST_CELL_ID)
        tableView.tableFooterView = UIView()
    }

    //MARK:- TableView functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PODCAST_CELL_ID, for: indexPath) as! PodcastCell
        
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a something to search"
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir Next", size: 18.0)
        label.textColor = .white
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.isEmpty && searchcontroller.searchBar.text?.isEmpty == true ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("Hello from podcast searching view")
        return podcastSearchingView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return self.podcasts.isEmpty && searchcontroller.searchBar.text?.isEmpty == false ? 200 : 0

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesVC = EpisodesVC()
        let podcast = self.podcasts[indexPath.row]
        episodesVC.podcast = podcast
        navigationController?.pushViewController(episodesVC, animated: true)

        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .black
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .white
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }

}

extension PodcastsSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchcontroller.searchBar.tintColor = #colorLiteral(red: 0.9607843137, green: 0.7058823529, blue: 0.2, alpha: 1)
        podcasts = []
        tableView.reloadData()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            SearchPodcast.shared.fetchPodcast(searchText: searchText) { (podcast) in
                self.podcasts = podcast
                self.tableView.reloadData()
                print("Something is not working")
            }
        })
        
    }
}


