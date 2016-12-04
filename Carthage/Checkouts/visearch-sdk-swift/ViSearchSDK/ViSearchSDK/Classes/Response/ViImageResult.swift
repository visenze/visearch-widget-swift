import Foundation

/// images result in the "result" section of the response
/// See http://developers.visenze.com/api/?shell#search-responses for example
open class ViImageResult: NSObject {
    // MARK: properties
    public var im_name: String
    
    // store the image url, in the value_map, 
    /// may be unavailable in response unless you set getAllFl in request param to true or set 'fl' to include 'im_url'
    /// See http://developers.visenze.com/api/?shell#retrieving-metadata for details
    public var im_url : String?
    
    /// store the score if "score" is set to true in the request
    public var score  : Float?
    
    /// store the meta data in the value_map
    /// See http://developers.visenze.com/api/?shell#retrieving-metadata for details
    public var metadataDict: [String: Any]?
    
    public init?(_ im_name: String) {
        if im_name.isEmpty{
            print("\(type(of: self)).\(#function)[line:\(#line)] - error: im_name is missing")
            
            return nil
        }
        
        self.im_name = im_name
    }
    
}
