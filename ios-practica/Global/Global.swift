//
//  Global.swift
//  ios-practica
//
//  Created by Eric Olsson on 3/14/23.
//

import Foundation

class Global {
    static var tokenMaster: String = "" // "eyJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJpZGVudGlmeSI6IkI4M0I1NjZCLUY2NEItNENGNi1CQzI1LUIwQTAxNkQzNkIzMiIsImVtYWlsIjoiZWpvbHNzb25AZ21haWwuY29tIiwiZXhwaXJhdGlvbiI6NjQwOTIyMTEyMDB9.fBTvAWVKbqaJoDAFvpLlO6YY5gjCPVwxJbXvCQMKiBw"
    static var herosToShowG: [HeroModel] = []
    static var loginStatus: Bool = false
    static var heroDataLocallyStored: Bool = false
}
