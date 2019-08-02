# Autobahn

### JSON API connections highway

Protocols and models for a simple creation Swift Combine AnyPublisher for call to JSON http APIs


## Description

Given this service https://developers.themoviedb.org/3/discover/movie-discover, with _Autobahn_, we only need this to define the  `AnyPublisher<DiscoverResponse, Error>`.

```swift
import Foundation
import Combine
import Autobahn
import SwiftUI

struct DiscoverResponseMovie: Codable, Identifiable {
    ...
}

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

struct APIRequest: Autobahn {
    
    let baseURL: URL = URL(string: "https://api.themoviedb.org")!
    let decoder: JSONDecoder = JSONDecoder()
    let urlSession: URLSession = URLSession.shared
    let commonHeaders: [String: String] = [:] // for all calls of APIRequest, not apply if redefined after
    let commonParameters: [String: String] = [
        "api_key": "{{TMDB_API_KEY}}",
        "language": "es-ES",  // prevails "en-GB" in second call above
        "include_image_language": "es",
    ]

    func discoverMovie(page: Int) -> AnyPublisher<DiscoverResponse, Error> {
        return get(path: "/3/discover/movie", parameters: ["page": "\(page)"])
    }

    func discoverENMovie(page: Int) -> AnyPublisher<DiscoverResponse, Error> {
        return get(path: "/3/discover/movie", parameters: ["page": "\(page)", "language": "en-GB"])
    }
    
}
```

And Voila! 

```swift
let emptyResponse = DiscoverResponse(page: 1, totalResults: 0, totalPages: 0, movies: [])
var cancellable: Cancellable = APIRequest().discoverMovie(page: self.currentPage)
    .replaceError(with: emptyResponse) // or 
    .eraseToAnyPublisher()
    .sink(receiveValue: { // received in main thread
        self.totalPages = $0.totalPages
        self.currentPage = $0.page
        self.movies.append(contentsOf: $0.movies)
    })
```


### Error handling

```swift

    var cancellable: Cancellable = APIRequest().sample_call()
        .sink(
            receiveCompletion: receiveCompletion, // received in main thread
            receiveValue: { // received in main thread
                self.totalPages = $0.totalPages
                self.currentPage = $0.page
                self.movies.append(contentsOf: $0.movies)
        })

    func receiveCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished:
            break
            case .failure(let error):
                switch error {
                    case AutobahnError.request(let code, _, _):
                        if code == 404 {
                            print("\n--")
                            print("Not found")
                        }
                    case AutobahnError.unknown(let request):
                        print("\n--")
                        print("Unknown error in \(request.httpMethod ?? "-") call to \(request.url?.absoluteString ?? "-")")
                    case AutobahnError.canNotDecode(let data, let request):
                        print("Cannot parse data in \(request.httpMethod ?? "-") call to \(request.url?.absoluteString ?? "-")")
                        print(String(data: data, encoding: .utf8) ?? "Not UTF 8 string response.")
                    default:
                        let error = error as NSError
                        print("\n--")
                        print(error.code)
                        print(error)
                        print(error.localizedDescription)
                }
        }
    }
```

---

Pull requests are welcome!

## Licence

MIT ofc.
