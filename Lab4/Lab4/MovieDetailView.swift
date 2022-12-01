//
//  MovieDetailView.swift
//  Lab4
//
//  Created by Eric Tabuchi on 10/22/22.
//

import UIKit

class MovieDetailView: UIViewController {
    
    var moviePoster: UIImage!
    var moviePosterPath: String!
    var movieTitle: String!
    var movieReleaseDate: String!
    var movieScore: String!
    var movieRating: String!
    var movieSummary: String!
    var movieID: Int!
    var detailState: Bool? // True = From VC, False = From Favorites
    
//    @IBOutlet weak var movieSearchResultCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // White background
        view.backgroundColor = UIColor.white
        
        // Movie Title        
        let titleFrame = CGRect(x: 0, y: 7.5, width: view.frame.width, height: 0.1 * view.frame.height)
        let titleView = UILabel(frame: titleFrame)
        titleView.text = movieTitle
        titleView.textAlignment = .center
        view.addSubview(titleView)
        
        // Movie Poster
        let posterFrame = CGRect(x: 0, y: view.frame.height * 0.1, width: view.frame.width, height: view.frame.height * 0.5)
        let posterView = UIImageView(frame: posterFrame)
        if detailState!
        {
            posterView.image = moviePoster
        }
        else
        {
            // Pushed from favorites screen so no poster image available --> Using poster path
            if moviePosterPath == "nil"
            {
                posterView.image = UIImage(named: "default-movie")!
            }
            else if moviePosterPath != nil
            {
                // Taught me proper URL format for poster_path https://www.themoviedb.org/talk/5aeaaf56c3a3682ddf0010de
                let path = moviePosterPath!
                let url = URL(string: "https://image.tmdb.org/t/p/original\(path)")
                print("https://image.tmdb.org/t/p/original\(path)")
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                posterView.image = image
            }
        }
        view.addSubview(posterView)
        
        // Movie Release Data
        let releaseFrame = CGRect(x: view.frame.width / 4, y: view.frame.height * 0.575, width: view.frame.width / 2, height: view.frame.height * 0.1)
        let releaseView = UILabel(frame: releaseFrame)
        releaseView.text = "Released: " + movieReleaseDate!
        view.addSubview(releaseView)
        
        // Movie Score
        let scoreFrame = CGRect(x: view.frame.width / 4, y: view.frame.height * 0.6, width: view.frame.width / 2, height: view.frame.height * 0.1)
        let scoreView = UILabel(frame: scoreFrame)
        scoreView.text = "Score: " + movieScore!
        view.addSubview(scoreView)
        
        // Movie Summary
        let summaryFrame = CGRect(x: 5, y: view.frame.height * 0.66, width: view.frame.width - 5, height: view.frame.height * 0.15)
        let summaryView = UILabel(frame: summaryFrame)
        if movieSummary.count == 0
        {
            summaryView.text = "Summary: N/A"
        }
        else
        {
            summaryView.text = "Summary: " + movieSummary!
        }
        summaryView.numberOfLines = 0
        summaryView.textAlignment = .center
        summaryView.lineBreakMode = .byTruncatingTail
        view.addSubview(summaryView)
        
        // Add To Favorite Button
        let favoriteButtonFrame = CGRect(x: view.frame.width / 3, y: view.frame.height * 0.8, width: view.frame.width / 3, height: view.frame.height * 0.1)
        let favoriteButton = UIButton(type: .system)
        favoriteButton.frame = favoriteButtonFrame
        favoriteButton.setTitle("Favorite", for: .normal)
        
        if detailState!
        {
            // START CITATION: https://www.appsdeveloperblog.com/create-uibutton-in-swift-programmatically/
            favoriteButton.addTarget(self, action: #selector(favoriteMovie(_:)), for: .touchUpInside)
            // END CITATION
            
            view.addSubview(favoriteButton)
        }
   }
   
   // START CITATION: https://www.appsdeveloperblog.com/create-uibutton-in-swift-programmatically/
   @objc func favoriteMovie(_ sender:UIButton!)
    {
       // Checks if favorite movie exists in UserDefaults array
       if var favoriteMovies = UserDefaults.standard.array(forKey: "favoriteMoviesID")
       {
           if favoriteMovies.contains(where: {$0 as? Int == movieID})
           {
               print("favorite already exists")
           }
           else
           {
               favoriteMovies.append(contentsOf: [movieID!])
               UserDefaults.standard.set(favoriteMovies, forKey: "favoriteMoviesID")

               var movieTitles = UserDefaults.standard.array(forKey: "favoriteMoviesTitle")
               movieTitles?.append(contentsOf: [movieTitle!])
               UserDefaults.standard.set(movieTitles, forKey: "favoriteMoviesTitle")
               
               var moviePosters = UserDefaults.standard.array(forKey: "favoriteMoviesPoster")
               if moviePosterPath != nil
               {
                   moviePosters?.append(contentsOf: [moviePosterPath!])
               }
               else
               {
                   moviePosters?.append(contentsOf: ["nil"])
               }
               UserDefaults.standard.set(moviePosters, forKey: "favoriteMoviesPoster")
               
               var movieScores = UserDefaults.standard.array(forKey: "favoriteMoviesScore")
               movieScores?.append(contentsOf: [movieScore!])
               UserDefaults.standard.set(movieScores, forKey: "favoriteMoviesScore")
               
               var movieSummaries = UserDefaults.standard.array(forKey: "favoriteMoviesSummary")
               movieSummaries?.append(contentsOf: [movieSummary!])
               UserDefaults.standard.set(movieSummaries, forKey: "favoriteMoviesSummary")
               
               var movieReleaseDates = UserDefaults.standard.array(forKey: "favoriteMoviesRelease")
               movieReleaseDates?.append(contentsOf: [movieReleaseDate!])
               UserDefaults.standard.set(movieReleaseDates, forKey: "favoriteMoviesRelease")
           }
       }
       else
       {
           // Make the array of favorite movies in UserDefaults and store movie ID
           UserDefaults.standard.set([movieID!], forKey: "favoriteMoviesID")
           UserDefaults.standard.set([movieTitle!], forKey: "favoriteMoviesTitle")
           UserDefaults.standard.set([moviePosterPath!], forKey: "favoriteMoviesPoster")
           UserDefaults.standard.set([movieScore!], forKey: "favoriteMoviesScore")
           UserDefaults.standard.set([movieSummary!], forKey: "favoriteMoviesSummary")
           UserDefaults.standard.set([movieReleaseDate!], forKey: "favoriteMoviesRelease")
       }
   }
   // END CITATION
}

