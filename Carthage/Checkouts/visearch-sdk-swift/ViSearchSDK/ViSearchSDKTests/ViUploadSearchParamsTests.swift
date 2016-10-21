//
//  ViUploadSearchParamsTests.swift
//  ViSearchSDK
//
//  Created by Hung on 6/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import XCTest
@testable import ViSearchSDK

class ViUploadSearchParamsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNil( ViUploadSearchParams(im_id: "") , "Missing image id")
        XCTAssertNil( ViUploadSearchParams(im_url: "") , "Missing image url")
        
    }
    
}
