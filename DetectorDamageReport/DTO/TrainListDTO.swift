//
//  TrainListDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-21.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation

struct TrainListDTO: Decodable {
    var TotalCount : Int?
    var TrainId: CLong
    var TrainOperator:String
    var TrainNumber:String
    var TrainDirection:String
    var VehicleCount : Int
    var MessageSent:String
    var Detector:String
    var isWheelDamage:Bool
    var isHotBoxHotWheel:Bool
    var TrainHasAlarmItem:Bool
}


