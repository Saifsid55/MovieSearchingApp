//
//  HomeViewController.swift
//  Loco Assessment
//
//  Created by Mohd Saif on 17/08/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Searching App"
        _ = view.applyGradient(colours: [UIColor(hexString: "#3E5151"),UIColor(hexString: "#DECBA4")])
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        createSearchBar()
        createCollectionView()
        createActivityIndicator()
    }
    
    private func createSearchBar() {
        searchBar = UISearchBar()
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0)
        ])
        
        searchBar.placeholder = "Search movies or series"
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        searchBar.delegate = self
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(hexString: "#DECBA4")
            textField.textColor = .black
            textField.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        }
    }
    
    private func createCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width, height: 130)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCVC.self, forCellWithReuseIdentifier: "MovieCVC")
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4.0)
        ])
        collectionView.backgroundColor = .clear
    }
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
}

extension HomeViewController {
    
    private func setupBindings() {
        
        viewModel.didUpdateMovies = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        viewModel.didFailWithError = { [weak self] error in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                AlertManager.showErrorAlert(on: self, message: "Failed to fetch movie/series, please try to search using another name.")
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

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.currentPage = 1
        viewModel.movies = []
        self.collectionView.reloadData()
        viewModel.fetchMovies(for: query)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCVC", for: indexPath) as! MovieCVC
        if let movies = viewModel.movies {
            cell.configure(with: movies[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfMovies - 1 {
            viewModel.currentPage += 1
            viewModel.fetchMovies(for: searchBar.text ?? "")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies?[indexPath.item]
        let detailVC = MovieDetailViewController()
        detailVC.movieID = selectedMovie?.imdbID
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
