//
//  ViSearchWidgetsTests.swift
//  ViSearchWidgetsTests
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import XCTest
import ViSearchSDK
@testable import ViSearchWidgets

class ViSearchWidgetsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSchemaMappingEmpty() {
        let mapping = ViProductSchemaMapping()
        let results: [ViImageResult] = []
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 0)
    }
    
    func testSchemaMappingImURLDefault() {
        let mapping = ViProductSchemaMapping()
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = sampleURL
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual(product.imageUrl?.absoluteString , sampleURL)
        
    }
    
    func testSchemaMappingURL() {
        var mapping = ViProductSchemaMapping()
        // custom mapping
        mapping.productUrl = "product_url"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual(product.imageUrl?.absoluteString , sampleURL)
        
    }
    
    func testSchemaInvalidMappingURL() {
        var mapping = ViProductSchemaMapping()
        // invalid mapping
        mapping.productUrl = "invalid"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 0)
        
    }
    
    func testSchemaMappingHeading() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.heading = "someheading"
        
        let headingValue = "hello"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "someheading" : headingValue]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual(product.heading , headingValue)
        
    }
    
    func testSchemaMappingInvalidHeading() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.heading = "invalidMap"
        
        let headingValue = "hello"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "someheading" : headingValue]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertNil(product.heading )
        
    }
    
    func testSchemaMappingLabel() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.label = "somelabel"
        
        let labelVal = "hello"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "somelabel" : labelVal]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual(product.label , labelVal)
        
    }

    func testSchemaMappingInvalidLabel() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.label = "invalidlabel"
        
        let labelVal = "hello"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "somelabel" : labelVal]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertNil(product.label )
        
    }
    
    func testSchemaMappingPrice() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.price = "prodPrice"
        
        let price = 3.2
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual(product.price , Float(price) )
        
    }

    func testSchemaMappingPriceString() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.price = "prodPrice"
        
        let price = "3.2"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual(product.price , Float(price) )
        
    }
    
    func testSchemaMappingInvalidPriceString() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.price = "prodPrice"
        
        let price = "ab123"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertNil(product.price )
        
    }
    
    func testSchemaMappingInvalidPriceMapping() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.price = "invalid"
        
        let price = "3.2"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertNil(product.price )
        
    }
    
    func testSchemaMappingInvalidDiscountPriceMapping() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.discountPrice = "invalid"
        
        let price = "3.2"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertNil(product.discountPrice )
        
    }
    
    func testSchemaMappingInvalidDiscountPriceString() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.discountPrice = "prodPrice"
        
        let price = "ab123"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertNil(product.discountPrice )
        
    }
    
    func testSchemaMappingDiscountPriceString() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.discountPrice = "prodPrice"
        
        let price = "3.22"
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual(product.discountPrice , Float(price) )
        
    }
    
    func testSchemaMappingDiscountPrice() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.discountPrice = "prodPrice"
        
        let price = 3.22
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual(product.discountPrice , Float(price) )
        
    }
    
    func testSchemaMappingMetaDict() {
        var mapping = ViProductSchemaMapping()
        
        // custom mapping
        mapping.productUrl = "product_url"
        mapping.discountPrice = "prodPrice"
        
        let price = 3.22
        
        let sampleURL = "http://abc.com/sample.png"
        
        var results: [ViImageResult] = []
        
        let result1 = ViImageResult("abc")
        result1?.im_url = "http://abc.com/haha.png"
        result1?.metadataDict = ["product_url" : sampleURL , "prodPrice" : price , "a" : 1 , "b" : "c" ]
        results.append(result1!)
        
        let products = ViSchemaHelper.parseProducts(mapping: mapping, imageResults: results)
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 1)
        
        let product = products[0]
        XCTAssertEqual( result1?.metadataDict?.description ,  product.metadataDict?.description )
        
    }



    
    
}
