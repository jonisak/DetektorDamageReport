//
//  UITableViewExtension.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-10-29.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import Foundation
import UIKit
extension UITableView {

func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = .black
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
    messageLabel.sizeToFit()

    self.backgroundView = messageLabel;
    self.separatorStyle = .none;
}

func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
    }
}
