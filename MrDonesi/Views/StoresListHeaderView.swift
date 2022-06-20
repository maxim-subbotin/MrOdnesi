//
//  StoresListHeaderView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

class StoresListHeaderView: UIView {
    private var titleLabel = UILabel()
    private var locationLabel = UILabel()
    
    var address: String? {
        get {
            return locationLabel.text
        }
        set {
            locationLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = UIColor(hex6: 0x02c39a)
        
        locationLabel.text = "Serbia"
        locationLabel.textColor = .white
        locationLabel.font = .customMedium(ofSize: 14)
        addSubview(locationLabel)
        
        titleLabel.text = "MrDonesi"
        titleLabel.textColor = .white
        titleLabel.font = .customBold(ofSize: 22)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        locationLabel.curb()
            .setBottom(to: self)
            .setHeight(30)
            .setWidth(to: self, constant: -40)
            .setCenterX(to: self)
            .commit()
        
        titleLabel.curb()
            .setBottom(toTop: locationLabel)
            .setHeight(40)
            .setWidth(to: self, constant: -40)
            .setCenterX(to: self)
            .commit()
    }
}
