//
//  AppDelegate.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 13/06/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var postListCoordinator: PostListCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let window = self.window {
            postListCoordinator = PostListCoordinator(window: window)
            postListCoordinator?.start()
        }
        window?.overrideUserInterfaceStyle = .dark
        return true
    }
}

