//
//  UidHelperTests.swift
//  ViSearchSDK
//
//  Created by Hung on 4/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import XCTest
@testable import ViSearchSDK

class UidHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGenerateUid() {
        let deviceId = UidHelper.uniqueDeviceUid()
//        dump( "deviceId: \(deviceId)" )
        XCTAssertNotNil(deviceId, "unable to get device id ")
        
        let deviceId2 = UidHelper.uniqueDeviceUid() // should return the same value
        XCTAssertEqual(deviceId, deviceId2, "device uid should be the same")
        
    }
   
    
}
