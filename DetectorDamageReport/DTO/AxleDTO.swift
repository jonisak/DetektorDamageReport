//
//  AxleDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-23.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation


struct AxleDTO: Decodable {
    var AxleId: CLong
    var AxleNumber : Int?
    //let WheelDamageMeasureDataAxleList: [WheelDamageMeasureDataAxleDTO]
    let WheelList: [WheelDTO]?
    let AlertList: [AlertDTO]?
}




