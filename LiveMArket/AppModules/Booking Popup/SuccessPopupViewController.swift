//
//  SuccessPopupViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 25/09/23.
//

import UIKit
import Lottie

protocol SuccessProtocol{
    func navigateOrderDetailsPage()
}

enum ShowButtonOption{
    case hideAll
    case showHome
    case showAll
}

class SuccessPopupViewController: UIViewController {
    
    var delegate:SuccessProtocol?
    var heading:String = ""
    var invoiceNumber:String = ""
    var confirmationText:String = ""
    var buttonOption : ShowButtonOption = .hideAll
    
    var onReviewPressed : (() -> ())?
    
    @IBOutlet weak var homeButtonContainer: UIView!
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var cofirmationLabel: UILabel!
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var lottieAnimation: LottieAnimationView!
    @IBOutlet weak var headingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLottie()
     
       
        if buttonOption == .hideAll{
            homeButtonContainer.isHidden = true
            buttonsView.isHidden = true
        }
        else if buttonOption == .showAll
        {
            buttonsView.isHidden = false
        }
        else
        {
            homeButtonContainer.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.headingLabel.text = heading
        self.invoiceNumberLabel.text = invoiceNumber
        self.cofirmationLabel.text = confirmationText
    }
    
//    func configureLanguage(){
//        headingLabel.text = "".localiz()
//        cofirmationLabel.text = "".localiz()
//    }

    func setUpLottie() {
        self.lottieAnimation?.contentMode = .scaleAspectFit
        self.lottieAnimation?.animationSpeed = 1
        playAnimation()
    }
    
    func playAnimation() {
        self.lottieAnimation?.play(completion: { played in
            if played == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.delegate?.navigateOrderDetailsPage()
                }
            }else {
                self.playAnimation()
            }
        })
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        Coordinator.updateRootVCToTab()
    }
    
    @IBAction func backToProfile(_ sender: UIButton) {
        
        self.dismiss(animated: false) {
            if self.buttonOption == .showHome {
                Coordinator.updateProfileVCToTabWithoutDelay()
            }
            else{
                Coordinator.updateProfileVCToTab()
            }
        }
    }
    
    @IBAction func SendToReviewScreen(_ sender: UIButton) {
        
        self.onReviewPressed?()
        self.delegate?.navigateOrderDetailsPage()
    }

}
