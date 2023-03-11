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
//        image = "http://i.annihil.us/u/prod/marvel/i/mg/b/c0/553a9abceb412/portrait_incredible.jpg"
        //"https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300" // place.photo // trying to get the picture to load
//        dateShow = place.dateShow
    }
}
