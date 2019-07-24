//
//  WheelDamageMeasureDataAxleDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-23.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation
struct WheelDamageMeasureDataAxleDTO: Decodable {
    var WheelDamageMeasureDataAxleId: CLong
    var AxleLoad : Float?
    var LeftRightLoadRatio : Float?

    
}


