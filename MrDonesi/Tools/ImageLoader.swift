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
    class Cache {
        private var images = NSCache<NSString, UIImage>()
        
        init() {
            images.countLimit = 1000
            images.totalCostLimit = 512 * 1024 * 1024
        }
        
        func set(_ image: UIImage, key: String) {
            let cacheId = key as NSString
            images.setObject(image, forKey: cacheId)
        }
        
        func image(_ key: String) -> UIImage? {
            let cacheId = key as NSString
            return images.object(forKey: cacheId)
        }
    }
    
    enum ImageLoaderError: Error {
        case serverError(_ error: Error)
        case cantConvertToImage
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var cache = Cache()
    private var currentRequests = [UUID: URLSessionDownloadTask]()
    
    func fetchImage(url: URL, callback: @escaping (Result<UIImage, Error>) -> ()) -> UUID {
        let uuid = UUID()
        
        // TODO: make cached images available after app relaunching
        // TODO: save image icons (300x300) to optimize gallery cells
        if let cachedImage = cache.image(url.path) {
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
                self.cache.set(img, key: url.path)
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
