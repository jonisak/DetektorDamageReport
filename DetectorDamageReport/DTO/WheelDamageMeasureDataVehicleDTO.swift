//
//  WheelDamageMeasureDataVehicleDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-23.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation

struct WheelDamageMeasureDataVehicleDTO: Decodable {
    var WheelDamageMeasureDataAxleId: CLong
    var FrontRearLoadRatio : Float
    var LeftRightLoadRatio : Float
    var WeightInTons : Float

    
}

