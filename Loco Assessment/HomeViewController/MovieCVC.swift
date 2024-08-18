//
//  MovieCVC.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import Foundation
import UIKit

final class MovieCVC: UICollectionViewCell {
    
    private var blurEffectView: UIVisualEffectView!
    private var moviePoster: UIImageView!
    private var movieTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        createBlurBackground()
        createMoviePoster()
        createMovieTitle()
    }
    
    private func createBlurBackground() {
        let blurEffect = UIBlurEffect(style: .regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        contentView.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4.0),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -4.0)
        ])
        blurEffectView.layer.cornerRadius = 8.0
        blurEffectView.clipsToBounds = true
    }
    
    private func createMoviePoster() {
        moviePoster = UIImageView()
        blurEffectView.contentView.addSubview(moviePoster)
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 4.0),
            moviePoster.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor, constant: 12.0),
            moviePoster.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: -4.0),
            moviePoster.widthAnchor.constraint(equalToConstant: 80.0)
        ])
        moviePoster.layer.cornerRadius = 8.0
        moviePoster.clipsToBounds = true
        moviePoster.contentMode = .scaleAspectFit
    }
    
    private func createMovieTitle() {
        movieTitle = UILabel()
        blurEffectView.contentView.addSubview(movieTitle)
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 8.0),
            movieTitle.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 12.0),
            movieTitle.bottomAnchor.constraint(lessThanOrEqualTo: blurEffectView.bottomAnchor, constant: -4.0),
            movieTitle.trailingAnchor.constraint(lessThanOrEqualTo: blurEffectView.trailingAnchor, constant: -4.0)
        ])
        movieTitle.numberOfLines = 0
        movieTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        movieTitle.textColor = .white
    }
}

extension MovieCVC {
    
    func configure(with movie: Search?) {
        if let movie = movie {
            movieTitle.text = movie.title
            // Load image asynchronously
            if let urlStr = movie.poster {
                ImageLoader.loadImage(from: urlStr, into: self.moviePoster)
            }
        }
    }
}
