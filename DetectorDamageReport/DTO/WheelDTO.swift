//
//  WheelDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-23.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation
struct WheelDTO: Codable {
    var WheelId: CLong
    
    let WheelDamageMeasureDataWheelList: [WheelDamageMeasureDataWheelDTO]?
    let HotBoxHotWheelMeasureWheelDataList: [HotBoxHotWheelMeasureWheelDataDTO]?
    let AlertList: [AlertDTO]?

}

