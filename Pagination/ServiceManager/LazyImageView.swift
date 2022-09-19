//
//  LazyImageView.swift
//  Pagination
//
//  Created by Mounika Madishetti on 04/09/21.
//

import Foundation
import UIKit

class LazyImageView: UIImageView {
    private let cache = NSCache<NSURL, UIImage>()
    func loadImage(url: URL, placeholder: String) {
        self.image = UIImage(named: placeholder)
        if let image = cache.object(forKey: url as NSURL) {
            self.image = image
            return 
        }
        DispatchQueue.global().async { [weak self] in
           
                if let imageData = try? Data(contentsOf: url) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async { [weak self] in
                            self?.image = image
                            self?.cache.setObject(image, forKey: url as NSURL)
                        }
                    }
                }
                
        }
    }
}
