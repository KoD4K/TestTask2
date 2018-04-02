//
// Created by Evgeny Plenkin on 28/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import Foundation
import ObjectMapper

class QoutationsResponse: Mappable {
    var ticks: [QoutationJson] = []
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        ticks <- map["ticks"]
    }
}
