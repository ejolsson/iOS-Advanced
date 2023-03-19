//
//  CoreDataManager.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/21/23.
//

import CoreData
import Foundation

class CoreDataManager {
    
    private let modelName: String
//    let coreDataManager: CoreDataManager
    
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
        
        print("Starting saveApiDataToCoreData...")
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
            } catch let error {
                debugPrint(error)
            }
        } // end herosSendToMapping.forEach
//        print("Output fm: saveApiDataToCoreData > herosSendToMapping\n \(herosSendToMapping)\n")
    } // end saveApiDataToCoreData
    
    // code credit: PracticaResueltalOSAvanzado
    static func getCoreDataForPresentation() -> [HeroModel] {
        
        print("\nStarting getCoreDataForPresentation...\n")
        
        let context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
        
        let heroFetch: NSFetchRequest<HeroCD> = HeroCD.fetchRequest()
        
        do {
            let result = try context.fetch(heroFetch)
            
            let heroToPresent = result.map {
                HeroModel.init(id: $0.id ?? "",
                               name: $0.name ?? "",
                               photo: $0.photo ?? "",
                               description: $0.desc ?? "",
                               favorite: $0.favorite,
                               latitude: $0.latitude,
                               longitude: $0.longitude)
            }
//            print("\nCoreDataManager > getCoreDataForPresentation() > heroToPresent: \(heroToPresent)\n") // no need to use this line since L66 in HLVC prings "herosToShow"
            NotificationCenter.default.post(name: Notification.Name("data.is.loaded.into.CD"), object: nil)
//            dataIsLoadedIntoCDNotification()
            return heroToPresent
        } catch let error as NSError {
            debugPrint("Error: \(error)")
            return []
        }
    } // end getCoreDataForPresentation()
    
    static func deleteCoreData() {
//        var herosToDelete =
    }
    
    func dataIsLoadedIntoCDNotification() {
        NotificationCenter.default.post(name: Notification.Name("data.is.loaded.into.CD"), object: nil)
    }
} // end clall CoreDataManager
