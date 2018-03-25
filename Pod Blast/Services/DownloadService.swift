//
//  DownloadService.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 23.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import Alamofire

class DownloadService {
    
    static let shared = DownloadService()
    typealias downloadCompletedTuple = (fileUrl: String, title: String)
    
    func downloadEipsodeToLocal(episode: Episode) {
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            //monitor download progress
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            
            }.response { (res) in
                print("Local file url is : \(res.destinationURL?.absoluteString ?? "")")
                
                let episodeDownloadedComplete = downloadCompletedTuple(fileUrl: res.destinationURL?.absoluteString ?? "", title: episode.title)
                NotificationCenter.default.post(name: .downloadProgressComplete, object: episodeDownloadedComplete, userInfo: nil)
                
                var downloadedEpisodes = UserDefaults.standard.listOfDownloadedEpisodes()
                guard let index = downloadedEpisodes.index(where: { $0.auther == episode.auther && $0.title == episode.title }) else { return }
                
                 downloadedEpisodes[index].fileUrl = res.destinationURL?.absoluteString ?? ""
                
                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
                } catch let err {
                    debugPrint(err as Any)
                }
        }
    }
}
