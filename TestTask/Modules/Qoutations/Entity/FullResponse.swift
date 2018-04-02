//
// Created by Evgeny Plenkin on 28/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import Foundation
import ObjectMapper

class FullResponse: Mappable {
    var subscribedList: QoutationsResponse!
    var subscribedCount: Int = 0

    required init?(map: ObjectMapper.Map) {

    }

    func mapping(map: ObjectMapper.Map) {
        subscribedList <- map["subscribed_list"]
        subscribedCount <- map["subscribed_count"]
    }
}