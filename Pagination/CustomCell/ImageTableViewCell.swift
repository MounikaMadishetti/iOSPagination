//
//  ImageTableViewCell.swift
//  Pagination
//
//  Created by Mounika Madishetti on 25/07/21.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var imageView1: LazyImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
