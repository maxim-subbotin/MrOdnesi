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
    // TODO: make icon monochrome for closed stores
    let closedSection: StoresSegmentView
    
    @ObservedObject private var viewModel = MrDiStoresViewModel(provider: WebStoresProvider())
    
    private var cancellable = Set<AnyCancellable>()
    
    private var recommendedHeightConstraint = "recommended_height"
    private var restrauntsHeightConstraint = "restraunts_height"
    private var closedHeightConstraint = "closed_height"
    
    private var isFirstAppearance = true
    
    init() {
        let vm = MrDiStoresViewModel(provider: WebStoresProvider())
        recommendedSection = StoresSegmentView(viewModel: vm)
        restrauntsSection = StoresSegmentView(viewModel: vm)
        closedSection = StoresSegmentView(viewModel: vm)
        viewModel = vm
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let vm = MrDiStoresViewModel(provider: WebStoresProvider())
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
        // TODO: show spinner while data is loading
        // TODO: reload data on view pull down
        // load data on first view appearance only
        if isFirstAppearance {
            viewModel.startDataFetching()
            //viewModel.loadData()
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
        headerView.curb()
            .setTop(to: self.view)
            .setHeight(UIDevice.hasTopNotch ? 120 : 80)
            .setWidth(to: self.view)
            .setCenterX(to: self.view)
            .commit()
        
        scrollView.curb()
            .setTop(toBottom: headerView)
            .setWidth(to: self.view)
            .setBottom(to: self.view)
            .setCenterX(to: self.view)
            .commit()
    }
    
    func applySections() {
        recommendedSection.removeFromSuperview()
        restrauntsSection.removeFromSuperview()
        closedSection.removeFromSuperview()
        
        var views = [UIView]()
        if viewModel.groups.recommended != nil {
            views.append(recommendedSection)
        }
        if viewModel.groups.restraunts != nil {
            views.append(restrauntsSection)
        }
        if viewModel.groups.closed != nil {
            views.append(closedSection)
        }
        
        var prevView: UIView? = nil
        for v in views {
            scrollView.addSubview(v)
            if prevView == nil {
                v.curb()
                    .setTop(to: scrollView)
                    .setWidth(to: scrollView)
                    .setHeight(210)
                    .setCenterX(to: scrollView)
                    .commit()
            } else {
                v.curb()
                    .setTop(toBottom: prevView!)
                    .setWidth(to: scrollView)
                    .setHeight(210)
                    .setCenterX(to: scrollView)
                    .commit()
            }
            prevView = v
        }
    }
    
    private func on(action: StoresViewModelAction) {
        switch action {
        case .refreshData:
            refreshData()
        case .selectStore(let store):
            let storeVC = StoreViewController()
            let storeViewModel = MrDiStoreViewModel(store: store, provider: viewModel.provider)
            storeViewModel.currentLocation = viewModel.coordinate
            storeVC.viewModel = storeViewModel
            self.navigationController?.pushViewController(storeVC, animated: true)
        case .updateAddress(let address):
            headerView.address = address
        default:
            print("\(action)")
        }
    }
    
    private func refreshData() {
        // TODO: make section hiding/showing more elegant
        applySections()
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
