//
//  ViewController.swift
//  Pagination
//
//  Created by Mounika Madishetti on 25/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResults: [Search] = [Search]()
    var pageCount = 0
    var searchText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
    }
    
    func fetchResults() {
        pageCount += 1
        ServiceManager().fetchResults(searchText: searchText, pageCount: pageCount, type: SearchResponseItems.self) { [self] (result) in
            switch result {
            case .success(let data):
                
                print(data)
                searchResults.append(contentsOf: data.search)
                self.tableView.reloadData()
                print("count is")
                print(searchResults.count)
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
        
       let imagePath = searchResults[indexPath.row].getImagePath()
       let image = ImageLoader.shared.cache.object(forKey: imagePath as! NSURL)
       cell.imageView1.image = image
//        if image == nil {
//            ImageManager.shared.downloadImage(imagePath: imagePath!) { (image) -> Void in
//                cell.imageView1.image = image
//
//            }
//        }
        if image == nil {
       ImageLoader.shared.downloadImage(imagePath: imagePath!) { image  in
        cell.imageView1.image = image
            
        }
//            ImageDownloader.shared.downloadImage(with: imagepa, completionHandler: <#T##(UIImage?, Bool) -> Void#>, placeHolderImage: <#T##UIImage?#>)
        }
      //  cell.imageView1.loadImage(url: imagePath!, placeholder: "dkf")
        cell.movieTitle.text = searchResults[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = MovieDetailViewController.instantiate()
        c.movieId = searchResults[indexPath.row].imdbID
        navigationController?.pushViewController(c, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchResults.count - 1 == indexPath.row {
            fetchResults()
        }
    }
    
}
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, text.count > 2 else { return }
        searchText = text
        fetchResults()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            self.searchText = ""
            self.pageCount = 0
            tableView.reloadData()
            print("UISearchBar.text cleared!")
        }
    }
    
}

