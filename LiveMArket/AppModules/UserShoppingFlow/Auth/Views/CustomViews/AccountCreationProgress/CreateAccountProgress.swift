//
//  CreateAccountProgress.swift
//  LiveMArket
//
//  Created by Albin Jose on 02/01/23.
//

import Foundation
import UIKit
class CreateAccountProgress :UIView {
    
    @IBOutlet weak var createAccountView: UIView!
    @IBOutlet weak var bankDetailsView: UIView!
    @IBOutlet weak var bankDetailsIcon: UIImageView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locIcon: UIImageView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var successIcon: UIImageView!
    @IBOutlet weak var createAccntSeparator: UIImageView!
    @IBOutlet weak var bankDetailsSeparator: UIImageView!
    @IBOutlet weak var locationSeparator: UIImageView!
    let nibName = "CreateAccountProgress"
    var contentView: UIView?
    var selectedTab:Int = 0 {
        didSet {
            [bankDetailsView,locationView,successView].forEach({$0?.borderWidth = 1})
            [bankDetailsView,locationView,successView].forEach({$0?.borderColor = Color.dark.color()})
            [bankDetailsView,locationView,successView].forEach({$0?.backgroundColor = .white})
            [bankDetailsView,locationView,successView].forEach({$0?.layer.masksToBounds = true})
            switch selectedTab {
            case 0:
                print("first")
            case 1:
                bankDetailsView.borderWidth = 0
                bankDetailsView.backgroundColor = Color.darkOrange.color()
                bankDetailsIcon.image = UIImage(named: "documents-tab-active")
                createAccntSeparator.backgroundColor = Color.darkOrange.color()
            case 2:
                locationView.borderWidth = 0
                bankDetailsView.borderWidth = 0
                bankDetailsView.backgroundColor = Color.darkOrange.color()
                locationView.backgroundColor = Color.darkOrange.color()
                locIcon.image = UIImage(named: "location-tab-active")
                bankDetailsIcon.image = UIImage(named: "documents-tab-active")
                createAccntSeparator.backgroundColor = Color.darkOrange.color()
                bankDetailsSeparator.backgroundColor = Color.darkOrange.color()
            default:
                locationView.borderWidth = 0
                bankDetailsView.borderWidth = 0
                successView.borderWidth = 0
                bankDetailsView.backgroundColor = Color.darkOrange.color()
                locationView.backgroundColor = Color.darkOrange.color()
                successView.backgroundColor = Color.darkOrange.color()
                locIcon.image = UIImage(named: "location-tab-active")
                bankDetailsIcon.image = UIImage(named: "documents-tab-active")
                successIcon.image = UIImage(named: "submit-icon-tab-active")
                createAccntSeparator.backgroundColor = Color.darkOrange.color()
                bankDetailsSeparator.backgroundColor = Color.darkOrange.color()
                locationSeparator.backgroundColor = Color.darkOrange.color()
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
