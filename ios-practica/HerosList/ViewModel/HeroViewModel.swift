//
//  HeroViewModel.swift
//  ios-practica
//
//  Created by Eric Olsson on 3/22/23.
//

import Foundation

class HeroViewModel: NSObject {
    
    let token = Global.tokenMaster
    let heroListViewController = HeroListViewController()
    
    func getCompleteHero(token: String) {
        
        NetworkLayer.shared.fetchHeros(token: Global.tokenMaster) { [weak self] herosModelContainer, error in
            guard let self = self else { return }
            
            if let herosModelContainer = herosModelContainer {
                
                self.addLocationsToHeroModel(herosModelContainer) // saveToCD nested
//                        for hero in heros
//                            group.notify
//                                moveToMain2 (héros.forEach)
//                                    saveApiDataToCoreData
//                                    getCoreDataForPresentation
                
                DispatchQueue.main.async {
                    self.heroListViewController.tableView.reloadData()
                }
            } else {
                print("Error fetching heros: ", error?.localizedDescription ?? "")
            }
        }
    }
    
    // below not in use yet
    let addLocationsToHeroModel = {(heros: [HeroModel]) -> Void in
        print("\nStarting addLocationsToHeroModel...\n")
        var herosWithLocations: [HeroModel] = []
        
        let group = DispatchGroup() // https://developer.apple.com/documentation/dispatch/dispatchgroup
        
        for hero in heros {
            group.enter() // Apple Docs: Explicitly indicates that a block has entered the group.
            
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
                group.leave() // indicates the operation will termianate
            }
        }
        
        group.notify(queue: .main) {
            debugPrint("herosWithLocations count (Should be 18): \(herosWithLocations.count)")
            
            HeroListViewController.herosToShow = herosWithLocations // suspect not necessary given moveToMain2, suspicion correct
            debugPrint("L227: HeroListViewController.herosToShow.count (Should be 18): \(HeroListViewController.herosToShow.count)\n")
            
            moveToMain2(herosWithLocations) //... contains: saveApiDataToCoreData
        }
    } // end addLocationsToHeroModel
    
    
}

// had some issue w/ partial loading...
let moveToMain2 = { (heros: [HeroModel]) -> Void in

    print("Starting moveToMain2... heros.forEach... saveApiDatatoCoreData")
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext

    debugPrint("moveToMain2 hero count: \(heros.count)\n")

    CoreDataManager.saveApiDataToCoreData(heros) // write api data to core data

    HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation() // CD->heroModel
    
    NotificationCenter.default.post(name: Notification.Name("data.is.loaded.into.CD"), object: nil) // wait unti everything is done
//    Global.herosToShowG = CoreDataManager.getCoreDataForPresentation() // CD->heroModel
//    print("Global.herosToShowG.count (post moveToMain2) = \(Global.herosToShowG.count)\n")
}
