//
//  URLHandler.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import UIKit

struct URLHandler {
    static func openUrl(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.canOpenURL(url)
        }
    }
    
    static func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        openUrl(url: settingsUrl)
    }
    
    static func call(phone: String) {
        guard let url = URL(string: "tel://\(phone)") else { return }
        openUrl(url: url)
    }
}
