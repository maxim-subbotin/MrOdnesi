//
//  DeliveryZone.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import UIKit

struct DeliveryZone: Codable {
    var name: String
    var active: Bool
    var priority: Int
    var polygon: Polygon
    
    enum CodingKeys: CodingKey {
        case name, active, priority, polygon
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        active = try values.decode(Bool.self, forKey: .active)
        priority = try values.decode(Int.self, forKey: .priority)
        let polStrings = try values.decode([String].self, forKey: .polygon)
        polygon = Polygon(points: polStrings.compactMap({ CGPoint(coordinateString: $0) }))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(active, forKey: .active)
        try container.encode(priority, forKey: .priority)
        try container.encode(polygon.points.map({ $0.coordinateString }), forKey: .polygon)
    }
}
