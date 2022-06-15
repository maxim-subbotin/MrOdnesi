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
    
    func fetchImage(url: URL, callback: @escaping (Result<UIImage, Error>) -> ()) -> UUID {
        return imageLoader.fetchImage(url: url, callback: callback)
    }
    
    func cancel(requestId: UUID) {
        imageLoader.cancel(requestId: requestId)
    }
}
