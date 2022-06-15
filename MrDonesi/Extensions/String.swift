//
//  String.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String {
    func height(withConstrainedWidth width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)

        return ceil(boundingBox.height)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        return height(withConstrainedWidth: width, attributes: [.font: font, .paragraphStyle: style])
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        return width(withConstrainedHeight: height, attributes: [.font: font, .paragraphStyle: style])
    }
    
    func width(withConstrainedHeight height: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)

        return ceil(boundingBox.width)
    }
    
    var md5: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.reduce("") {$0 + String(format: "%02x", $1)}
    }
}
