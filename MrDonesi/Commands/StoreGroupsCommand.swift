//
//  StoreGroupsCommand.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation

public class StoreGroupsCommand: Command<[StoreGroup], ServerError> {
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
    
    public init() {
        super.init(apiUrl: "https://api.mrdonesi.com/api/public", path: "store/explore-v2")
    }
}
