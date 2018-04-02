//
// Created by Evgeny Plenkin on 27/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import Foundation
import Starscream
import RxSwift
import ObjectMapper
import CoreData

class QoutationsModel: WebSocketDelegate {

    var socket: WebSocket!
    private let qoutationsVariable: Variable<[QoutationJson]>

    init() {
        qoutationsVariable = Variable([])
        var request = URLRequest(url: URL(string: "wss://quotes.exness.com:18400")!)
        request.timeoutInterval = 5
        socket = Singleton.sharedInstance(WebSocket.self, initWithDefaultValue: WebSocket(request: request))
        socket.delegate = self
    }

    func connect() {
        socket.connect()
    }
    func disconnect() {
        if socket.isConnected {
            socket.disconnect()
        }
    }

    func subscribeToQoutations() {
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 3) {
            if self.qoutationsVariable.value.count == 0 {
                self.subscribeToAll()
            }
            else {
                for qout in self.qoutationsVariable.value {
                    self.subscribe(toQoutation: qout.symbol)
                }
            }
        }
    }

    func updateQoutationFromDB() {
        do {
            let context = CoreDataManager.instance.managedObjectContext
            let request = CoreDataManager.instance.allQoutationRequest()
            if try context.count(for: request) != 0 {
                var qoutations: [QoutationJson] = []
                for qout in try context.fetch(request) as! [QoutationObject] {
                    let qoutation = QoutationJson(fromObject: qout)
                    if qout.available {
                        qoutations.append(qoutation)
                    }
                }
                qoutations.sort(by: {$0.row < $1.row})
                qoutationsVariable.value = qoutations
            }
        } catch {
            print("failed while updating from DB")
        }
    }
    
    //MARK: - SUBSCRIBE
    
    private func subscribe(toQoutation symbol:String) {
        socket.write(string: "SUBSCRIBE: \(symbol)")
    }
    private func unsubscribe(toQoutation symbol:String) {
        socket.write(string: "UNSUBSCRIBE: \(symbol)")
    }
    private func subscribeToAll() {
        for qoutType in QoutationType.allValues {
            subscribe(toQoutation: qoutType.rawValue)
        }
    }
    
    //MARK: - OBSERVABLE
    
    func qoutationsObservable() -> Observable<[QoutationJson]> {
        return qoutationsVariable.asObservable().skip(1).share()
    }

    //MARK: - WEBSOCKET DELEGATE
    func websocketDidConnect(socket: WebSocketClient) {
        
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let full = FullResponse(JSONString: text) {
            if let subList = full.subscribedList {
                for tick in subList.ticks {
                    updateQoutation(qoutation: tick)
                }
            } else if let ticks = QoutationsResponse(JSONString: text) {
                for tick in ticks.ticks {
                    updateQoutation(qoutation: tick)
                }
            }
        }
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }

    //MARK: - WORK WITH QOUTATION
    
    private func updateQoutation(qoutation: QoutationJson) {
        for i in 0..<qoutationsVariable.value.count {
            if qoutation.symbol == qoutationsVariable.value[i].symbol {
                var qout = qoutationsVariable.value[i]
                qout.ask = qoutation.ask
                qout.bid = qoutation.bid
                qout.spread = qoutation.spread
                qoutationsVariable.value[i] = qout
                do {
                    let context = CoreDataManager.instance.managedObjectContext
                    let symbolReq = CoreDataManager.instance.symbolRequest(symbol: qoutation.symbol)
                    if try context.count(for: symbolReq) != 0 {
                        for qout in try context.fetch(symbolReq) as! [QoutationObject] {
                            qout.ask = qoutation.ask
                            qout.bid = qoutation.bid
                            qout.spread = qoutation.spread
                        }
                    }
                } catch {
                }
                do {
                    try CoreDataManager.instance.managedObjectContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                break
            }
        }
    }
    
    func disableQoutation(symbol: String) {
        for i in 0..<qoutationsVariable.value.count {
            if symbol == qoutationsVariable.value[i].symbol {
                do {
                    let context = CoreDataManager.instance.managedObjectContext
                    let symbolReq = CoreDataManager.instance.symbolRequest(symbol: symbol)

                    if try context.count(for: symbolReq) != 0 {
                        for qout in try context.fetch(symbolReq) as! [QoutationObject] {
                            qout.available = false
                        }
                    }
                } catch {
                }
                do {
                    try CoreDataManager.instance.managedObjectContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                qoutationsVariable.value.remove(at: i)
                unsubscribe(toQoutation: symbol)
                break
            }
        }
    }
    
    func handleMoveQoutation(withQoutation qoutation:QoutationJson, sourceRow: Int, destRow: Int) {
        do {
            let context = CoreDataManager.instance.managedObjectContext
            let request = CoreDataManager.instance.allQoutationRequest()
            if sourceRow > destRow {
                request.predicate = NSPredicate(format: "(index > \(destRow - 1)) AND (index < \(sourceRow))")
                if try context.count(for: request) != 0 {
                    for qout in try context.fetch(request) as! [QoutationObject] {
                        qout.index += 1
                    }
                }
            }
            else {
                request.predicate = NSPredicate(format: "(index > \(sourceRow)) AND (index < \(destRow + 1))")
                if try context.count(for: request) != 0 {
                    for qout in try context.fetch(request) as! [QoutationObject] {
                        qout.index -= 1
                    }
                }
            }
            let symbolReq = CoreDataManager.instance.symbolRequest(symbol: qoutation.symbol)
            if try context.count(for: symbolReq) != 0 {
                for qout in try context.fetch(symbolReq) as! [QoutationObject] {
                    let row: Int32 = Int32(destRow)
                    qout.index = Int32(row)
                }
            }
            do {
                try CoreDataManager.instance.managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            updateQoutationFromDB()
        } catch {
        }
    }
}
