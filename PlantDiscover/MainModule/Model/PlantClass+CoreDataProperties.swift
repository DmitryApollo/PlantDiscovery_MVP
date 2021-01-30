//
//  PlantClass+CoreDataProperties.swift
//  PlantDiscover
//
//  Created by Дмитрий on 29/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//
//

import Foundation
import CoreData

extension PlantClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlantClass> {
        return NSFetchRequest<PlantClass>(entityName: "PlantClass")
    }

    @NSManaged public var id: Int64
    @NSManaged public var commonName: String?
    @NSManaged public var scientificName: String?
    @NSManaged public var year: Int32
    @NSManaged public var bibliography: String?
    @NSManaged public var author: String?
    @NSManaged public var status: String?
    @NSManaged public var rank: String?
    @NSManaged public var familyCommonName: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var isFavourite: Bool

}
