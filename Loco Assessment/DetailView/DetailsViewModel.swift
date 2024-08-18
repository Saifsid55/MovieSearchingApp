//
//  DetailsViewModel.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import Foundation

final class DetailsViewModel {
    
    private let networkManager = NetworkManager()
        private(set) var movie: Detail?
        
        var didUpdateMovieDetails: (() -> Void)?
        var didFailWithError: ((Error) -> Void)?
        var isLoading: ((Bool) -> Void)?
        
        func fetchMovieDetails(by id: String) {
            isLoading?(true)
            
            networkManager.fetchMovieDetails(movieID: id) { [weak self] result in
                guard let self = self else { return }
                self.isLoading?(false)
                
                switch result {
                case .success(let movieDetails):
                    self.movie = movieDetails
                    self.didUpdateMovieDetails?()
                case .failure(let error):
                    self.didFailWithError?(error)
                }
            }
        }
}
