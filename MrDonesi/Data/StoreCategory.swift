//
//  StoreCategory.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation

struct StoreCategory: Codable {
    var id: Int
    var name: String
    var imageUrl: String?
    var categoryPriority: Int
    var forGrouping: Bool
    var promo: Bool
    var priority: Int
}
