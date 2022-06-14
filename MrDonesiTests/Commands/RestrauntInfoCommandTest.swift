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
    
    let storeIds = [3127,4581,3119,4255,3893,3303,3251,4607,3143,3781,3529,4671,3293,4493,4811,3463,3121,3519,3515,4215,5149,5249,5289,5175,4367,3051,3469,3647,3621,3523,4955,4991,3727,4781,4961,3783,4985,3113,4617,5113,4823,4449,3451,4565,3483,3663,4713,4347,3091,3407,4049,4211,3697,4697,4771,3757,3863,4475,3891,4517,4103,3371,3589,4515,4111,4445,4385,4335,4807,3683,4319,4389,4599,3771,4569,4395,4625,4767,3295,4285,4745,3283,3445,4193,3081,4721,3249,3365,4143,4967,3603,4251,4351,4497,4329,3053,3597,4447,3599,4027,3481,4213,5001,4913,4879,3563,4085,5003,5163,4153,4171,4191,4253,4331,4409,4443,4451,4489,4559,4579,4611,4613,4627,4657,4965,4979,5039,5109,5215,5225,3399,3633,3853,3897,3987,4005,4025,4029]
    
    override func setUp() {
        command = RestrauntInfoCommand()
    }
    
    func testSingleCommand() {
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
    
    func testWrongCommad() {
        let exp = expectation(description: "command")
        command.storeId = 4581
        command.latitude = 20
        command.longitude = 30
        command.fetchData(callback: { result in
            switch result {
            case .success(_):
                assertionFailure("Command should return an error")
            case .failure(let error):
                if case let RestrauntInfoCommand.CommandError.serverError(err) = error {
                    print("Correct error has been returned: \(err)")
                } else {
                    assertionFailure("Command produced an error: \(error)")
                }
            }
            exp.fulfill()
        })
        wait(for: [exp], timeout: 60)
    }
    
    func testCommandSet() {
        for id in storeIds {
            let exp = expectation(description: "command")
            command = RestrauntInfoCommand()
            command.storeId = id
            command.latitude = 44.8088835
            command.longitude = 20.4634834
            command.fetchData(callback: { result in
                switch result {
                case .success(let store):
                    print(store)
                case .failure(let error):
                    assertionFailure("Command produced an error: \(error) for storeId: \(id)")
                }
                exp.fulfill()
            })
            wait(for: [exp], timeout: 60)
        }
    }
}
