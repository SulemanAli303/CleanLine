//
//  MyOrdersViewController.swift
//  LiveMArket
//
//  Created by Farhan on 29/08/2023.
//

import UIKit

fileprivate enum OrderType { case delivery, delegate }
fileprivate enum DeliveryOrderType { case all, pending, delivered }

final class MyOrdersViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var topBGView: UIView!
    @IBOutlet private var topButtons: [UIButton]!
    @IBOutlet private var bottomButtons: [UIButton]!
    @IBOutlet weak private var bottomContainer: UIView!
    
    //MARK: Properties
    private var selectedCategory: OrderType = .delivery
    private var selectedDeliveryOrder: DeliveryOrderType = .all

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topBGView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20.0)
    }
    
    //MARK: IBActions
    @IBAction private func actionTopButtonSelected(_ sender: UIButton) {
        UIView.transition(with: bottomContainer, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.bottomContainer.isHidden = sender.tag == 1
        })
        
        selectedCategory = sender.tag == 0 ? .delivery : .delegate
        
        topButtons.forEach {
            $0.backgroundColor = .clear
            $0.titleLabel?.textColor = .white
        }
        
        topButtons[sender.tag].backgroundColor = .white
        topButtons[sender.tag].setTitleColor(Color.theme.color(), for: .normal)
        
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    @IBAction private func actionBottomButtonSelected(_ sender: UIButton) {
        
        switch sender.tag {
        case 0 : selectedDeliveryOrder = .all
        case 1: selectedDeliveryOrder = .pending
        case 2: selectedDeliveryOrder = .delivered
        default: break
        }
        
        bottomButtons.forEach {
            $0.backgroundColor = .clear
            $0.titleLabel?.textColor = .white
        }
        
        bottomButtons[sender.tag].backgroundColor = .white
        bottomButtons[sender.tag].setTitleColor(Color.theme.color(), for: .normal)
        
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    //MARK: View Configurations
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookingCellTableViewCell.nib, forCellReuseIdentifier: BookingCellTableViewCell.identifier)
    }
    
}
//MARK: UITableView Delegate & DataSource Methods
extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategory == .delegate ? 10 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedCategory {
        case .delegate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingCellTableViewCell.identifier, for: indexPath) as? BookingCellTableViewCell else { return UITableViewCell() }
            
            return cell
            
        case .delivery:
            return UITableViewCell()
        }
    }
    
    
}
