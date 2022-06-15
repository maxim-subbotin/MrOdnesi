//
//  ImageProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

class ImageProvider {
    var imageLoader = ImageLoader()
    
    func fetchImage(url: URL, callback: @escaping (Result<UIImage, Error>) -> ()) {
        imageLoader.fetchImage(url: url, callback: callback)
    }
}
