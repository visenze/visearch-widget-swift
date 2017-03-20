import Foundation

public enum ViHttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public enum ViAPIEndPoints: String {
    case COLOR_SEARCH  = "colorsearch"
    case ID_SEARCH     = "search"
    case UPLOAD_SEARCH = "uploadsearch"
    case REC_SEARCH    = "recommendation"
    case TRACK         = "__aq.gif"
}

/// Search client
open class ViSearchClient: NSObject, URLSessionDelegate {
    
    public static let VISENZE_URL = "https://visearch.visenze.com"
    public static let VISENZE_TRACK_URL = "https://track.visenze.com"
    
    public typealias SuccessHandler = (ViResponseData?) -> ()
    public typealias FailureHandler = (Error) -> ()
    
    // MARK: properties
    
    // if isAppKeyEnabled is true, this refers to the appKey. If fail it is accessKey and meant to be used with secret
    public var accessKey : String
    
    // with the new authentication, this would be optional
    public var secret    : String = ""
    public var baseUrl   : String
    public var trackUrl  : String
    
    public var session: URLSession
    public var sessionConfig: URLSessionConfiguration
//    private var uploadSession: URLSession?

    public var timeoutInterval : TimeInterval = 10 // how long to timeout request
    public var requestSerialization: ViRequestSerialization
    
    public var userAgent : String = "visearch-swift-sdk/1.2.1"
    private static let userAgentHeader : String = "X-Requested-With"
    
    // whether to authenticate by appkey or by access/secret key point
    public var isAppKeyEnabled : Bool = true
    
 
    // MARK: constructors
    public init?(baseUrl: String, accessKey: String , secret: String) {
        
        if baseUrl.isEmpty {
            return nil;
        }
        
        if accessKey.isEmpty {
            return nil;
        }
        
        if secret.isEmpty {
            return nil;
        }
        
        self.baseUrl = baseUrl
        self.accessKey = accessKey
        self.secret = secret
        self.isAppKeyEnabled = false
        
        self.requestSerialization = ViRequestSerialization()
        
        // config default session
        sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = timeoutInterval
        sessionConfig.timeoutIntervalForResource = timeoutInterval
        
        // Configuring caching behavior for the default session
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheURL = cachesDirectoryURL.appendingPathComponent("viSearchCache")
        let diskPath = cacheURL.path
        
        let cache = URLCache(memoryCapacity:16384, diskCapacity: 268435456, diskPath: diskPath)
        sessionConfig.urlCache = cache
        sessionConfig.requestCachePolicy = .useProtocolCachePolicy
        
        // base 64 authentication
        sessionConfig.httpAdditionalHeaders = ["Authorization" : requestSerialization.getBasicAuthenticationString(accessKey: accessKey, secret: secret)]
        
        session = URLSession(configuration: sessionConfig)
        
        self.trackUrl = ViSearchClient.VISENZE_TRACK_URL
        
    }
    
    public init?(baseUrl: String, appKey: String ) {
        
        if baseUrl.isEmpty {
            return nil;
        }
        
        if appKey.isEmpty {
            return nil;
        }
        
        self.baseUrl = baseUrl
        self.accessKey = appKey
        self.secret = ""
        self.isAppKeyEnabled = true
        
        self.requestSerialization = ViRequestSerialization()
        
        // config default session
        sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = timeoutInterval
        sessionConfig.timeoutIntervalForResource = timeoutInterval
        
        // Configuring caching behavior for the default session
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheURL = cachesDirectoryURL.appendingPathComponent("viSearchCache")
        let diskPath = cacheURL.path
        
        let cache = URLCache(memoryCapacity:16384, diskCapacity: 268435456, diskPath: diskPath)
        sessionConfig.urlCache = cache
        sessionConfig.requestCachePolicy = .useProtocolCachePolicy
        
        session = URLSession(configuration: sessionConfig)
        
        self.trackUrl = ViSearchClient.VISENZE_TRACK_URL
        
    }

    
    public convenience init?(accessKey: String , secret: String)
    {
        self.init( baseUrl: ViSearchClient.VISENZE_URL , accessKey: accessKey, secret: secret)
    }
    
    public convenience init?(appKey: String)
    {
        self.init( baseUrl: ViSearchClient.VISENZE_URL , appKey: appKey)
    }
    
