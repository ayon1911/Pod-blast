//
//  StringExt.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 08.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation

extension String {
    func secureHttps() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
