//
//  ViewController.swift
//  TestTask
//
//  Created by Evgeny Plenkin on 26/03/2018.
//  Copyright © 2018 Evgeny Plenkin. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import CoreData

class QoutationsController: UIViewController {
  
    private var tableView: UITableView!
    fileprivate var viewModel: QoutationsViewModel!
    
    var dataSource: RxTableViewSectionedReloadDataSource<DefaultSectionModel<QoutationJson>>!

    lazy private var disposeBag: DisposeBag = {
        return DisposeBag()
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        let router = QoutationsRouter(withRootViewController: self)
        viewModel = QoutationsViewModel(withRouter: router)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder:) not implemented")
    }

    //MARK: - LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        makeTableView()
        setTableViewDataSource()
        addSettingsButton()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
        editing ? viewModel.stop() : viewModel.start()
    }
    
    //MARK: - APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.stop()
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

        tableView.registerCellsArray(nibNames: [QoutationsCell.nibName])

        tableView.separatorStyle = .none

        tableView.estimatedRowHeight = 44

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.itemMoved.subscribe(onNext: { (sourceIndexPath, destinationIndexPath) in
            self.viewModel.handleMoveQoutation(withQoutation: self.dataSource[destinationIndexPath],
                                               sourceRow: sourceIndexPath.row,
                                               destRow: destinationIndexPath.row)
        }).disposed(by: disposeBag)
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
        },
            canEditRowAtIndexPath: { (ds, ip) in
                return true
        },
            canMoveRowAtIndexPath: { _, _ in
                return true
        })
        
        return dataSource
    }
    
    private func createCell(for qoutation: QoutationJson, table: UITableView) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: QoutationsCell.nibName) as? QoutationsCell {
            cell.fill(withQoutation: qoutation)
            return cell
        }
        
        fatalError("Something wrong with cell")
    }

    //MARK: - BUTTONS
    private func addSettingsButton() {
        let settingsButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        settingsButton.addTarget(self, action: #selector(settingsButtonPress), for: .touchUpInside)
        settingsButton.setImage(UIImage(named: "Gear"), for: .normal)
        let settingsButtonItem = UIBarButtonItem.init(customView: settingsButton)
        navigationItem.rightBarButtonItem = settingsButtonItem
    }

    @objc func settingsButtonPress() {
        viewModel.openSettings()
    }

    //MARK: - OTHER
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QoutationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            let qout = self.dataSource[indexPath]
            self.viewModel.disableQoutation(symbol: qout.symbol)
        }
        return [delete]
    }
}
