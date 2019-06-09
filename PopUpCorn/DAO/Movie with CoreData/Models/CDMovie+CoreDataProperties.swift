//
//  CDMovie+CoreDataProperties.swift
//  
//
//  Created by Elias Paulino on 08/06/19.
//
//

import Foundation
import CoreData

extension CDMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMovie> {
        return NSFetchRequest<CDMovie>(entityName: "CDMovie")
    }

    @NSManaged public var backDrop: String?
    @NSManaged public var genres: String?
    @NSManaged public var id: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?

}
