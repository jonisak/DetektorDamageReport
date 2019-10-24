//
//  DetectorDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-10-14.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation
import Eureka


import Foundation
struct DetectorDTO: Codable {
    var DetectorId: Int
    var SGLN:String
    var Name:String
    var DetectorType:String
    var Latitude:String?
    var Longitude:String?

}
