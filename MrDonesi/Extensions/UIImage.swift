//
//  UIImage.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

extension UIImage {
    func resize(fitWidth w: CGFloat) -> UIImage {
        let h = w * size.height / size.width
        return resize(size: CGSize(width: w, height: h))
    }
    
    func resize(size targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        var newImage: UIImage? = nil
        autoreleasepool {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1) //UIScreen.main.scale)
            self.draw(in: CGRect(origin: .zero, size: newSize))
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }

        return newImage ?? UIImage()
    }
}
