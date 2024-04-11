//
//  MovieServiceSDKTests.swift
//  MovieServiceSDKTests
//
//  Created by Devanand Chauhan on 10/04/24.
//

import XCTest
@testable import MovieServiceSDK

final class MovieServiceSDKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        guard let file =  Bundle(for: type(of: self)).url(forResource: "latest", withExtension: "json") else { return }
        print("file:\(file)")
        
        guard let data = try? Data.init(contentsOf: file) else { return }
        
        let decoder = JSONDecoder()
        let article = try? decoder.decode(Movie.self , from: data)
        XCTAssertNotNil(article)
    }
    
    func testExample2() throws {
        
        let movieService = MovieService.shared
        movieService.fetchMovies(from: .latest) { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let err):
                print(err)
            }
        }
        
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
