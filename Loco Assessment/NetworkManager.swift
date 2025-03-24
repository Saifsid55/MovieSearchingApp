//
//  NetworkManager.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import Foundation

//"https://gist.githubusercontent.com/sanjeevkumargautam-nykaa/a2ab56f3a0973bd415a41b10906a0683/raw/15136211cf4e810abaa19dc0ec77641cd518cc26/products.json"

//    https://www.omdbapi.com/?apikey=5932c39c&s=Avenger&page=1

//  "https://www.jsonkeeper.com/b/9LXA"

class NetworkManager {
    private let apiKey = "5932c39c"
    func fetchMovies(searchQuery: String, page: Int, completion: @escaping (Result<Movies, Error>) -> Void) {
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchQuery)&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        print("URL->",url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let moviesResponse = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(moviesResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchMovieDetails(movieID: String, completion: @escaping (Result<Detail, Error>) -> Void) {
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(movieID)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let movieDetails = try JSONDecoder().decode(Detail.self, from: data)
                completion(.success(movieDetails))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
