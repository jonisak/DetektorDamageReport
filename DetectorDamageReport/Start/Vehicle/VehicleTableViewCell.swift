//
//  VehicleTableViewCell.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-19.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    
    var vehicleNumberLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    
    var speedLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    
    var axleCountLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(vehicleNumberLabel)
        self.contentView.addSubview(speedLabel)
        self.contentView.addSubview(axleCountLabel)
        
        
        vehicleNumberLabel.translatesAutoresizingMaskIntoConstraints = false;
        vehicleNumberLabel.backgroundColor = UIColor.white
        vehicleNumberLabel.textColor = UIColor.black
        vehicleNumberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        vehicleNumberLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        vehicleNumberLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true;
        vehicleNumberLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        
        
        speedLabel.translatesAutoresizingMaskIntoConstraints = false;
        speedLabel.backgroundColor = UIColor.white
        speedLabel.textColor = UIColor.black
        speedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        speedLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        speedLabel.topAnchor.constraint(equalTo: vehicleNumberLabel.bottomAnchor, constant: 10).isActive = true;
        speedLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        
        
        
        axleCountLabel.translatesAutoresizingMaskIntoConstraints = false;
        axleCountLabel.backgroundColor = UIColor.white
        axleCountLabel.textColor = UIColor.black
        axleCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        axleCountLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        axleCountLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 10).isActive = true;
        axleCountLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        
        
   
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state

    }
}
