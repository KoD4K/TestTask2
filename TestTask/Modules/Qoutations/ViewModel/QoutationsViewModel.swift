//
//  QoutationsViewModel.swift
//  TestTask
//
//  Created by Evgeny Plenkin on 26/03/2018.
//  Copyright © 2018 Evgeny Plenkin. All rights reserved.
//

import RxSwift

class QoutationsViewModel {
    private let router: QoutationsRouter
    private let model: QoutationsModel
    lazy private var disposeBag: DisposeBag = {
        return DisposeBag()
    }()

    let sections: Variable<[DefaultSectionModel<QoutationJson>]>

    init(withRouter router: QoutationsRouter) {
        self.router = router
        self.model = QoutationsModel()
        sections = Variable([])
        subscribeOnQoutations()
        model.updateQoutationFromDB()
    }

    private func subscribeOnQoutations() {
        model.qoutationsObservable().subscribe(onNext: { qoutations in
            self.updateSection(withQoutations: qoutations)
        }).disposed(by: disposeBag)
    }

    //MARK: - LOAD QOUTATIONS
    func start() {
        model.connect()
        model.updateQoutationFromDB()
        model.subscribeToQoutations()
    }

    func stop() {
        model.disconnect()
    }

    //MARK: - SHOW QOUTATIONS
    private func updateSection(withQoutations qoutations: [QoutationJson]) {
        sections.value = [DefaultSectionModel(items: qoutations, id: 0)]
    }

    //MARK: - DELETE
    func disableQoutation(symbol:String) {
        model.disableQoutation(symbol: symbol)
    }

    //MARK: - ROUTER
    func openSettings() {
        router.openSettings()
    }
    
    //MARK: - MOVE
    func handleMoveQoutation(withQoutation qoutation:QoutationJson, sourceRow: Int, destRow: Int) {
        model.handleMoveQoutation(withQoutation: qoutation, sourceRow: sourceRow, destRow: destRow)
    }
}
