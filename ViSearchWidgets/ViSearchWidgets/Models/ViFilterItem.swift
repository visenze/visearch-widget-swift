//
//  ViFilterItem.swift
//  ViSearchWidgets
//
//  Created by Hung on 30/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit


/// Filter item type
///
/// - CATEGORY: filter by category e.g. brand or category. This is a multiple selection filter
/// - RANGE: filter by a numeric range e.g. for price
public enum ViFilterItemType : Int {
    
    case CATEGORY = 1
    case RANGE = 2
    
    case UNKNOWN = -1
    
}


open class ViFilterItem: NSObject {

    /// title to display in filter
    public var title: String
    
    /// filter type
    public var filterType : ViFilterItemType {
        return .UNKNOWN
    }
    
    /// mapping to schema in Dashboard
    public var schemaMapping: String
    
    public init(title: String, schemaMapping: String){
        self.title = title
        self.schemaMapping = schemaMapping
    }
    
    /// reset filter. To be implemented by subclass
    open func reset() {}
    
    // checking whether this filter is currently reset
    // if this is the case, it will be ignored. Needs to be overrided by subclass
    open func isReset() -> Bool {
        return false
    }
    
    /// generate the fq value for filtering for this item. Need to be overrided by subclass
    open func getFilterQueryValue() -> String {
        return ""
    }
    
    
    /// to be implemented by subclass
    /// soft clone the current object but reset all selected options
    open func clone() -> ViFilterItem{
        return self
    }

}

/// filter category option similar to <select> in html
/// option will be displayed to user while value is sent to server for filtering
open class ViFilterItemCategoryOption : NSObject {
    public var option: String
    public var value: String
    
    /// if only option is provided, value is assumed to be the same
    public init(option: String) {
        self.option = option
        self.value = option
    }
    
    public init(option: String , value: String) {
        self.option = option
        self.value = value
    }
}

open class ViFilterItemCategory : ViFilterItem {
    /// filter type
    public override var filterType : ViFilterItemType {
        return .CATEGORY
    }
    
    /// all options
    public var options : [ViFilterItemCategoryOption] = []
    
    /// selected options from user
    public var selectedOptions : [ViFilterItemCategoryOption] = []
    
    public convenience init(title: String, schemaMapping: String , options: [ViFilterItemCategoryOption]){
        self.init(title: title, schemaMapping: schemaMapping)
        self.options = options
    }
    
    open func isAllSelected() -> Bool {
        // if no options, we assume that it is all selected
        if self.selectedOptions.count == 0 {
            return true
        }
        
        if self.selectedOptions.count == self.options.count {
            return true
        }
        
        return false
    }
    
    // return comma separated string for selected options
    open func getSelectedString() -> String {
        let arr : [String] = selectedOptions.map { $0.option }
        return arr.joined(separator: ", ")
    }
    
    open override func reset() {
        self.selectedOptions.removeAll()
    }
    
    open override func isReset() -> Bool {
        return self.isAllSelected()
    }
    
    open override func getFilterQueryValue() -> String {
        let arr : [String] = self.selectedOptions.map { String(format: "\"%@\"", $0.value ) }
        
        return arr.joined(separator: " OR ")
    }
    
    open override func clone() -> ViFilterItem{
        let item = ViFilterItemCategory(title: self.title, schemaMapping: self.schemaMapping)
        // keep reference to old options but not selected options
        item.options = self.options
        
        return item
    }

}

open class ViFilterItemRange : ViFilterItem {
    
    public var min : Int = 0
    public var max : Int = 1000
    
    public var selectedMin : Int = 0
    public var selectedMax : Int = 1000
    
    /// filter type
    public override var filterType : ViFilterItemType {
        return .RANGE
    }
    
    public convenience init(title: String, schemaMapping: String , min: Int , max: Int){
        self.init(title: title, schemaMapping: schemaMapping)
        self.min = min
        self.max = max
        
        // something is wrong here, in this case, we set max to min
        if min > max {
             print("\(type(of: self)).\(#function)[line:\(#line)] - error: max value (\(max)) is smaller than min value (\(min)) ")
            
            self.max = min
        }
        
        self.selectedMin = self.min
        self.selectedMax = self.max
    }
    
    open override func reset() {
        self.selectedMin = self.min
        self.selectedMax = self.max
    }
    
    open override func isReset() -> Bool {
        return (self.selectedMin == self.min) && (self.selectedMax == self.max )
    }
    
    open override func getFilterQueryValue() -> String {
        return String(format: "%d,%d", self.selectedMin, self.selectedMax)
    }
    
    open override func clone() -> ViFilterItem{
        let item = ViFilterItemRange(title: self.title, schemaMapping: self.schemaMapping , min: self.min , max: self.max)
        return item
    }
}

