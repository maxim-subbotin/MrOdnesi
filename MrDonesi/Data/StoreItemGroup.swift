//
//  StoreGroup.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

struct StoreItemGroup: Codable {
    var id: Int
    var storeId: Int
    var name: String
    var active: Bool
    var hidden: Bool
    var priority: Int
    //var hiddenTimetable: // TODO: What's field?
    var items: [StoreGroupItem]
}
