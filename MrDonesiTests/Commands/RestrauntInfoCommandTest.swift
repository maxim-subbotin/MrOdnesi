//
//  RestrauntInfoCommandTest.swift
//  MrDonesiTests
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import XCTest
import MrDonesi

class RestrauntInfoCommandTest: XCTestCase {
    var command = RestrauntInfoCommand()
    
    func testCommand() {
        let exp = expectation(description: "command")
        command.storeId = 3587
        command.latitude = 44.8088835
        command.longitude = 20.4634834
        command.fetchData(callback: { result in
            switch result {
            case .success(let store):
                print(store)
            case .failure(let error):
                assertionFailure("Command produced an error: \(error)")
            }
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60)
    }
}
