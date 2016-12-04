//
//  String+Visenze.swift
//  ViSearchWidgets
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit


// MARK: - extension for String
public extension String{

    /// return trimmed string
    public var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // return lines break by new lines
    public var lines: [String] {
        return components(separatedBy: CharacterSet.newlines)
    }
    
}
