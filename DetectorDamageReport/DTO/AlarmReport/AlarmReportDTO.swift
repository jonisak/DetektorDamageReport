//
//  AlarmReportDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-27.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation

struct AlarmReportDTO: Codable {
    var AlarmReportId : Int
    var alarmReportReasonDTO : AlarmReportReasonDTO
    var trainDTo: TrainDTO
    var ReportedDateTime:String
    var Comment:String
}


