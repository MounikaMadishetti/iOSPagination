//
//  MovieDetailManager.swift
//  Pagination
//
//  Created by Mounika Madishetti on 27/07/21.
//

import Foundation
struct MovieDetailManager {
    
    
    func getUrl(id: String) -> URL? {
        guard let url = URL(string: "http://www.omdbapi.com/?i=\(id)&apikey=\(APIData.shared.key)") else {
            return nil
        }
        return url
    }
    
    func fetchMovieDetail<T: Codable>(id: String, type: T.Type, completionHandler: @escaping(Result<MovieDetail, Error>) -> Void) {
        guard let url = getUrl(id: id) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if error == nil {
                    do {
                        guard let data = data else { return }
                        let jsonData = try JSONDecoder().decode(MovieDetail.self, from: data)
                        completionHandler(.success(jsonData))
                    } catch let error {
                        completionHandler(.failure(error))
                    }
                    
                } else {
                    completionHandler(.failure(error as! Error))
                }
            }
        }.resume()
    }
}
