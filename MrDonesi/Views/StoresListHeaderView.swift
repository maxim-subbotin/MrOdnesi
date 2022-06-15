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
        
        titleLabel.text = "MrDonesi"
        titleLabel.textColor = .white
        titleLabel.font = .customBold(ofSize: 22)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let tlCb = titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let tlCw = titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40)
        let tlCh = titleLabel.heightAnchor.constraint(equalToConstant: 50)
        let tlCx = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([tlCb, tlCw, tlCh, tlCx])
    }
}
