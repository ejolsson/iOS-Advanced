//
//  DetailsViewModel.swift
//  ios-practica
//
//  Created by Eric Olsson on 3/22/23.
//

import Foundation
import UIKit

class DetailsViewModel: NSObject {
    
    static func fetchTransformations(hero: HeroModel!) -> [Transformation] {
        // try adding tranformations in the call... NOPE... no value to send
        // 3/31 making the function return a value to pass back to the VC
        
        let token = Global.tokenMaster
        let detailsViewController = DetailsViewController()
//        var hero: HeroModel! // if enabled, tranformation view completely blows up... must compete w/ the VC version
        var transformations: [Transformation] = [] // try commenting this out too... nope
        let transformationButton = detailsViewController.transformationButton
        
        NetworkLayer
            .shared
            .fetchTransformations(token: token, heroId: hero.id) { allTrans, error in
//                guard let self = self else { return }
                
                if let allTrans = allTrans {
                    
                    transformations = allTrans
                    
                    print("Transformation count: ", allTrans.count)
                    
                    if !transformations.isEmpty {
                        DispatchQueue.main.async {
                            print("transformation NOT empty \n")
                            print("transformation: \(transformations)")
//                            detailsViewController.transformationButton.alpha = 1
                            transformationButton?.alpha = 1
                        }
                    }
                } else {
                    print("Error fetching transformations: ", error?.localizedDescription ?? "")
                }
            }
        return transformations
    }
    
    static func showTransformationButton(transformations: [Transformation]) {
        
        let detailsViewController = DetailsViewController()
        
        print("transformation logic count: \(transformations.count)\n")
        
        if !transformations.isEmpty {
            DispatchQueue.main.async {
                print("transformation NOT empty \n")
                detailsViewController.transformationButton.alpha = 1
//                detailsViewController.transformationButton.alpha = 1 // button.alpha = 0 by default
            }
        }
    }
}
