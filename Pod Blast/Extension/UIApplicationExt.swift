//
//  UIApplicationExt.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 19.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
