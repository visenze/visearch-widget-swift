//
//  ViSearchClientTests.swift
//  ViSearchSDK
//
//  Created by Hung on 4/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import XCTest
@testable import ViSearchSDK

class ViSearchClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchClientInit() {
        XCTAssertNil( ViSearchClient(baseUrl: "", accessKey: "" , secret: "") )
        XCTAssertNil( ViSearchClient( accessKey: "" , secret: "aa") )
        XCTAssertNil( ViSearchClient( accessKey: "aa" , secret: "") )
        XCTAssertNotNil( ViSearchClient( accessKey: "bb" , secret: "aa") )
    
    }
    
}
