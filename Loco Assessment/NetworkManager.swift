//
//  NetworkManager.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import Foundation


class NetworkManager {
    private let apiKey = "5932c39c"
    
    func fetchMovies(searchQuery: String, page: Int, completion: @escaping (Result<Movies, Error>) -> Void) {
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchQuery)&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        
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
