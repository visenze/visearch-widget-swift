//
//  ViColorSearchParamsTests.swift
//  ViSearchSDK
//
//  Created by Hung on 4/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import XCTest
@testable import ViSearchSDK


class ViColorSearchParamsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColorParamsInit() {
        XCTAssertNil( ViColorSearchParams(color: "" ) , "Missing color parameter")
        XCTAssertNil( ViColorSearchParams(color: "12345" ) , "Invalid length")
        XCTAssertNil( ViColorSearchParams(color: "12345G" ) , "Invalid character G")
        XCTAssertNotNil( ViColorSearchParams(color: "67890A" ) , "Valid")
        XCTAssertNil( ViColorSearchParams(color: "1357m9" ) , "Invalid character m")
        XCTAssertNotNil( ViColorSearchParams(color: "abcdef" ) , "valid")
        XCTAssertNotNil( ViColorSearchParams(color: "ABCDEF" ) , "valid")
        XCTAssertNotNil( ViColorSearchParams(color: "ff0067" ) , "valid")
        
        
    }
    

    
}
