//
//  LaunchViewController.swift
//  LiveMArket
//
//  Created by Greeniitc on 15/06/23.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {

    
    private var lottieAnimation: LottieAnimationView?
    @IBOutlet weak var centerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLottie()
        // Do any additional setup after loading the view.
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, tvOS 11.0, *) {
            Constants.shared.hasTopNotch = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        } else {
            Constants.shared.hasTopNotch = false
        }
    }
    //MARK: - Methods
        func setUpLottie() {
            //
            self.lottieAnimation = LottieAnimationView(name: "splashLogoNew")
            
            let difference : CGFloat = 2
          //  self.lottieAnimation = LottieAnimationView(name: "splash_logo")
            self.lottieAnimation?.contentMode = .scaleToFill
            self.lottieAnimation?.frame = CGRect(x: 0, y:difference/2, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-difference)
            self.lottieAnimation?.animationSpeed = 2
            self.view.addSubview(self.lottieAnimation!)
            //view.bringSubviewToFront(titleImg)
            playAnimation()
        }
        func playAnimation() {
            self.lottieAnimation?.play(completion: { played in
                if played == true {
                    //let frame = UIScreen.main.bounds
                    //self.window = UIWindow(frame: frame)
                    //self.redirect = RedirectHelper(window: self.window)
                    //self.redirect.determineRoutes()
                    //Coordinator.loadIntroScreen()
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let home = BaseViewController()
                        if SessionManager.isLoggedIn() {
                            Coordinator.updateRootVCToTab()
                        }else {
                            Coordinator.updateRootVCToTab()
                        }
                   /// }
                }else {
                    self.playAnimation()
                }
            })
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
