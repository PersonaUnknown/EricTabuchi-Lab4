//
//  FavoriteMovieCell.swift
//  Lab4
//
//  Created by Eric Tabuchi on 10/31/22.
//

import UIKit

class FavoriteMovieCell: UITableViewCell {

    // Title to be displayed
    @IBOutlet weak var movieTitle: UILabel!
    
    // Poster to be displayed
    var poster: String!
    var title: String!
    var releaseDate: String!
    var score: String!
    var rating: String!
    var summary: String!
}
