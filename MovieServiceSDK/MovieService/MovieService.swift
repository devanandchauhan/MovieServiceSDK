//
//  MovieStore.swift
//  NetworkSDK
//
//  Created by Devanand Chauhan on 08/04/24.
//

import Foundation

public class MovieService: MovieServiceProtocol {
    
    public static let shared = MovieService()
    
    private init() {}
    
    public var apiKey = "APIKEY"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    public func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, ServiceError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    public func fetchMovie(id: Int, completion: @escaping (Result<Movie, ServiceError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: ["append_to_response": "videos,credits"], completion: completion)
    }
    
    public func searchMovie(query: String, completion: @escaping (Result<MovieResponse, ServiceError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": query
        ], completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, ServiceError>) -> ()) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            debugPrint("Response: \(String(data: data!, encoding: .utf8))")
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                if let thisData = data, let decodedResponse = try? self.jsonDecoder.decode(ServiceResponse.self, from: thisData) {
                    self.executeCompletionHandlerInMainThread(with: .failure(.response(decodedResponse)), completion: completion)
                } else {
                    self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                }
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                debugPrint("Error: \(error))")

                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, ServiceError>, completion: @escaping (Result<D, ServiceError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
