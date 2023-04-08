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
        
        print("Core  inventory check of heroesToShow: \(HeroViewModel.heroesShow.count)\n")
        
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
                
                addLocationsToHeroModelFunc(heroes: heroesModelContainer)
                
                DispatchQueue.main.async {
                }
            } else {
                print("Error fetching hereos: ", error?.localizedDescription ?? "")
            }
        }
    }
    
    func addLocationsToHeroModelFunc (heroes: [HeroModel]) -> Void {
        print("\nStarting addLocationsToHeroModelFunc...\n")
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
            
            self.moveToMainFunc(heroes: heroesWithLocations)
        }
    }
    
    func moveToMainFunc (heroes: [HeroModel]) -> Void {
        
        print("Starting movetoMainFunc... heroes.forEach... saveApiDatatoCoreData\n")
        print("moveToMain2 hero count: \(heroes.count)\n")

        CoreDataManager.saveApiDataToCoreData(heroes) // write api data to core data

        HeroViewModel.heroesShow = CoreDataManager.getCoreDataForPresentation()
        
        NotificationCenter.default.post(name: Notification.Name("data.is.loaded.into.CD"), object: nil) // wait unti everything is done, send notif for UI refresh
    }
}
