//
//  ViewController.swift
//  Pagination
//
//  Created by Mounika Madishetti on 25/07/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    var movieDetail: MovieDetail?
    var movieId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        MovieDetailManager().fetchMovieDetail(id: movieId, type: MovieDetail.self) { [self] (result) in
            switch result {
            case .success(let data):
            
                movieTitle.text = data.title
                movieYear.text = data.year
                moviePlot.text = data.plot
                ImageDownloader.shared.downloadImage(with: data.poster, completionHandler: { (image, isPlaceholder) in
                    movieImage.image = image

                }, placeHolderImage: UIImage(systemName: "person"))
//                guard  let url = URL(string: data.poster) else { return }
//                let image = ImageManager.shared.cache.object(forKey: url as! NSURL)
//                movieImage.image = image
//                if movieImage.image == nil {
//                ImageManager.shared.downloadImage(imagePath: url) { (image) -> Void in
//                   movieImage.image = image
//
//                }
//                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    

    

}
