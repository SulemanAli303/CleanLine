//
//  AppleSignInManager.swift
//
//  Created by Muneeb on 28/08/2021.
//

import Foundation
import AuthenticationServices

protocol  AppleSignInDataProviadable {
    var token: String { get set }
    var userID: String { get set }
    var userName: String { get set }
    var email: String { get set }
}

protocol  AppleAuthorization: AnyObject {
    func didAuthorizedWithAppleSuccessfully(appleData: AppleSignInData)
    func didFailToAuthorizeWithApple(errorString: String)
}

struct AppleSignInData: AppleSignInDataProviadable {
    var token: String
    var userID: String
    var userName: String
    var email: String
}

@available(iOS 13.0, *)
class AppleSignInManager: NSObject {
    
    static let shared = AppleSignInManager()
    var appleEmail: String?
    weak var appleSignInDelegate: AppleAuthorization?
}

// MARK: - AppleSignIn ActionListener
@available(iOS 13.0, *)
extension AppleSignInManager {
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

// MARK: - AppleSign ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension AppleSignInManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let givenName = appleIDCredential.fullName?.givenName
            let familyName = appleIDCredential.fullName?.familyName
            let fullName = "\(givenName ?? "") \(familyName ?? "")"
            let email = appleIDCredential.email
            let token = String(data: appleIDCredential.identityToken!, encoding: .utf8)
            let userID = appleIDCredential.user
            appleEmail = email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            var appleSignInData = AppleSignInData(token: token!, userID: userID, userName: String(describing: fullName), email: email ?? "")
            guard let data = saveDataToKeyChain(appleData: appleSignInData) else {
                print("Failed for existing users")
                return
            }
            appleSignInData = data
            print(appleSignInData)
            appleSignInDelegate?.didAuthorizedWithAppleSuccessfully(appleData: appleSignInData)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        appleSignInDelegate?.didFailToAuthorizeWithApple(errorString: error.localizedDescription)
    }
}

@available(iOS 13.0, *)
extension AppleSignInManager {
    
    private func saveDataToKeyChain(appleData: AppleSignInData) -> AppleSignInData? {
        var appleKeyChainData: AppleSignInData? = appleData
        let keychainManger = KeyChainManger()
        if let _ = self.appleEmail {
            keychainManger.saveAppleSignInDataToKeyChain(appleSignInData: appleKeyChainData!)
        } else {
            if let signInData = keychainManger.getApplSignInDataFromKeyChain() {
                appleKeyChainData = signInData
            } else {
                appleKeyChainData = nil
                keychainManger.stopUsingAppleID()
            }
        }
        return appleKeyChainData
    }
}
