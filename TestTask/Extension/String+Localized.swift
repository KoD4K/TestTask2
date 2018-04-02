//
// Created by Evgeny Plenkin on 28/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}