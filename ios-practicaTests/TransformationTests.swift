//
//  TransformationTests.swift
//  ios-practicaTests
//
//  Created by Eric Olsson on 1/14/23.
//

import XCTest

final class TransformationTests: XCTestCase {

    var trans: Transformation!
    
    override func setUp() {
        super.setUp()
        
        trans = Transformation(id: "1",
                               name: "Super transformation",
                               photo: "https://areajugones.sport.es/wp-content/uploads/2019/07/super-saiyajin-3-vegeta-a-maxima-potencia_1680217-1024x576.jpg.webp",
                               description: "Correct description")
    }

    override func tearDown() {
        trans = nil
        super.tearDown()
    }

    func testTransformationId() {
        XCTAssertNotNil(trans.id)
        XCTAssertEqual(trans.id, "1")
        XCTAssertNotEqual(trans.id, "2")
    }
    
    func testTransformationName() {
        XCTAssertNotNil(trans.name)
        XCTAssertEqual(trans.name, "Super transformation")
        XCTAssertNotEqual(trans.name, "Super saiyan Blue")
    }
    
    func testTransformationPhoto() {
        let url = URL(string: trans.photo)
        
        XCTAssertNotNil(trans.photo)
        XCTAssertEqual(trans.photo, "https://areajugones.sport.es/wp-content/uploads/2019/07/super-saiyajin-3-vegeta-a-maxima-potencia_1680217-1024x576.jpg.webp")
        XCTAssertNotEqual(trans.photo, "https://www.keepcoding.com")
        XCTAssertNotNil(url?.absoluteURL)
    }
    
    func testTransformationDescription() {
        XCTAssertNotNil(trans.description)
        XCTAssertEqual(trans.description, "Correct description")
        XCTAssertNotEqual(trans.description, "Some other description")
    }

}
