//
//  MenuGroupHeaderView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 16.06.2022.
//

import Foundation
import UIKit

class MenuGroupHeaderView: UIView {
    private var label = UILabel()
    var title: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        label.font = .customBold(ofSize: 22)
        label.textColor = .black
        self.addSubview(label)
        
        self.backgroundColor = .white
    }
    
    func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        let lCy = label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let lCl = label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        let lCh = label.heightAnchor.constraint(equalTo: self.heightAnchor)
        let lCt = label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        NSLayoutConstraint.activate([lCy, lCl, lCh, lCt])
    }
}
