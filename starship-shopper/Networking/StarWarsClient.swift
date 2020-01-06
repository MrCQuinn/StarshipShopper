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
    
    func starWarsRequest(endpoint: Endpoint, page: Int, params: [URLQueryItem]?) -> URLRequest {
        let url = URL(string: endpoint.rawValue, relativeTo: baseURL)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        if let params = params {
            urlComponents?.queryItems?.append(contentsOf: params)
        }
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
        //            let toPrint = String(data: data, encoding: .utf8)!
        //
        //            print(toPrint)
                  
                  parser(data)
                }).resume()
    }
    
    func fetchStarships(page: Int, completion: @escaping (Result<Any, DataResponseError>) -> Void) {
        let urlRequest = starWarsRequest(endpoint: Endpoint.starships, page: page, params: nil)
        
        self.fetch(request: urlRequest, completion: completion) { data in
            guard let decodedResponse = try? JSONDecoder().decode(StarshipResponse.self, from: data) else {
              completion(Result.failure(DataResponseError.decoding))
              return
            }
            
            completion(Result.success(decodedResponse))
        }
    }
    
    func fetchSearchResults(endpoint: Endpoint, query: String, page: Int,  completion: @escaping
        (Result<Any, DataResponseError>) -> Void) {
        
        let urlRequest = starWarsRequest(endpoint: endpoint, page: page, params: [URLQueryItem(name: "search", value: query)])
        
        self.fetch(request: urlRequest, completion: completion) { data in
            
            switch endpoint {
            case Endpoint.starships:
                guard let decodedResponse = try? JSONDecoder().decode(StarshipResponse.self, from: data) else {
                  completion(Result.failure(DataResponseError.decoding))
                  return
                }
                let searchResults = SearchResponse(starshipResponse: decodedResponse)
                completion(Result.success(searchResults))
            case Endpoint.planets:
                guard let decodedResponse = try? JSONDecoder().decode(PlanetResponse.self, from: data) else {
                 completion(Result.failure(DataResponseError.decoding))
                 return
               }
               let searchResults = SearchResponse(planetResponse: decodedResponse)
               completion(Result.success(searchResults))
            }
            
        }
    }
}
