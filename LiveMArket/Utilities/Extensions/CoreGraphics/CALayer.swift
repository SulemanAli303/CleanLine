
import UIKit

extension CALayer {
    func applySketchShadow( color: UIColor = .black,
                            alpha: Float = 0.5,
                            x: CGFloat = 0,
                            y: CGFloat = 2,
                            blur: CGFloat = 4,
                            spread: CGFloat = 0) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    fileprivate func pulseAnimiation() -> CAAnimationGroup {
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.5
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]
        return animationGroup
    }
    
    func addHeartBeatPulseLayerForUIButton(btn: UIButton) {
        btn.layer.add(pulseAnimiation(), forKey: "pulse")
    }
    
    func addHeartBeatPulseLayerForUILabel(label: UILabel) {
        label.layer.add(pulseAnimiation(), forKey: "pulse")
    }
}

extension CATransition {
    func fadeTransition() -> CATransition {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        return transition
    }
}
