//
//  StoresProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

protocol StoresProvider {
    func fetchStores(callback: @escaping (Result<[StoreGroup], Error>) -> ())
    func fetchStoreInfo(storeId: Int, callback: @escaping (Result<Store, Error>) -> ())
}

class WebStoresProvider: StoresProvider {
    var storesCommand: StoreGroupsCommand?
    var storeInfoCommand: StoreInfoCommand?
    
    func fetchStores(callback: @escaping (Result<[StoreGroup], Error>) -> ()) {
        storesCommand = StoreGroupsCommand()
        storesCommand?.latitude = 44.8088835
        storesCommand?.longitude = 20.4634834
        storesCommand?.fetchData(callback: { res in
            switch res {
            case .success(let stores):
                callback(.success(stores))
            case .failure(let error):
                callback(.failure(error))
            }
        })
    }
    
    func fetchStoreInfo(storeId: Int, callback: @escaping (Result<Store, Error>) -> ()) {
        storeInfoCommand = StoreInfoCommand()
        storeInfoCommand?.storeId = storeId
        storeInfoCommand?.fetchData(callback: { res in
            switch res {
            case .success(let store):
                callback(.success(store))
            case .failure(let error):
                callback(.failure(error))
            }
        })
    }
}

class LocalStoresProvider: StoresProvider {
    func fetchStores(callback: @escaping (Result<[StoreGroup], Error>) -> ()) {
        assertionFailure("Not implemented")
    }
    
    func fetchStoreInfo(storeId: Int, callback: @escaping (Result<Store, Error>) -> ()) {
        assertionFailure("Not implemented")
    }
    
    
}
