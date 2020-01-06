//
//  StarWarsClient.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 12/28/19.
//  Copyright © 2019 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

final class StarWarsClient {
    private lazy var baseURL: URL = {
        return URL(string: "https://swapi.co/api/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func starWarsRequest(endpoint: Endpoint, params: [URLQueryItem]?) -> URLRequest {
        let url = URL(string: endpoint.rawValue, relativeTo: baseURL)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = params
        return URLRequest(url: (urlComponents?.url)!)
    }
    
    func fetch(request: URLRequest, completion: @escaping (Result<Any, DataResponseError>) -> Void, parser: @escaping (Data) -> Void) {
        session.dataTask(with: request, completionHandler: { data, response, error in
                  guard let httpResponse = response as? HTTPURLResponse,
                     (200...299).contains(httpResponse.statusCode),
                    let data = data
                  else {
                      completion(Result.failure(DataResponseError.network))
                      return
                  }
//                    let toPrint = String(data: data, encoding: .utf8)!
//
//                    print(toPrint)
                  
                  parser(data)
                }).resume()
    }
    
    func fetchStarships(page: Int, completion: @escaping (Result<Any, DataResponseError>) -> Void) {
        let urlRequest = starWarsRequest(endpoint: Endpoint.starships, params: [URLQueryItem(name: "page", value: "\(page)")])
        
        self.fetch(request: urlRequest, completion: completion) { data in
            guard let decodedResponse = try? JSONDecoder().decode(StarshipResponse.self, from: data) else {
              completion(Result.failure(DataResponseError.decoding))
              return
            }
            
            completion(Result.success(decodedResponse))
        }
    }
    
    func parseSearchData(endpoint: Endpoint, data: Data) -> SearchResponse? {
        switch endpoint {
        case Endpoint.starships:
            guard let decodedResponse = try? JSONDecoder().decode(StarshipResponse.self, from: data) else {
              return nil
            }
            return StarshipSearchResponse(starshipResponse: decodedResponse)
        case Endpoint.planets:
            guard let decodedResponse = try? JSONDecoder().decode(PlanetResponse.self, from: data) else {
             return nil
           }
           return PlanetSearchResponse(planetResponse: decodedResponse)
        }
    }
    
    func fetchSearchResults(endpoints: [Endpoint], query: String, completion: @escaping (Result<Any, DataResponseError>) -> Void) {
        var results = [SearchResult]()
        var endpointsFetched = 0
        for endpoint in endpoints {
            // create request for endpoint
            let urlRequest = starWarsRequest(endpoint: endpoint, params: [URLQueryItem(name: "search", value: query)])
            // req all for endpoint
            self.fetchResults(for: endpoint, request: urlRequest, allResults: results, completion: completion) { newResults in
                // add to total results
                results.append(contentsOf: newResults)
                endpointsFetched += 1
                if endpointsFetched >= endpoints.count {
                    // run completion handler with results
                    completion(Result.success(results))
                }
            }
        }
    }
    
    func fetchResults(for endpoint: Endpoint, request: URLRequest, allResults: [SearchResult], completion: @escaping (Result<Any, DataResponseError>) -> Void, onEndpointFetched: @escaping ([SearchResult]) -> Void) {
        var results = allResults
        self.fetch(request: request, completion: completion) { data in
            
            guard let response = self.parseSearchData(endpoint: endpoint, data: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            results.append(contentsOf: response.searchResults)
            
            guard let nextUrl = response.next else {
                onEndpointFetched(results)
                return
            }
            
            return self.fetchResults(for: endpoint, request: URLRequest(url: URL(string: nextUrl)!), allResults: results, completion: completion, onEndpointFetched: onEndpointFetched)
        }
    }
}
