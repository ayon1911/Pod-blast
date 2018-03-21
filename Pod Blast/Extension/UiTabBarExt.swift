//
//  UiTabBarExt.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 21.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 55
        return sizeThatFits
    }
}
