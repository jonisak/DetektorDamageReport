//
//  WheelDamageMeasureDataWheelDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-23.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation

struct WheelDamageMeasureDataWheelDTO: Decodable {
    var WheelDamageMeasureDataWheelId: CLong
    var LeftWheelDamageDistributedLoadValue : Float?
    var LeftWheelDamageMeanValue : Float?
    var LeftWheelDamagePeakValue : Float?
    var LeftWheelDamageQualityFactor : Float?
    var RightWheelDamageDistributedLoadValue : Float?
    var RightWheelDamageMeanValue : Float?
    var RightWheelDamagePeakValue : Float?
    var RightWheelDamageQualityFactor : Float?
}


