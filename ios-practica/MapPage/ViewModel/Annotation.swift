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
    let desc: String
    let image: String
//    let dateShow: String
    
    init(place: HeroModel) {
        coordinate = CLLocationCoordinate2D(latitude: Double(place.latitude ?? 0.0) , longitude:   Double(place.longitude ?? 0.0) )
        name = place.name
        desc = place.description
        image = place.photo

    }
}
