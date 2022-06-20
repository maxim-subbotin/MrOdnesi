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
    
    var viewModel: StoresViewModel?
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
        headerView.curb()
            .setHeight(50)
            .setTop(to: self)
            .setWidth(to: self)
            .setCenterX(to: self)
            .commit()
        
        headerTitle.curb()
            .setHeight(to: headerView)
            .setCenter(view: headerView)
            .setWidth(to: headerView, constant: -40)
            .commit()
        
        groupScroll.curb()
            .setTop(toBottom: headerView)
            .setBottom(to: self)
            .setWidth(to: self)
            .setCenterX(to: self)
            .commit()
    }
    
    func onTapStore(index: Int) {
        tapCallback?(index)
    }
}
