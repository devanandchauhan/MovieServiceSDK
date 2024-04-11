//
//  MovieResponse.swift
//  NetworkSDK
//
//  Created by Devanand Chauhan on 08/04/24.
//

import Foundation

public struct MovieResponse: Decodable {
    public let results: [Movie]
}

public struct Movie: Decodable, Identifiable, Hashable {
    
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public let id: Int
    
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let voteAverage: Double
    public let voteCount: Int
    public let runtime: Int?
    public let releaseDate: String?
    
    let genres: [MovieGenre]?
    let credits: MovieCredit?
    let videos: MovieVideoResponse?
    
    public var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    public var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    public var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    
    public var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        return ratingText
    }
    
    public var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }
    
    public var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Utils.yearFormatter.string(from: date)
    }
    
    public var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        return Utils.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    var cast: [MovieCast]? {
        credits?.cast
    }
    
    var crew: [MovieCrew]? {
        credits?.crew
    }
    
    var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    
    var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    
    var screenWriters: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }
    
    var youtubeTrailers: [MovieVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }
    
}

public struct MovieGenre: Decodable {
    let name: String
}

public struct MovieCredit: Decodable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

public struct MovieCast: Decodable, Identifiable {
    public let id: Int
    let character: String
    let name: String
}

public struct MovieCrew: Decodable, Identifiable {
    public let id: Int
    let job: String
    let name: String
}

public struct MovieVideoResponse: Decodable {
    
    let results: [MovieVideo]
}

public struct MovieVideo: Decodable, Identifiable {
    
    public let id: String
    let key: String
    let name: String
    let site: String
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}
