//
// Created by Evgeny Plenkin on 27/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

enum QoutationType: String {
    case EURUSD
    case EURGBP
    case USDJPY
    case GBPUSD
    case USDCHF
    case USDCAD
    case AUDUSD
    case EURJPY
    case EURCHF

    static let allValues = [EURUSD, EURGBP, USDJPY, GBPUSD, USDCHF, USDCAD, AUDUSD, EURJPY, EURCHF]
}

struct QoutationJson {
    var name = ""
    var symbol = ""
    var bid = ""
    var ask = ""
    var spread = ""
    var available = true

    var row: Int = 0

    init(fromObject object:QoutationObject) {
        if let symbol = object.symbol {
            self.symbol = symbol
            let startIndex = symbol.index(symbol.startIndex, offsetBy: 3)
            let startSubstring = symbol.prefix(upTo: startIndex)
            let endIndex = symbol.index(symbol.endIndex, offsetBy: -3)
            let endSubstring = symbol[endIndex...]
            name = "\(startSubstring)/\(endSubstring)"
        }
        if let ask = object.ask {
            self.ask = ask
        }
        if let bid = object.bid {
            self.bid = bid
        }
        if let spread = object.spread {
            self.spread = spread
        }
        if object.index != 0 {
            row = Int(object.index)
        }
        available = object.available
    }
}

extension QoutationJson: Mappable {
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        symbol <- map["s"]
        bid <- map["b"]
        ask <- map["a"]
        spread <- map["spr"]
    }
}

extension QoutationJson: IdentifiableType {
    typealias Identity = String

    var identity: Identity {
        return symbol
    }
}

extension QoutationJson: Hashable {
    var hashValue: Int {
        return "\(self.identity)".hashValue
    }
}

extension QoutationJson: Equatable {
    static func ==(lhs: QoutationJson, rhs: QoutationJson) -> Bool {
        return lhs.symbol == rhs.symbol &&
                lhs.bid == rhs.bid &&
                lhs.ask == rhs.ask &&
                lhs.spread == rhs.spread
    }
}
