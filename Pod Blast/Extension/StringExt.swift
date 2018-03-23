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
    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
