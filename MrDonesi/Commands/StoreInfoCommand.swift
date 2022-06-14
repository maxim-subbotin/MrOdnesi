//
//  StoreInfoCommand.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

public class StoreInfoCommand: Command<Store, ServerError> {
    public var latitude: Double {
        get {
            return 0
        }
        set {
            self.urlParametes.append(.double(param: newValue, name: "lat"))
        }
    }
    public var longitude: Double {
        get {
            return 0
        }
        set {
            self.urlParametes.append(.double(param: newValue, name: "lng"))
        }
    }
    public var storeId: Int {
        get {
            return 0
        }
        set {
            self.pathComponents.append("\(newValue)")
        }
    }
    
    public init() {
        super.init(apiUrl: "https://api.mrdonesi.com/api/public", path: "store")
    }
}
