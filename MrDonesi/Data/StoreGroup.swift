//
//  StoreGroup.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation

public struct StoreGroup: Codable {
    var name: String
    var imageUrl: String?
    var stores: [Store]
    var layout: RestaurantGroupLayout
}

struct StoreSet {
    enum GroupType: String {
        case recommended = "Preporučeno"
        case restraunts = "Restorani"
        case closed = "Zatvoreno"
    }
    
    var recommended: StoreGroup?
    var restraunts: StoreGroup?
    var closed: StoreGroup?
    
    init() {}
    
    init(groups: [StoreGroup]) {
        recommended = groups.first(where: { $0.name == GroupType.recommended.rawValue })
        restraunts = groups.first(where: { $0.name == GroupType.restraunts.rawValue })
        closed = groups.first(where: { $0.name == GroupType.closed.rawValue })
    }
    
    func group(byName name: String) -> StoreGroup? {
        if let type = GroupType(rawValue: name) {
            switch type {
            case .recommended:
                return recommended
            case .restraunts:
                return restraunts
            case .closed:
                return closed
            }
        }
        return nil
    }
}
