//
//  StoresViewController.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation
import SwiftUI
import Combine

class StoresViewController: UIViewController {
    let headerView: StoresListHeaderView
    let registeredSection: StoresSegmentView
    let restrauntsSection: StoresSegmentView
    let closedSection: StoresSegmentView
    
    @ObservedObject private var viewModel = MyStoresViewModel(provider: WebStoresProvider())
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        let vm = MyStoresViewModel(provider: WebStoresProvider())
        registeredSection = StoresSegmentView(viewModel: vm)
        restrauntsSection = StoresSegmentView(viewModel: vm)
        closedSection = StoresSegmentView(viewModel: vm)
        headerView = StoresListHeaderView()
        viewModel = vm
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let vm = MyStoresViewModel(provider: WebStoresProvider())
        registeredSection = StoresSegmentView(viewModel: vm)
        restrauntsSection = StoresSegmentView(viewModel: vm)
        closedSection = StoresSegmentView(viewModel: vm)
        headerView = StoresListHeaderView()
        viewModel = vm
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        //viewModel.delegate = self
        viewModel.loadData()
        viewModel.subject.sink(receiveValue: { action in
            self.on(action: action)
        }).store(in: &cancellable)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        self.view.addSubview(headerView)
        self.view.addSubview(registeredSection)
        self.view.addSubview(restrauntsSection)
        self.view.addSubview(closedSection)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let hCt = headerView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let hCh = headerView.heightAnchor.constraint(equalToConstant: UIDevice.hasTopNotch ? 120 : 80)
        let hCl = headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let hCtr = headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        NSLayoutConstraint.activate([hCt, hCh, hCl, hCtr])
        
        var prevView: UIView? = headerView
        for v in [registeredSection, restrauntsSection, closedSection] {
            v.translatesAutoresizingMaskIntoConstraints = false
            let tC = prevView == nil ? v.topAnchor.constraint(equalTo: self.view.topAnchor) : v.topAnchor.constraint(equalTo: prevView!.bottomAnchor)
            let wC = v.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            let hC = v.heightAnchor.constraint(equalToConstant: 210)
            let cyC = v.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            NSLayoutConstraint.activate([tC, wC, hC, cyC])
            prevView = v
        }
    }
    
    func on(action: StoresViewModelAction) {
        switch action {
        case .refreshData:
            refreshData()
        case .selectStore(let store):
            let storeVC = StoreViewController()
            storeVC.viewModel = MyStoreViewModel(store: store)
            self.present(storeVC, animated: true)
            //self.navigationController?.pushViewController(storeVC, animated: true)
        }
    }
    
    func refreshData() {
        registeredSection.title = viewModel.groups[0].name
        restrauntsSection.title = viewModel.groups[1].name
        closedSection.title = viewModel.groups[2].name
    }
}
