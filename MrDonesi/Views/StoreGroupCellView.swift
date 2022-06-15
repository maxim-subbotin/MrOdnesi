//
//  StoreGroupCellView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import UIKit

class StoreGroupViewCell: UICollectionViewCell {
    var viewModel: StoresViewModel?
    private var imageView = UIImageView()
    private var toneView = UIView()
    private var titleLabel = UILabel()
    private var categoriesView = TagsView()
    var index: Int?
    var groupName: String?
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    var categories: [String]? {
        get {
            return categoriesView.tags
        }
        set {
            categoriesView.tags = newValue ?? []
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
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor

        contentView.layer.masksToBounds = true
        layer.cornerRadius = 10
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 5
        self.backgroundView?.layer.cornerRadius = 5
        
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        self.contentView.addSubview(imageView)
        
        toneView.backgroundColor = .black
        toneView.alpha = 0.1
        self.contentView.addSubview(toneView)
        
        // TODO: support of long store names, multilines
        titleLabel.textColor = .white
        titleLabel.font = .customMedium(ofSize: 20)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowRadius = 3.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.textAlignment = .center
        self.contentView.addSubview(titleLabel)
        
        self.contentView.addSubview(categoriesView)
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let ivCx = imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let ivCy = imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let ivCw = imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        let ivCh = imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        NSLayoutConstraint.activate([ivCx, ivCy, ivCw, ivCh])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let tlCx = titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let tlCy = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let tlCh = titleLabel.heightAnchor.constraint(equalToConstant: 50)
        let tlCw = titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -50)
        NSLayoutConstraint.activate([tlCx, tlCy, tlCh, tlCw])
        
        toneView.translatesAutoresizingMaskIntoConstraints = false
        let tnCx = toneView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let tnCy = toneView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let tnCh = toneView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        let tnCw = toneView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        NSLayoutConstraint.activate([tnCx, tnCy, tnCh, tnCw])
        
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        let ctCt = categoriesView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        let ctCb = categoriesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let ctCl = categoriesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        let ctCr = categoriesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        NSLayoutConstraint.activate([ctCt, ctCb, ctCl, ctCr])
    }
    
    func prepare() {
        if let groupName = groupName, let index = index {
            title = viewModel?.storeName(group: groupName, index: index)
            categories = viewModel?.storeCategories(group: groupName, index: index)
            viewModel?.downloadImage(forGroupName: groupName, index: index, callback: { res in
                switch res {
                case .success(let img):
                    DispatchQueue.main.async {
                        self.imageView.image = img
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                            self.imageView.alpha = 1.0
                        }
                    }
                case .failure(let error):
                    print("\(error)")
                }
            })
        } else {
            // set default image
        }
    }
    
    func clear() {
        imageView.image = nil
        imageView.alpha = 0
    }
}
