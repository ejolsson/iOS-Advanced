//
//  TransformationDetailViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 1/14/23.
//

import UIKit

class TransformationDetailViewController: UIViewController {

    
    @IBOutlet weak var transformationImageView: UIImageView!
    @IBOutlet weak var transformationNameLabel: UILabel!    
    @IBOutlet weak var transformationDescLabel: UILabel!
    
    var transformation: Transformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = transformation.name
        
        transformationImageView.setImage(url: transformation.photo)
        transformationNameLabel.text = transformation.name
        transformationDescLabel.text = transformation.description
        transformationDescLabel.sizeToFit()
    }

}
