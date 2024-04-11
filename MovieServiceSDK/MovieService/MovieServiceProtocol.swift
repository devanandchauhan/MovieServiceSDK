//
//  MovieService.swift
//  NetworkSDK
//
//  Created by Devanand Chauhan on 06/04/24.
//

import Foundation

public protocol MovieServiceProtocol {
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, ServiceError>) -> ())
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, ServiceError>) -> ())
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, ServiceError>) -> ())
}

public enum MovieListEndpoint: String, CaseIterable, Identifiable {
    
    public var id: String { rawValue }

    case popular
    case upcoming
    
    var description: String {
        switch self {
            case .upcoming: return "Upcoming"
            case .popular: return "Popular"
        }
    }
}
