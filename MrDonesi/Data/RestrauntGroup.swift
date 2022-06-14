//
//  RestrauntGroup.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation

public struct RestrauntGroup: Codable {
    var name: String
    var imageUrl: String?
    var stores: [Restraunt]
    var layout: RestaurantGroupLayout
}
