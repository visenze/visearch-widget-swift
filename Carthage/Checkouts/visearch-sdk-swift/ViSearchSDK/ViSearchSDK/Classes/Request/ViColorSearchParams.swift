//
//  ViColorSearchParams.swift
//  ViSearchSDK
//
//  Created by Hung on 3/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import UIKit


/// Construct color search parameter request
public class ViColorSearchParams: ViBaseSearchParams {
    public var color: String
    
    public init? (color: String ) {
        self.color = color
        
        //verify that color is exactly 6 digits
        if self.color.characters.count != 6 {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: color length must be 6")
            
            return nil
        }
        
        // verify color is of valid format i.e. only a-fA-F0-9
        let regex = try! NSRegularExpression(pattern: "[^a-fA-F|0-9]", options: [])
        let numOfMatches = regex.numberOfMatches(in: self.color, options: [.reportCompletion], range: NSMakeRange(0, self.color.characters.count ))
        if numOfMatches != 0 {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: invalid color format")
            
            return nil
        }
    }
    
    public convenience init (color: UIColor){
        self.init(color: color.hexString())!
    }
    
    public override func toDict() -> [String: Any] {
        var dict = super.toDict()
        dict["color"] = color
        return dict;
    }
    
}
