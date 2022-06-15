//
//  FileProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

class FileProvider {
    private enum Folders: String {
        case cachedImages
        case cachedIcons
    }
    
    var cachedImagesFolder: URL? {
        return checkAndCreate(folder: Folders.cachedImages)
    }
    
    var cachedIconsFolder: URL? {
        return checkAndCreate(folder: Folders.cachedIcons)
    }
    
    private func checkAndCreate(folder: Folders) -> URL? {
        if let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let folder = docFolder.appendingPathComponent(folder.rawValue)
            if !FileManager.default.fileExists(atPath: folder.path) {
                do {
                    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
                } catch {
                    return nil
                }
            }
            return folder
        } else {
            return nil
        }
    }
    
    func putInCache(image: UIImage, forUrl url: URL) {
        if let folder = cachedImagesFolder, let data = image.jpegData(compressionQuality: 0.8) {
            let fileName = "\(url.path.md5).jpg"
            let fileUrl = folder.appendingPathComponent(fileName)
            try? data.write(to: fileUrl)
        }
    }
    
    func getFromCache(forUrl url: URL) -> UIImage? {
        if let folder = cachedImagesFolder {
            let fileName = "\(url.path.md5).jpg"
            let fileUrl = folder.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: fileUrl.path),
               let data = try? Data(contentsOf: fileUrl),
               let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
