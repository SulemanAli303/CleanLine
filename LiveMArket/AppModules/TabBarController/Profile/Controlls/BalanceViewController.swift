//
//  BalanceViewController.swift
//  LiveMArket
//
//  Created by Zain falak on 23/01/2023.
//

import UIKit

class BalanceViewController: BaseViewController {
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var walletHistoryView: UIView!
    @IBOutlet weak var earningsButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var historyButtonView: UIView!
    @IBOutlet weak var withdrawbutton: UIButton!
    @IBOutlet weak var lastRequestedStackView: UIStackView!
    @IBOutlet weak var balanceErningsLabel: UILabel!
    @IBOutlet weak var totalErningsLabel: UILabel!
    @IBOutlet weak var overAllErningsLabel: UILabel!
    @IBOutlet weak var lastRequestedAmountLabel: UILabel!
    
    @IBOutlet weak var yourBalanceLabel: UILabel!
    @IBOutlet weak var rechargeButton: UIButton!
    @IBOutlet weak var balanceEarningLabel: UILabel!
    @IBOutlet weak var totalEarnedLabel: UILabel!
    @IBOutlet weak var overAllEarningLabel: UILabel!
    @IBOutlet weak var lastRequestedLabel: UILabel!
    
    
    
    
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var listArray : [WalletEarningsList] = []
    
    var balanceAmount: WalletHistoryData? {
        didSet {
            balanceLbl.text = "\(balanceAmount?.currenctCode ?? "") \(balanceAmount?.balance ?? "0.0")"
            //lastUpdatedLbl.text = ""
            if (balanceAmount?.lastUpdated ?? "") != "" {
                //lastUpdatedLbl.text = "LAST UPDATED : \((balanceAmount?.lastUpdated ?? "").changeTimeToFormat(frmFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd MMM yyyy HH:mm"))"
            }
            listArray = balanceAmount?.transaction.list ?? []
            self.tableView.reloadData()
        }
    }
    var walletData:WalletEarningsData?{
        didSet{
            print(walletData)
            balanceErningsLabel.text = "\(walletData?.currenct_code ?? "") \(walletData?.earning_balance ?? "")"
            totalErningsLabel.text = "\(walletData?.currenct_code ?? "") \(walletData?.withdrawels ?? "")"
            overAllErningsLabel.text = "\(walletData?.currenct_code ?? "") \(walletData?.earnings ?? "")"
            lastRequestedAmountLabel.text = "\(walletData?.currenct_code ?? "") \(walletData?.last_requested_amount ?? "")"
            
            if walletData?.last_requested_amount ?? "" == "0"{
                withdrawbutton.isEnabled = true
                withdrawbutton.setBackgroundImage(UIImage(named: "WithdrawOrange"), for: .normal)
                lastRequestedStackView.isHidden = true
            }else{
                if walletData?.earning_balance ?? "" == "0" || walletData?.last_requested_amount ?? "" != "0"{
                    withdrawbutton.setBackgroundImage(UIImage(named: "WithdrawGray"), for: .normal)
                    withdrawbutton.isEnabled = false
                    lastRequestedStackView.isHidden = false
                }else{
                    withdrawbutton.setBackgroundImage(UIImage(named: "WithdrawOrange"), for: .normal)
                    withdrawbutton.isEnabled = true
                    lastRequestedStackView.isHidden = false
                }
            }
            
            
            
            listArray = walletData?.transaction?.list ?? []
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0.0)
        type = .backWithTop
        viewControllerTitle = "Balance".localiz()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(setupNotificationObserver), name: Notification.Name("OrderStatusChanged"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        if SessionManager.getUserData()?.user_type_id == "6"{
            walletErningDetails()
        }else{
            self.getBalance()
            self.walletHistoryView.isHidden = true
            self.historyButtonView.isHidden = true
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    func configureLanguage(){
        yourBalanceLabel.text = "Your Balance".localiz()
        rechargeButton.setTitle("Recharge".localiz(), for: .normal)
        balanceEarningLabel.text = "Balance Earnings".localiz()
        withdrawbutton.setTitle("Withdraw".localiz(), for: .normal)
        totalEarnedLabel.text = "Total Earned".localiz()
        overAllEarningLabel.text = "Overall Earnings".localiz()
        lastRequestedLabel.text = "Last Requested Amount".localiz()
        allButton.setTitle("All".localiz(), for: .normal)
        earningsButton.setTitle("Earnings".localiz(), for: .normal)
    }
    
    func defaultColor(){
        allButton.borderColor = Color.darkGray.color()
        earningsButton.borderColor = Color.darkGray.color()
        allButton.setTitleColor(Color.darkGray.color(), for: .normal)
        earningsButton.setTitleColor(Color.darkGray.color(), for: .normal)
    }
    
    func setup() {
        // MARK: - TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(BalanceTableViewCell.nib, forCellReuseIdentifier: BalanceTableViewCell.identifier)
        self.tableView.tableFooterView = UIView()
    }
    @objc func setupNotificationObserver()
    {
        walletErningDetails()
    }
    
    func walletErningDetails(){
        self.getBalance()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.walletHistoryAPI(showErnings: "")
        }
        defaultColor()
        allButton.borderColor = Color.darkOrange.color()
        allButton.setTitleColor(Color.darkOrange.color(), for: .normal)
        self.walletHistoryView.isHidden = false
        self.historyButtonView.isHidden = false
    }
    @IBAction func recharge(_ sender: UIButton) {
        Coordinator.gotoRecharge(controller: self)
    }
    @IBAction func withdrawAction(_ sender: UIButton) {
        let  VC = AppStoryboard.Profile.instance.instantiateViewController(withIdentifier: "WithdrawViewController") as! WithdrawViewController
        VC.walletData = walletData
        VC.delegate = self
        self.present(VC, animated: true)
    }
    @IBAction func allButtonAction(_ sender: UIButton) {
        defaultColor()
        allButton.borderColor = Color.darkOrange.color()
        allButton.setTitleColor(Color.darkOrange.color(), for: .normal)
        walletHistoryAPI(showErnings: "")
    }
    @IBAction func earningsButtonAction(_ sender: UIButton) {
        defaultColor()
        earningsButton.borderColor = Color.darkOrange.color()
        earningsButton.setTitleColor(Color.darkOrange.color(), for: .normal)
        walletHistoryAPI(showErnings: "1")
    }
    
}
extension BalanceViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard listArray.count != 0 else {
            tableView.setEmptyView(title: "", message: "No Wallet History Found!".localiz(), image: UIImage(named: "undraw_chore_list_re_2lq8 1"))
            
            return 0
        }
        tableView.backgroundView = nil
        return listArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: BalanceTableViewCell.identifier, for: indexPath) as! BalanceTableViewCell
        Cell.selectionStyle = .none
        Cell.currency = walletData?.currenct_code ?? ""
        Cell.walletAmunt = listArray[indexPath.row]
        Cell.setData()
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
extension BalanceViewController {
    func getBalance() {
        self.topStackView.isHidden = true
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? ""
        ]
        AuthenticationAPIManager.getWalletAPI(parameters: parameters) { result in
            self.topStackView.isHidden = false
            switch result.status {
                
            case "1":
                self.balanceAmount = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ) {
                    
                }
            }
        }
    }
}
extension BalanceViewController{
    func walletHistoryAPI(showErnings:String?) {
        
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "show_earning" : showErnings ?? ""
        ]
        print(parameters)
        
        StoreAPIManager.walletEarningAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.walletData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
}

extension BalanceViewController:UpdateRequestProtocol{
    func updateValue() {
        walletErningDetails()
    }
    
    
}
