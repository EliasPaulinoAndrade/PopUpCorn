//
//  DAOProtocol.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 08/06/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol DAOProtocol {
    associatedtype Element

    /// All the elements from the database
    ///
    /// - Returns: all the elements
    func getAll() -> [Element]

    /// Save a element to the database.
    ///
    /// - Parameter element: the element
    /// - Returns: if the the element was saved it return the element the id already set. Returns nil if not.
    func save(element: Element) -> Element?

    func delete(element: Element)
    func get(elementWithID daoID: String) -> Element?

    /// updates a element in the database
    ///
    /// - Parameter element: the element
    /// - Returns: true if the update was sucessfull, false if not.
    func update(element: Element) -> Bool
}
