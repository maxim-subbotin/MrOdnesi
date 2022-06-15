//
//  UIFont.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

public extension UIFont {
    static func customMedium(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Nunito-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    static func customBold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Nunito-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}
