//
//  AlertDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-23.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation

struct AlertDTO: Decodable {
    var AlertId: CLong
    var MeasurementType : String
    var DecriptionText : String
    var AlarmCode : String
    var AlarmLevel : String
    
    
}

