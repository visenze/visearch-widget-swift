import Foundation


/// Configure selection box for uploaded image if necessary
/// See http://developers.visenze.com/api/?shell#selection-box
public struct ViBox {
    public var x1 : Int;
    public var x2 : Int;
    public var y1 : Int;
    public var y2 : Int;
    
    
    public init( x1: Int, y1: Int, x2: Int, y2: Int  ){
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
    }
    
}
