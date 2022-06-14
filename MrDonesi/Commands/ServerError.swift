//
//  ServerError.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation

public struct ServerError: Codable {
    var error: String
    var code: Int
    var message: String
    var localizedMessage: String
    
    enum CodingKeys: String, CodingKey {
        case error
        case code
        case message
        case localizedMessage = "message_sr"
    }
}
