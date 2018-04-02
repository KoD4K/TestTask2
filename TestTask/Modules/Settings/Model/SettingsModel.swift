//
// Created by Evgeny Plenkin on 29/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import RxSwift
import CoreData

class SettingsModel {

    private let qoutationsVariable: Variable<[QoutationJson]>
    
    init() {
        qoutationsVariable = Variable([])
    }
    
    func fillTable() {
        do {
            let context = CoreDataManager.instance.managedObjectContext
            let request = CoreDataManager.instance.allQoutationRequest()
            
            if try context.count(for: request) != 0 {
                var qoutations: [QoutationJson] = []
                for qout in try context.fetch(request) as! [QoutationObject] {
                    qoutations.append(QoutationJson(fromObject: qout))
                }
                qoutations.sort(by: {$0.row < $1.row})
                qoutationsVariable.value = qoutations
            }
        } catch {
            print("failed while getting from DB fro settings")
        }
    }
    
    func saveQoutation(qoutation: QoutationJson) {
        let symbol = qoutation.symbol
        do {
            let context = CoreDataManager.instance.managedObjectContext
            let symbolReq = CoreDataManager.instance.symbolRequest(symbol: symbol)
            
            if try context.count(for: symbolReq) != 0 {
                for qout in try context.fetch(symbolReq) as! [QoutationObject] {
                    qout.available = qoutation.available
                }
            }
        } catch {
        }
        do {
            try CoreDataManager.instance.managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - OBSERVABLE
    
    func qoutationsObservable() -> Observable<[QoutationJson]> {
        return qoutationsVariable.asObservable().skip(1).share()
    }
}
