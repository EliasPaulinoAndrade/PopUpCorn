//
//  PUTMDBQuery.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 14/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol PUTMDBQuery {
    associatedtype QueryType
    func run(fromURL url: URL,
             sucessCompletion: @escaping (QueryType) -> Void,
             errorCompletion: @escaping (Error?) -> Void)

    func cancel()
}
