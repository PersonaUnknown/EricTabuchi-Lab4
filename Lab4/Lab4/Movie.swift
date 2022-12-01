//
//  Movie.swift
//  Lab4
//
//  Created by Eric Tabuchi on 10/19/22.
//

import Foundation

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}

struct APIResultsTV:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [TV]
}

struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}

struct TV: Decodable {
    let poster_path: String?
    let first_air_date: String?
    let id: Int!
    let name: String?
    let overview: String?
    let vote_average: Double
    let vote_count:Int!
    let popularity: Double
}
