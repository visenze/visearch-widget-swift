//
//  AppDelegate.swift
//  WidgetsExample
//
//  Created by Hung on 21/10/16.
//  Copyright © 2016 Visenze. All rights reserved.
//

import UIKit
import ViSearchSDK
import ViSearchWidgets
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // TODO: please copy and add the ViApiKeys.plist to the project
        // after that fill in the access key and private key for this demo app
        if let path = Bundle.main.path(forResource: "ViApiKeys", ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: path)
        
            let appKey = dict!["accessKey"] as! String
            //let secret = dict!["secret"] as! String
            
//            print( "access key: \(accessKey), secret:\(secret)")
            
            // set up our search client
            
            // new & recommended way to setup ViSearch client with widget app key
            ViSearch.sharedInstance.setup(appKey: appKey)
            
            // old way of set up search client with access key and secret
//            ViSearch.sharedInstance.setup(accessKey: accessKey, secret: secret)
            
            // configure timeout example. default to 10s.
            ViSearch.sharedInstance.client?.timeoutInterval = 30
            ViSearch.sharedInstance.client?.sessionConfig.timeoutIntervalForRequest = 30
            ViSearch.sharedInstance.client?.sessionConfig.timeoutIntervalForResource = 30
            ViSearch.sharedInstance.client?.session = URLSession(configuration: (ViSearch.sharedInstance.client?.sessionConfig)!)
            
            // configure timeout for downloading if necessary, default is 15s
            KingfisherManager.shared.downloader.downloadTimeout = 30
        }
        else {
            print("Unable to load API keys plist. Please copy/add ViApiKeys.plist to the project and configure the API keys ")
        }
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    public static func loadSampleSchemaMappingFromPlist() -> ViProductSchemaMapping{
        var mapping = ViProductSchemaMapping()
        
        if let path = Bundle.main.path(forResource: "SampleData", ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: path)
            
            mapping.heading = dict!["heading_schema_mapping"] as? String
            mapping.label = dict!["label_schema_mapping"] as? String
            mapping.price = dict!["price_schema_mapping"] as? String
            mapping.discountPrice = dict!["discount_price_schema_mapping"] as? String
        }
        else {
            print("Unable to load SampleData keys plist. Please copy/add SampleData.plist to the project and configure the sample im_names ")
        }
        
        return mapping
    }
    
    public static func loadFilterItemsFromPlist() -> [ViFilterItem]{
        // filterItems
        var items : [ViFilterItem] = []
        
        if let path = Bundle.main.path(forResource: "SampleData", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                if let arr = dict["filterItems"] as? Array<Dictionary<String, Any>> {
                    
                    for d in arr {
                        let title = d["title"] as! String
                        let schemaMapping = d["schemaMapping"] as! String
                        let filterTypeRaw = d["filterType"] as! Int
                        
                        let filterType = ViFilterItemType(rawValue: filterTypeRaw)
                        if (filterType == ViFilterItemType.CATEGORY) {
                            let optionString = d["filterOptions"] as! String
                            let options = optionString.components(separatedBy: ",")
                            
                            var optionArr : [ViFilterItemCategoryOption] = []
                            
                            for o in options {
                                optionArr.append( ViFilterItemCategoryOption(option: o) )
                            }
                            
                            let item = ViFilterItemCategory(title: title, schemaMapping: schemaMapping, options: optionArr)
                            items.append(item)
                        }
                        else if (filterType == ViFilterItemType.RANGE) {
                            let min = d["min"] as! Int
                            let max = d["max"] as! Int
                            
                            let item = ViFilterItemRange(title: title, schemaMapping: schemaMapping, min: min, max: max)
                            items.append(item)
                        }
                        
                    }
                    
                }
            }
            
        }
        else {
            print("Unable to load SampleData keys plist. Please copy/add SampleData.plist to the project and configure the sample im_names ")
        }
        
        return items

    }

}

