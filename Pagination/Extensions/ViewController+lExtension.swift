//
//  ViewController+lExtension.swift
//  Pagination
//
//  Created by Mounika Madishetti on 27/07/21.
//

import Foundation
import UIKit
extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        return vc
    }
}
