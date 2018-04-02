//
// Created by Evgeny Plenkin on 27/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCellsArray(nibNames:[String]) {
        for nibname in nibNames {
            self.register(UINib.init(nibName: nibname, bundle: nil),
                    forCellReuseIdentifier: nibname)
        }
    }
}