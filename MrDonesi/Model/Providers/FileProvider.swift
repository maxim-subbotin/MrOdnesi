//
//  FileProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

class FileProvider {
    class SaveImageOperation: Operation {
        var image: UIImage
        var url: URL
        var folder: URL
        var iconFolder: URL
        
        init(image: UIImage, url: URL, folder: URL, iconFolder: URL) {
            self.image = image
            self.url = url
            self.folder = folder
            self.iconFolder = iconFolder
        }
        
        override func main() {
            let fileName = "\(url.path.md5).jpg"
            if let data = image.jpegData(compressionQuality: 0.8) {
                let fileUrl = folder.appendingPathComponent(fileName)
                try? data.write(to: fileUrl)
            }
            /*
             In case of using full-size images main gallery uses ~60 MB
             In case of using icons main gallery uses ~20 MB
             */
            if image.size.width > 300 {
                let icon = image.resize(fitWidth: 300)
                if let data = icon.jpegData(compressionQuality: 0.8) {
                    let fileUrl = iconFolder.appendingPathComponent(fileName)
                    try? data.write(to: fileUrl)
                }
            }
        }
    }
    
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
    
    private var queue = OperationQueue()
    
    init() {
        queue.maxConcurrentOperationCount = 4
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
        if let folder = cachedImagesFolder, let iconFolder = cachedIconsFolder {
            let operation = SaveImageOperation(image: image, url: url, folder: folder, iconFolder: iconFolder)
            queue.addOperation(operation)
        }
    }
    
    func getFromCache(forUrl url: URL, allowIcon: Bool = false) -> UIImage? {
        if allowIcon, let folder = cachedIconsFolder {
            if let icon = find(url: url, inFolder: folder) {
                return icon
            }
        }
        if let folder = cachedImagesFolder {
            return find(url: url, inFolder: folder)
        }
        return nil
    }
    
    private func find(url: URL, inFolder folder: URL) -> UIImage? {
        let fileName = "\(url.path.md5).jpg"
        let fileUrl = folder.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileUrl.path),
           let data = try? Data(contentsOf: fileUrl),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    func cleanTempDirectory() {
        let tempFolder = URL(fileURLWithPath: NSTemporaryDirectory(),
                                            isDirectory: true)
        print(tempFolder.path)
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: tempFolder.path) else {
            return
        }
        for file in files {
            let url = tempFolder.appendingPathComponent(file)
            try? FileManager.default.removeItem(at: url)
        }
    }
}
