//
//  StoreItemOption.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

struct StoreItemOption: Codable {
    var description: String?
    var active: Bool
    var price: Int
    var priority: Int?
    var discount: Int?
    var discountPlatformShare: String?
    //var addons: // what's type?
}
