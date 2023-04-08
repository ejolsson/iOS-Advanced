//
//  HeroViewModel.swift
//  ios-practica
//
//  Created by Eric Olsson on 3/22/23.
//

import Foundation

class HeroViewModel: NSObject {
    
    static var herosToShow2: [HeroModel] = []
    var place: Place! // needed for location api call & parsing
    
    func checkForExistingHeros () {

        print("\nInitial check for heroes in CD...")

        HeroViewModel.herosToShow2 = CoreDataManager.getCoreDataForPresentation()
        
        print("Core Data inventory check of herosToShow: \(HeroViewModel.herosToShow2.count)\n")
        
        if HeroViewModel.herosToShow2.isEmpty {
            
            print("herosToShow2.isEmpty == true... make api calls\n")
            getCompleteHero(token: Global.tokenMaster)
            
        } else {
            print("herosToShow2 is NOT empty\n")
        }
    }
    
    func getCompleteHero(token: String) {
        
        NetworkLayer.shared.fetchHeros(token: Global.tokenMaster) { [weak self] herosModelContainer, error in
            guard let self = self else { return }
            
            if let herosModelContainer = herosModelContainer {
                
                addLocationsToHeroModelFunc(heros: herosModelContainer)
                
                DispatchQueue.main.async {
                    // self.heroListViewController.tableView.reloadData()
                }
            } else {
                print("Error fetching heros: ", error?.localizedDescription ?? "")
            }
        }
    }
    
    func addLocationsToHeroModelFunc (heros: [HeroModel]) -> Void {
        print("\nStarting addLocationsToHeroModelFunc...\n")
        var herosWithLocations: [HeroModel] = []
        
        let group = DispatchGroup()
        
        for hero in heros {
            group.enter()
            
            NetworkLayer.shared.getLocalization(token: Global.tokenMaster, with: hero.id) { heroLocations, error in
                var fullHero = hero
                
                if let firstLocation = heroLocations.first { // only grab first hero location
                    fullHero.latitude = Double(firstLocation.latitud)
                    fullHero.longitude = Double(firstLocation.longitud)
                } else {
                    fullHero.latitude = 0.0
                    fullHero.longitude = 0.0
                }
                herosWithLocations.append(fullHero)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { //[self] in // try commenting out [self] in
            
            self.moveToMainFunc(heros: herosWithLocations)
        }
    }
    
    func moveToMainFunc (heros: [HeroModel]) -> Void {
        
        print("Starting movetoMainFunc... heros.forEach... saveApiDatatoCoreData")
        
        var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext

        debugPrint("moveToMain2 hero count: \(heros.count)\n")

        CoreDataManager.saveApiDataToCoreData(heros) // write api data to core data

        HeroViewModel.herosToShow2 = CoreDataManager.getCoreDataForPresentation()
        
        NotificationCenter.default.post(name: Notification.Name("data.is.loaded.into.CD"), object: nil) // wait unti everything is done, send notif for UI refresh
    }
    
}
