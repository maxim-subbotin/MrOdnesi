//
//  RestrauntFullInfo.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

// Merge with Restraunt and rename
struct RestrauntFullInfo: Codable {
    var id: Int
    var name: String
    var slug: String?
    var lat: Double
    var lng: Double
    var city: String
    var location: String
    var phone: String?
    var categories: [RestrauntCategory]
    var type: String // TODO: enum
    var imageUrl: String?
    var rating: Double
    var ratingCount: Int
    var offline: Bool
    var closed: Bool
    var blocked: Bool
    var priceRange: String?
    var openTime: String?
    var closeTime: String?
    var termsOfServiceUrl: String?
    var privacyPolicyUrl: String?
    var website: String?
    var workingHours: WorkingHoursWeek
    var available: Bool
    var minimumOrder: Int
    var distance: Int
    var deliveryCost: Int
    var deliveryDiscount: String? // ???
    var deliveryTime: String?
    var priority: Int
    var priorityType: String // TODO: enum
    var marketPlace: Bool
    var discountMessage: String?
    var coveringFreeDelivery: Bool
    var favorite: Bool
    var groups: [StoreGroup]
}
