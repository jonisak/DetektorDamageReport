//
//  DeviceTypeDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-15.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation
   struct DeviceTypeDTO: Codable {
        var DeviceType: String = ""
        var DeviceTypeDisplayName: String = ""
        var Selected: Bool = true
        
        init(deviceType: String, deviceTypeDisplayName: String, selected:Bool) {
            self.DeviceType = deviceType
            self.DeviceTypeDisplayName = deviceTypeDisplayName
            self.Selected = selected
    }
}
