//
//  ServiceManager.swift
//  Pagination
//
//  Created by Mounika Madishetti on 25/07/21.
//

import Foundation
struct ServiceManager {
    public let key = "4a087f27"
    
    func getUrl(searchText: String, pageCount: String) -> URL? {
        guard let url = URL(string: "http://www.omdbapi.com/?apikey=\(key)&s=\(searchText)&page=\(pageCount)") else {
            return nil
        }
        return url
    }
    
    func fetchResults<T: Codable>(searchText: String, pageCount: Int, type: T.Type, completionHandler: @escaping(Result<SearchResponseItems, Error>) -> Void) {
        
        guard let url = getUrl(searchText: searchText, pageCount: pageCount.description) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if error == nil {
                    do {
                        guard let data = data else {
                            return }
                        let jsonData = try JSONDecoder().decode(SearchResponseItems.self, from: data)
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
