//
//  DetailsViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 1/9/23.
//

import UIKit

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroTitleLabel: UILabel!
    @IBOutlet weak var heroDescLabel: UILabel!
    @IBOutlet weak var transformationButton: UIButton!
    
    @IBAction func transformationsButtonTapped(_ sender: Any) {
        let transView = TransformationViewController()
        transView.transformations = self.transformations
        
        navigationController?.pushViewController(transView, animated: true)
    }
    
    var hero: HeroModel!
    var transformations: [Transformation] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        title = hero.name
        transformationButton.alpha = 0
        
        heroImageView.setImage(url: hero.photo )
        heroTitleLabel.text = hero.name
        heroDescLabel.text = hero.description
        
        let token = Global.tokenMaster
        
        transformations = DetailsViewModel.fetchTransformations(hero: hero) // 3/31 made the func return a value and assign to transformtions
        
        DetailsViewModel.showTransformationButton(transformations: transformations)
        
        // try pulling out this logic from api call below. Given transformtions is populated, (timing aside) might work?...
        if !self.transformations.isEmpty {
            DispatchQueue.main.async {
                self.transformationButton.alpha = 1
            }
        }
        
//        NetworkLayer
//            .shared
//            .fetchTransformations(token: token, heroId: hero.id) { [weak self] allTrans, error in
//                guard let self = self else { return }
//
//                if let allTrans = allTrans {
//
//                    self.transformations = allTrans
//
//                    print("Transformation count: ", allTrans.count)
//
//                    if !self.transformations.isEmpty {
//                        DispatchQueue.main.async {
//                            self.transformationButton.alpha = 1
//                        }
//                    }
//                } else {
//                    print("Error fetching transformations: ", error?.localizedDescription ?? "")
//                }
//            }
        }

}
