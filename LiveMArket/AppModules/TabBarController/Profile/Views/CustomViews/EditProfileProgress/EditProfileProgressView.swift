//
//  EditProfileProgressView.swift
//  LiveMArket
//
//  Created by Farhan on 14/08/2023.
//

import Foundation
import UIKit

class EditProfileProgressView: UIView {
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var bankDetailsView: UIView!
    @IBOutlet weak var bankDetailsIcon: UIImageView!
    @IBOutlet weak var createAccntSeparator: UIImageView!
    
    let nibName = "EditProfileProgressView"
    var contentView: UIView?
    
    var selectedTab:Int = 0 {
        didSet {
            [bankDetailsView,accountView].forEach({$0?.borderWidth = 1})
            [bankDetailsView,accountView].forEach({$0?.borderColor = Color.dark.color()})
            [bankDetailsView,accountView].forEach({$0?.backgroundColor = .white})
            [bankDetailsView,accountView].forEach({$0?.layer.masksToBounds = true})
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
            default:
                bankDetailsView.borderWidth = 0
                accountView.backgroundColor = Color.darkOrange.color()
                bankDetailsView.backgroundColor = Color.darkOrange.color()
                bankDetailsIcon.image = UIImage(named: "documents-tab-active")
                createAccntSeparator.backgroundColor = Color.darkOrange.color()
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
