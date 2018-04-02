//
// Created by Evgeny Plenkin on 29/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class SettingsController: UIViewController {

    private var tableView: UITableView!
    fileprivate var viewModel: SettingsViewModel!
    var dataSource: RxTableViewSectionedReloadDataSource<DefaultSectionModel<QoutationJson>>!
    lazy private var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let router = SettingsRouter(withRootViewController: self)
        viewModel = SettingsViewModel(withRouter: router)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder:) not implemented")
    }

    //MARK: - LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTableView()
        setTableViewDataSource()
    }
    
    //MARK: - TABLE VIEW
    private func makeTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.registerCellsArray(nibNames: [SettingsCell.nibName])

        tableView.separatorStyle = .none

        tableView.estimatedRowHeight = 44

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setTableViewDataSource() {
        dataSource = configureDataSource()
        
        viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func configureDataSource() -> RxTableViewSectionedReloadDataSource<DefaultSectionModel<QoutationJson>> {
        let dataSource = RxTableViewSectionedReloadDataSource<DefaultSectionModel<QoutationJson>>(
            configureCell:{ (dataSource, table, idxPath, qoutation) in
                self.createCell(for: qoutation, table: table)
        })
        
        return dataSource
    }

    private func createCell(for qoutation: QoutationJson, table: UITableView) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: SettingsCell.nibName) as? SettingsCell {
            cell.fill(withQoutation: qoutation, action: changeSwitch)
            return cell
        }
        
        fatalError("Something wrong with cell")
    }
    
    //MARK: - RECOGNIZE SWITCH
    
    private func changeSwitch(_ qoutation: QoutationJson) {
        viewModel.saveQoutation(qoutation: qoutation)
    }
}

extension SettingsController: UITableViewDelegate {

}
