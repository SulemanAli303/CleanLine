//
//  TaxCertificateVC.swift
//  LiveMArket
//
//  Created by Apple on 14/02/2023.
//

import UIKit

class TaxCertificateVC: BaseViewController {

    @IBOutlet weak var tableView: IntrinsicallySizedTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = "Tax Certificate".localiz()
        setup()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    func setup() {
        // MARK: - TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(TaxCertifcateCell.nib, forCellReuseIdentifier: TaxCertifcateCell.identifier)
        self.tableView.tableFooterView = UIView()
    }

}
extension TaxCertificateVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: TaxCertifcateCell.identifier, for: indexPath) as! TaxCertifcateCell
         Cell.selectionStyle = .none
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
