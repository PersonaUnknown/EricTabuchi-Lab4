//
//  TVDetailView.swift
//  Lab4
//
//  Created by Eric Tabuchi on 10/31/22.
//

import UIKit

class TVDetailView: UIViewController {

    var tvPoster: UIImage!
    var tvPosterPath: String!
    var tvTitle: String!
    var tvReleaseDate: String!
    var tvScore: String!
    var tvRating: String!
    var tvSummary: String!
    var tvID: Int!
    var detailState: Bool? // True = From VC, False = From Favorites

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // White background
        view.backgroundColor = UIColor.white
        
        // Movie Title
        let titleFrame = CGRect(x: 0, y: 7.5, width: view.frame.width, height: 0.1 * view.frame.height)
        let titleView = UILabel(frame: titleFrame)
        titleView.text = tvTitle
        titleView.textAlignment = .center
        view.addSubview(titleView)
        
        // Movie Poster
        let posterFrame = CGRect(x: 0, y: view.frame.height * 0.1, width: view.frame.width, height: view.frame.height * 0.5)
        let posterView = UIImageView(frame: posterFrame)
        if detailState!
        {
            posterView.image = tvPoster
        }
        else
        {
            // Pushed from favorites screen so no poster image available --> Using poster path
            if tvPosterPath == "nil"
            {
                posterView.image = UIImage(named: "default-movie")!
            }
            else if tvPosterPath != nil
            {
                // Taught me proper URL format for poster_path https://www.themoviedb.org/talk/5aeaaf56c3a3682ddf0010de
                let path = tvPosterPath!
                let url = URL(string: "https://image.tmdb.org/t/p/original\(path)")
                print("https://image.tmdb.org/t/p/original\(path)")
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                posterView.image = image
            }
        }
        view.addSubview(posterView)
        
        // Movie Release Data
        let releaseFrame = CGRect(x: view.frame.width / 4, y: view.frame.height * 0.575, width: view.frame.width, height: view.frame.height * 0.1)
        let releaseView = UILabel(frame: releaseFrame)
        releaseView.text = "First Released: " + tvReleaseDate!
        view.addSubview(releaseView)
        
        // Movie Score
        let scoreFrame = CGRect(x: view.frame.width / 4, y: view.frame.height * 0.6, width: view.frame.width / 2, height: view.frame.height * 0.1)
        let scoreView = UILabel(frame: scoreFrame)
        scoreView.text = "Score: " + tvScore!
        view.addSubview(scoreView)
        
        // Movie Summary
        let summaryFrame = CGRect(x: 5, y: view.frame.height * 0.66, width: view.frame.width - 5, height: view.frame.height * 0.15)
        let summaryView = UILabel(frame: summaryFrame)
        if tvSummary.count == 0
        {
            summaryView.text = "Summary: N/A"
        }
        else
        {
            summaryView.text = "Summary: " + tvSummary!
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
       // Check if favorite TV exists
       if var favoriteTV = UserDefaults.standard.array(forKey: "favoriteShowID") {
           if favoriteTV.contains(where: {$0 as? Int == tvID})
           {
               print("favorite already exists")
           }
           else
           {
               favoriteTV.append(contentsOf: [tvID!])
               UserDefaults.standard.set(favoriteTV, forKey: "favoriteShowID")

               var tvTitles = UserDefaults.standard.array(forKey: "favoriteShowTitle")
               tvTitles?.append(contentsOf: [tvTitle!])
               UserDefaults.standard.set(tvTitles, forKey: "favoriteShowTitle")
               
               var tvPosters = UserDefaults.standard.array(forKey: "favoriteShowPoster")
               if tvPosterPath != nil
               {
                   tvPosters?.append(contentsOf: [tvPosterPath!])
               }
               else
               {
                   tvPosters?.append(contentsOf: ["nil"])
               }
               UserDefaults.standard.set(tvPosters, forKey: "favoriteShowPoster")
               
               var tvScores = UserDefaults.standard.array(forKey: "favoriteShowScore")
               tvScores?.append(contentsOf: [tvScore!])
               UserDefaults.standard.set(tvScores, forKey: "favoriteShowScore")
               
               var tvSummaries = UserDefaults.standard.array(forKey: "favoriteShowSummary")
               tvSummaries?.append(contentsOf: [tvSummary!])
               UserDefaults.standard.set(tvSummaries, forKey: "favoriteShowSummary")
               
               var tvReleaseDates = UserDefaults.standard.array(forKey: "favoriteShowRelease")
               tvReleaseDates?.append(contentsOf: [tvReleaseDate!])
               UserDefaults.standard.set(tvReleaseDates, forKey: "favoriteShowRelease")
           }
       }
       else
       {
           // Else create favorites
           UserDefaults.standard.set([tvID!], forKey: "favoriteShowID")
           UserDefaults.standard.set([tvTitle!], forKey: "favoriteShowTitle")
           UserDefaults.standard.set([tvPosterPath!], forKey: "favoriteShowPoster")
           UserDefaults.standard.set([tvScore!], forKey: "favoriteShowScore")
           UserDefaults.standard.set([tvSummary!], forKey: "favoriteShowSummary")
           UserDefaults.standard.set([tvReleaseDate!], forKey: "favoriteShowRelease")
       }
   }
}
