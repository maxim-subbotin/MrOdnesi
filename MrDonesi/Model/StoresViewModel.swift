//
//  StoresViewModel.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import Combine
import UIKit

/*protocol StoresViewControllerDelegate: AnyObject {
    func refreshData()
}*/

enum StoresViewModelAction {
    case refreshData
    case selectStore(_ store: Store)
    case updateAddress(_ address: String)
}

protocol StoresViewModel: class {
    var groups: StoreSet { get }
    var subject: PassthroughSubject<StoresViewModelAction, Never> { get }
    func loadData()
    func group(forName name: String) -> StoreGroup?
    func downloadImage(forGroupName name: String, index: Int, callback: @escaping (Result<UIImage, Error>) -> ()) -> UUID?
    func storeName(group name: String, index: Int) -> String?
    func storeCategories(group name: String, index: Int) -> [String]?
    func clearData(id: UUID)
    func selectStore(index: Int, groupName: String)
}

class MyStoresViewModel: ObservableObject, StoresViewModel {
    enum StoreError: Error {
        case groupWithNameNotFound
        case wrongIndexInGroup
        case storeDoesntContainImage
        case incorrectStoreImage
    }
    // TODO: use dictionary: [String: [Store]]
    private(set) var groups = StoreSet()
    //weak var delegate: StoresViewControllerDelegate?
    var provider: StoresProvider
    var localProvider = LocalStoresProvider()
    var imageProvider = ImageProvider()
    var locationProvider = LocationProvider()
    var networkProvider = NetworkProvider()
    
    let subject = PassthroughSubject<StoresViewModelAction, Never>()
    var coordinate: CGPoint?
    var currentAddress: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var networkIsAvailable = true
    
    init(provider: StoresProvider) {
        self.provider = provider
        locationProvider
            .subject
            .sink(receiveValue: on(locationAction:))
            .store(in: &cancellables)
        networkProvider
            .subject
            .sink(receiveValue: on(networkStatus:))
            .store(in: &cancellables)
    }
    
    func loadData() {
        let lat = coordinate?.x ?? 0
        let lng = coordinate?.y ?? 0
        
        if networkIsAvailable {
            self.provider.fetchStores(latitude: lat, longitude: lng, callback: applyFetchStoresResult(_:))
        } else {
            localProvider.fetchStores(latitude: lat, longitude: lng, callback: applyFetchStoresResult(_:))
        }
        locationProvider.checkAuth()
    }
    
    private func applyFetchStoresResult(_ result: Result<[StoreGroup], Error>) {
        switch result {
        case .success(let groups):
            self.groups = StoreSet(groups: groups)
            self.subject.send(.refreshData)
        case .failure(let error):
            print("Error: \(error)")
        }
    }
    
    func group(forName name: String) -> StoreGroup? {
        return groups.group(byName: name)
    }
    
    func storeName(group name: String, index: Int) -> String? {
        guard let group = group(forName: name) else {
            return nil
        }
        if index >= group.stores.count {
            return nil
        }
        return group.stores[index].name
    }
    
    func storeCategories(group name: String, index: Int) -> [String]? {
        guard let group = group(forName: name) else {
            return nil
        }
        if index >= group.stores.count {
            return nil
        }
        return group.stores[index].categories.map({ $0.name })
    }
    
    func downloadImage(forGroupName name: String, index: Int, callback: @escaping (Result<UIImage, Error>) -> ()) -> UUID? {
        guard let group = group(forName: name) else {
            callback(.failure(StoreError.groupWithNameNotFound))
            return nil
        }
        if index >= group.stores.count {
            callback(.failure(StoreError.wrongIndexInGroup))
            return nil
        }
        let store = group.stores[index]
        if let path = store.imageUrl, let url = URL(string: path) {
            return imageProvider.fetchImage(url: url, isIcon: true, callback: callback)
        }
        return nil
    }
    
    func clearData(id: UUID) {
        imageProvider.cancel(requestId: id)
    }
    
    func selectStore(index: Int, groupName: String) {
        guard let group = group(forName: groupName) else {
            return
        }
        if index >= group.stores.count {
            return
        }
        let store = group.stores[index]
        subject.send(.selectStore(store))
    }
    
    private func on(locationAction action: LocationProvider.Action) {
        switch action {
        case .locationUpdated(let loc):
            //self.coordinate = CGPoint(x: loc.lat, y: loc.lng)
            self.currentAddress = loc.address
            subject.send(.updateAddress(loc.address))
            
            // TODO: for testing: ignore real coordinates, use places with the most massive data
            //loadData()
        }
    }
    
    private func on(networkStatus status: NetworkProvider.Status) {
        networkIsAvailable = status == .on
    }
}
