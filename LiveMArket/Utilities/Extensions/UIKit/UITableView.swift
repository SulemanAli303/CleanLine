//
//  UITableView.swift
//  TalentBazar
//
//  Created by Muneeb on 05/05/2022.
//

import UIKit
extension UITableView {
    // MARK: - Public Methods
    
    func getCell<T: Registerable>(type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    
    func getCell<T: Registerable>(type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    func register(types: Registerable.Type ...) {
        for type in types {
            register(type.getNIB(), forCellReuseIdentifier: type.identifier)
        }
    }
    
    func getHeaderFooter<T: Registerable>(type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: type.identifier) as? T
    }
    
    func registerHeaderFooter(types: Registerable.Type ...) {
        for type in types {
            register(type.getNIB(), forHeaderFooterViewReuseIdentifier: type.identifier)
        }
    }
    
    func setLoadingView() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = center
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        backgroundView = activityIndicator
    }
    
    func resetBackgroundView() {
        backgroundView = UIView(frame: .zero)
    }
    
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastSection = numberOfSections - 1
        guard numberOfRows(inSection: lastSection) > 0 else { return }
        let lastItemIndexPath = IndexPath(item: numberOfRows(inSection: lastSection) - 1, section: lastSection)
        scrollToRow(at: lastItemIndexPath, at: .bottom, animated: animated)
    }
    
    func scrollToTop(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        let lastSection = 0
        guard numberOfRows(inSection: lastSection) > 0 else { return }
        let firstItemIndexPath = IndexPath(row: 0, section: lastSection)
        scrollToRow(at: firstItemIndexPath, at: .top, animated: animated)
    }
    
    func reloadData(duration: Double) {
        reloadData()
        if duration > 0 {
            let animation = CATransition()
            animation.type = .fade
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fillMode = .both
            animation.duration = duration
            layer.add(animation, forKey: "UITableViewReloadDataAnimationKey")
        }
    }
    
    func reloadWithoutAnimation() {
        let contentOffset = self.contentOffset
        UIView.performWithoutAnimation {
            self.reloadData()
            self.layoutIfNeeded()
            self.setContentOffset(contentOffset, animated: false)
        }
    }
    
}
