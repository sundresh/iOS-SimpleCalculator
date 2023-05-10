//
//  SceneDelegate.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/6/23.
//

import SwiftUI
import UIKit

extension UserDefaults {
    static let useSwiftUIPreferenceKey = "useSwiftUI"

    @objc dynamic var useSwiftUI: Bool {
        return bool(forKey: UserDefaults.useSwiftUIPreferenceKey)
    }

    static var useSwiftUI: Bool {
        UserDefaults.standard.bool(forKey: useSwiftUIPreferenceKey)
    }
}

/// The SceneDelegate is used to create a UIWindow and populate it with a ViewController to
/// provide the user interface for a simple calculator. On startup, it automatically selects
/// whether to SwiftUI or UIKit implementation of the user interface, depending on the setting of
/// the `swiftui_preference` application setting in the system Settings app.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let calculator: Calculator
    var window: UIWindow?
    var observer: NSKeyValueObservation?

    override init() {
        calculator = Calculator()
        super.init()
    }

    deinit {
        observer?.invalidate()
    }

    private func setRootViewController() {
        // Construct the appropriate user interface based on the app settings.
        if UserDefaults.useSwiftUI {
            window?.rootViewController = UIHostingController(rootView: CalculatorView(calculator: calculator))
        } else {
            window?.rootViewController = CalculatorViewController(calculator: calculator)
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create the main window to host the view controller.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()

        observer = UserDefaults.standard.observe(\.useSwiftUI, options: [.initial, .new], changeHandler: { (defaults, change) in
            self.setRootViewController()
        })
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

