//
//  WorkingHours.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation

struct WorkingHoursWeek: Codable {
    var monday: [WorkingHours]?
    var tuesday: [WorkingHours]?
    var wednesday: [WorkingHours]?
    var thursday: [WorkingHours]?
    var friday: [WorkingHours]?
    var saturday: [WorkingHours]?
    var sunday: [WorkingHours]?
    
    enum CodingKeys: String, CodingKey {
        case monday = "MONDAY"
        case tuesday = "TUESDAY"
        case wednesday = "WEDNESDAY"
        case thursday = "THURSDAY"
        case friday = "FRIDAY"
        case saturday = "SATURDAY"
        case sunday = "SUNDAY"
    }
}

struct WorkingHours: Codable {
    var start: String
    var end: String
}
