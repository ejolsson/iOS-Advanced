//
//  Hero.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//  

import Foundation

struct HeroModel: Codable {
    let id: String
    let name: String
    let photo: String
    let description: String
    let favorite: Bool
    var latitude: Double? // optional since values not present in heros api call
    var longitude: Double?
}
