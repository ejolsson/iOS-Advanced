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
    } // complete
    
    var hero: Hero!
    var transformations: [Transformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = hero.name
        transformationButton.alpha = 0
        
        heroImageView.setImage(url: hero.photo)
        heroTitleLabel.text = hero.name
        heroDescLabel.text = hero.description
        //heroDescLabel.sizeToFit() // attempting to align text to top of label
        
        let token = LocalDataLayer.shared.getToken()
        
        NetworkLayer
            .shared
            .fetchTransformations(token: token, heroId: hero.id) { [weak self] allTrans, error in
                guard let self = self else { return }
                
                if let allTrans = allTrans {
                    
                    self.transformations = allTrans
                    
                    print("Transformation count: ", allTrans.count)
                    
                    if !self.transformations.isEmpty {
                        DispatchQueue.main.async {
                            self.transformationButton.alpha = 1
                        }
                    }
                } else {
                    print("Error fetching transformations: ", error?.localizedDescription ?? "")
                }
            }
        }

}
