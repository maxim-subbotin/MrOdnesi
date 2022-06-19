//
//  StoresViewModel.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import Combine
import UIKit

enum StoresViewModelAction {
    case completeReloading
    case refreshData
    case selectStore(_ store: Store)
    case updateAddress(_ address: String)
    case updateCollection(name: String, delete: [Int], insert: [Int], move: [(from: Int, to: Int)])
}

protocol StoresViewModel: AnyObject {
    var groups: StoreSet { get }
    var subject: PassthroughSubject<StoresViewModelAction, Never> { get }
    func loadData()
    func startDataFetching()
    func group(forName name: String) -> StoreGroup?
    func downloadImage(forGroupName name: String, index: Int, callback: @escaping (Result<UIImage, Error>) -> ()) -> UUID?
    func storeName(group name: String, index: Int) -> String?
    func storeCategories(group name: String, index: Int) -> [String]?
    func clearData(id: UUID)
    func selectStore(index: Int, groupName: String)
}

class MrDiStoresViewModel: ObservableObject, StoresViewModel {
    enum StoreError: Error {
        case groupWithNameNotFound
        case wrongIndexInGroup
        case storeDoesntContainImage
        case incorrectStoreImage
    }
    private(set) var groups = StoreSet()
    var provider: StoresProvider
    var localProvider = LocalStoresProvider()
    var imageProvider = ImageProvider()
    var locationProvider: LocationProvider
    var networkProvider = NetworkProvider()
    
    let subject = PassthroughSubject<StoresViewModelAction, Never>()
    var coordinate: CGPoint?
    var currentAddress: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var networkIsAvailable = true
    
    init(provider: StoresProvider, locationProvider: LocationProvider = TestLocationProvider()) {
        self.provider = provider
        self.locationProvider = locationProvider
        locationProvider
            .subject
            .sink(receiveValue: on(locationAction:))
            .store(in: &cancellables)
        networkProvider
            .subject
            .sink(receiveValue: on(networkStatus:))
            .store(in: &cancellables)
    }
    
    /**
     Load temporary local data set and call location service
     */
    func startDataFetching() {
        localProvider.fetchStores(latitude: 0, longitude: 0, callback: applyFetchStoresResult(_:))
        locationProvider.checkAuth()
    }
    
    /**
     Load data from the API
     */
    func loadData() {
        let lat = coordinate?.x ?? 0
        let lng = coordinate?.y ?? 0
        
        self.provider.fetchStores(latitude: lat, longitude: lng, callback: applyFetchStoresResult(_:))
    }
    
    /**
     Pass new store groups set to collection views
     */
    private func applyFetchStoresResult(_ result: Result<[StoreGroup], Error>) {
        switch result {
        case .success(let groups):
            let newGroups = StoreSet(groups: groups)
            let merger = ArrayMerger<Store>()
            var updates = [StoresViewModelAction]()
            if newGroups.recommended != nil || self.groups.recommended != nil {
                let merge = merger.merge(oldArray: self.groups.recommended?.stores, newArray: newGroups.recommended?.stores)
                let name: String = self.groups.recommended?.name ?? (newGroups.recommended?.name ?? "")
                updates.append(
                    .updateCollection(name: name,
                                      delete: merge.deleted,
                                      insert: merge.inserted,
                                      move: merge.moves.map({ (from: $0.from, to: $0.to) })))
            }
            if newGroups.restraunts != nil || self.groups.restraunts != nil {
                let merge = merger.merge(oldArray: self.groups.restraunts?.stores, newArray: newGroups.restraunts?.stores)
                let name: String = self.groups.restraunts?.name ?? (newGroups.restraunts?.name ?? "")
                updates.append(
                    .updateCollection(name: name,
                                      delete: merge.deleted,
                                      insert: merge.inserted,
                                      move: merge.moves.map({ (from: $0.from, to: $0.to) })))
            }
            if newGroups.closed != nil || self.groups.closed != nil {
                let merge = merger.merge(oldArray: self.groups.closed?.stores, newArray: newGroups.closed?.stores)
                let name: String = self.groups.closed?.name ?? (newGroups.closed?.name ?? "")
                updates.append(
                    .updateCollection(name: name,
                                      delete: merge.deleted,
                                      insert: merge.inserted,
                                      move: merge.moves.map({ (from: $0.from, to: $0.to) })))
            }
            let completeReloading = self.groups.isEmpty
            self.groups = newGroups
            updates.append(.refreshData)
            if completeReloading {
                updates.append(.completeReloading)
            }
            updates.forEach({
                self.subject.send($0)
            })
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
    
    private func on(locationAction action: LocationAction) {
        switch action {
        case .locationUpdated(let loc):
            self.coordinate = CGPoint(x: loc.lat, y: loc.lng)
            self.currentAddress = loc.address
            subject.send(.updateAddress(loc.address))
            
            // TODO: for testing: ignore real coordinates, use places with the most massive data
            loadData()
        }
    }
    
    private func on(networkStatus status: NetworkProvider.Status) {
        networkIsAvailable = status == .on
    }
}
