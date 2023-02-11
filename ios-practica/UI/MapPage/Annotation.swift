//
//  Annotation.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
     
    let coordinate: CLLocationCoordinate2D
    let name: String
    let image: String
    
    init(place: Place) {
        coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        name = place.name
        image = place.image
    }
}
