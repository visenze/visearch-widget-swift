import Foundation

/// Tracking parameters
public class ViTrackParams : ViSearchParamsProtocol{

    //MARK: properties
    public var action : String
    public var imName : String?
    public var reqId  : String
    public var cuid   : String?
    var cid    : String?
    
    /// Init tracking parameters. For example, after user search for images, we want to track which image they clicked
    ///
    /// - parameter accessKey: API access key
    /// - parameter reqId: recent request id e.g. search for similar images
    /// - parameter action: tracking action e.g. click, add to cart, etc. Currently only click is supported
    public convenience init?(accessKey: String, reqId : String , action: String ) {
        
        if accessKey.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: accessKey parameter is missing")
            
            return nil
        }
        
        self.init(reqId: reqId, action: action)
        
        self.cid = accessKey
        self.cuid = nil
        self.imName = nil
    }
    
    /// Init tracking parameters. For example, after user search for images, we want to track which image they clicked
    /// Assumption: access key will be passed by client later
    /// - parameter reqId: recent request id e.g. search for similar images
    /// - parameter action: tracking action e.g. click, add to cart, etc. Currently only click is supported
    public init?(reqId : String , action: String){
        if reqId.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: reqId parameter is missing")
            return nil
        }
        
        if action.isEmpty {
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: action parameter is missing")
            return nil
        }

        self.reqId = reqId
        self.action = action
    }
    
    //MARK: search protocol
    public func toDict() -> [String: Any] {
        var dict : [String:Any] = [:]
        dict["action"] = action
        dict["reqid"] = reqId
        dict["cid"] = cid
        
        if imName != nil {
            dict["im_name"] = imName
        }
        if cuid != nil {
            dict["cuid"] = cuid
        }
        return dict ;
        
    }
    
}
