//
//  EditProfileProgressView.swift
//  LiveMArket
//
//  Created by Farhan on 14/08/2023.
//

import Foundation
import UIKit

class EditDriverProfileProgressView :UIView {
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var bankDetailsView: UIView!
    @IBOutlet weak var bankDetailsIcon: UIImageView!
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var vehicleIcon: UIImageView!
    @IBOutlet weak var createAccntSeparator: UIImageView!
    @IBOutlet weak var bankDetailsSeparator: UIImageView!
    
    let nibName = "EditDriverProfileProgressView"
    var contentView: UIView?
    
    var selectedTab:Int = 0 {
        didSet {
            [bankDetailsView,accountView,vehicleView].forEach({$0?.borderWidth = 1})
            [bankDetailsView,accountView,vehicleView].forEach({$0?.borderColor = Color.dark.color()})
            [bankDetailsView,accountView,vehicleView].forEach({$0?.backgroundColor = .white})
            [bankDetailsView,accountView,vehicleView].forEach({$0?.layer.masksToBounds = true})
            switch selectedTab {
            case 0:
                print("first")
            case 1:
                accountView.borderWidth = 0
                bankDetailsView.borderWidth = 0
                accountView.backgroundColor = Color.darkOrange.color()
                bankDetailsView.backgroundColor = Color.darkOrange.color()
                bankDetailsIcon.image = UIImage(named: "documents-tab-active")
                createAccntSeparator.backgroundColor = Color.darkOrange.color()
            case 2:
                accountView.borderWidth = 0
                vehicleView.borderWidth = 0
                bankDetailsView.borderWidth = 0
                accountView.backgroundColor = Color.darkOrange.color()
                bankDetailsView.backgroundColor = Color.darkOrange.color()
                vehicleView.backgroundColor = Color.darkOrange.color()
                vehicleIcon.image = UIImage(named: "vehicle-tab-active")
                bankDetailsIcon.image = UIImage(named: "documents-tab-active")
                createAccntSeparator.backgroundColor = Color.darkOrange.color()
                bankDetailsSeparator.backgroundColor = Color.darkOrange.color()
            default:
                vehicleView.borderWidth = 0
                bankDetailsView.borderWidth = 0
                accountView.backgroundColor = Color.darkOrange.color()
                bankDetailsView.backgroundColor = Color.darkOrange.color()
                vehicleView.backgroundColor = Color.darkOrange.color()
                vehicleIcon.image = UIImage(named: "vehicle-tab-active")
                bankDetailsIcon.image = UIImage(named: "documents-tab-active")
                createAccntSeparator.backgroundColor = Color.darkOrange.color()
                bankDetailsSeparator.backgroundColor = Color.darkOrange.color()
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
