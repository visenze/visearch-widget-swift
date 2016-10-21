import Foundation

/// Construct search parameters request for Find Similar, You May Also Like APIs
public class ViSearchParams: ViBaseSearchParams {
    public var imName: String
    
    public init?(imName: String){
        self.imName = imName
        
        if imName.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: imName is missing")
            
            return nil
        }
    }
    
    public override func toDict() -> [String: Any] {
        var dict = super.toDict()
        dict["im_name"] = imName
        return dict;
    }
}
