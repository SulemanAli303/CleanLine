

import UIKit
enum DeviceType: String {
    case iPhone = "mobile"
    case iPad = "tablet"
}
extension UIViewController {

    var orientation: UIUserInterfaceIdiom {
        UIDevice().userInterfaceIdiom == .pad ? .pad : .phone
    }
    
    var getDeviceType: String {
        return orientation == .pad ? DeviceType.iPad.rawValue : DeviceType.iPhone.rawValue
    }

    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
  
    func add(_ child: UIViewController) {
        addChild(child)
        UIView.animate(withDuration: 0.5) { [self] in
            view.addSubview(child.view)
            child.didMove(toParent: self)
        }
    }
    
    func add(_ child: UIViewController, container: UIView) {
        print("children \(self.children.count)")
        addChild(child)
        print("children after adding\(self.children.count)")
        child.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            child.view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
            child.view.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            child.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
        ])
        child.didMove(toParent: self)
    }
    
    func removeChild() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        print("children after removing\(self.children.count)")
    }
}

// MARK: - StoryBoard Identifiable
extension UIViewController {
    static var storyboardID : String {
        return "\(self)" + "_ID"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
