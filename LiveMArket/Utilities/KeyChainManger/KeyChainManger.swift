//
//  KeyChainManger.swift
//
//  Created by Muneeb on 12/08/2021.
//

import Foundation
import KeychainAccess

enum KeyChainAccessIdenetifiers {
    static let accessGroupIdenetifier = "in.enmovil.BuildMart"
    static let appleSignEmailKey = "appleSignInEmail"
    static let appleUserNameKey = "appleUserName"
    static let appleTokenKey = "appleToken"
    static let appleUserIDKey = "appleUserID"
}

protocol KeyChainAccessParam {
    var appleSignInData: AppleSignInData? { get set }
    var keychain: Keychain? { get set }
}

class KeyChainManger: KeyChainAccessParam {
    var appleSignInData: AppleSignInData?
    var keychain: Keychain?
    
    func saveAppleSignInDataToKeyChain(appleSignInData: AppleSignInData) {
        self.appleSignInData = appleSignInData
        keychain = Keychain(service: KeyChainAccessIdenetifiers.accessGroupIdenetifier)
        keychain?[KeyChainAccessIdenetifiers.appleSignEmailKey] = self.appleSignInData?.email
        keychain?[KeyChainAccessIdenetifiers.appleUserNameKey] = self.appleSignInData?.userName
        keychain?[KeyChainAccessIdenetifiers.appleTokenKey] = self.appleSignInData?.token
        keychain?[KeyChainAccessIdenetifiers.appleUserIDKey] = self.appleSignInData?.userID
    }
    
    func getApplSignInDataFromKeyChain() -> AppleSignInData? {
        keychain = Keychain(service: KeyChainAccessIdenetifiers.accessGroupIdenetifier)
        guard let email = keychain?[KeyChainAccessIdenetifiers.appleSignEmailKey] else {
            
            return nil
        }
        guard  let fullName = keychain?[KeyChainAccessIdenetifiers.appleUserNameKey] else {
            return nil
        }
        guard let token = keychain?[KeyChainAccessIdenetifiers.appleTokenKey] else {
            return nil
        }
        guard let userId = keychain?[KeyChainAccessIdenetifiers.appleUserIDKey] else {
            return nil
        }
        appleSignInData = AppleSignInData(token: token, userID: userId, userName: fullName, email: email)
        return appleSignInData!
    }
    
    func stopUsingAppleID() {
        let msgString = "Failed to sign in with apple"
        Utilities.showWarningAlert(message: msgString) {
           // AppConfiguration.canOpenSettings()
        }
    }
}


// MARK: - Clear AppKey Chain
extension KeyChainManger {
    func resetKeyChain() {
        keychain = Keychain(service: KeyChainAccessIdenetifiers.accessGroupIdenetifier)
        try! keychain?.removeAll()
    }
}
