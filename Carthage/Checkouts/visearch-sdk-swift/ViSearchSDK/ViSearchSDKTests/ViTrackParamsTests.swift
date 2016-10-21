//
//  ViTrackParamsTests.swift
//  ViSearchSDK
//
//  Created by Hung on 3/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import XCTest
@testable import ViSearchSDK

class ViTrackParamsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitTrackParams() {
        XCTAssertNil( ViTrackParams(accessKey: "", reqId: "aa", action: "bb") , "missing access key" )
        XCTAssertNil( ViTrackParams(accessKey: "aa", reqId: "", action: "bb") , "missing request id" )
        XCTAssertNil( ViTrackParams(accessKey: "aa", reqId: "bb", action: "") , "missing action" )
        
        XCTAssertNotNil( ViTrackParams(accessKey: "aa", reqId: "bb", action: "cc") , "valid constructor" )
        
    }
   
    
}
