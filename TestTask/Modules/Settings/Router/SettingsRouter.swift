//
//  SettingsRouter.swift
//  TestTask
//
//  Created by Evgeny Plenkin on 01/04/2018.
//  Copyright © 2018 Evgeny Plenkin. All rights reserved.
//

import UIKit

class SettingsRouter {
    private let viewController: UIViewController
    
    init(withRootViewController viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func popController() {
        viewController.navigationController?.popViewController(animated: true)
    }
}
