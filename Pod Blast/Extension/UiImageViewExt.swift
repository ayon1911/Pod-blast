//
//  UiImageViewExt.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 21.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    open override func awakeFromNib() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
}
