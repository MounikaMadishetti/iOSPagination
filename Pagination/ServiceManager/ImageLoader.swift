//
//  ImageLoader.swift
//  Pagination
//
//  Created by Mounika Madishetti on 24/09/21.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private init() {}
    var task: URLSessionDataTask!
//    let downloadQueue = DispatchQueue(label: "queue", qos: .background)
    var cache = NSCache<NSURL, UIImage>()
    func downloadImage(imagePath: URL, completion: @escaping(_ image: UIImage) -> Void) {
//        downloadQueue.async { () -> Void in
            if let image = self.cache.object(forKey: imagePath as NSURL) {
                DispatchQueue.main.async {
                    completion(image)
                    return
                }

            }
//            do {
//                let data = try Data(contentsOf: imagePath)
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.cache.setObject(image, forKey: imagePath as NSURL)
//                        completion(image)
//                    }
//                } else {
//                    print("error")
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
        if let task = task {
            task.cancel()
        }
        task = URLSession.shared.dataTask(with: imagePath) { (data, response, error) in
            guard let data = data, let newImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.cache.setObject(newImage, forKey: imagePath as NSURL)
                completion(newImage)
            }
            
            
        }
        task.resume()
    }
}
