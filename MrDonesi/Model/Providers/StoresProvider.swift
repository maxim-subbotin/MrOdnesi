//
//  StoresProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

protocol StoresProvider {
    func fetchStores(callback: @escaping (Result<[StoreSet], Error>) -> ())
    func fetchStoreInfo(storeId: Int, callback: @escaping (Result<Store, Error>) -> ())
}

class WebStoresProvider: StoresProvider {
    func fetchStores(callback: @escaping (Result<[StoreSet], Error>) -> ()) {
        let command = StoreGroupsCommand()
        command.fetchData(callback: { res in
            switch res {
            case .success(let stores):
                callback(.success(stores))
            case .failure(let error):
                callback(.failure(error))
            }
        })
    }
    
    func fetchStoreInfo(storeId: Int, callback: @escaping (Result<Store, Error>) -> ()) {
        let command = StoreInfoCommand()
        command.storeId = storeId
        command.fetchData(callback: { res in
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
    func fetchStores(callback: @escaping (Result<[StoreSet], Error>) -> ()) {
        assertionFailure("Not implemented")
    }
    
    func fetchStoreInfo(storeId: Int, callback: @escaping (Result<Store, Error>) -> ()) {
        assertionFailure("Not implemented")
    }
    
    
}
