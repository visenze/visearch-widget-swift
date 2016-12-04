//
//  ViMultipartFormData.swift
//  ViSearchSDK
//
//  Created by Hung on 6/10/16.
//  Copyright © 2016 Hung. All rights reserved.
//

import Foundation

/// used to encode image data in form upload
open class ViMultipartFormData: NSObject {
    
    // MARK: - Helper Types and methods
    struct EncodingCharacters {
        static let crlf = "\r\n"
    }
    
    struct BoundaryGenerator {
        enum BoundaryType {
            case initial, encapsulated, final
        }
        
        static func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
            let boundaryText: String
            
            switch boundaryType {
            case .initial:
                boundaryText = "--\(boundary)\(EncodingCharacters.crlf)"
            case .encapsulated:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)\(EncodingCharacters.crlf)"
            case .final:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)--\(EncodingCharacters.crlf)"
            }
            
            return boundaryText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        }
    }
    
    
    /// Generate random boundary
    ///
    /// - returns: random boundary for use in form upload
    public static func randomBoundary() -> String {
        return String(format: "visearch.boundary.%08x%08x", arc4random(), arc4random())
    }
    
    /// assumption: imageData is of the type jpeg after we compress the image
    /// encode image data for uploading, add content headers
    public static func encode(imageData: Data? , boundary: String) -> Data {
        var encoded = Data()
        
        if imageData != nil {
            let initialData = BoundaryGenerator.boundaryData(forBoundaryType: .initial, boundary: boundary)
            encoded.append(initialData)
            
            let headers = contentHeaders(withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            let headerData = encodeHeaders(headers: headers)
            encoded.append(headerData)
            
            encoded.append(imageData!)
        }
        let finalBoundaryData = BoundaryGenerator.boundaryData(forBoundaryType: .final, boundary: boundary)
        encoded.append(finalBoundaryData)
        
        return encoded
    }
    
    // MARK: - Private - Body Part Encoding
    private static func encodeHeaders(headers: [String: String]) -> Data {
        var headerText = ""
        
        for (key, value) in headers {
            headerText += "\(key): \(value)\(EncodingCharacters.crlf)"
        }
        headerText += EncodingCharacters.crlf
        
        return headerText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }

    
    private static func contentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> [String: String] {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName {
            disposition += "; filename=\"\(fileName)\""
        }
        
        var headers = ["Content-Disposition": disposition]
        if let mimeType = mimeType {
            headers["Content-Type"] = mimeType
        }
        
        return headers
    }

    
}
