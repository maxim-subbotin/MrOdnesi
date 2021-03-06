//
//  StoresProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

protocol StoresProvider {
    func fetchStores(latitude: Double, longitude: Double, callback: @escaping (Result<[StoreGroup], Error>) -> ())
    func fetchStoreInfo(storeId: Int, callback: @escaping (Result<Store, Error>) -> ())
}

class WebStoresProvider: StoresProvider {
    var storesCommand: StoreGroupsCommand?
    var storeInfoCommand: StoreInfoCommand?
    
    func fetchStores(latitude: Double = 0, longitude: Double = 0, callback: @escaping (Result<[StoreGroup], Error>) -> ()) {
        storesCommand = StoreGroupsCommand()
        // Just for test purposes: use default BG coordinates by default
        storesCommand?.latitude = latitude == 0 ? 44.8088835 : latitude
        storesCommand?.longitude = longitude == 0 ? 20.4634834 : longitude
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
    enum LocalStoreError: Error {
        case noDataInCache
    }
    
    let fileProvider = FileProvider()
    
    func fetchStores(latitude: Double, longitude: Double, callback: @escaping (Result<[StoreGroup], Error>) -> ()) {
        if let url = URL(string: "https://api.mrdonesi.com/api/public/store/explore-v2"),
           let data = fileProvider.getRequestDataFromCachec(forUrl: url),
           let groups = try? JSONDecoder().decode([StoreGroup].self, from: data) {
            callback(.success(groups))
        }
        callback(.failure(LocalStoreError.noDataInCache))
    }

    func fetchStoreInfo(storeId: Int, callback: @escaping (Result<Store, Error>) -> ()) {
        assertionFailure("Not implemented")
    }
}
