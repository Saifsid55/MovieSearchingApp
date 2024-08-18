//
//  MovieDetailViewController.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var poster: UIImageView!
    private var verticalStackView: UIStackView!
    private var movieTitle: UILabel!
    private var releaseDate: UILabel!
    private var directorName: UILabel!
    private var plotLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel = DetailsViewModel()
    var movieID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = view.applyGradient(colours: [UIColor(hexString: "#3E5151"),UIColor(hexString: "#DECBA4")])
        setupViews()
        bindViewModel()
        
        if let movieID = movieID {
            viewModel.fetchMovieDetails(by: movieID)
        }
    }
    
    private func setupViews() {
        createScrollView()
        createContentView()
        createActivityIndicator()
        createPoster()
        createVerticalStackView()
        createTitleLabel()
        createDirectorLabel()
        createReleaseDateLabel()
        createPlotLabel()
    }
    
    private func createScrollView() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        scrollView.isScrollEnabled = true
    }
    
    private func createContentView() {
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func createPoster() {
        poster = UIImageView()
        contentView.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            poster.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            poster.widthAnchor.constraint(equalToConstant: 240),
            poster.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        poster.layer.cornerRadius = 8.0
        poster.clipsToBounds = true
        poster.contentMode = .scaleAspectFit
    }
    
    private func createVerticalStackView() {
        verticalStackView = UIStackView()
        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 20.0),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8.0),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        ])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 8
    }
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
    }
    
    private func createTitleLabel() {
        movieTitle = UILabel()
        verticalStackView.addArrangedSubview(movieTitle)
        movieTitle.numberOfLines = 0
        movieTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        movieTitle.textColor = .white
    }
    
    private func createDirectorLabel() {
        directorName = UILabel()
        verticalStackView.addArrangedSubview(directorName)
        directorName.numberOfLines = 0
        directorName.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        directorName.textColor = .white
    }
    
    private func createReleaseDateLabel() {
        releaseDate = UILabel()
        verticalStackView.addArrangedSubview(releaseDate)
        releaseDate.numberOfLines = 0
        releaseDate.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        releaseDate.textColor = .white
    }
    
    private func createPlotLabel() {
        plotLabel = UILabel()
        verticalStackView.addArrangedSubview(plotLabel)
        plotLabel.numberOfLines = 0
        plotLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        plotLabel.textColor = .white
    }
    
    private func bindViewModel() {
        viewModel.didUpdateMovieDetails = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let movie = self.viewModel.movie else { return }
                self.movieTitle.text = "Movie Name: \(movie.title ?? "N/A")"
                self.releaseDate.text = "Release Date: \(movie.year ?? "N/A")"
                self.directorName.text = "Director: \(movie.director ?? "N/A")"
                self.plotLabel.text = "Plot: \(movie.plot ?? "N/A")"
                self.poster.image = UIImage(named: "placeholder")
                
                if let url = movie.poster {
                    ImageLoader.loadImage(from: url, into: self.poster)
                } else {
                    self.poster.image = UIImage(named: "placeholder")
                    
                }
                self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.didFailWithError = { [weak self] error in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                AlertManager.showErrorAlert(on: self, message: "Details not found!")
            }
        }
        
        viewModel.isLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
