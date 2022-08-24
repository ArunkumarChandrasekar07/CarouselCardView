//
//  Tab.swift
//  CarouselCardView
//
//  Created by Arunkumar Chandrasekar on 23/08/22.
//

import Foundation

enum Tab: String, CaseIterable {
    case home = "house"
    case explore = "safari"
    case heart = "heart"
    case profile = "person"
}

struct Movie: Identifiable, Equatable {
    var id = UUID().uuidString
    var movieTitle: String
    var poster: String
}

var movies: [Movie] = [
    .init(movieTitle: "Star Wars", poster: "star"),
    .init(movieTitle: "Joker", poster: "joker"),
    .init(movieTitle: "Avengers", poster: "avengers"),
    .init(movieTitle: "Black Widow", poster: "blackwidow"),
    .init(movieTitle: "Inception", poster: "inception"),
    .init(movieTitle: "Star Wars II", poster: "starwars"),
    .init(movieTitle: "Lord of Rings", poster: "lordofrings")
]

