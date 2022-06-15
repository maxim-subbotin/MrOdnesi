//
//  String.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

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
}
