//
//  KeychainHelper.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 19/1/21.
//

import KeychainAccess

class KeychainHelper {
    static let shared = KeychainHelper(keychain: Keychain(service: "dnKey"))
    private var keychain: Keychain
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    var currentUserData: Data? {
        get {
            return keychain[data: #function]
        }
        
        set {
            keychain[data: #function] = newValue
        }
    }
}
