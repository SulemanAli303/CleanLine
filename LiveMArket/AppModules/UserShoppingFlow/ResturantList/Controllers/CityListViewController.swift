//
//  CityListViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 02/09/23.
//

import UIKit

protocol CityUpdateProtocol{
    func updateCityName(cityData:CityList)
}

class CityListViewController: UIViewController {

    @IBOutlet weak var cityListTableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    var delegate:CityUpdateProtocol?
    var cityArray:[CityList] = []
    var filterCityArray:[CityList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchText.placeholder = "Search here..".localiz()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let tabbar = tabBarController as? TabbarController
        tabbar?.hideTabBar()
        getAllCity()
    }
    

    var cityData:CityData?{
        didSet{
            if let dataArray = cityData?.list{
                cityArray = dataArray
                filterCityArray = cityArray
                self.cityListTableView.reloadData()
            }
        }
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAllCity() {
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameters:[String:String] = [
            "limit":"100",
            "page":"1"
        ]
      
        StoreAPIManager.getCityDataAPI(parameters: parameters) { result in
            switch result.status {
            case "1":
                self.cityData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? "") {
                    
                }
            }
        }
    }
    
}

extension CityListViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameTableViewcell", for: indexPath) as! CityNameTableViewcell
        cell.nameLabel.text = filterCityArray[indexPath.row].name ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.updateCityName(cityData: filterCityArray[indexPath.row])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}

extension CityListViewController:UITextFieldDelegate{
    // UITextFieldDelegate method to respond to text changes in the UITextField
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Get the current text in the UITextField
            let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            // Filter the data based on the search text
            filterCityArray = cityArray.filter({$0.name?.lowercased().range(of: searchText.lowercased()) != nil})
            if searchText == ""{
                filterCityArray = cityArray
            }
            
            // Reload the UITableView to reflect the filtered data
            cityListTableView.reloadData()
            
            return true
        }
}


class CityNameTableViewcell:UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
