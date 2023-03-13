//
//  CoreDataManager.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/21/23.
//

import CoreData

class CoreDataManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error {
                debugPrint("Error during loading persistent stores \(error)")
            }
        }
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            debugPrint("Error during saving context \(error)")
        }
    } // not used
    
    static func saveApiDataToCoreData(_ herosSendToMapping: [HeroModel]) {
        
        var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        herosSendToMapping.forEach { heroSendToMapping in
        
            let heroRecFmMapping = HeroCD(context: context)
            
            heroRecFmMapping.id = heroSendToMapping.id
            heroRecFmMapping.name = heroSendToMapping.name
            heroRecFmMapping.desc = heroSendToMapping.description
            heroRecFmMapping.photo = heroSendToMapping.photo
            heroRecFmMapping.favorite = heroSendToMapping.favorite
            heroRecFmMapping.latitude = heroSendToMapping.latitude ?? 0.0
            heroRecFmMapping.longitude = heroSendToMapping.longitude ?? 0.0
            
            do {
                try context.save()
//                print("\nsaveApiDataToCoreData successfull.\n\(heroRecFmMapping)\n")
            } catch let error {
                debugPrint(error)
            }
        } // end herosSendToMapping.forEach
    } // end saveApiDataToCoreData
    
    // code credit: PracticaResueltalOSAvanzado
    static func getCoreDataForPresentation() -> [HeroModel] {
        
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        let heroFetch: NSFetchRequest<HeroCD> = HeroCD.fetchRequest()
        
        do {
            let result = try context.fetch(heroFetch)
            
            let heroToPresent = result.map {
                HeroModel.init(id: $0.id ?? "",
                               name: $0.name ?? "",
                               photo: $0.photo ?? "",
                               description: $0.desc ?? "",
                               favorite: $0.favorite)
            }
            print("\nCoreDataManager > getCoreDataForPresentation() > heroToPresent[6]: \(heroToPresent[6])\n")
            return heroToPresent
        } catch let error as NSError {
            debugPrint("Error: \(error)")
            return []
        }
    } // end getCoreDataForPresentation()
    
} // end CoreDataManager
