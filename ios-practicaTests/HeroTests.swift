//
//  HeroTests.swift
//  ios-practicaTests
//
//  Created by Eric Olsson on 1/14/23.
// L3 02:52:50 - API usage in Postman

import XCTest
@testable import ios_practica

final class HeroTests: XCTestCase {

    var hero: Hero!
    
    override func setUp() {
        super.setUp()
        
        hero = Hero(id: "1",
                      name: "Goku",
                      photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300", // any valid url
                      description: "Correct description",
                      favorite: true)
    }

    override func tearDown()  {
        hero = nil
        super.tearDown()
    }
    
    func testHeroId() {
        XCTAssertNotNil(hero.id)
        XCTAssertEqual(hero.id, "1")
        XCTAssertNotEqual(hero.id, "2")
        XCTAssertNotEqual(hero.id, "3")
    } // pass
    
    func testHeroName() {
        XCTAssertNotNil(hero.name)
        XCTAssertEqual(hero.name, "Goku")
        XCTAssertNotEqual(hero.name, "Krilin")
    } // pass
    
    func testHeroPhoto() {
        let url = URL(string: hero.photo)
        
        XCTAssertNotNil(hero.photo)
        XCTAssertEqual(hero.photo, "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300")
        XCTAssertNotEqual(hero.photo, "https://www.keepcoding.com")
        XCTAssertNotNil(url?.absoluteURL) // test url validity
    } // pass
    
    func testHeroDescription() {
        XCTAssertNotNil(hero.description)
        XCTAssertEqual(hero.description, "Correct description")
        XCTAssertNotEqual(hero.description, "Some other description")
    } // pass
    
    func testHeroFav() {
        XCTAssertNotNil(hero.favorite)
        XCTAssertEqual(hero.favorite, true)
    } // pass

} // pass
