//
//  SearchPodcast.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 06.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import Alamofire

class SearchPodcast {
    
    static let shared = SearchPodcast()
    
    //fetchPodcast
    func fetchPodcast(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (responseData) in
            
            if let err = responseData.error {
                debugPrint(err as Any)
                return
            }
            guard let data = responseData.data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completionHandler(searchResult.results)
                
            } catch let err {
                debugPrint("Some error occured: \(err as Any)")
            }
        }
    }
    //decoing from the response data, the property name should be exactly the same as the json key
    struct SearchResult: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
}
