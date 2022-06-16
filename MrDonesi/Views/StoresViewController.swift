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
    
    private var cancellable = Set<AnyCancellable>()
    
    private var recommendedHeightConstraint = "recommended_height"
    private var restrauntsHeightConstraint = "restraunts_height"
    private var closedHeightConstraint = "closed_height"
    
    private var isFirstAppearance = true
    
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
        viewModel.subject.sink(receiveValue: { action in
            self.on(action: action)
        }).store(in: &cancellable)
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: reload data on view pull down
        // load data on first view appearance only
        if isFirstAppearance {
            viewModel.loadData()
            isFirstAppearance = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize.height = 3 * 210
    }
    
    private func setupViews() {
        self.view.addSubview(headerView)
        
        scrollView.addSubview(recommendedSection)
        scrollView.addSubview(restrauntsSection)
        scrollView.addSubview(closedSection)
        self.view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
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
        for v in [(recommendedHeightConstraint, recommendedSection),
                  (restrauntsHeightConstraint, restrauntsSection),
                  (closedHeightConstraint, closedSection)] {
            v.1.translatesAutoresizingMaskIntoConstraints = false
            let tC = prevView == nil ? v.1.topAnchor.constraint(equalTo: scrollView.topAnchor) : v.1.topAnchor.constraint(equalTo: prevView!.bottomAnchor)
            let wC = v.1.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
            let hC = v.1.heightAnchor.constraint(equalToConstant: 0)
            hC.identifier = v.0
            let cyC = v.1.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor)
            NSLayoutConstraint.activate([tC, wC, hC, cyC])
            prevView = v.1
        }
    }
    
    private func on(action: StoresViewModelAction) {
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
    
    private func refreshData() {
        // TODO: hide sections if data is not presented in set
        if viewModel.groups.recommended != nil {
            recommendedSection.title = viewModel.groups.recommended!.name
            show(true, section: recommendedSection, constraintId: recommendedHeightConstraint)
        } else {
            show(false, section: recommendedSection, constraintId: recommendedHeightConstraint)
        }
        if viewModel.groups.restraunts != nil {
            restrauntsSection.title = viewModel.groups.restraunts!.name
            show(true, section: restrauntsSection, constraintId: restrauntsHeightConstraint)
        } else {
            show(false, section: restrauntsSection, constraintId: restrauntsHeightConstraint)
        }
        if viewModel.groups.closed != nil {
            closedSection.title = viewModel.groups.closed!.name
            show(true, section: closedSection, constraintId: closedHeightConstraint)
        } else {
            show(false, section: restrauntsSection, constraintId: restrauntsHeightConstraint)
        }
    }
    
    private func show(_ val: Bool, section: UIView, constraintId: String) {
        if let hC = section.constraints.first(where: { $0.identifier == constraintId }) {
            hC.constant = val ? 210 : 0
        }
    }
}
