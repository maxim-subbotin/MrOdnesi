//
//  ArrayMergerTest.swift
//  MrDonesiTests
//
//  Created by Maxim Subbotin on 17.06.2022.
//

import Foundation
import XCTest
import MrDonesi

class ArrayMergerTest: XCTestCase {
    struct Color: Identifiable {
        var id: Int
        var name: String
    }
    var colors1: [Color] = [.init(id: 1, name: "Red"),
                            .init(id: 2, name: "Green"),
                            .init(id: 3, name: "Blue"),
                            .init(id: 7, name: "Silver")]
    var colors2: [Color] = [.init(id: 1, name: "Red"),
                            .init(id: 4, name: "Yellow"),
                            .init(id: 5, name: "Brown"),
                            .init(id: 2, name: "Green"),
                            .init(id: 6, name: "Purple")]
    
    func testMerge() {
        let m = ArrayMerger<Color>()
        let res = m.merge(oldArray: colors1, newArray: colors2)
        print(res)
        assert(res.deleted == [2, 3])
        assert(res.inserted == [2, 3, 4])
        assert(res.moves.count == 2)
    }
}
