//
//  Refreshable.swift
//  ISHELF
//
//  Created by A2 MacBook Pro 2012 on 06/08/20.
//  Copyright © 2020 a2solution. All rights reserved.
//

import UIKit

@objc protocol Refreshable {
    var refreshControl: UIRefreshControl? { get set }
    var tableView: UITableView! { get set }
    
    @objc func handleRefresh(_ sender: UITableView)
}

extension Refreshable where Self: UIViewController {
    func installRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Color.theme.color()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
        tableView.refreshControl = refreshControl
    }
}

@objc protocol RefreshableCollectionView {
    var refreshControl: UIRefreshControl? { get set }
    var collectionView: UICollectionView! { get set }
    
    @objc func handleRefresh(_ sender: UICollectionView)
}

extension RefreshableCollectionView where Self: UIViewController {
    func installRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Color.theme.color()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
        collectionView.refreshControl = refreshControl
    }
}
