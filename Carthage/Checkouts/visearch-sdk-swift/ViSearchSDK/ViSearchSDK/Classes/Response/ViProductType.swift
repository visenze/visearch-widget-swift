import Foundation

/// product type result for automatic object recognition feature
open class ViProductType: NSObject {
    public var box   : ViBox
    public var score : Float
    public var type  : String
    public var attributes : [String: Any] = [:]
    
    public init(box: ViBox, score: Float, type: String) {
        self.box = box
        self.score = score
        self.type = type
    }
}
