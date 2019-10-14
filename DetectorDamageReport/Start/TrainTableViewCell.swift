//
//  TrainTableViewCell.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-19.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit

class TrainTableViewCell: UITableViewCell {
    
    
    
    var warningImageView: UIImageView = {
        let t = UIImageView()
        t.translatesAutoresizingMaskIntoConstraints = false;
        t.image = UIImage(named: "AlertImage")
        
        return t;
    }()
    
    var messageTypeLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    
    var detectorLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    
    var sentLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    
    var trainOperatorLabel: UILabel = {
            let t = UILabel()
            t.translatesAutoresizingMaskIntoConstraints = false;
            return t;
        }()
    
    

    var trainNumberLabel: UILabel = {
        let t = UILabel()
        
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    var trainDirectionLabel: UILabel = {
        let t = UILabel()
        
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    var vehicleCountLabel: UILabel = {
        let t = UILabel()
        
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none;
    }
    
    func layoutViews(trainListDTO:TrainListDTO)
    {
        let theSubviews: Array = (self.contentView.subviews)
        for view in theSubviews
        {
            view.removeFromSuperview()
        }

        
        if trainListDTO.TrainHasAlarmItem
        {
            self.contentView.addSubview(warningImageView)

            warningImageView.translatesAutoresizingMaskIntoConstraints = false;
            warningImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            warningImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            warningImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true;
            warningImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true;
        }

        self.contentView.addSubview(messageTypeLabel)
        self.contentView.addSubview(detectorLabel)
        self.contentView.addSubview(sentLabel)
        self.contentView.addSubview(trainOperatorLabel)
        self.contentView.addSubview(trainNumberLabel)
        self.contentView.addSubview(trainDirectionLabel)
        self.contentView.addSubview(vehicleCountLabel)
        
        messageTypeLabel.translatesAutoresizingMaskIntoConstraints = false;
        messageTypeLabel.backgroundColor = UIColor.white
        messageTypeLabel.textColor = UIColor.black
        messageTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        messageTypeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        messageTypeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;

        if trainListDTO.TrainHasAlarmItem
        {
            messageTypeLabel.topAnchor.constraint(equalTo: warningImageView.bottomAnchor, constant: 10).isActive = true;
        }else
        {
            messageTypeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true;
        }
        
        
        detectorLabel.translatesAutoresizingMaskIntoConstraints = false;
        detectorLabel.backgroundColor = UIColor.white
        detectorLabel.textColor = UIColor.black
        detectorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        detectorLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        detectorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        detectorLabel.topAnchor.constraint(equalTo: self.messageTypeLabel.bottomAnchor, constant: 10).isActive = true;

        
        

        
        
        
        
        sentLabel.translatesAutoresizingMaskIntoConstraints = false;
        sentLabel.backgroundColor = UIColor.white
        sentLabel.textColor = UIColor.black
        sentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sentLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        sentLabel.topAnchor.constraint(equalTo: detectorLabel.bottomAnchor, constant: 10).isActive = true;
        sentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        
        
        
        trainOperatorLabel.translatesAutoresizingMaskIntoConstraints = false;
        trainOperatorLabel.backgroundColor = UIColor.white
        trainOperatorLabel.textColor = UIColor.black
        trainOperatorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        trainOperatorLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        trainOperatorLabel.topAnchor.constraint(equalTo: sentLabel.bottomAnchor, constant: 10).isActive = true;
        trainOperatorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        
        
        trainNumberLabel.translatesAutoresizingMaskIntoConstraints = false;
        trainNumberLabel.backgroundColor = UIColor.white
        trainNumberLabel.textColor = UIColor.black
        trainNumberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        trainNumberLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        trainNumberLabel.topAnchor.constraint(equalTo: trainOperatorLabel.bottomAnchor, constant: 10).isActive = true;
        trainNumberLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        
        
        trainDirectionLabel.translatesAutoresizingMaskIntoConstraints = false;
        trainDirectionLabel.backgroundColor = UIColor.white
        trainDirectionLabel.textColor = UIColor.black
        trainDirectionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        trainDirectionLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        trainDirectionLabel.topAnchor.constraint(equalTo: trainNumberLabel.bottomAnchor, constant: 10).isActive = true;
        trainDirectionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        
        
        vehicleCountLabel.translatesAutoresizingMaskIntoConstraints = false;
        vehicleCountLabel.backgroundColor = UIColor.white
        vehicleCountLabel.textColor = UIColor.black
        vehicleCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        vehicleCountLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        vehicleCountLabel.topAnchor.constraint(equalTo: trainDirectionLabel.bottomAnchor, constant: 10).isActive = true;
        vehicleCountLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true;
        
        
    }
    
    
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            // Configure the view for the selected state
        }
}
