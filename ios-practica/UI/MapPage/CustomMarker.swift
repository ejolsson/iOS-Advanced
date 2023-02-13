//
//  CustomMarker.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/13/23.
//

import UIKit
import MapKit

class CustomMarker: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            let pinImage = UIImage(named: "marker-blue")
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            self.image = resizedImage
        }
    }
}
