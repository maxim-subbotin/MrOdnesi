//
//  StoreGroupsCommand.swift
//  MrDonesiTests
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation
import XCTest
import MrDonesi

class StoreGroupsCommandTest: XCTestCase {
    var command = StoreGroupsCommand()
    
    override func setUpWithError() throws {
        
    }
    
    func testCommand() {
        let exp = expectation(description: "command")
        command.latitude = 44.8088835
        command.longitude = 20.4634834
        command.fetchData(callback: { result in
            switch result {
            case .success(let groups):
                assert(groups.count == 3, "Wrong count of restaurant groups")
            case .failure(let error):
                assertionFailure("Command produced an error: \(error)")
            }
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60)
    }
}
