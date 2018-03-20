//
//  PlayerDetailsView+Gestures.swift
//  Pod Blast
//
//  Created by Khaled Rahman Ayon on 20.03.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

extension PlayerDetailsView {
    //all the gestures recognizer
    func setupGestures() {
        //add gestureRecognizer to maximize the playerdetailsView
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maximizePlayerView)))
        //add pan gesture recognizer
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handelDismissalPan)))
    }
    
    @objc func handelDismissalPan(gesture: UIPanGestureRecognizer) {
        let translationPoint = gesture.translation(in: self.superview)
        if gesture.state == .changed {
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translationPoint.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                if translationPoint.y > 70 {
                    UIApplication.mainTabBarController()?.minimizePlayerDetailsView()
                }
                self.maximizedStackView.transform = .identity
            })
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translationPoint = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        print("transform ended")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translationPoint.y < 200 || velocity.y < 500 {
                UIApplication.mainTabBarController()?.maximizePlayerDetailsView(episode: nil)
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        })
    }
    
    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translationPoint = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translationPoint.y)
        self.miniPlayerView.alpha = 1 + translationPoint.y / 200
        self.maximizedStackView.alpha = -translationPoint.y / 200
    }
}
