//
//  Hero.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/27/22.
//  Hero model for main object data // This file complete ✅

import Foundation

struct Hero: Codable { // was codable...
    let id: String
    let name: String
    let photo: String
    let description: String
    let favorite: Bool
//    let dateShow: String
//    let idLocation: String
    var latitude: Double? // optional since values not present in heros api call
    var longitude: Double?
}
