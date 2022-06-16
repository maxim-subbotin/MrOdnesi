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
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        let llCb = locationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let llCw = locationLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40)
        let llCh = locationLabel.heightAnchor.constraint(equalToConstant: 30)
        let llCx = locationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([llCb, llCw, llCh, llCx])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let tlCb = titleLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor)
        let tlCw = titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40)
        let tlCh = titleLabel.heightAnchor.constraint(equalToConstant: 40)
        let tlCx = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([tlCb, tlCw, tlCh, tlCx])
    }
}
