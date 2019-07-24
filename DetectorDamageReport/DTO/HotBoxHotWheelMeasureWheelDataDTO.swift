//
//  HotBoxHotWheelMeasureWheelDataDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-23.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation


struct HotBoxHotWheelMeasureWheelDataDTO: Decodable {
    var HotBoxHotWheelMeasureWheelDataId: CLong
    var HotBoxLeftValue : Int?
    var HotBoxRightValue : Int?
    var HotWheelLeftValue : Int?
    var HotWheelRightValue : Int?

}


