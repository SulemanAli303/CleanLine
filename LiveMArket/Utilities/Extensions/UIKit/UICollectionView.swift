//
//  UICollectionView.swift
//  TalentBazar
//
//  Created by Muneeb on 05/05/2022.
//

import UIKit
extension UICollectionView {
    // MARK: - Public Methods
    func getCell<T: Registerable>(type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
    
    func register(types: Registerable.Type ...) {
        for type in types {
            register(type.getNIB(), forCellWithReuseIdentifier: type.identifier)
        }
    }
    
    func registerHeader(types: Registerable.Type ...) {
        for type in types {
            register(type.getNIB(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.identifier)
        }
    }
    
    func getHeader<T: Registerable>(type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
    
    func registerFooter(types: Registerable.Type ...) {
        for type in types {
            register(type.getNIB(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: type.identifier)
        }
    }
    
    func getFooter<T: Registerable>(type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
    
    func setLoadingView() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = center
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        
        backgroundView = activityIndicator
    }
    
    func setLoadingViewOnTop(topMargin: CGFloat = 150) {
        let margins: CGFloat = 40
        var labelFrame = CGRect(x: frame.origin.x + margins, y: frame.origin.y, width: frame.width - (2 * margins), height: frame.height)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = center
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        
        
        let containerView = UIView(frame: frame)
        labelFrame.origin.y = topMargin
        labelFrame.size.height = 40
        activityIndicator.frame = labelFrame
        containerView.addSubview(activityIndicator)
        backgroundView = containerView

    }
}
