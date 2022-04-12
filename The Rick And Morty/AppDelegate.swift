//
//  AppDelegate.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = SplashScreenConfigurator.create()
        self.window?.overrideUserInterfaceStyle = .dark
        self.window?.makeKeyAndVisible()
        
        notificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: {(granted, error) in
                guard granted else { return }
                self.notificationCenter.getNotificationSettings { (settings) in
                    guard settings.authorizationStatus == .authorized else { return }
                    print(settings)
                }
            })
        notificationCenter.delegate = self
        sendNotification()
        
        return true
    }
}

