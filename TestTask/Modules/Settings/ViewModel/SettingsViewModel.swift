//
// Created by Evgeny Plenkin on 29/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import RxSwift

class SettingsViewModel {
    private let router: SettingsRouter
    private let model: SettingsModel
    lazy private var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    let sections: Variable<[DefaultSectionModel<QoutationJson>]>
    
    init(withRouter router: SettingsRouter) {
        self.router = router
        self.model = SettingsModel()
        sections = Variable([])
        subscribeOnQoutations()
        model.fillTable()
    }
    
    func saveQoutation(qoutation: QoutationJson) {
        model.saveQoutation(qoutation: qoutation)
    }
    
    private func subscribeOnQoutations() {
        model.qoutationsObservable().subscribe(onNext: { qoutations in
            self.updateSection(withQoutations: qoutations)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - SHOW QOUTATIONS SETTINGS
    private func updateSection(withQoutations qoutations: [QoutationJson]) {
        sections.value = [DefaultSectionModel(items: qoutations, id: 0)]
    }
}
