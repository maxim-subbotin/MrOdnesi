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
    let headerView = StoresListHeaderView()
    let scrollView = UIScrollView()
    let recommendedSection: StoresSegmentView
    let restrauntsSection: StoresSegmentView
    let closedSection: StoresSegmentView
    
    @ObservedObject private var viewModel = MyStoresViewModel(provider: WebStoresProvider())
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        let vm = MyStoresViewModel(provider: WebStoresProvider())
        recommendedSection = StoresSegmentView(viewModel: vm)
        restrauntsSection = StoresSegmentView(viewModel: vm)
        closedSection = StoresSegmentView(viewModel: vm)
        viewModel = vm
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let vm = MyStoresViewModel(provider: WebStoresProvider())
        recommendedSection = StoresSegmentView(viewModel: vm)
        restrauntsSection = StoresSegmentView(viewModel: vm)
        closedSection = StoresSegmentView(viewModel: vm)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize.height = 3 * 210
    }
    
    func setupViews() {
        self.view.addSubview(headerView)
        
        scrollView.addSubview(recommendedSection)
        scrollView.addSubview(restrauntsSection)
        scrollView.addSubview(closedSection)
        self.view.addSubview(scrollView)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let hCt = headerView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let hCh = headerView.heightAnchor.constraint(equalToConstant: UIDevice.hasTopNotch ? 120 : 80)
        let hCl = headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let hCtr = headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        NSLayoutConstraint.activate([hCt, hCh, hCl, hCtr])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let scCt = scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        let scCw = scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let scCx = scrollView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        let scCb = scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([scCt, scCw, scCx, scCb])
        
        var prevView: UIView? = nil
        for v in [recommendedSection, restrauntsSection, closedSection] {
            v.translatesAutoresizingMaskIntoConstraints = false
            let tC = prevView == nil ? v.topAnchor.constraint(equalTo: scrollView.topAnchor) : v.topAnchor.constraint(equalTo: prevView!.bottomAnchor)
            let wC = v.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
            let hC = v.heightAnchor.constraint(equalToConstant: 210)
            let cyC = v.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor)
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
            storeVC.viewModel = MyStoreViewModel(store: store, provider: viewModel.provider)
            self.navigationController?.pushViewController(storeVC, animated: true)
        case .updateAddress(let address):
            headerView.address = address
        }
    }
    
    func refreshData() {
        // TODO: hide sections if data is not presented in set
        if viewModel.groups.recommended != nil {
            recommendedSection.title = viewModel.groups.recommended!.name
        }
        if viewModel.groups.restraunts != nil {
            restrauntsSection.title = viewModel.groups.restraunts!.name
        }
        if viewModel.groups.closed != nil {
            closedSection.title = viewModel.groups.closed!.name
        }
    }
}
