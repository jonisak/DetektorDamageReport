//
//  TrainDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-18.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation
struct TrainDTO: Decodable {
  
    
    var TrainId: CLong
    var TrainOperator:String
    var TrainNumber:String
    var TrainDirection:String
    var VehicleCount : Int
    var Vehicles: [VehicleDTO]?
    var MessageSent:String
    var Detector:String
    var AlertList: [AlertDTO]?
}


