//
//  SettingsCell.swift
//  TestTask
//
//  Created by Evgeny Plenkin on 29/03/2018.
//  Copyright © 2018 Evgeny Plenkin. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var symbolSwitch: UISwitch!

    static let nibName = "SettingsCell"

    private var switchAction: QoutInNoOut!
    private var qoutation: QoutationJson!
    
    func fill(withQoutation qoutation:QoutationJson, action: @escaping QoutInNoOut) {
        symbolSwitch.isOn = qoutation.available
        switchAction = action
        self.qoutation = qoutation
        symbolLabel.text = qoutation.name
        symbolSwitch.addTarget(self, action: #selector(changeSwitch(cellSwitch:)), for: .valueChanged)
    }
    
    //MARK: - SWITCH RECOGNIZE
    
    @objc private func changeSwitch(cellSwitch:UISwitch) {
        qoutation.available = cellSwitch.isOn
        switchAction(qoutation)
    }
}
