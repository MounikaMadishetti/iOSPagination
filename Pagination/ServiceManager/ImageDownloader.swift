//
//  ImageDownloader.swift
//  Pagination
//
//  Created by Mounika Madishetti on 14/09/21.
//

import Foundation
import UIKit

final class ImageDownloader {
    static let shared = ImageDownloader()
    private var cachedImages: [String: UIImage]
    private var imagesDownloadTasks: [String: URLSessionDataTask]
    
    let sqForImages = DispatchQueue(label: "images.queue", attributes: .concurrent)
    let sqForDataTasks = DispatchQueue(label: "datatasks.queue", attributes: .concurrent)
    var task: URLSessionDataTask!
    private init() {
        self.cachedImages = [:]
        self.imagesDownloadTasks = [:]
    }
    
    func downloadImage(with urlString: String?, completionHandler: @escaping (UIImage?, Bool) -> Void, placeHolderImage: UIImage?) {
        
        guard let urlString = urlString else {
            completionHandler(placeHolderImage, true)
            return
        }
        guard let url = URL(string: urlString) else {
           completionHandler(placeHolderImage, true)
            return
        }
        if let image = getCachedImageFor(urlString: urlString) {
            completionHandler(image, true)
            return
        } else {
            if let _ = getDataTasksFrom(urlString: urlString) {
                return
            }
            if let task = task {
                task.cancel()
            }
             task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                if let _ = error {
                    DispatchQueue.main.async {
                        completionHandler(placeHolderImage, true)
                    }
                    return
                }
                let image = UIImage(data: data)
                self.sqForImages.sync(flags: .barrier) {
                    self.cachedImages[urlString] = image
                }
                
                _ = self.sqForDataTasks.sync(flags: .barrier) {
                    self.imagesDownloadTasks.removeValue(forKey: urlString)
                }
                DispatchQueue.main.async {
                    completionHandler(image, false)
                }
                
            }
            self.sqForDataTasks.sync(flags:.barrier) {
                imagesDownloadTasks[urlString] = task
            }
            task.resume()
        }
    
        
    }
    
    private func getCachedImageFor(urlString: String) -> UIImage? {
        sqForImages.sync {
       return self.cachedImages[urlString]
        }
    }
    private func getDataTasksFrom(urlString: String) -> URLSessionDataTask? {
        sqForDataTasks.sync {
            return self.imagesDownloadTasks[urlString]
        }
    }
}
