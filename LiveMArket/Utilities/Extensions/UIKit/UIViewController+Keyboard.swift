

import UIKit

private let padding: CGFloat = 16.0

protocol KeyboardDisplayable {

    func keyboardShown(scrollView: UIScrollView, containerFrame: CGRect?, notification: Notification)
    func keyboardHide(scrollView: UIScrollView, notification: Notification)
}

extension KeyboardDisplayable where Self: UIViewController {

    func keyboardShown(scrollView: UIScrollView, containerFrame: CGRect?, notification: Notification) {

        guard let keyboardFrame: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        let bottomInset = keyboardFrame.size.height + padding

        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {

            scrollView.contentInset.bottom  = bottomInset

            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardFrame.size.height

            if let containerFrame = containerFrame {
				// TODO: have check y request password creating issue. Disabled it for request password screen
                //if aRect.contains(containerFrame.origin) {
                    scrollView.scrollRectToVisible(containerFrame, animated: false)
                //}
            }

        }, completion: nil)
    }

    func keyboardHide(scrollView: UIScrollView, notification: Notification) {

        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {

            if #available(iOS 11.0, *) {

                guard let keyboardFrame: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
                scrollView.contentInset.bottom  = scrollView.adjustedContentInset.bottom - (keyboardFrame.size.height + padding)

            } else {
                scrollView.contentInset.bottom = 0
            }

        }, completion: nil)
    }

}

extension UIViewController: KeyboardDisplayable { }
