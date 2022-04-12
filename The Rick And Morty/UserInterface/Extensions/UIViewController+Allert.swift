//
//  UIViewController+Allert.swift
//  The Rick And Morty
//
//  Created by user on 31.03.2022.
//

import UIKit

extension UIViewController {
    
    func showAlert(
        tag: Int = 0,
        title: String? = nil,
        message: String? = nil,
        cancelText: String? = nil,
        cancelCompletion: ((UIAlertAction) -> Void)? = nil,
        actionText: String = "ОК",
        isActionTextBold: Bool = false,
        actionCompletion: ((UIAlertAction) -> Void)? = nil
    ) {
        
        let rootViewController = UIApplication.rootViewController
        guard rootViewController?.lastPresentedViewController as? UIAlertController == nil else { return }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tag = tag
        
        let okAction = UIAlertAction(title: actionText, style: .default, handler: actionCompletion)
        alertController.addAction(okAction)
        
        if isActionTextBold {
            alertController.preferredAction = okAction
        }
        
        if let cancelText = cancelText {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: cancelCompletion)
            alertController.addAction(cancelAction)
        }
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showConnectionAlert(completion: ((UIAlertAction) -> Void)? = nil) {
        print((presentedViewController is UIAlertController))
        if !(presentedViewController is UIAlertController) {
            showAlert(title: "Ошибка при подключении", message: "Проверьте Ваше подключение к сети", actionText: "Повторить", actionCompletion: completion)
        }
    }
}
