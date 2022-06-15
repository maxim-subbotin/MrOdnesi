//
//  Downloader.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

class ImageLoader {
    enum ImageLoaderError: Error {
        case serverError(_ error: Error)
        case cantConvertToImage
    }
    
    func fetchImage(url: URL, callback: @escaping (Result<UIImage, Error>) -> ()) {
        // TODO: use cache
        let task = URLSession.shared.downloadTask(with: url) { url, response, error in
            if error != nil {
                callback(.failure(ImageLoaderError.serverError(error!)))
                return
            }
            if let url = url, let img = UIImage(contentsOfFile: url.path) {
                callback(.success(img))
            } else {
                callback(.failure(ImageLoaderError.cantConvertToImage))
            }
        }
        task.resume()
    }
}
