//
//  ChaletsListVC.swift
//  LiveMArket
//
//  Created by Zain on 31/01/2023.
//

import UIKit

class SelectRoomViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Select Room"
        setData()
    }
    func setData() {
        tableView.register(UINib(nibName: "SelectRoomCell", bundle: nil), forCellReuseIdentifier: "SelectRoomCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        let tabbar = tabBarController as? TabbarController
//        tabbar?.showTabBar()
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let tabbar = tabBarController as? TabbarController
//        tabbar?.hideTabBar()
//    }
}
extension SelectRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectRoomCell", for: indexPath) as! SelectRoomCell
        cell.base  = self
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SelectRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

