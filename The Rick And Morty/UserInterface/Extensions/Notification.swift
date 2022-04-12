//
//  Notification.swift
//  The Rick And Morty
//
//  Created by mac on 11.04.2022.
//

import UIKit

extension AppDelegate {
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Rick and Morty"
        content.body = "We are pleased that you are using our app. Welcome back"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
}
