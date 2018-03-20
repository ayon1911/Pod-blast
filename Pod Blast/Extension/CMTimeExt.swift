//
//  CMTimeExt.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 12.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toFormateTimeString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        
        let timeFormattedString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormattedString
    }
}
