//
//  MyReviewsViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 23/01/2023.
//

import UIKit

class AddressListVC: BaseViewController {
    
    
    var addressList : [List]? {
        didSet {
            
            if (addressList?.count ?? 0) > 0 {
                self.otherLbl.isHidden  = false
                self.stackView.isHidden = false
                self.noDataView.isHidden = true
            }else {
                self.otherLbl.isHidden  = true
                self.stackView.isHidden = true
                self.noDataView.isHidden = false
            }
            
            if addressList != nil {
                for (index,item) in addressList!.enumerated() {
                    if item.isDefault == "1" {
                        self.addressPrime = item
                        addressList?.remove(at: index)
                        self.primeView.isHidden = false
                        break
                    }
                }
            }
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    var addressPrime : List? {
        didSet {
            self.primeAddName.text = addressPrime?.fullName ?? ""
            self.primeAdd.text = "\(addressPrime?.buildingName ?? ""), \(addressPrime?.flatNo ?? ""), \(addressPrime?.address ?? "")"
        }
    }
    @IBOutlet weak var primeView: UIView!
    @IBOutlet weak var primeAddName: UILabel!
    @IBOutlet weak var primeAdd: UILabel!
    @IBOutlet weak var otherLbl: UILabel!
    @IBOutlet weak var tableView: IntrinsicallySizedTableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var primaryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .backTitleRightButton
        viewControllerTitle = "My Address".localiz()
        primaryLabel.text = "Primary".localiz()
        otherLbl.text = "  Other Addresses".localiz()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        print(SessionManager.getUserData()?.id ?? "")
        self.primeView.isHidden = true
        getAdressAPI()
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
        self.tableView.register(AddressCell.nib, forCellReuseIdentifier: AddressCell.identifier)
        self.tableView.tableFooterView = UIView()
    }
    
    override func addNewAddress() {
        SellerOrderCoordinator.goToAddNewAddress(controller: self,isEdit: false)
    }
    @IBAction func DeleteAction(_ sender: Any) {
        if self.addressPrime != nil {
            Utilities.showQuestionAlert(message: "Are you sure you want to delete address?".localiz()) {
                let parameters:[String:String] = [
                    "access_token" : SessionManager.getAccessToken() ?? "",
                    "address_id" : String(self.addressPrime?.id ?? "")
                ]
                AddressAPIManager.deleteAddressAPI(parameters: parameters) { result in
                    switch result.status {
                    case "1":
                        self.getAdressAPI()
                    default:
                        Utilities.showWarningAlert(message: result.message ?? "") {
                            
                        }
                    }
                }
            }
        }
    }
    @IBAction func EditAction(_ sender: Any) {
        if self.addressPrime != nil {
            SellerOrderCoordinator.goToAddNewAddress(controller: self,isEdit: true,Item: self.addressPrime)
        }
    }
}
extension AddressListVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: AddressCell.identifier, for: indexPath) as! AddressCell
        Cell.selectionStyle = .none
        Cell.name.text = addressList?[indexPath.row].fullName ?? ""
        Cell.address.text = "\(addressList?[indexPath.row].buildingName ?? ""), \(addressList?[indexPath.row].flatNo ?? ""), \(addressList?[indexPath.row].address ?? "")"
        Cell.deleteBtn.tag = indexPath.row
        Cell.editBtn.tag = indexPath.row
        Cell.deleteBtn.addTarget(self, action: #selector(DeleteAdd(sender:)), for: .touchUpInside)
        Cell.editBtn.addTarget(self, action: #selector(editAdd(sender:)), for: .touchUpInside)
        
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "address_id" : String(self.addressList?[indexPath.row].id ?? "")
        ]
        AddressAPIManager.setDefaultAddressAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.getAdressAPI()
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
extension AddressListVC {
    @objc func DeleteAdd(sender: UIButton){
        Utilities.showQuestionAlert(message: "Are you sure you want to delete address?".localiz()) {
            let parameters:[String:String] = [
                "access_token" : SessionManager.getAccessToken() ?? "",
                "address_id" : String(self.addressList?[sender.tag].id ?? "")
            ]
            AddressAPIManager.deleteAddressAPI(parameters: parameters) { result in
                switch result.status {
                case "1":
                    self.getAdressAPI()
                default:
                    Utilities.showWarningAlert(message: result.message ?? "") {
                        
                    }
                }
            }
        }
    }
    @objc func editAdd(sender: UIButton){
        let buttonTag = sender.tag
        SellerOrderCoordinator.goToAddNewAddress(controller: self,isEdit: true,Item: self.addressList?[sender.tag])
    }
    func getAdressAPI() {
        self.stackView.isHidden = true
        self.primeView.isHidden = true
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AddressAPIManager.listAddressAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.addressList = result.oData?.list
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
    
}
