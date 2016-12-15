//
//  StopWatch.swift
//  WidgetsExample
//
//  Created by Hung on 15/12/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit

// record time
public class StopWatch {
    
    public let name: String
    public var startTime: CFAbsoluteTime? = nil
    public var elapsedTime: CFAbsoluteTime = 0
    public var elapsedTimeStep: CFAbsoluteTime = 0
    
    
    public init(name: String) {
        self.name = name
    }
    
    public func reset() {
        elapsedTime = 0
        elapsedTimeStep = 0
        startTime = nil
    }
    
    public func resume() {
        if startTime == nil {
            startTime = CFAbsoluteTimeGetCurrent()
        }
    }
    
    public func pause() {
        if let startTime = startTime {
            elapsedTimeStep = CFAbsoluteTimeGetCurrent() - startTime
            elapsedTime += elapsedTimeStep
            self.startTime = nil
        }
    }
}
