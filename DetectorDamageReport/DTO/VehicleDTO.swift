//
//  VehicleDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-18.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation

struct VehicleDTO: Decodable {
    var VehicleId: CLong
    var VehicleNumber : String
    var Speed : Int
    var AxleCount : Int

    let AxleList: [AxleDTO]
    let WheelDamageMeasureDataVehicleList: [WheelDamageMeasureDataVehicleDTO]
    let AlertList: [AlertDTO]
}

