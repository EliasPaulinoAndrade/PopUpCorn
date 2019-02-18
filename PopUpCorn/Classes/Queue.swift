//
//  Queue.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 17/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

class Queue<Element: Equatable> {
    private var list: [Element] = []
    var limit: Int

    var count: Int {
        return list.count
    }

    init(withLimit limit: Int) {
        self.limit = limit
    }

    func add(_ newElement: Element) {
        if list.count == limit {
            list.remove(at: 0)
        }

        list.append(newElement)
    }

    func add(array: [Element]) {
        if array.count + list.count < limit {
            list.append(contentsOf: array)
        }
    }

    func contains(_ element: Element) -> Bool {
        return self.list.contains(element)
    }

    subscript(index: Int) -> Element {
        get {
            return list[index]
        } set {
            list[index] = newValue
        }
    }

    var array: [Element] {
        return list
    }
}
