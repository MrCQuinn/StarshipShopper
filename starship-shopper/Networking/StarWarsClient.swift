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
    
    func fetchStarships(endpoint: String, page: Int, completion: @escaping (Result<PagedStarshipResponse, DataResponseError>) -> Void) {
        let url = URL(string: endpoint, relativeTo: baseURL)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        let urlRequest = URLRequest(url: (urlComponents?.url)!)
        
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
          guard let httpResponse = response as? HTTPURLResponse,
             (200...299).contains(httpResponse.statusCode),
            let data = data
          else {
              completion(Result.failure(DataResponseError.network))
              return
          }
            let toPrint = String(data: data, encoding: .utf8)!
            
            print(toPrint)
          
          guard let decodedResponse = try? JSONDecoder().decode(PagedStarshipResponse.self, from: data) else {
            completion(Result.failure(DataResponseError.decoding))
            return
          }
          
          completion(Result.success(decodedResponse))
        }).resume()
    }
}
