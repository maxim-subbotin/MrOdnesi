//
//  CGPoint.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import UIKit

public extension CGPoint {
    init?(coordinateString s: String) {
        let parts = s.components(separatedBy: ",")
        if parts.count != 2 {
            return nil
        }
        guard let lat = Double(parts[0]), let lng = Double(parts[1]) else {
            return nil
        }
        self.init(x: lat, y: lng)
    }
    
    var coordinateString: String {
        get {
            return "\(x),\(y)"
        }
    }
}
