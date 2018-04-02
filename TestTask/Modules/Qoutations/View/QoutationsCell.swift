//
//  QoutationsCell.swift
//  TestTask
//
//  Created by Evgeny Plenkin on 26/03/2018.
//  Copyright © 2018 Evgeny Plenkin. All rights reserved.
//

import UIKit

class QoutationsCell: UITableViewCell {

    @IBOutlet weak var symbalLabel: UILabel!
    @IBOutlet weak var bidaskLabel: UILabel!
    @IBOutlet weak var spreadLabel: UILabel!

    static let nibName = "QoutationsCell"

    func fill(withQoutation qoutation:QoutationJson) {
        symbalLabel.text = qoutation.name
        bidaskLabel.text = "\(qoutation.bid)/\(qoutation.ask)"
        spreadLabel.text = "\(qoutation.spread)"
    }
}
