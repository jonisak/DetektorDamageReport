//
//  TrainFilterDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-11.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation

struct TrainFilterDTO: Codable {
    var MaxResultCount: Int = 0
    var Page: Int? = 0
    var PageSize: Int? = 0
    var ShowTrainWithAlarmOnly:Bool
    var DeviceTypeDTOList : [DeviceTypeDTO]
    var TrainNumber: String = ""
    var FromDate:String = ""
    var ToDate: String = ""


    init(maxResultCount: Int, page: Int, pageSize: Int ,showTrainWithAlarmOnly:Bool, deviceTypeDTOList: [DeviceTypeDTO]) {
        self.MaxResultCount = maxResultCount
        self.Page = page
        self.PageSize = pageSize
        self.ShowTrainWithAlarmOnly = showTrainWithAlarmOnly
        self.DeviceTypeDTOList = deviceTypeDTOList
        
    }
}

