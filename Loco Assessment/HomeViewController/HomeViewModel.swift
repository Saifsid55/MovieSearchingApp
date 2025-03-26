//
//  HomeViewModel.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import Foundation

class HomeViewModel {
    
    var movies: [Search]? = []
    var currentPage = 1
    private var isFetching = false
    private let networkManager = NetworkManager()
    
    var didUpdateMovies: (() -> Void)?
    var didFailWithError: ((Error) -> Void)?
    var isLoading: ((Bool) -> Void)?
    
    var numberOfMovies: Int {
        guard let movies = movies else {return 0}
        return movies.count
    }
    
    func fetchMovies(for query: String) {
        guard !isFetching else { return }
        isFetching = true
        isLoading?(true)
        let urlString = "https://www.omdbapi.com/?apikey=\(ApiHelper.shared.apikey)&s=\(query)&page=\(currentPage)"
        
        networkManager.fetchData(urlStr: urlString) { [weak self] (result: Result<Movies, Error>) in
            guard let self = self else {return}
            self.isFetching = false
            switch result {
            case .success(let movieData):
                self.movies?.append(contentsOf: movieData.search)
                self.didUpdateMovies?()
            case .failure(let error):
                if !(currentPage>1){
                    self.didFailWithError?(error)
                }
            }
            self.isLoading?(false)
        }
    }
}

