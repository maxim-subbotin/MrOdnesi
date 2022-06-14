//
//  StoreGroup.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation

public struct StoreSet: Codable {
    var name: String
    var imageUrl: String?
    var stores: [Store]
    var layout: RestaurantGroupLayout
}
