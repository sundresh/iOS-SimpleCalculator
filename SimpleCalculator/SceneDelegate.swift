//
//  SceneDelegate.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/6/23.
//

import SwiftUI
import UIKit

/// Accessors to read the system settings for this app.
struct Settings {
    static let swiftUIPreferenceKey = "swiftui_preference"

    static var userInterfaceSettingIsSwiftUI: Bool {
        UserDefaults.standard.bool(forKey: swiftUIPreferenceKey)
    }
}

/// The SceneDelegate is used to create a UIWindow and populate it with a ViewController to
/// provide the user interface for a simple calculator. On startup, it automatically selects
/// whether to SwiftUI or UIKit implementation of the user interface, depending on the setting of
/// the `swiftui_preference` application setting in the system Settings app.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    @IBAction
    private func onButtonTap(sender: UIButton, forEvent event: UIEvent) {
        print("button tapped. sender = \(String(describing: sender)), event = \(String(describing: event))")
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create the main window to host the view controller.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()

        // Construct the appropriate user interface based on the app settings.
        if Settings.userInterfaceSettingIsSwiftUI {
            window?.rootViewController = UIHostingController(rootView: CalculatorView())
        } else {
            window?.rootViewController = CalculatorViewController()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

