//
//  AuthenticationAPIManager.swift
//  Maharani
//
//  Created by Albin Jose on 12/01/22.
//

import Foundation
import Alamofire


class AuthenticationAPIManager {
    //// login
    struct LoginConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/login"
    }
    
    public class func loginAPI(parameters: [String: String], completionHandler : @escaping(_ result: Authentication_Base) -> Void) {
        var config = LoginConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Authentication_Base.self, from: json)
                switch response.status {
                case "1":
                    guard var dict = result?["oData"] as? [String:Any] else { return }
                    guard var dict2 = dict["user"] as? [String:Any] else { return }
                    dict2["access_token"] = response.oData?.token ?? ""
                    SessionManager.setUserData(dictionary: dict2)
                    UserDefaults.standard.set(nil, forKey: "googleImage")
                default:
                    break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// Individual SignUp
    struct SignUpIndConfig : UploadAPIConfiguration {
        var documents: [String : [UploadMedia?]]
        var uploadImages: [BBMedia]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/create-account"
    }
    class func signupIndividualAPI(images:[String : [UIImage?]],parameters: [String: String], completionHandler: @escaping(_ result: Authentication_Base) -> Void) {
        var config = SignUpIndConfig(
            documents: [:], uploadImages: [],
            images : images
        )
        config.parameters = parameters
        APIClient.multiPartRequestV2(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Authentication_Base.self, from: json)
                switch response.status {
                case "1":
                    guard var dict = result?["oData"] as? [String:Any] else { return }
                    guard var dict2 = dict["user"] as? [String:Any] else { return }
                    dict2["access_token"] = response.oData?.token ?? ""
                    SessionManager.setUserData(dictionary: dict2)
                    UserDefaults.standard.set(nil, forKey: "googleImage")
                default:
                    break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    struct SignUpIndConfigConfirm : UploadAPIConfiguration {
        var documents: [String : [UploadMedia?]]
        var uploadImages: [BBMedia]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/register-confirm"
    }
    class func signupAPIConfirmRegister(images:[String : [UIImage?]],parameters: [String: String], completionHandler: @escaping(_ result: Authentication_Base) -> Void) {
        var config = SignUpIndConfigConfirm(
            documents: [:], uploadImages: [],
            images : images
        )
        config.parameters = parameters
        APIClient.multiPartRequestV2(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Authentication_Base.self, from: json)
                switch response.status {
                case "1":
                    guard var dict = result?["oData"] as? [String:Any] else { return }
                    guard var dict2 = dict["user"] as? [String:Any] else { return }
                    dict2["access_token"] = response.oData?.token ?? ""
                    SessionManager.setUserData(dictionary: dict2)
                    UserDefaults.standard.set(nil, forKey: "googleImage")
                default:
                    break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// add bank Account
    struct BankAccountConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add-bank-details"
    }
    
    public class func bankAccountAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = BankAccountConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    public class func bankAccountAPIV2(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = BankAccountConfig()
        config.parameters = parameters
        APIClient.apiRequestV2(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// add Location
    struct LocationConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add-location"
    }
    
    public class func addLocationAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = LocationConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    public class func addLocationAPIV2(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = LocationConfig()
        config.parameters = parameters
        APIClient.apiRequestV2(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Get Account Type
    struct AccountTypeConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/account-types"
    }
    
    public class func getAccountTypeAPI(parameters: [String: String], completionHandler : @escaping(_ result: AccountType_base) -> Void) {
        var config = AccountTypeConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(AccountType_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Get Activity Type
    struct ActivityTypeConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/activity-types/\(SessionManager.getUserType() ?? "")/\(SessionManager.getBusinessType() ?? "")"
    }
    
    public class func getActivityTypeAPI(parameters: [String: String], completionHandler : @escaping(_ result: AccountType_base) -> Void) {
        var config = ActivityTypeConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(AccountType_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Get Business Type
    struct BusinessTypeConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/business-types"
    }
    
    public class func getBusinessTypeAPI(parameters: [String: String], completionHandler : @escaping(_ result: BusinessType_base) -> Void) {
        var config = BusinessTypeConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(BusinessType_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// upload bank and commercial
    struct uploadDocConfig: UploadDocsAPIConfiguration {
        var images: [String : [UIImage?]] = [:]
        var documents: [String : [Data?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add-bank-and-company"
    }

    class func bankAndCommercialAPI(photos: [UIImage?], documents:[String:[Data]], parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse?) -> Void) {

        var config = uploadDocConfig(
            images: ["image": photos],
            documents: documents
        )
        config.parameters = parameters
        APIClient.multiPartRequestForDocs(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    struct uploadDocConfigv2: UploadDocsAPIConfiguration {
        var images: [String : [UIImage?]] = [:]
        var documents: [String : [Data?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add-bank-and-company"
    }

    class func bankAndCommercialAPIV2(photos: [UIImage?], documents:[String:[Data]], parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse?) -> Void) {

        var config = uploadDocConfigv2(
            images: ["image": photos],
            documents: documents
        )
        config.parameters = parameters
        APIClient.multiPartRequestForDocsV2(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// delivery SignUp
    struct SignUpdeliveryConfig : UploadAPIConfiguration {
        var documents: [String : [UploadMedia?]]
        var uploadImages: [BBMedia]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "create-delivery-partner"
    }
    class func signupDeliveryAPI(images:[String : [UIImage?]],parameters: [String: String], completionHandler: @escaping(_ result: Authentication_Base) -> Void) {
        var config = SignUpdeliveryConfig(
            documents: [:], uploadImages: [],
            images : images
        )
        config.parameters = parameters
        APIClient.multiPartRequestV2(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Authentication_Base.self, from: json)
                switch response.status {
                case "1":
                    guard var dict = result?["oData"] as? [String:Any] else { return }
                    guard var dict2 = dict["user"] as? [String:Any] else { return }
                    dict2["access_token"] = response.oData?.token ?? ""
                    SessionManager.setUserData(dictionary: dict2)
                    UserDefaults.standard.set(nil, forKey: "googleImage")
                default:
                    break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    /// add Vehicle SignUp
    struct VehicledeliveryConfig : UploadAPIConfiguration {
        var documents: [String : [UploadMedia?]]
        var uploadImages: [BBMedia]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/add-vehicle-details"
    }
    class func VehicleDeliveryAPI(images:[String : [UIImage?]],parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse) -> Void) {
        var config = VehicledeliveryConfig(
            documents: [:], uploadImages: [],
            images : images
        )
        config.parameters = parameters
        APIClient.multiPartRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    class func VehicleDeliveryAPIV2(images:[String : [UIImage?]],parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse) -> Void) {
        var config = VehicledeliveryConfig(
            documents: [:], uploadImages: [],
            images : images
        )
        config.parameters = parameters
        APIClient.multiPartRequestV2(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    /// update Banner
    struct updateBannerConfig : UploadAPIConfiguration {
        var documents: [String : [UploadMedia?]]
        var uploadImages: [BBMedia]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/update_banner_image"
    }
    class func updateBannerAPI(images:[String : [UIImage?]],parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse) -> Void) {
        var config = updateBannerConfig(
            documents: [:], uploadImages: [],
            images : images
        )
        config.parameters = parameters
        APIClient.multiPartRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    /// update Banner
    struct updateProfileImgConfig : UploadAPIConfiguration {
        var documents: [String : [UploadMedia?]]
        var uploadImages: [BBMedia]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/update_user_image"
    }
    class func updateProfileImgAPI(images:[String : [UIImage?]],parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse) -> Void) {
        var config = updateProfileImgConfig(
            documents: [:], uploadImages: [],
            images : images
        )
        config.parameters = parameters
        APIClient.multiPartRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    struct validateFaceConfig : UploadAPIConfiguration {
        var documents: [String : [UploadMedia?]]
        var uploadImages: [BBMedia]
        var images: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/validate_profile_image"
    }
    class func validateFaceImage(images:[String : [UIImage?]],parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse) -> Void) {
        var config = validateFaceConfig(
            documents: [:], uploadImages: [],
            images : images
        )
        config.parameters = parameters
        APIClient.multiPartRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ///Update Profile
    struct updateProfileConfig: AddPostUploadAPIConfiguration {
        var uploadImages: [BBMedia]
        var documents: [String : [UploadMedia?]]
        var images: [String : [UIImage?]]
        var firstImages: [String : [UIImage?]]
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/update_profile"
    }
    
    class func updateProfileAPI(image: [UIImage],firstImage:[UIImage], parameters: [String: String], completionHandler: @escaping(_ result: GenericResponse) -> Void) {
        var config = updateProfileConfig (
            uploadImages: [], documents: [:], images: ["userImage": image], firstImages: ["bannerImage" : firstImage]
        )
        config.parameters = parameters
        APIClient.multiPartAddPostRequest(request: config) { result in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }

    
    //// Logout
    struct logoutConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "logout"
    }
    
    public class func logoutAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = logoutConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }   
    //// Delete Account
    struct DeleteAccountConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "auth/delete_account"
    }
    
    public class func deleteAccountAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = DeleteAccountConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }   

        //// Logout
    struct ProfilePicChnageRequestConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "request_profile_pic_change"
    }
    public class func profilePicChangeRequest(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = ProfilePicChnageRequestConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Change password
    struct changePasswordConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "change_password"
    }
    
    public class func changePasswordAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = changePasswordConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    //// Forgot password
    struct forgotConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/forgot_password_api"
    }
    
    public class func forgotAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = forgotConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    //// validate OTP
    struct validateOTPConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/validate_otp_api"
    }
    
    public class func validateOTPAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = validateOTPConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Reset Password
    struct resetPasswordConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/reset_password_api"
    }
    
    public class func resetOTPAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = resetPasswordConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Social Login
    struct SocialLoginConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/social_media_login"
    }
    
    public class func socialloginAPI(parameters: [String: String], completionHandler : @escaping(_ result: Authentication_Base) -> Void) {
        var config = SocialLoginConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(Authentication_Base.self, from: json)
                switch response.status {
                case "1":
                    if response.needRegistration != "1" {
                        guard var dict = result?["oData"] as? [String:Any] else { return }
                        guard var dict2 = dict["user"] as? [String:Any] else { return }
                        dict2["access_token"] = response.oData?.token ?? ""
                        SessionManager.setUserData(dictionary: dict2)
                        UserDefaults.standard.set(nil, forKey: "googleImage")
                    }
                default:
                    break
                }
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ////get wallet
    struct walletConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/wallet_details"
    }
    
    public class func getWalletAPI(parameters: [String: String], completionHandler : @escaping(_ result: WalletHistory_base) -> Void) {
        var config = walletConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(WalletHistory_base.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ////Recharge Wallet
    struct walletRechargeConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/wallet_payment_init"
    }
    
    public class func rechargeWalletAPI(parameters: [String: String], completionHandler : @escaping(_ result: TappPeymentRespoSE) -> Void) {
        var config = walletRechargeConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(TappPeymentRespoSE.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    ////Recharge Complete
    struct walletCompleteConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/wallet_recharge"
    }
    
    public class func completeWalletAPI(parameters: [String: String], completionHandler : @escaping(_ result: GenericResponse) -> Void) {
        var config = walletCompleteConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(GenericResponse.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    //// Get Account Type
    struct GetCountriesConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .get
        var path = "/countries-list"
    }
    
    public class func getCountriesListAPI(parameters: [String: String], completionHandler : @escaping(_ result: CountryListBase) -> Void) {
        var config = GetCountriesConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(CountryListBase.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
    
    
    struct GetCitiesConfig: APIConfiguration {
        var parameters: [String : String] = [:]
        var method: HTTPMethod = .post
        var path = "/get_city_list"
    }
    
    public class func getCitiesListAPI(parameters: [String: String], completionHandler : @escaping(_ result: CitiesListBase) -> Void) {
        var config = GetCitiesConfig()
        config.parameters = parameters
        APIClient.apiRequest(request: config) { (result) in
            do {
                let json = try JSONSerialization.data(withJSONObject: result as Any)
                let response = try JSONDecoder().decode(CitiesListBase.self, from: json)
                completionHandler(response)
            } catch let err {
                print(err)
            }
        }
    }
}
