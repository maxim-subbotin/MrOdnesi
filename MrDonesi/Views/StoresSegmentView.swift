//
//  StoresSegmentView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import UIKit

class StoresSegmentView: UIView {
    typealias StoreTapCallback = (Int) -> ()
    
    var headerView = UIView()
    var headerTitle = UILabel()
    var groupScroll: StoreGroupScrollView
    
    var viewModel: StoresViewModel
    var tapCallback: StoreTapCallback?
    
    var title: String {
        get {
            return headerTitle.text ?? ""
        }
        set {
            headerTitle.text = newValue
            groupScroll.name = newValue
        }
    }
    
    init(viewModel: StoresViewModel, name: String? = nil) {
        self.viewModel = viewModel
        //self.name = name
        
        groupScroll = StoreGroupScrollView(viewModel: viewModel, name: name)
        
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    /*override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }*/
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {
        headerView = UIView()
        headerView.backgroundColor = .white
        
        headerTitle = UILabel()
        headerTitle.font = .customBold(ofSize: 18)
        headerTitle.textColor = .black
        
        headerView.addSubview(headerTitle)
        
        self.addSubview(headerView)
        
        groupScroll.tapCallback = onTapStore(index:)
        self.addSubview(groupScroll)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let hvCh = headerView.heightAnchor.constraint(equalToConstant: 50)
        let hvCt = headerView.topAnchor.constraint(equalTo: self.topAnchor)
        let hvCl = headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let hvCtr = headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        NSLayoutConstraint.activate([hvCh, hvCt, hvCl, hvCtr])
        
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        let htCh = headerTitle.heightAnchor.constraint(equalTo: headerView.heightAnchor)
        let htCt = headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor)
        let htCl = headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20)
        let htCtr = headerTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 20)
        NSLayoutConstraint.activate([htCh, htCt, htCl, htCtr])
        
        groupScroll.translatesAutoresizingMaskIntoConstraints = false
        let gsCt = groupScroll.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        let gsCb = groupScroll.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let gsCl = groupScroll.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let gsCtr = groupScroll.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        NSLayoutConstraint.activate([gsCt, gsCb, gsCl, gsCtr])
    }
    
    func onTapStore(index: Int) {
        tapCallback?(index)
    }
}
