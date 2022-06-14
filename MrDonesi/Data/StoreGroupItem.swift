//
//  StoreGroupItem.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

// Food or Dish?
struct StoreGroupItem: Codable {
    var id: Int?
    var name: String
    var description: String?
    var options: [String: StoreItemOption]
    var imageUrl: String?
    var maxCountPerOrder: Int
    var groupId: Int
    var active: Bool
    var priority: Int?
    var displayPrice: Double
    var displayDiscount: Double?
    var hidden: Bool
    var alcohol: Bool
    var large: Bool
    var deleted: Bool
}
