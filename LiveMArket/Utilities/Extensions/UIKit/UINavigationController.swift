
import UIKit
extension UINavigationController {
    func getReference<ViewController: UIViewController>(to viewController: ViewController.Type) -> ViewController? {
        return viewControllers.first { $0 is ViewController } as? ViewController
    }
    
    func popViewControllerWithHandler(completion: @escaping () -> ()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: false)
        CATransaction.commit()
    }
}

