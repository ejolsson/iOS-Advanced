//
//  HeroViewModel.swift
//  ios-practica
//
//  Created by Eric Olsson on 3/22/23.
//

import Foundation

class HeroViewModel: NSObject {
    
    static var heroesShow: [HeroModel] = []
    var place: Place! // needed for location api call & parsing
    
    func checkForExistingHeroes () {

        HeroViewModel.heroesShow = CoreDataManager.getCoreDataForPresentation()
        
        print("CoreData inventory check of heroes: \(HeroViewModel.heroesShow.count)\n")
        
        if HeroViewModel.heroesShow.isEmpty {
            
            print("heroesShow.isEmpty... make api calls\n")
            getCompleteHero(token: Global.tokenMaster)
            
        } else {
            print("heroesShow is NOT empty\n")
        }
    }
    
    func getCompleteHero(token: String) {
        
        NetworkLayer.shared.fetchHeroes(token: Global.tokenMaster) { [weak self] heroesModelContainer, error in
            guard let self = self else { return }
            
            if let heroesModelContainer = heroesModelContainer {
                
                addLocationsToHeroes(heroes: heroesModelContainer)
                
                DispatchQueue.main.async {
                }
            } else {
                print("Error fetching hereos: ", error?.localizedDescription ?? "")
            }
        }
    }
    
    func addLocationsToHeroes (heroes: [HeroModel]) -> Void {
        print("\nStarting addLocationsToHeroes...\n")
        var heroesWithLocations: [HeroModel] = []
        
        let group = DispatchGroup()
        
        for hero in heroes {
            group.enter()
            
            NetworkLayer.shared.fetchLocations(token: Global.tokenMaster, with: hero.id) { heroLocations, error in
                var fullHero = hero
                
                if let firstLocation = heroLocations.first { // only grab first hero location
                    fullHero.latitude = Double(firstLocation.latitud)
                    fullHero.longitude = Double(firstLocation.longitud)
                } else {
                    fullHero.latitude = 0.0
                    fullHero.longitude = 0.0
                }
                heroesWithLocations.append(fullHero)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { //[self] in // try commenting out [self] in
            
            self.saveThenReadToCoreData(heroes: heroesWithLocations)
        }
    }
    
    func saveThenReadToCoreData (heroes: [HeroModel]) -> Void {
        
        print("Starting saveThenReadToCoreData\n")
        print("Hero count: \(heroes.count)\n")

        CoreDataManager.saveApiDataToCoreData(heroes) // write api data to core data

        HeroViewModel.heroesShow = CoreDataManager.getCoreDataForPresentation() // read from Core Data to present in UI
        
        NotificationCenter.default.post(name: Notification.Name("data.is.loaded.into.CD"), object: nil) // wait unti everything is done, send notif for UI refresh
    }
}
