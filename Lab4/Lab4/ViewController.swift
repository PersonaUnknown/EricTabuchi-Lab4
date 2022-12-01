//
//  ViewController.swift
//  Lab4
//
//  Created by Eric Tabuchi on 10/19/22.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    // Arrays to store / cache data
    var searchResults : [APIResults] = []
    var imageCache : [UIImage] = []
    var titleCache : [String] = []
    
    // Outlets
    @IBOutlet weak var movieSearchResultCount: UILabel!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieSearchResultCollection: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieSearchResultCollection.dataSource = self
        movieSearchResultCollection.delegate = self
        movieSearchBar.delegate = self
        spinner.isHidden = true
        
        movieSearchResultCount.text = "Results:"
        movieSearchResultCollection.reloadData()

        // Start up spinner
        spinner.isHidden = false
        spinner.startAnimating()
        
        DispatchQueue.global().async
        {
            let apiRequest = "https://api.themoviedb.org/3/trending/movie/week?api_key=0d5c8531845b87f32cb30c6edc61e511"
            let url = URL(string: apiRequest)
            if let data = try? Data(contentsOf: url!)
            {
                // Errors were received from directly copying the code structure from Lecture 10
                // https://developer.apple.com/forums/thread/708962 explains it is because the API result is a single JSON object
                self.searchResults = [try! JSONDecoder().decode(APIResults.self, from: data)]

                self.cacheImages()
            }
            
            DispatchQueue.main.async
            {
                // Stop the spinner because done searching
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                
                // Data has been changed so update
                self.movieSearchResultCollection.reloadData()
                
                // Update the number of search results
                if self.searchResults.count == 0
                {
                    self.movieSearchResultCount.text = "Results: 0"
                }
                else
                {
                    self.movieSearchResultCount.text = "Results: \(self.searchResults[0].results.count)"
                }
            }
        }
    }

    // API Request
    // Used to have no parameters but to use global queue, UILabel couldn't be used in the function so it instead became the parameter
    func fetchMovieData(apiQuery: String)
    {
        // Template given by TMDB for querying movies
        // https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher
        
        // My API key created for this Lab
        let apiKey = "0d5c8531845b87f32cb30c6edc61e511"
        let encodedQuery = apiQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        // Query movie search
        if apiQuery.count != 0
        {
            // API Request
            let apiRequest = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedQuery!)"
            let url = URL(string: apiRequest)

            if let data = try? Data(contentsOf: url!)
            {
                // Errors were received from directly copying the code structure from Lecture 10
                // https://developer.apple.com/forums/thread/708962 explains it is because the API result is a single JSON object
                searchResults = [try! JSONDecoder().decode(APIResults.self, from: data)]

                cacheImages()
            }
        }
    }
    
    // Cache Images
    func cacheImages()
    {
        if searchResults.count > 0
        {
            for index in 0..<searchResults[0].results.count
            {
                if let path = searchResults[0].results[index].poster_path
                {
                    // Taught me proper URL format for poster_path https://www.themoviedb.org/talk/5aeaaf56c3a3682ddf0010de
                    let url = URL(string: "https://image.tmdb.org/t/p/original\(path)")
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    imageCache.append(image!)
                }
                else
                {
                    imageCache.append(UIImage(named: "default-movie")!)
                }
                titleCache.append(searchResults[0].results[index].title)
            }
        }
    }
    
    // Collection View Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    // Up to three movies in a row
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Reuse cell
        let cell = movieSearchResultCollection.dequeueReusableCell(withReuseIdentifier: "movieSearchResultCell", for: indexPath) as! MovieCell
        
        // Make sure not to have index out of bounds error
        if indexPath.section * 3 + indexPath.row < imageCache.count
        {
            // Movie Poster Image
            cell.moviePoster.image = imageCache[indexPath.section * 3 + indexPath.row]
            
            // Movie Title
            cell.movieTitle.text = titleCache[indexPath.section * 3 + indexPath.row]
            
            // Add ellipses (...) if movie title is too long
            cell.movieTitle.lineBreakMode = .byTruncatingTail
            
            // Add semi transparent background to title to be better seen
            cell.movieTitle.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        }
        else
        {
            cell.moviePoster.image = nil
            cell.movieTitle.text = nil
            cell.movieTitle.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    // When you tap a movie
    func collectionView(_ collectionView: UICollectionView,
             didSelectItemAt indexPath: IndexPath) {
        
        // Movie Details
        let movieDetails = searchResults[0].results[indexPath.section * 3 + indexPath.row]
        
        // View to Store Information
        let movieDetailView = MovieDetailView()
        
        // Movie Poster, Release Date, Score, Summary
        movieDetailView.moviePoster = imageCache[indexPath.section * 3 + indexPath.row]
        if String(movieDetails.vote_average).contains("/ 10")
        {
            movieDetailView.movieScore = String(movieDetails.vote_average)
        }
        else
        {
            movieDetailView.movieScore = String(movieDetails.vote_average) + " / 10"
        }
        movieDetailView.movieReleaseDate = movieDetails.release_date
        movieDetailView.movieSummary = movieDetails.overview
        movieDetailView.movieTitle = movieDetails.title
        movieDetailView.movieID = movieDetails.id
        movieDetailView.moviePosterPath = movieDetails.poster_path
        movieDetailView.detailState = true
        
        // Push VC
        navigationController?.pushViewController(movieDetailView, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""
        {
            imageCache = []
            titleCache = []
            movieSearchResultCount.text = "Results: 0"
            movieSearchResultCollection.reloadData()
        }
    }
    
    @IBAction func getUpcomingMovies(_ sender: Any) {
        imageCache = []
        titleCache = []
        movieSearchResultCount.text = "Results:"
        movieSearchResultCollection.reloadData()

        // Start up spinner
        spinner.isHidden = false
        spinner.startAnimating()
        
        DispatchQueue.global().async
        {
            let apiRequest = "https://api.themoviedb.org/3/movie/upcoming?api_key=0d5c8531845b87f32cb30c6edc61e511"
            let url = URL(string: apiRequest)
            if let data = try? Data(contentsOf: url!)
            {
                // Errors were received from directly copying the code structure from Lecture 10
                // https://developer.apple.com/forums/thread/708962 explains it is because the API result is a single JSON object
                self.searchResults = [try! JSONDecoder().decode(APIResults.self, from: data)]

                self.cacheImages()
            }
            
            DispatchQueue.main.async
            {
                // Stop the spinner because done searching
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                
                // Data has been changed so update
                self.movieSearchResultCollection.reloadData()
                
                // Update the number of search results
                if self.searchResults.count == 0
                {
                    self.movieSearchResultCount.text = "Results: 0"
                }
                else
                {
                    self.movieSearchResultCount.text = "Results: \(self.searchResults[0].results.count)"
                }
            }
        }
    }
    
    @IBAction func getTrendingMovies(_ sender: Any) {
        imageCache = []
        titleCache = []
        movieSearchResultCount.text = "Results:"
        movieSearchResultCollection.reloadData()

        // Start up spinner
        spinner.isHidden = false
        spinner.startAnimating()
        
        DispatchQueue.global().async
        {
            let apiRequest = "https://api.themoviedb.org/3/trending/movie/week?api_key=0d5c8531845b87f32cb30c6edc61e511"
            let url = URL(string: apiRequest)
            if let data = try? Data(contentsOf: url!)
            {
                // Errors were received from directly copying the code structure from Lecture 10
                // https://developer.apple.com/forums/thread/708962 explains it is because the API result is a single JSON object
                self.searchResults = [try! JSONDecoder().decode(APIResults.self, from: data)]

                self.cacheImages()
            }
            
            DispatchQueue.main.async
            {
                // Stop the spinner because done searching
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                
                // Data has been changed so update
                self.movieSearchResultCollection.reloadData()
                
                // Update the number of search results
                if self.searchResults.count == 0
                {
                    self.movieSearchResultCount.text = "Results: 0"
                }
                else
                {
                    self.movieSearchResultCount.text = "Results: \(self.searchResults[0].results.count)"
                }
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Clear cache if spinner is not animating (only search when a search is finished)
        if !spinner.isAnimating
        {
            imageCache = []
            titleCache = []
            movieSearchResultCount.text = "Results:"
            movieSearchResultCollection.reloadData()
            
            // When using software / iOS keyboard, make search bar disappear
            searchBar.resignFirstResponder()
            
            // Start up new query if search bar is non empty
            if movieSearchBar.text!.count > 0
            {
                // Start up spinner
                spinner.isHidden = false
                spinner.startAnimating()
                
                let query = movieSearchBar.text!
                DispatchQueue.global().async
                {
                    self.fetchMovieData(apiQuery: query)
                    DispatchQueue.main.async
                    {
                        // Stop the spinner because done searching
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        
                        // Data has been changed so update
                        self.movieSearchResultCollection.reloadData()
                        
                        // Update the number of search results
                        if self.searchResults.count == 0
                        {
                            self.movieSearchResultCount.text = "Results: 0"
                        }
                        else
                        {
                            self.movieSearchResultCount.text = "Results: \(self.searchResults[0].results.count)"
                        }
                    }
                }
            }
            else
            {
                movieSearchResultCount.text = "Results: 0"
            }
        }
    }
}