    // MARK: Visenze APIs
    @discardableResult public func uploadSearch(params: ViUploadSearchParams,
                             successHandler: @escaping SuccessHandler,
                             failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        var url : String? = nil
        
        // NOTE: image must be first line before generating of url
        // url box parameters depend on whether the compress image is generated
        let imageData: Data? = params.generateCompressImageForUpload()
        
        if self.isAppKeyEnabled {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: .UPLOAD_SEARCH , searchParams: params, appKey: self.accessKey)
        }
        else {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: .UPLOAD_SEARCH , searchParams: params)
            
        }
        
        let request = NSMutableURLRequest(url: URL(string: url!)! , cachePolicy: .useProtocolCachePolicy , timeoutInterval: timeoutInterval)
        
        let boundary = ViMultipartFormData.randomBoundary()
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = ViMultipartFormData.encode(imageData: imageData, boundary: boundary);
        
        // make tracking call to record the action
        return httpPost(request: request,
                       successHandler: {
                        (data: ViResponseData?) -> Void in
                        
                        if let resData = data {
                            if let reqId = resData.reqId {
                                let params = ViTrackParams(accessKey: self.accessKey, reqId: reqId, action: ViAPIEndPoints.UPLOAD_SEARCH.rawValue )
                                self.track(params: params!, handler: nil)
                            }
                        }
                        
                        successHandler(data)
            },
                       failureHandler: failureHandler )
    }
    
    @discardableResult public func colorSearch(params: ViColorSearchParams,
                            successHandler: @escaping SuccessHandler,
                            failureHandler: @escaping FailureHandler
                            ) -> URLSessionTask
    {
        return makeGetApiRequest(params: params, apiEndPoint: .COLOR_SEARCH, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    @discardableResult public func findSimilar(params: ViSearchParams,
                            successHandler: @escaping SuccessHandler,
                            failureHandler: @escaping FailureHandler
        ) -> URLSessionTask
    {
        return makeGetApiRequest(params: params, apiEndPoint: .ID_SEARCH, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    @discardableResult public func recommendation(params: ViSearchParams,
                            successHandler: @escaping SuccessHandler,
                            failureHandler: @escaping FailureHandler
        ) -> URLSessionTask
    {
        return makeGetApiRequest(params: params, apiEndPoint: .REC_SEARCH, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    // track the API calls and various actions
    @discardableResult public func track(params: ViTrackParams,
                      handler:  ( (_ success: Bool, Error?) -> Void )?
                      ) -> Void {
        
        params.cid = accessKey
        
        // different url for tracking
        let url = requestSerialization.generateRequestUrl(baseUrl: trackUrl , apiEndPoint: .TRACK , searchParams: params)
        let request = NSMutableURLRequest(url: URL(string: url)! , cachePolicy: .useProtocolCachePolicy , timeoutInterval: timeoutInterval)
        
        let deviceUid = UidHelper.uniqueDeviceUid()
        request.addValue("uid=\(deviceUid)", forHTTPHeaderField: "Cookie")
        request.addValue(getUserAgentValue() , forHTTPHeaderField: ViSearchClient.userAgentHeader )
        
        session.dataTask(with: request as URLRequest, completionHandler:{
            (data, response, error) in
            if handler != nil {
                let hasError = (error == nil)
                handler!( hasError ,  error )
            }
        }).resume()
    }
    
    // MARK: http requests internal
    
    // make API call and also send a tracking request immediately if successful
    private func makeGetApiRequest(params: ViBaseSearchParams,
                                   apiEndPoint: ViAPIEndPoints,
                                   successHandler: @escaping SuccessHandler,
                                   failureHandler: @escaping FailureHandler
        ) -> URLSessionTask{
        
        var url : String? = nil
        if self.isAppKeyEnabled {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: apiEndPoint , searchParams: params, appKey: self.accessKey)
        }
        else {
            url = requestSerialization.generateRequestUrl(baseUrl: baseUrl, apiEndPoint: apiEndPoint , searchParams: params)
            
        }
        
        let request = NSMutableURLRequest(url: URL(string: url!)! , cachePolicy: .useProtocolCachePolicy , timeoutInterval: timeoutInterval)
        
        // make tracking call to record the action 
        return httpGet(request: request,
                       successHandler: {
                             (data: ViResponseData?) -> Void in
                        
                               if let resData = data {
                                  if let reqId = resData.reqId {
                                    let params = ViTrackParams(accessKey: self.accessKey, reqId: reqId, action: apiEndPoint.rawValue )
                                    self.track(params: params!, handler: nil)
                                  }
                               }
                        
                               successHandler(data)
                       },
                       failureHandler: failureHandler )
        
    }
    
    private func httpGet(request: NSMutableURLRequest,
                         successHandler: @escaping SuccessHandler,
                         failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        return httpRequest(method: ViHttpMethod.GET, request: request, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    private func httpPost(request: NSMutableURLRequest,
                         successHandler: @escaping SuccessHandler,
                         failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        return httpRequest(method: ViHttpMethod.POST, request: request, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    private func httpRequest(method: ViHttpMethod,
                             request: NSMutableURLRequest,
                             successHandler: @escaping SuccessHandler,
                             failureHandler: @escaping FailureHandler) -> URLSessionTask {
        
        request.httpMethod = method.rawValue
        let task = createSessionTaskWithRequest(request: request, successHandler: successHandler, failureHandler: failureHandler)
        task.resume()
        
        return task
    }
    
    /**
     *  create data task session for request
     *
     *  @param URLRequest   request
     *  @param SuccessHandler success handler closure
     *  @param FailureHandler failure handler closure
     *
     *  @return session task
     */
    private func createSessionTaskWithRequest(request: NSMutableURLRequest,
                                              successHandler: @escaping SuccessHandler,
                                              failureHandler: @escaping FailureHandler) -> URLSessionTask
    {
        request.addValue(getUserAgentValue() , forHTTPHeaderField: ViSearchClient.userAgentHeader )
        
        let task = session.dataTask(with: request as URLRequest , completionHandler:{
            (data, response, error) in
            if (error != nil) {
                failureHandler(error!)
            }
            else {
                if response == nil || data == nil {
                    successHandler(nil)
                }
                else{
                    let responseData = ViResponseData(response: response!, data: data!)
                    successHandler(responseData)
                }
            }
        })
        
        return task
    }
    
    private func getUserAgentValue() -> String{
        return userAgent ;
    }
    
    
}
