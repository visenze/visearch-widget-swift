import Foundation

public class UidHelper: NSObject {
    
    
    /// Internal key for storing search uid
    static let ViSearchUidKey = "visearch_uid"
    
    /// retrieve unique device uid and store into userDefaults
    /// this is needed for tracking API to identify various actions
    ///
    /// - returns: unique device uid
    public static func uniqueDeviceUid() -> String {
        let storeUid = SettingHelper.getStringSettingProp(propName: ViSearchUidKey)
        
        if storeUid == nil || storeUid?.characters.count == 0 {
            let deviceId = UIDevice.current.identifierForVendor?.uuidString ;
            
            // store in the setting
            SettingHelper.setSettingProp(propName: ViSearchUidKey, newValue: deviceId!)
            
            return deviceId!
        }
        
        return storeUid!
    }
    
    
    /// Force update the device uid and store in setting
    ///
    /// - parameter newUid: new device uid
    public static func updateStoreDeviceUid(newUid: String) -> Void {
        SettingHelper.setSettingProp(propName: ViSearchUidKey, newValue: newUid)
    }
}
