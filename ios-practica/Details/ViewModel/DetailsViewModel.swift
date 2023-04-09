//
//  DetailsViewModel.swift
//  ios-practica
//
//  Created by Eric Olsson on 3/22/23.
//

import Foundation
import UIKit

class DetailsViewModel: NSObject {
    
    static var transformations: [Transformation] = []
//    var hero: HeroModel!
    
    static func fetchTransformations(hero: HeroModel!) -> [Transformation] {

        NetworkLayer.shared.fetchTransformations(token: Global.token, heroId: hero.id) { allTrans, error in
                
                if let allTrans = allTrans {
                    
                    transformations = allTrans
                    
                    print("Transformation count for \(hero.name): ", allTrans.count)
                    
                    if !transformations.isEmpty {
                        DispatchQueue.main.async {
                            print("Transformation NOT empty, show transformation button\n")
                            NotificationCenter.default.post(name: Notification.Name("transformations.are.ready"), object: nil)
                        }
                    }
                } else {
                    print("Error fetching transformations: ", error?.localizedDescription ?? "")
                }
            }
        return self.transformations
    }
}
