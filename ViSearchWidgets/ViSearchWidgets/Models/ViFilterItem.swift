//
//  ViFilterItem.swift
//  ViSearchWidgets
//
//  Created by Hung on 30/11/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit


/// Supported filter item type
///
/// - CATEGORY: filter by category e.g. brand or category. This is a multiple selection filter
/// - RANGE: filter by a numeric range e.g. for price with min/max price
public enum ViFilterItemType : Int {
    
    case CATEGORY = 1
    case RANGE = 2
    
    case UNKNOWN = -1
    
}

/// Base/abstract class for a filter item that will appear in the filter bar
/// This is not meant to be used directly. Should only instantiate the sub classes
open class ViFilterItem: NSObject {

    /// title to display in filter
    public var title: String
    
    /// filter type
    public var filterType : ViFilterItemType {
        return .UNKNOWN
    }
    
    /// mapping to schema in Dashboard
    /// Refer to this link for more details: http://developers.visenze.com/setup/#Upload-your-datafeed
    public var schemaMapping: String
    
    /// Default constructor
    ///
    /// - Parameters:
    ///   - title: Filter to display to user in mobile app
    ///   - schemaMapping: Backend schema mapping
    public init(title: String, schemaMapping: String){
        self.title = title
        self.schemaMapping = schemaMapping
    }
    
    /// reset filter. To be implemented and overrided by subclass
    open func reset() {}
    
    // checking whether this filter is currently in Reset state
    open func isReset() -> Bool {
        return false
    }
    
    /// generate the fq (filter query) value for filtering for this item. Need to be overrided by subclass
    open func getFilterQueryValue() -> String {
        return ""
    }

    /// to be implemented by subclass
    /// soft clone the current object to keep filter configuration.
    open func clone() -> ViFilterItem{
        return self
    }

}

/// Filter category option similar to <select> in html
/// Option will be displayed to user while 'value' is sent to server for filtering. 'value' is compared against the schema
open class ViFilterItemCategoryOption : NSObject {
    
    /// Display filter category option e.g. specific brand for a "Brand" filter
    public var option: String
    
    /// Internal category value i.e. the actual value that will be compared against stored schema
    /// For example, 'option' is set to 'Jeans' while value in schema database is 'jean'
    public var value: String
    
    /// Constructor. Value will be set the same as option
    ///
    /// - Parameter option: Category name
    public init(option: String) {
        self.option = option
        self.value = option
    }
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - option: category name
    ///   - value: category actual value that will be sent to server
    public init(option: String , value: String) {
        self.option = option
        self.value = value
    }
}


/// The multiple selection category filter
open class ViFilterItemCategory : ViFilterItem {
    
    /// return the filter type i.e. category filter
    public override var filterType : ViFilterItemType {
        return .CATEGORY
    }
    
    /// all category options
    public var options : [ViFilterItemCategoryOption] = []
    
    /// selected catory options
    public var selectedOptions : [ViFilterItemCategoryOption] = []
    
    /// Constructor for category filter
    ///
    /// - Parameters:
    ///   - title: display category name e.g. brand
    ///   - schemaMapping: schema mapping for this category field
    ///   - options: The list of category options/values
    public convenience init(title: String, schemaMapping: String , options: [ViFilterItemCategoryOption]){
        self.init(title: title, schemaMapping: schemaMapping)
        self.options = options
    }
    
    
    /// Check if all options are selected. If user has not selected any options (the default) , this will return true
    ///
    /// - Returns: true if all options or none of the options is selected. False otherwise
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
    
    /// return comma separated string for selected options for display in UI
    open func getSelectedString() -> String {
        let arr : [String] = selectedOptions.map { $0.option }
        return arr.joined(separator: ", ")
    }
    
    /// reset this filter i.e. to "All"
    open override func reset() {
        self.selectedOptions.removeAll()
    }
    
    /// check if the filter is already reset
    ///
    /// - Returns: true if filter is reset
    open override func isReset() -> Bool {
        return self.isAllSelected()
    }
    
    /// Generate filter query value.
    /// See this for more details: http://developers.visenze.com/api/?shell#filtering-results
    ///
    /// - Returns: filter query value
    open override func getFilterQueryValue() -> String {
        if self.isReset() {
            let allArr : [String] = self.options.map { String(format: "\"%@\"", $0.value ) }
            
            return allArr.joined(separator: " OR ")
        }
        
        let arr : [String] = self.selectedOptions.map { String(format: "\"%@\"", $0.value ) }
        
        return arr.joined(separator: " OR ")
    }
    
    /// Clone filter item options.
    ///
    /// - Returns: new filter item
    open override func clone() -> ViFilterItem{
        let item = ViFilterItemCategory(title: self.title, schemaMapping: self.schemaMapping)
        
        item.options = self.options
        
        var cloneOptions : [ViFilterItemCategoryOption] = []
        for o in self.selectedOptions {
            cloneOptions.append(o)
        }
        item.selectedOptions = cloneOptions
        
        return item
    }

}


/// Range filter e.g. for filtering price range
open class ViFilterItemRange : ViFilterItem {
    
    /// minimum filter value
    public var min : Int = 0
    
    /// maximum filter value
    public var max : Int = 1000
    
    /// selected lower bound
    public var selectedLower : Int = 0
    
    /// selected upper bounds
    public var selectedUpper : Int = 1000
    
    /// return range filter type
    public override var filterType : ViFilterItemType {
        return .RANGE
    }
    
    /// Constructor for range filter. Selected lower/upper values will be set to min/max initially
    ///
    /// - Parameters:
    ///   - title: Display filter name
    ///   - schemaMapping: schema mapping
    ///   - min: minimum value
    ///   - max: maximum value
    public convenience init(title: String, schemaMapping: String , min: Int , max: Int){
        self.init(title: title, schemaMapping: schemaMapping)
        self.min = min
        self.max = max
        
        // something is wrong here, in this case, we set max to min
        if min > max {
             print("\(type(of: self)).\(#function)[line:\(#line)] - error: max value (\(max)) is smaller than min value (\(min)) ")
            
            self.max = min
        }
        
        self.selectedLower = self.min
        self.selectedUpper = self.max
    }
    
    /// reset this filter selection i.e. lower to min, upper to max
    open override func reset() {
        self.selectedLower = self.min
        self.selectedUpper = self.max
    }
    
    /// Check if this filter is reset
    ///
    /// - Returns: true if lower = min and upper = max
    open override func isReset() -> Bool {
        return (self.selectedLower == self.min) && (self.selectedUpper == self.max )
    }
    
    /// Generate filter query value.
    /// See this for more details: http://developers.visenze.com/api/?shell#filtering-results
    ///
    /// - Returns: filter query value
    open override func getFilterQueryValue() -> String {
        
        return String(format: "%d,%d", self.selectedLower, self.selectedUpper)
    }
    
    /// Clone filter item.
    ///
    /// - Returns: new filter item
    open override func clone() -> ViFilterItem{
        let item = ViFilterItemRange(title: self.title, schemaMapping: self.schemaMapping , min: self.min , max: self.max)
        item.selectedLower = self.selectedLower
        item.selectedUpper = self.selectedUpper
        return item
    }
}

