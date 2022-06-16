//
//  MenuItemCellView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 16.06.2022.
//

import Foundation
import UIKit

class MenuItemCellView: UITableViewCell {
    private var nameLabel = UILabel()
    private var descLabel = UILabel()
    private var priceLabel = UILabel()
    private var iconView = UIImageView()
    private var inactiveView = UIView()
    
    var groupNumber: Int?
    var itemNumber: Int?
    
    private var currentGuid: UUID?
    
    weak var viewModel: StoreViewModel? {
        didSet {
            prepare()
        }
    }

    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    var itemDescription: String? {
        get {
            return descLabel.text
        }
        set {
            descLabel.text = newValue
        }
    }
    var itemPrice: String? {
        get {
            return priceLabel.text
        }
        set {
            priceLabel.text = newValue
        }
    }
    var active: Bool {
        get {
            return inactiveView.isHidden
        }
        set {
            inactiveView.isHidden = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        nameLabel.textColor = .black
        nameLabel.font = .customBold(ofSize: 16)
        self.contentView.addSubview(nameLabel)
        
        descLabel.textColor = .gray
        descLabel.font = .customMedium(ofSize: 14)
        descLabel.numberOfLines = 2
        self.contentView.addSubview(descLabel)
        
        priceLabel.textColor = .black
        priceLabel.font = .customBold(ofSize: 16)
        self.contentView.addSubview(priceLabel)
        
        iconView.contentMode = .scaleAspectFill
        iconView.alpha = 0
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 5
        self.contentView.addSubview(iconView)
        
        inactiveView.backgroundColor = UIColor(hex6: 0x000000, alpha: 0.1)
        inactiveView.isHidden = true
        self.contentView.addSubview(inactiveView)
    }
    
    func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let ivCh = iconView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20)
        let ivCw = iconView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20)
        let ivCy = iconView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        let ivCt = iconView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20)
        NSLayoutConstraint.activate([ivCh, ivCw, ivCy, ivCt])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nlCh = nameLabel.heightAnchor.constraint(equalToConstant: 40)
        let nlCl = nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        let nlCt = nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        let nlCtr = nameLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -20)
        NSLayoutConstraint.activate([nlCh, nlCl, nlCt, nlCtr])
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        let dlCh = descLabel.heightAnchor.constraint(equalToConstant: 40)
        let dlCl = descLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        let dlCt = descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
        let dlCtr = descLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -20)
        NSLayoutConstraint.activate([dlCh, dlCl, dlCt, dlCtr])
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        let plCh = priceLabel.heightAnchor.constraint(equalToConstant: 40)
        let plCl = priceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        let plCt = priceLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor)
        let plCtr = priceLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -20)
        NSLayoutConstraint.activate([plCh, plCl, plCt, plCtr])
        
        inactiveView.translatesAutoresizingMaskIntoConstraints = false
        let iaCw = inactiveView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
        let iaCh = inactiveView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor)
        let iaCx = inactiveView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        let iaCy = inactiveView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        NSLayoutConstraint.activate([iaCw, iaCh, iaCx, iaCy])
    }
    
    deinit {
        clear()
    }
    
    func prepare() {
        if let groupNumber = groupNumber, let itemNumber = itemNumber {
            currentGuid = viewModel?.downloadImage(groupNum: groupNumber, itemNum: itemNumber, callback: {[weak self] res in
                switch res {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.iconView.image = image
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                            self?.iconView.alpha = 1.0
                        }
                    }
                case .failure(let error):
                    print("\(error)")
                    // TODO: show "!" icon on image area
                }
            })
        }
    }
    
    func clear() {
        iconView.image = nil
        iconView.alpha = 0
        if let id = currentGuid {
            viewModel?.clearData(id: id)
        }
    }
}
