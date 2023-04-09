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
        transView.transformations = DetailsViewModel.transformations
        
        navigationController?.pushViewController(transView, animated: true)
    }
    
    var hero: HeroModel!
    var transformations: [Transformation] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        title = hero.name
        transformationButton.alpha = 0 // 0 = invisible
        
        heroImageView.setImage(url: hero.photo )
        heroTitleLabel.text = hero.name
        heroDescLabel.text = hero.description
        
        transformations = DetailsViewModel.fetchTransformations(hero: hero)
        
        addNotfication()
    }

    func addNotfication() {
        NotificationCenter.default.addObserver(self, selector: #selector(configureTransformationButton(_:)), name: NSNotification.Name("transformations.are.ready"), object: nil)
    }
    
    @objc
    func configureTransformationButton(_ notification: Notification) {
        self.transformationButton.alpha = 1 // 1 = button fully visible
    }
}
