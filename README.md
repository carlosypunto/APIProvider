# Autobahn

### JSON API connections highway

Protocols and models for a simple creation Swift Combine AnyPublisher for call to JSON http APIs

Pull requests are welcome!

## Description

Given this service https://developers.themoviedb.org/3/discover/movie-discover we wait for the next model:

```swift
import SwiftUI

struct DiscoverResponseMovie: Codable, Identifiable {
    
    let voteCount: Int
    let id: Int
    let video: Bool
    let voteAverage: Double
    let title: String
    let popularity: Double
    let posterPath: String
    let originalLanguage: String
    let originalTitle: String
    let genreIDS: [Int]
    let backdropPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id
        case video
        case voteAverage = "vote_average"
        case title
        case popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case releaseDate = "release_date"
    }
    
}
```

and.

```swift
struct DiscoverResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let movies: [DiscoverResponseMovie]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}
```

With _Autobahn_, we only need this to define the  `AnyPublisher<DiscoverResponse, Error>`.

```swift
import Foundation
import Combine
import Autobahn

struct APIRequest: Autobahn {
    
    let baseURL: URL = URL(string: "https://api.themoviedb.org")!
    let decoder: JSONDecoder = JSONDecoder()
    let urlSession: URLSession = URLSession.shared
    let commonHeaders: [String: String] = [:]
    let commonParameters: [String: String] = [
    "api_key": "{{TMDB_API_KEY}}",
        "language": "es-ES",
        "include_image_language": "es",
    ]

    func discoverMovie(page: Int) -> AnyPublisher<DiscoverResponse, Error> {
        return get(path: "/3/discover/movie", parameters: ["page": "\(page)"])
    }
    
}
```

And Voila! 

```swift
let emptyResponse = DiscoverResponse(page: 1, totalResults: 0, totalPages: 0, movies: [])
var cancellable: Cancellable = APIRequest().discoverMovie(page: self.currentPage)
    .replaceError(with: emptyResponse)
    .eraseToAnyPublisher()
    .sink(receiveValue: {
        self.totalPages = $0.totalPages
        self.currentPage = $0.page
        self.movies.append(contentsOf: $0.movies)
    })
```

## Licence

MIT ofc.
