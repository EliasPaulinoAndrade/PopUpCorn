//
//  PUTMDBGenreQuery.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

class PUTMDBModelQuery<T: Decodable>: PUTMDBQuery {

    private var task: URLSessionDataTask?

    /// Get a movies page from a given URL from TBDB API.
    ///
    /// - Parameters:
    ///   - moviesURL: the TMDB URL that returs movies
    ///   - sucessCompletion: this completion is called when all ocurred well
    ///   - errorCompletion: this completion is called when something bad or some error happend in the request
    func run(
        fromURL url: URL,
        sucessCompletion: @escaping (T) -> Void,
        errorCompletion: @escaping (Error?) -> Void) {

        self.task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                errorCompletion(error)
                return
            }

            if let data = data {
                let jsonDecoder = JSONDecoder.init()

                do {
                    let movies = try jsonDecoder.decode(T.self, from: data)
                    sucessCompletion(movies)
                } catch {
                    errorCompletion(error)
                }
            } else {
                errorCompletion(nil)
            }
        }

        self.task?.resume()
    }

    func cancel() {
        task?.cancel()
    }
}
