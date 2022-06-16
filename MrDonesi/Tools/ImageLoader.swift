//
//  Downloader.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit
import Combine

class ImageLoader {
    enum ImageLoaderError: Error {
        case serverError(_ error: Error)
        case cantConvertToImage
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var currentRequests = [UUID: URLSessionDownloadTask]()
    private var fileProvider = FileProvider()
    
    func fetchImage(url: URL, callback: @escaping (Result<UIImage, Error>) -> (), isIcon: Bool = false) -> UUID {
        let uuid = UUID()
        
        if let cachedImage = fileProvider.getFromCache(forUrl: url, allowIcon: isIcon) {
            callback(.success(cachedImage))
            return uuid
        }
        let task = URLSession.shared.downloadTask(with: url) { localUrl, response, error in
            defer {
                self.currentRequests.removeValue(forKey: uuid)
            }
            if error != nil {
                callback(.failure(ImageLoaderError.serverError(error!)))
                return
            }
            if let localUrl = localUrl, let img = UIImage(contentsOfFile: localUrl.path) {
                callback(.success(img))
                self.fileProvider.putInCache(image: img, forUrl: url)
            } else {
                callback(.failure(ImageLoaderError.cantConvertToImage))
            }
        }
        task.resume()
        
        currentRequests[uuid] = task
        return uuid
    }
    
    func cancel(requestId: UUID) {
        currentRequests[requestId]?.cancel()
        currentRequests.removeValue(forKey: requestId)
    }
}
