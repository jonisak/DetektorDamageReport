//
//  StructExtension.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-09.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
