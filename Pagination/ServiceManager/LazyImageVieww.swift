//
//  LazyImageVieww.swift
//  Pagination
//
//  Created by Mounika Madishetti on 24/09/21.
//

import Foundation
import UIKit
var cache = NSCache<NSURL, UIImage>()
class LazyImageVieww: UIImageView {
    var task: URLSessionDataTask!
    func loadImage(url: URL) {
        image = nil
        if let task = task {
            task.cancel()
        }
        if let image = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                self.image = image
                return
            }

        }
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let newImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                cache.setObject(newImage, forKey: url as NSURL)
                self.image = newImage
            }
            
            
        }
        task.resume()
    }
}
