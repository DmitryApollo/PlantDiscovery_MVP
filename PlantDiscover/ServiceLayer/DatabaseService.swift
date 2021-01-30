//
//  DatabaseService.swift
//  PlantDiscover
//
//  Created by Дмитрий on 29/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation
import CoreData

protocol DatabaseServiceProtocol {
    func insertPlant(_ plant: Plant) throws
    func fetchPlants() throws -> [PlantClass]
    func delete(plant: PlantClass) throws
}
 
class DatabaseService: DatabaseServiceProtocol {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlantDiscover")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var context: NSManagedObjectContext {
        return Self.persistentContainer.viewContext
    }
    
    func insertPlant(_ plant: Plant) throws {
        let plantClass = PlantClass(context: self.context)
        plantClass.id = Int64(plant.id)
        plantClass.commonName = plant.commonName
        plantClass.scientificName = plant.scientificName
        plantClass.year = Int32(plant.year ?? 0)
        plantClass.bibliography = plant.bibliography
        plantClass.author = plant.author
        plantClass.status = plant.status
        plantClass.rank = plant.rank
        plantClass.familyCommonName = plant.familyCommonName
        plantClass.imageUrl = plant.imageUrl
        plantClass.isFavourite = plant.isFavourite
    
        self.context.insert(plantClass)
        try self.context.save()
    }
    
    func fetchPlants() throws -> [PlantClass] {
        let plants = try self.context.fetch(PlantClass.fetchRequest() as NSFetchRequest<PlantClass>)
        return plants
    }
    
    func delete(plant: PlantClass) throws {
        self.context.delete(plant)
        try self.context.save()
    }
}
