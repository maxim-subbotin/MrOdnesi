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
}

protocol StoresViewModel {
    var groups: [StoreSet] { get }
    var subject: PassthroughSubject<StoresViewModelAction, Never> { get }
    func loadData()
    func group(forName name: String) -> StoreSet?
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
    private(set) var groups = [StoreSet]()
    //weak var delegate: StoresViewControllerDelegate?
    var provider: StoresProvider
    var imageProvider = ImageProvider()
    
    let subject = PassthroughSubject<StoresViewModelAction, Never>()
    
    init(provider: StoresProvider) {
        self.provider = provider
    }
    
    func loadData() {
        self.provider.fetchStores(callback: { res in
            switch res {
            case .success(let sets):
                self.groups = sets
                self.subject.send(.refreshData)
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }
    
    func group(forName name: String) -> StoreSet? {
        return groups.filter({ $0.name == name }).first
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
}
