import Foundation

// store settings
public class SettingHelper {
    
    
    /// Set a property , store in userDefault
    ///
    /// - parameter propName: property name
    /// - parameter newValue: new value for property
    public static func setSettingProp(propName: String , newValue: Any?) -> Void {
        let userDefault = UserDefaults.standard
        userDefault.set(newValue, forKey: propName)
        // this will be deprecated in future
//        userDefault.synchronize()
    }
    
    
    /// retrieve setting in userdefault as String
    ///
    /// - parameter propName: name of property
    ///
    /// - returns: value as String?
    public static func getStringSettingProp (propName: String) -> String? {
        let userDefault = UserDefaults.standard
        return userDefault.string(forKey: propName)
    }
}
