import Foundation


/// Protocol to generate dictionary for query parameters (in the URL)
public protocol ViSearchParamsProtocol{
    
    
    /// Generate dictionary of parameters for query string use in ViSearch APIs
    /// Reference: http://developers.visenze.com/api/?shell#advanced-parameters
    ///
    /// - returns: dictionary
    func toDict() -> [String: Any]
}



/// Base class for constructing Search API requests
/// This was not meant to be used directly. 
/// See http://developers.visenze.com/api/?shell#advanced-parameters for more details on various parameters
open class ViBaseSearchParams : ViSearchParamsProtocol {

    // MARK: properties
    
    
    /// The number of results returned per page. The maximum number of results returned from the API is 100
    /// Default to 10
    public var limit : Int = 10
    
    /// The result page number.
    public var page  : Int = 1
    
    /// If the value is true, the score for each image result will be included in the response.
    public var score : Bool = false
    
    /// The metadata fields to filter the results. Only fields marked with ‘searchable’ in ViSearch Dashboard can be used as filters. 
    /// If the filter field is not in data schema, it will be ignored.
    public var fq    : [String:String] = [:]
    
    /// The metadata fields to be returned. If the query value is not in data schema, it will be ignored.
    public var fl    : [String] = []
    
    /// If true, query information will be returned.
    public var queryInfo : Bool = false
    
    /// Sets the minimum score threshold for the search. 
    /// The value must be between 0.0 to 1.0 inclusively, or an error will be returned. Default value is 0.0.
    public var scoreMin : Float = 0
    
    /// Sets the maximum score threshold for the search. 
    /// The value must be between 0.0 to 1.0 inclusively, or an error will be returned. Default value is 1.0
    public var scoreMax : Float = 1
    
    /// To retrieve all metadata of your image results, specify get_all_fl parameter and set it to true.
    public var getAllFl : Bool = false
    
    /// See http://developers.visenze.com/api/?shell#automatic-object-recognition-beta
    /// Used for automatic object recognition
    public var detection : String? = nil
    
    /// List of fields to enable faceting
    public var facets    : [String] = []
    
    /// Limit of the number of facet values to be returned. Only for non-numerical fields
    public var facetsLimit : Int = 10
    
    /// whether to show the facets count in the response.
    public var facetShowCount : Bool = false
    
    // MARK: search protocol
    public func toDict() -> [String: Any] {
        var dict : [String:Any] = [:]
        
        if limit > 0 {
            dict["limit"] = String(limit)
        }
        
        if page > 0 {
            dict["page"] = String(page)
        }
      
        dict["score"] = score ? "true" : "false"
        
        dict["score_max"] = String(format: "%f", scoreMax);
        dict["score_min"] = String(format: "%f", scoreMin);
        
        dict["get_all_fl"] = (getAllFl ? "true" : "false" )
        
        if (detection != nil) {
            dict["detection"] = detection!
        }
        
        if queryInfo {
            dict["qinfo"] = "true"
        }
        
        if fq.count > 0 {
            var arr : [String] = []
            for ( key, val) in fq {
                let s = "\(key):\(val)"
                arr.append(s)
            }
            
            dict["fq"] = arr
        }
        
        if fl.count > 0 {
            dict["fl"] = fl
        }
        
        if facets.count > 0 {
            dict["facets"] = self.facets
            dict["facets_limit"] = self.facetsLimit
            dict["facets_show_count"] = self.facetShowCount ? "true" : "false"
        }
        
        return dict ;
        
    }
    
}
