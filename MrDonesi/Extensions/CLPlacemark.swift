//
//  CLPlacemaker.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 16.06.2022.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var address: String {
        return [subThoroughfare, thoroughfare, locality, administrativeArea, country]
            .reversed()
            .compactMap({ $0 })
            .joined(separator: ", ")
    }
}
