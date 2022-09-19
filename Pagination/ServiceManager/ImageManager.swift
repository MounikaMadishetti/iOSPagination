//
//  ImageManager.swift
//  Pagination
//
//  Created by Mounika Madishetti on 25/07/21.
//

import UIKit
struct ImageManager {
    static let shared = ImageManager()
    private init() {}
    let downloadQueue = DispatchQueue(label: "queue", qos: .background)
    var cache = NSCache<NSURL, UIImage>()
    func downloadImage(imagePath: URL, completion: @escaping(_ image: UIImage) -> Void) {
        downloadQueue.async { () -> Void in
            if let image = self.cache.object(forKey: imagePath as NSURL) {
                DispatchQueue.main.async {
                    completion(image)
                    return
                }
                
            }
            do {
                let data = try Data(contentsOf: imagePath)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: imagePath as NSURL)
                        completion(image)
                    }
                } else {
                    print("error")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
