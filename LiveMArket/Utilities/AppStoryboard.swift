//
//  AppStoryboard.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import Foundation
import UIKit
enum AppStoryboard : String {
    
    // TAB BAR
    case Auth
    case Home
    case Discover
    case Message
    case Profile
    case MoreOptions
    
    //Profile
    case ProfileOrders

    // User SHOPPING FLOW
    case Main
    case ThankYou
    case ShopProfile
    case ShopDetail
    case ReceivingOption
    case RatingAndReview
    case Notification
    case ProductAndServices
    case CustomPackages
    case List
    case Search
    case Chat
    case RequestQuote
    case Venue
    case Deals
    case Filter
    case VendorDetails
    case Rate
    case BookingDetails
    case UserCart
    case ResturantList
    case Floating
    case SubmitPicture
    case UserServicesBooking
    
    ///Food
    case FoodStore
    
    //Whole Seller Auth
    
    case WSAuth
    case DRAuth
    case RRAuth
    //Seller Order
    
    case SellerOrder
    case SellerOrderDetail
    case NewOrder
    case SellerBookingDetails
    case TakePicture
    case PostComment
    
    case DriverOrderDetails
    
    //PlayGroundBookingFLow
    case BookNow
    case BookNowDetail
    case CompleteBooking
    case PGBookingDetails
    case GymBooking
    case DateTime
    case Chalets
    case Notifications
    case LiveComments
    case HotelReservationManagment
    case ChaletsReservationManagment
    case GymManagmentFlow
    
    //Service Provider Booking
    case ServiceProviderBooking
    
    //Booking Hotel
    case BookingHotel
    case CarBooking
    case CarBookingDetails
    case NotificationPopup
    case TableBooking
    case AddOnSB

    //inddividual Seller Order
    
    case ISellerOrder
    case ISellerOrderDetail
    
    case Popup

    case CMS
    
    case BookingDelegate

    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main) }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
