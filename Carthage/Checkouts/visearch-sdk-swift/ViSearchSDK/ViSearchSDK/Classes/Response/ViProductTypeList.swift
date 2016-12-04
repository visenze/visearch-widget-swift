import Foundation

/// Store supported product types in automatic object recognition feature
open class ViProductTypeList: NSObject {
    public var type  : String
    public var attributes_list : [String: Any] = [:]
    
    public init(type: String) {
        self.type = type
    }
}
