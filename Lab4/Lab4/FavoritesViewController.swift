//
//  FavoritesViewController.swift
//  Lab4
//
//  Created by Eric Tabuchi on 10/23/22.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoritesList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoritesList.delegate = self
        favoritesList.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let favorites = UserDefaults.standard.array(forKey: "favoriteMoviesID")
        {
            if let shows = UserDefaults.standard.array(forKey: "favoriteShowID")
            {
                return favorites.count + shows.count + 2
            }
            return favorites.count + 2
        }
        else
        {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 && indexPath.row != (UserDefaults.standard.array(forKey: "favoriteMoviesID")?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = favoritesList.dequeueReusableCell(withIdentifier: "favoriteMovie", for: indexPath) as! FavoriteMovieCell
            cell.selectionStyle = .none
            cell.movieTitle.text = "Favorite Movies"
            return cell
        }
        else if indexPath.row == (UserDefaults.standard.array(forKey: "favoriteMoviesID")?.count ?? 0) + 1
        {
            let cell = favoritesList.dequeueReusableCell(withIdentifier: "favoriteMovie", for: indexPath) as! FavoriteMovieCell
            cell.selectionStyle = .none
            cell.movieTitle.text = "Favorite TV Shows"
            return cell
        }
        else if indexPath.row <= UserDefaults.standard.array(forKey: "favoriteMoviesID")!.count
        {
            let cell = favoritesList.dequeueReusableCell(withIdentifier: "favoriteMovie", for: indexPath) as! FavoriteMovieCell
            if let favorites = UserDefaults.standard.array(forKey: "favoriteMoviesTitle")
            {
                cell.movieTitle.text = "\u{2022} " + String(describing: favorites[indexPath.row - 1])
            }
            return cell
        }
        else
        {
            let cell = favoritesList.dequeueReusableCell(withIdentifier: "favoriteMovie", for: indexPath) as! FavoriteMovieCell
            if let favorites = UserDefaults.standard.array(forKey: "favoriteShowTitle")
            {
                let movies = UserDefaults.standard.array(forKey: "favoriteMoviesID")
                cell.movieTitle.text = "\u{2022} " + String(describing: favorites[indexPath.row - (movies?.count ?? 0) - 2])
            }
            return cell
        }
    }
    
    // Deleting table cells / movie from favorites
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            if indexPath.row <= UserDefaults.standard.array(forKey: "favoriteMoviesID")!.count
            {
                var titles = UserDefaults.standard.array(forKey: "favoriteMoviesTitle")!
                titles.remove(at: indexPath.row - 1)
                UserDefaults.standard.set(titles, forKey: "favoriteMoviesTitle")
                
                var ids = UserDefaults.standard.array(forKey: "favoriteMoviesID")!
                ids.remove(at: indexPath.row - 1)
                UserDefaults.standard.set(ids, forKey: "favoriteMoviesID")
                
                var posters = UserDefaults.standard.array(forKey: "favoriteMoviesPoster")!
                posters.remove(at: indexPath.row - 1)
                UserDefaults.standard.set(posters, forKey: "favoriteMoviesPoster")
                
                var scores = UserDefaults.standard.array(forKey: "favoriteMoviesScore")!
                scores.remove(at: indexPath.row - 1)
                UserDefaults.standard.set(scores, forKey: "favoriteMoviesScore")
                
                var summaries = UserDefaults.standard.array(forKey: "favoriteMoviesSummary")!
                summaries.remove(at: indexPath.row - 1)
                UserDefaults.standard.set(summaries, forKey: "favoriteMoviesSummary")
                
                var releaseDates = UserDefaults.standard.array(forKey: "favoriteMoviesRelease")!
                releaseDates.remove(at: indexPath.row - 1)
                UserDefaults.standard.set(releaseDates, forKey: "favoriteMoviesRelease")
            }
            else
            {
                let index = indexPath.row - (UserDefaults.standard.array(forKey: "favoriteMoviesID")?.count ?? 0) - 2
                
                var titles = UserDefaults.standard.array(forKey: "favoriteShowTitle")!
                titles.remove(at: index)
                UserDefaults.standard.set(titles, forKey: "favoriteShowTitle")
                
                var ids = UserDefaults.standard.array(forKey: "favoriteShowID")!
                ids.remove(at: index)
                UserDefaults.standard.set(ids, forKey: "favoriteShowID")
                
                var posters = UserDefaults.standard.array(forKey: "favoriteShowPoster")!
                posters.remove(at: index)
                UserDefaults.standard.set(posters, forKey: "favoriteShowPoster")
                
                var scores = UserDefaults.standard.array(forKey: "favoriteShowScore")!
                scores.remove(at: index)
                UserDefaults.standard.set(scores, forKey: "favoriteShowScore")
                
                var summaries = UserDefaults.standard.array(forKey: "favoriteShowSummary")!
                summaries.remove(at: index)
                UserDefaults.standard.set(summaries, forKey: "favoriteShowSummary")
                
                var releaseDates = UserDefaults.standard.array(forKey: "favoriteShowRelease")!
                releaseDates.remove(at: index)
                UserDefaults.standard.set(releaseDates, forKey: "favoriteShowRelease")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    // CREATIVE PORTION: Tapping cell shows info about favorited movie
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 && indexPath.row != (UserDefaults.standard.array(forKey: "favoriteMoviesID")?.count ?? 0) + 1
        {
            if indexPath.row <= UserDefaults.standard.array(forKey: "favoriteMoviesID")!.count
            {
                // Movie
                // Grab details from UserDefaults
                if UserDefaults.standard.array(forKey: "favoriteMoviesID") != nil
                {
                    // Details actually exist, so create view to Store Information
                    let movieDetailView = MovieDetailView()
                    
                    // Grab full information of movie
                    let summary = UserDefaults.standard.array(forKey: "favoriteMoviesSummary")
                    let title = UserDefaults.standard.array(forKey: "favoriteMoviesTitle")
                    let score = UserDefaults.standard.array(forKey: "favoriteMoviesScore")
                    let releaseDate = UserDefaults.standard.array(forKey: "favoriteMoviesRelease")
                    let posterPath = UserDefaults.standard.array(forKey: "favoriteMoviesPoster")
                    
                    // Movie Poster, Release Date, Score, Summary
                    movieDetailView.moviePosterPath = posterPath![indexPath.row - 1] as? String
                    movieDetailView.movieScore = (score![indexPath.row - 1] as? String)!
                    movieDetailView.movieSummary = summary![indexPath.row - 1] as? String
                    movieDetailView.movieTitle = title![indexPath.row - 1] as? String
                    movieDetailView.movieReleaseDate = releaseDate![indexPath.row - 1] as? String
                    movieDetailView.detailState = false
                    
                    // Push VC
                    navigationController?.pushViewController(movieDetailView, animated: true)
                }
            }
            else
            {
                // TV Show
                // Grab details from UserDefaults
                if UserDefaults.standard.array(forKey: "favoriteShowID") != nil
                {
                    // Details actually exist, so create view to Store Information
                    let tvDetailView = TVDetailView()
                    
                    // Grab full information of movie
                    let summary = UserDefaults.standard.array(forKey: "favoriteShowSummary")
                    let title = UserDefaults.standard.array(forKey: "favoriteShowTitle")
                    let score = UserDefaults.standard.array(forKey: "favoriteShowScore")
                    let releaseDate = UserDefaults.standard.array(forKey: "favoriteShowRelease")
                    let posterPath = UserDefaults.standard.array(forKey: "favoriteShowPoster")
                    
                    // Get lengths
                    let movies = UserDefaults.standard.array(forKey: "favoriteMoviesID")
                    
                    // Movie Poster, Release Date, Score, Summary
                    tvDetailView.tvPosterPath = posterPath![indexPath.row - (movies?.count ?? 0) - 2] as? String
                    tvDetailView.tvScore = (score![indexPath.row - (movies?.count ?? 0) - 2] as? String)!
                    tvDetailView.tvSummary = summary![indexPath.row - (movies?.count ?? 0) - 2] as? String
                    tvDetailView.tvTitle = title![indexPath.row -  (movies?.count ?? 0) - 2] as? String
                    tvDetailView.tvReleaseDate = releaseDate![indexPath.row - (movies?.count ?? 0) - 2] as? String
                    tvDetailView.detailState = false
                    
                    // Push VC
                    navigationController?.pushViewController(tvDetailView, animated: true)
                }
            }
        }
    }

    @IBAction func clearFavorites(_ sender: Any) {
        UserDefaults.standard.set([], forKey: "favoriteMoviesID")
        UserDefaults.standard.set([], forKey: "favoriteMoviesSummary")
        UserDefaults.standard.set([], forKey: "favoriteMoviesTitle")
        UserDefaults.standard.set([], forKey: "favoriteMoviesScore")
        UserDefaults.standard.set([], forKey: "favoriteMoviesRelease")
        UserDefaults.standard.set([], forKey: "favoriteMoviesPoster")
        
        UserDefaults.standard.set([], forKey: "favoriteShowID")
        UserDefaults.standard.set([], forKey: "favoriteShowTitle")
        UserDefaults.standard.set([], forKey: "favoriteShowPoster")
        UserDefaults.standard.set([], forKey: "favoriteShowScore")
        UserDefaults.standard.set([], forKey: "favoriteShowSummary")
        UserDefaults.standard.set([], forKey: "favoriteShowRelease")
        favoritesList.reloadData()
    }
}
