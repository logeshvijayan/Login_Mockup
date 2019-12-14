//
//  KeyChainModel.swift
//  Login Model
//
//  Created by logesh on 12/13/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import Foundation
import Security

// MARK: Security Constatns
struct KeychainConstants {
    static var accessGroup: String { return toString(kSecAttrAccessGroup) }
    static var accessible: String { return toString(kSecAttrAccessible) }
    static var attrAccount: String { return toString(kSecAttrAccount) }
    static var attrSynchronizable: String { return toString(kSecAttrSynchronizable) }
    static var klass: String { return toString(kSecClass) }
    static var matchLimit: String { return toString(kSecMatchLimit) }
    static var returnData: String { return toString(kSecReturnData) }
    static var valueData: String { return toString(kSecValueData) }
    static func toString(_ value: CFString) -> String {
        return value as String
    }
}

//  MARK: - Keychain Access Options
enum KeychainAccessOptions {
    case accessibleWhenUnlocked
    case accessibleWhenUnlockedThisDeviceOnly
    case accessibleAfterFirstUnlock
    case accessibleAfterFirstUnlockThisDeviceOnly
    case accessibleAlways
    case accessibleWhenPasscodeSetThisDeviceOnly
    case accessibleAlwaysThisDeviceOnly
    
    static var defaultOption: KeychainAccessOptions {
        return .accessibleWhenUnlocked
}

var value: String {
    switch self {
    case .accessibleWhenUnlocked:
        return toString(kSecAttrAccessibleWhenUnlocked)

    case .accessibleWhenUnlockedThisDeviceOnly:
        return toString(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)

    case .accessibleAfterFirstUnlock:
        return toString(kSecAttrAccessibleAfterFirstUnlock)

    case .accessibleAfterFirstUnlockThisDeviceOnly:
        return toString(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)

    case .accessibleAlways:
        return toString(kSecAttrAccessibleAlways)

    case .accessibleWhenPasscodeSetThisDeviceOnly:
        return toString(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)

    case .accessibleAlwaysThisDeviceOnly:
        return toString(kSecAttrAccessibleAlwaysThisDeviceOnly)
    }
}
    
}

func toString(_ value: CFString) -> String {
    return KeychainConstants.toString(value)
}

//  MARK: - Class
class KeyChainModel  {
    
    //  MARK: - Local Variables
    static let shared = KeyChainModel()
    var lastResultCode : OSStatus = 0
    fileprivate var keyPrefix:String = "LM"
    var lastQueryParameters: [String: AnyObject]?
    var accessGroup: String?
    
    //MARK: - Helper Functions
    func toString(_ value: CFString) -> String {
        return KeychainConstants.toString(value)
    }
    
    func keyWithPrefix(_ key: String) -> String {
        return "\(keyPrefix)\(key)"
    }
    
    func addAccessGroupWhenPresent(_ items: [String: Any]) -> [String: Any] {
        guard let accessGroup = accessGroup else { return items }
        
        var result: [String: Any] = items
        result[KeychainConstants.accessGroup] = accessGroup
        return result
    }
    
    
//  MARK: - Keychain Methods
    func clear() -> Bool {
        var query: [String: AnyObject] = [ kSecClass as String : kSecClassGenericPassword ]
        query = addAccessGroupWhenPresent(query) as [String : AnyObject]
        self.lastQueryParameters = query
        lastResultCode = SecItemDelete(query as CFDictionary)
        return lastResultCode == noErr
    }
    
    func set(_ value: String, forKey key: String,
             withAccess access: KeychainAccessOptions? = nil) -> Bool {
        
        if let value = value.data(using: String.Encoding.utf8) {
            return set(value, forKey: key, withAccess: access)
        }
        return false
    }
    
    func set(_ value: Data, forKey key: String,
             withAccess access: KeychainAccessOptions? = nil) -> Bool {
        
        _ = delete(key)
       let accessible = access?.value ?? KeychainAccessOptions.defaultOption.value
        let prefixedKey = keyWithPrefix(key)
        var query: [String : AnyObject] = [
            KeychainConstants.klass       : kSecClassGenericPassword,
            KeychainConstants.attrAccount : prefixedKey as AnyObject,
            KeychainConstants.valueData   : value as AnyObject,
            KeychainConstants.accessible  : accessible as AnyObject
        ]
        query = addAccessGroupWhenPresent(query) as [String : AnyObject]
        lastQueryParameters = query
        lastResultCode = SecItemAdd(query as CFDictionary, nil)
         print(lastResultCode)
        return lastResultCode == noErr
    }
    
    func delete(_ key: String) -> Bool {
        let prefixedKey = keyWithPrefix(key)
        var query: [String: AnyObject] = [
            KeychainConstants.klass       : kSecClassGenericPassword,
            KeychainConstants.attrAccount : prefixedKey as AnyObject
        ]
        
        query = addAccessGroupWhenPresent(query) as [String : AnyObject]
        lastQueryParameters = query
        lastResultCode = SecItemDelete(query as CFDictionary)
        return lastResultCode == noErr
    }
    
    
    func get(_ key: String) -> String? {
        if let data = getData(key) {
            if let currentString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
                return currentString
            }
            lastResultCode = -67853 // errSecInvalidEncoding
        }
        return nil
    }
    
    func getData(_ key: String) -> Data? {
        let prefixedKey = keyWithPrefix(key)
        
        var query: [String: AnyObject] = [
            KeychainConstants.klass       : kSecClassGenericPassword,
            KeychainConstants.attrAccount : prefixedKey as AnyObject,
            KeychainConstants.returnData  : kCFBooleanTrue,
            KeychainConstants.matchLimit  : kSecMatchLimitOne
        ]
        
        query = addAccessGroupWhenPresent(query) as [String : AnyObject]
        lastQueryParameters = query
        
        var result: AnyObject?
        lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if lastResultCode == noErr { return result as? Data }
        return nil
    }
    
  //  MARK: - App Functionality
    
    func saveUserCredentials (userName : String,password : String)
    {
        self.set(password, forKey: userName)
        print(self.get(userName))
       
    }
    
 
}
