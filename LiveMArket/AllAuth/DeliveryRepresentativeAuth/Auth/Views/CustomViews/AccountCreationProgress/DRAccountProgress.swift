//
//  CreateAccountProgress.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import Foundation
import UIKit
class DRAccountProgress :UIView {
    
    @IBOutlet weak var createProfileView: UIView!
    @IBOutlet weak var createProfileSeparator: UIImageView!
    
    @IBOutlet weak var createAccountView: UIView!
    @IBOutlet weak var createAccountIcon: UIImageView!
    @IBOutlet weak var createAccountSeparator: UIImageView!
    
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var vehicleIcon: UIImageView!
    @IBOutlet weak var vehicleSeparator: UIImageView!

    @IBOutlet weak var doucumentView: UIView!
    @IBOutlet weak var doucumentIcon: UIImageView!
    @IBOutlet weak var doucumentSeparator: UIImageView!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationSeparator: UIImageView!
    
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var successIcon: UIImageView!
    
    let nibName = "DRAccountProgress"
    var contentView: UIView?
    var selectedTab:Int = 0 {
        didSet {
            [createAccountView,vehicleView,doucumentView,locationView,successView].forEach({$0?.borderWidth = 1})
            [createAccountView,vehicleView,doucumentView,locationView,successView].forEach({$0?.borderColor = Color.dark.color()})
            [createAccountView,vehicleView,doucumentView,locationView,successView].forEach({$0?.backgroundColor = .white})
            [createAccountView,vehicleView,doucumentView,locationView,successView].forEach({$0?.layer.masksToBounds = true})
            switch selectedTab {
            case 0:
                print("first")
            case 1:
                createAccountView.borderWidth = 0
                createAccountView.backgroundColor = Color.darkOrange.color()
                createAccountIcon.image = UIImage(named: "Info-tab-active")
                createProfileSeparator.backgroundColor = Color.darkOrange.color()
            case 2:
                
                createAccountView.borderWidth = 0
                createAccountView.backgroundColor = Color.darkOrange.color()
                createAccountIcon.image = UIImage(named: "Info-tab-active")
                createAccountSeparator.backgroundColor = Color.darkOrange.color()

                createProfileSeparator.backgroundColor = Color.darkOrange.color()
                
                vehicleView.borderWidth = 0
                vehicleView.backgroundColor = Color.darkOrange.color()
                vehicleIcon.image = UIImage(named: "vehicle-tab-active")
                
            case 3:
                
                createAccountView.borderWidth = 0
                createAccountView.backgroundColor = Color.darkOrange.color()
                createAccountIcon.image = UIImage(named: "Info-tab-active")
                createAccountSeparator.backgroundColor = Color.darkOrange.color()

                createProfileSeparator.backgroundColor = Color.darkOrange.color()
                
                vehicleView.borderWidth = 0
                vehicleView.backgroundColor = Color.darkOrange.color()
                vehicleIcon.image = UIImage(named: "vehicle-tab-active")
                vehicleSeparator.backgroundColor = Color.darkOrange.color()
                
                doucumentView.borderWidth = 0
                doucumentView.backgroundColor = Color.darkOrange.color()
                doucumentIcon.image = UIImage(named: "documents-tab-active")
                
            case 4:
              
                createAccountView.borderWidth = 0
                createAccountView.backgroundColor = Color.darkOrange.color()
                createAccountIcon.image = UIImage(named: "Info-tab-active")
                createAccountSeparator.backgroundColor = Color.darkOrange.color()

                createProfileSeparator.backgroundColor = Color.darkOrange.color()
                
                vehicleView.borderWidth = 0
                vehicleView.backgroundColor = Color.darkOrange.color()
                vehicleIcon.image = UIImage(named: "vehicle-tab-active")
                vehicleSeparator.backgroundColor = Color.darkOrange.color()
                
                doucumentView.borderWidth = 0
                doucumentView.backgroundColor = Color.darkOrange.color()
                doucumentIcon.image = UIImage(named: "documents-tab-active")
                doucumentSeparator.backgroundColor = Color.darkOrange.color()
                
                locationView.borderWidth = 0
                locationView.backgroundColor = Color.darkOrange.color()
                locationIcon.image = UIImage(named: "location-tab-active")
            
            default:
                
                createAccountView.borderWidth = 0
                createAccountView.backgroundColor = Color.darkOrange.color()
                createAccountIcon.image = UIImage(named: "Info-tab-active")
                createAccountSeparator.backgroundColor = Color.darkOrange.color()

                createProfileSeparator.backgroundColor = Color.darkOrange.color()
                
                vehicleView.borderWidth = 0
                vehicleView.backgroundColor = Color.darkOrange.color()
                vehicleIcon.image = UIImage(named: "vehicle-tab-active")
                vehicleSeparator.backgroundColor = Color.darkOrange.color()
                
                doucumentView.borderWidth = 0
                doucumentView.backgroundColor = Color.darkOrange.color()
                doucumentIcon.image = UIImage(named: "documents-tab-active")
                doucumentSeparator.backgroundColor = Color.darkOrange.color()
                
                locationView.borderWidth = 0
                locationView.backgroundColor = Color.darkOrange.color()
                locationIcon.image = UIImage(named: "location-tab-active")
                locationSeparator.backgroundColor = Color.darkOrange.color()
            
                
                successView.borderWidth = 0
                successView.backgroundColor = Color.darkOrange.color()
                successIcon.image = UIImage(named: "submit-icon-tab-active")
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
