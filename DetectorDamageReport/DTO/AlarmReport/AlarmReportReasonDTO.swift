//
//  ReportAlarmCauseDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-26.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation
struct AlarmReportReasonDTO : Codable {
    var AlarmReportReasonId : Int
    var Name:String
    
    
    init(alarmReportReasonId: Int, name: String) {
        self.AlarmReportReasonId = alarmReportReasonId
        self.Name = name
    
    }
}
