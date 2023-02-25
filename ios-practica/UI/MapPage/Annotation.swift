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
//    let image: String
//    let dateShow: String
    
    init(place: Place) {
        coordinate = CLLocationCoordinate2D(latitude: Double(place.latitud) ?? 0.0, longitude:   Double(place.longitud) ?? 0.0)
        name = place.id
//        image = place.image
//        dateShow = place.dateShow
    }
}
