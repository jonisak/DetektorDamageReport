//
//  AlarmReportImageDTO.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-11-07.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation

struct AlarmReportImageDTO: Codable {
    var AlarmReportImageId : Int?
    var AlarmReportId : Int?
    var Description:String
    var AlarmReportImageBinDTO:AlarmReportImageBinDTO?
    var AlarmReportImageThumbnailBinDTO:AlarmReportImageThumbnailBinDTO?
}


