//
//  Place.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//

import UIKit

struct Place: Codable {
    let id: String
    let latitud: String
    let longitud: String
//    let dateShow: String // not used?
//    let name: String // not used?
}

// Lat, long need to be strings to match API format
// parameter spelling syntax and data type need to match API
// allowed to bring in less items than provided by api
// Codable is a type alias for the Encodable and Decodable protocols.
