//
//  CGPointExtTest.swift
//  MrDonesiTests
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import XCTest

class CGPointExtTest: XCTestCase {
    let strArray = ["44.8151536,20.4917548",
                    "44.8112263,20.487077",
                    "44.8080728,20.4820815",
                    "44.804741,20.4770776",
                    "44.8034621,20.480071",
                    "44.8026095,20.4818412",
                    "44.8007216,20.4835578",
                    "44.7975356,20.4872383",
                    "44.7963327,20.4895343",
                    "44.7954496,20.4899956",
                    "44.7930589,20.4956926",
                    "44.7926553,20.4962612",
                    "44.7912848,20.4977633",
                    "44.7922861,20.5025694",
                    "44.793291,20.5038784",
                    "44.7938697,20.5046294",
                    "44.7943174,20.5055875",
                    "44.7935469,20.5074684",
                    "44.792551,20.507209",
                    "44.79248,20.509161",
                    "44.7945306,20.5122516",
                    "44.7959612,20.5095616",
                    "44.797005,20.508497",
                    "44.797583,20.508631",
                    "44.798115,20.510144",
                    "44.79999,20.508196",
                    "44.800045,20.507539"]
    
    func testStringToPoint() {
        for str in strArray {
            let point = CGPoint(coordinateString: str)
            XCTAssertNotNil(point, "Function returns nil object for string = \(str)")
        }
    }
    
    func testIncorrectStringToPoint() {
        let str = "45.0 90.0"
        let point = CGPoint(coordinateString: str)
        XCTAssertNil(point, "Function returns nil object for string = \(str)")
    }
    
    func testPointToString() {
        let point = CGPoint(x: 12.34567, y: 98.76543)
        let str = point.coordinateString
        XCTAssert(str == "12.34567,98.76543", "Function returns wrong converted string")
    }
}
