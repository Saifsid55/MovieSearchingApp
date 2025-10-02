//
//  HomeViewModel.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import Foundation

protocol HomeViewProtocol {
    var movies: [Search] {get set}
    var currentPage: Int {get set}
    
    var numberOfMovies: Int { get }
    
    var didUpdateMovies: (() -> Void)? { get set }
    var didFailWithError: ((Error) -> Void)? { get set }
    var isLoading: ((Bool) -> Void)? { get set }
    
    func fetchMovies(for query: String)
}

class HomeViewModel: HomeViewProtocol {
    
    var movies: [Search] = []
    var currentPage = 1
    private var isFetching = false
    private let networkManager: NetworkService
    
    var didUpdateMovies: (() -> Void)?
    var didFailWithError: ((Error) -> Void)?
    var isLoading: ((Bool) -> Void)?
    
    
    
    var numberOfMovies: Int {
        guard movies.count > 0 else {return 0}
        return movies.count
    }
    
    
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkManager = networkService
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
                self.movies.append(contentsOf: movieData.search)
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

