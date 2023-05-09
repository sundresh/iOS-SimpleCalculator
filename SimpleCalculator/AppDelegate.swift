//
//  AppDelegate.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/6/23.
//

import SwiftUI
import UIKit

/// The AppDelegate is the main entrypoint for the program. All it really does, though, is it tells
/// the system to instantiate the UIWindowSceneDelegate associated with `Default Configuration` in
/// the Appliation Scene Manifest (found in SimpleCalculator > Info in Xcode).
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle
    // Note: If we didn't have the methods below, then the initialization that happens in
    // `SceneDelegate` would need to be implemented in the
    // `applicaation(_ didFinishLaunchingWithOptions)` method above.

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

