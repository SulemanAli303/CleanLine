//
//  InviteFriendsViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 21/09/23.
//

import UIKit

class InviteFriendsViewController: BaseViewController {

    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var shareFriendsLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       type = .backWithTop
        viewControllerTitle = "Invite Friends".localiz()
        shareFriendsLabel.placeholder = "Share with friends and earn".localiz()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        self.referralCodeTextField.text = Constants.shared.referralCode
        self.descriptionTextLabel.text = Constants.shared.referralText
    }
    
    @IBAction func copyButtonTapped(_ sender: UIButton) {
        // Get the text to copy from the label or text field
        let textToCopy = referralCodeTextField.text // or textToCopyTextField.text

        // Check if there's text to copy
        guard let text = textToCopy, !text.isEmpty else {
            return
        }

        // Copy the text to the clipboard
        UIPasteboard.general.string = text

        // Optionally, provide user feedback (e.g., a toast or alert)
        let alert = UIAlertController(title: "Copied".localiz(), message: "Text copied to clipboard".localiz(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localiz(), style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func shareButtonAction(_ sender: UIButton) {
        guard  self.referralCodeTextField.text != "" else {return}
        self.createShareURL(id: self.referralCodeTextField.text ?? "", type: "referralCode", title:"\("Hey there, if you do, sign up using referral code".localiz()) \(self.referralCodeTextField.text ?? "") , \("you will receive 50 SAR in your wallet.".localiz())", image: "https://firebasestorage.googleapis.com/v0/b/soouqlive.appspot.com/o/app_logo.png?alt=media&token=ac8b7880-e97f-4aba-bc78-cc2400e54b90")
        
    }
}
