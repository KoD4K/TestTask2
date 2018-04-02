//
//  QoutationsRouter.swift
//  TestTask
//
//  Created by Evgeny Plenkin on 26/03/2018.
//  Copyright © 2018 Evgeny Plenkin. All rights reserved.
//

import Foundation
import UIKit

class QoutationsRouter {
    private let viewController: UIViewController
    
    init(withRootViewController viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlertView(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: StringManager.Alert.ok, style: .cancel))
        viewController.present(alertController, animated: true)
    }

    func openSettings() {
        let settingsCtrl = SettingsController()
        viewController.navigationController?.pushViewController(settingsCtrl, animated: true)
    }
}
