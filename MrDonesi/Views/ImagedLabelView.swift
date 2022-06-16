//
//  ImagedLabelView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

class ImageLabelView: UIView {
    private var iconView = UIImageView()
    private var label = UILabel()
    var image: UIImage? {
        get {
            return iconView.image
        }
        set {
            iconView.image = newValue
        }
    }
    var title: String? {
        get {
            return label.text
        }
        set {
            label.attributedText = nil
            label.text = newValue
        }
    }
    var attributedTitle: NSAttributedString? {
        get {
            return label.attributedText
        }
        set {
            label.text = nil
            label.attributedText = newValue
        }
    }
    var iconColor: UIColor {
        get {
            return iconView.tintColor
        }
        set {
            iconView.tintColor = newValue
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
        self.iconView.contentMode = .scaleAspectFit
        self.addSubview(iconView)
        
        label.font = .customMedium(ofSize: 14)
        label.textColor = .black
        self.addSubview(label)
    }
    
    func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let ivCw = iconView.widthAnchor.constraint(equalToConstant: 20)
        let ivCh = iconView.heightAnchor.constraint(equalToConstant: 20)
        let ivCl = iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let ivCy = iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([ivCw, ivCh, ivCl, ivCy])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let lCl = label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 15)
        let lCh = label.heightAnchor.constraint(equalTo: self.heightAnchor)
        let lCt = label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let lCy = label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([lCl, lCh, lCt, lCy])
    }
}
