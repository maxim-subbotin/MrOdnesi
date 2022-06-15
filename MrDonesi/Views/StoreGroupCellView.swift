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
    var imageView = UIImageView()
    var index: Int?
    var groupName: String?
    
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
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let ivCx = imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let ivCy = imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let ivCw = imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        let ivCh = imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        NSLayoutConstraint.activate([ivCx, ivCy, ivCw, ivCh])
    }
    
    func prepare() {
        if let groupName = groupName, let index = index {
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
